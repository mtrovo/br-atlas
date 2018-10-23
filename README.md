# Brazil Atlas TopoJSON

This repository provides a TopoJSON file generated from the [IBGE's](https://www.ibge.gov.br/) shapefiles, 2017 edition.

### Usage

In a browser (using [d3-geo](https://github.com/d3/d3-geo) and SVG):

```html
<!DOCTYPE html>
<svg width="960" height="960" fill="none" stroke="#000" stroke-linejoin="round" stroke-linecap="round"></svg>
<script src="https://d3js.org/d3.v4.min.js"></script>
<script src="https://unpkg.com/topojson-client@3"></script>
<script>

var svg = d3.select("svg");

var path = d3.geoPath();

d3.json("./br/250gc.json", function(error, br) {
  if (error) throw error;
  
  svg.append("path")
      .attr("stroke", "#aaa")
      .attr("stroke-width", 0.5)
      .attr("d", path(topojson.mesh(br, br.objects.counties, function(a, b) { return a !== b; })));

  svg.append("path")
      .attr("stroke-width", 0.5)
      .attr("d", path(topojson.mesh(br, br.objects.states, function(a, b) { return a !== b; })));

  svg.append("path")
      .attr("d", path(topojson.feature(br, br.objects.nation)));
});

</script>


## File Reference

### br/250gc.json

A [TopoJSON *topology*](https://github.com/topojson/topojson-specification/blob/master/README.md#21-topology-objects) containing three geometry collections: <i>counties</i>, <i>states</i>, and <i>nation</i>. The geometry is quantized, projected using [d3.geoMercator](https://github.com/d3/d3-geo/blob/master/README.md) to fit a 960×960 viewport, and simplified. This topology is derived from the IBGE's cartographic county boundaries, 2017 edition. The state boundaries are computed by [merging](https://github.com/topojson/topojson-client/blob/master/README.md#merge) counties, and the nation boundary is computed by merging states, ensuring a consistent topology.

#### br.objects.counties
![Brazil with counties](/img/counties.png)

#### br.objects.states
![Brazil with states](/img/states.png)

#### br.objects.nation
![Brazil nation](/img/nation.png)

