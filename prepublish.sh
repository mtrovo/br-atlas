set -ex 
rm -rvf br
mkdir -p build br

if [ ! -f build/br_municipios.zip ]; then
	curl -o build/br_municipios.zip \
		ftp://geoftp.ibge.gov.br/organizacao_do_territorio/malhas_territoriais/malhas_municipais/municipio_2017/Brasil/BR/br_municipios.zip
	unzip -od build build/br_municipios.zip BRMUE250GC_SIR.*
	chmod a-x build/BRMUE250GC_SIR.*
	mapshaper -i build/BRMUE250GC_SIR.shp encoding=UTF-8 snap -simplify dp 2.5% -o format=geojson build/simplified.json
fi

geo2topo -q 1e5 -n counties=<( \
    geoproject 'd3.geoMercator().fitSize([960, 960], d)' build/simplified.json \
	  | ndjson-split d.features \
      | ndjson-map '(d.id = d.properties.CD_GEOCMU, delete d.properties, d)') \
	| topomerge states=counties -k 'd.id.slice(0, 2)' \
	| topomerge nation=states \
	> br/250gc.json