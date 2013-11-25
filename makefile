all:
	rapydscript js/searchlight.py > js/searchlight.js
	cd js;cat libs/leaflet05.js libs/spin.js libs/leaflet/spin.js libs/leaflet/markercluster/markercluster.js  libs/jquery191min.js  libs/jquery/getUrlParam.js  libs/tabletop.js control.js searchlight.js > /tmp/searchlight.js; cat /tmp/searchlight.js > ../site_src/js/searchlight.js

	rapydscript js/exemplos.py > js/exemplos.js
	cat js/exemplos/markercluster.js js/exemplos.js > /tmp/ex.js; mv /tmp/ex.js site_src/js/exemplos.js
	cd site_src; jekyll build
	rsync -av /tmp/site/ ../site/


