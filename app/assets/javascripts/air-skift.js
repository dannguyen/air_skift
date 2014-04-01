$(document).ready(function() {

	// Map controls
	if ($('#map-controls').length) {
		$('#map-controls a.domestic').click(function() {
			$(this).hide();
			$('#map-controls a.international').show();
			return false;
		});

		$('#map-controls a.international').click(function() {
			$(this).hide();
			$('#map-controls a.domestic').show();
			return false;
		});
	}

var zoom = d3.behavior.zoom()
.on("zoom",function() {
map.svg.select("g").attr("transform","translate("+
d3.event.translate.join(",")+")scale("+d3.event.scale+")");
map.svg.select("g").selectAll("circle")
.attr("d", map.path.projection(map.projection));
map.svg.select("g").selectAll("path")
.attr("d", map.path.projection(map.projection));
});

	// if ($('svg').length && svgPanZoom) {
	// 	svgPanZoom.init({
	// 		'selector': 'svg'
	// 	});
	// }

});