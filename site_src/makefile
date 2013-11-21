all:
	rapydscript js/searchlight.py > js/searchlight.js
	cd js;cat libs/leaflet05.js libs/spin.js libs/leaflet/spin.js libs/leaflet/markercluster/markercluster.js  libs/jquery191min.js  libs/jquery/getUrlParam.js  libs/tabletop.js control.js searchlight.js > /tmp/searchlight.js; cat /tmp/searchlight.js > searchlight.js

	rapydscript js/exemplos.py > js/exemplos.js
	cd js;cat exemplos/markercluster.js exemplos.js > /tmp/ex.js; mv /tmp/ex.js exemplos.js
	jekyll build


