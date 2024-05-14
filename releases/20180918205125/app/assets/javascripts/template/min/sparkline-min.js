function defaultChartConfig(t,a){nv.addGraph(function(){var n=nv.models.sparklinePlus();return n.margin({left:30}).x(function(t,a){return a}).xTickFormat(function(t){return d3.time.format("%x")(new Date(a[t].x))}),d3.select(t).datum(a).transition().duration(250).call(n),n})}function sine(){for(var t=[],a=+new Date,n=0;100>n;n++)t.push({x:a+1e3*n*60*60*24,y:Math.sin(n/10)});return t}function volatileChart(t,a,n){var r=[],e=+new Date;n=n||100;for(var i=1;n>i;i++){r.push({x:e+1e3*i*60*60*24,y:t});var o=Math.random(),u=2*a*o;u>a&&(u-=2*a),t+=t*u}return r}defaultChartConfig("#chart1",sine()),defaultChartConfig("#chart2",volatileChart(130,.02)),defaultChartConfig("#chart3",volatileChart(25,.09,30));