if not window.scriptFolder
    scriptEls = document.getElementsByTagName( 'script' )
    thisScriptEl = scriptEls[scriptEls.length - 1]
    scriptPath = thisScriptEl.src
    scriptFolder = scriptPath.substr(0, scriptPath.lastIndexOf( '/' )+1 )
else
    scriptFolder = window.scriptFolder


$("<link/>", {
   rel: "stylesheet",
   type: "text/css",
   href: "http://cdn.leafletjs.com/leaflet-0.7.3/leaflet.css"
   #href: scriptFolder+ "./bower_components/leaflet/dist/leaflet.css"

}).appendTo("head")

$("<link/>", {
   rel: "stylesheet",
   type: "text/css",
   href: "https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css"

}).appendTo("head")



$("<link/>", {
   rel: "stylesheet",
   type: "text/css",
   href: scriptFolder+"./js/markercluster/MarkerCluster.css"
}).appendTo("head")

$("<link/>", {
   rel: "stylesheet",
   type: "text/css",
   href: scriptFolder+"./js/markercluster/MarkerCluster.Default.css"
}).appendTo("head")


$("<link/>", {
   rel: "stylesheet",
   type: "text/css",
   href: scriptFolder+"./css/searchlight.css"
}).appendTo("head")


window.getSLpath=() ->  scriptFolder

window.SLControl = L.Control.extend({
    options: {
        position: 'topright'
    },

    onAdd: (map) ->
        # create the control container with a particular class name
        container = L.DomUtil.create('div', 'searchlight-control leaflet-control-layers')
        container.innerHTML = "<div class='searchlight-opcoes'><ul> </ul></div>"
        container.innerHTML += "<div class='searchlight-analise'></div>"
        stop = L.DomEvent.stopPropagation
        # ... initialize other DOM elements, add listeners, etc.
        L.DomEvent.on(container, 'click', stop)
        L.DomEvent.on(container, 'mousedown', stop)
        L.DomEvent.on(container, 'mouseover', stop)
        L.DomEvent.on(container, 'touchstart', stop)
        L.DomEvent.on(container, 'touchend', stop)
        L.DomEvent.on(container, 'dblclick', stop)
        L.DomEvent.on(container, 'scroll', stop)
        L.DomEvent.on(container, 'mousewheel', stop)

        return container
    
})

window.SLUndoRedoControl = L.Control.extend({
    options: {
        position: 'bottomleft'
    },

    onAdd: (map) ->
        # create the control container with a particular class name
        container = L.DomUtil.create('div', 'leaflet-control-layers')
        container.innerHTML += "<div class='searchlight-undozoom'></div>"
        stop = L.DomEvent.stopPropagation
        #  initialize other DOM elements, add listeners, etc.
        L.DomEvent.on(container, 'click', stop)
        L.DomEvent.on(container, 'mousedown', stop)
        L.DomEvent.on(container, 'mouseover', stop)
        L.DomEvent.on(container, 'touchstart', stop)
        L.DomEvent.on(container, 'touchend', stop)
        L.DomEvent.on(container, 'dblclick', stop)
        L.DomEvent.on(container, 'scroll', stop)
        L.DomEvent.on(container, 'mousewheel', stop)

        return container
})

