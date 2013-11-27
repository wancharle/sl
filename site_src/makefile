all:
	rapydscript js/searchlight/searchlight.py > /tmp/searchlight.js
	cd js;cat libs/leaflet05.js libs/spin.js libs/leaflet/spin.js libs/leaflet/markercluster/markercluster.js  libs/jquery191min.js  libs/jquery/getUrlParam.js  libs/tabletop.js searchlight/control.js /tmp/searchlight.js > searchlight.js; 

	rapydscript js/exemplos/exemplos.py > /tmp/exemplos.js
	cat js/exemplos/markercluster.js /tmp/exemplos.js > js/exemplos.js
	jekyll build
	rsync -arv /tmp/site/ ../../site/


