requirejs.config({
	baseUrl: 'js/lib',
	shim: {
		'jquery-ui': {
			deps: [
				'jquery'
			],
			'requirecontext': true
		},
		'nv.d3': {
			deps: ['d3.v2.min']
		}
	},
	paths: {
		'app': '../app',
		'data': '../app/data',
		'hardata': '../app/hardata'
	}
});

requirejs(['jquery', 'hardata', 'jquery-ui', 'nv.d3'],
function ($) {
	$(function () {
		function doTheGraph(data) {
			data = JSON.parse(data);
			nv.addGraph(function() {
			  var chart = nv.models.stackedAreaChart()
			                .x(function(d) { return d[0] })
			                .y(function(d) { return d[1] })
			                .clipEdge(true);

			  chart.xAxis
			      .showMaxMin(false)
			      .tickFormat(function(d) { return d3.time.format('%a %H:%M %S')(new Date(d)) });

			  chart.yAxis
			      .tickFormat(d3.format(',.0f'));

			  d3.select('.result svg')
			    .datum(data)
			      .transition().duration(500).call(chart);

			  nv.utils.windowResize(chart.update);

			  return chart;
			});
		}

		function getTheData() {
			var def = $.Deferred();
			$.ajax('/api/226', {
				'success': function (data) {
					def.resolve(data)
				},
				'error': function (data) {
					def.reject(data)
				}
			});
			return def
		}

		getTheData()
			.then(doTheGraph)
	});
});