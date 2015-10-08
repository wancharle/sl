


attribution = 'Map generated by <a href="http://wancharle.github.com/Searchlight">Searchlight</a>,  Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a>'
CENTER = [-15.799088, -47.865350]
smap = angular.module('smap',[ ])

smap.directive 'slMap', () ->
  scope:
    json : '='
    osm: '=?'
    height: '@'
  replace: true
  link: (scope, element, attr) ->
    scope.osm = if angular.isDefined(scope.osm) then $scope.osm else "http://{s}.tile.osm.org/{z}/{x}/{y}.png"
    mapDiv = angular.element("##{attr.id} div.map")[0]
    angular.element(mapDiv).height('100%')
      
    CamadaBasica = L.tileLayer(scope.osm,  { 'attribution': attribution, 'maxZoom': 18 })
    scope.map = L.map(mapDiv, {layers:[CamadaBasica],'center': CENTER,'zoom': 13}) 
    scope.$broadcast('mapInit',attr.id) 
    #map.addControl(new SLControl())

  template: "<div><div class='map' sl-control data-map='map'></div></div>"
  
Control =  L.Control.extend({
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


smap.directive 'slControl', ->
  link: (scope, element, attr) ->
    show_opcoes = (event) ->
        $(scope.id_opcoes).show()

    hide_opcoes = (event) ->
        $(scope.id_opcoes).hide()


    addControl = (e,map_id)->
      control = new Control()
      scope.map.addControl(control)

      scope.id_control = "#" + map_id + " div.searchlight-control"
      scope.id_opcoes = "#" + map_id + " div.searchlight-opcoes"
      id_camadas = scope.id_opcoes + "ul"
      
      $(scope.id_control).mouseenter(show_opcoes)
      $(scope.id_control).bind('touchstart',show_opcoes)
      $("#"+map_id).mouseover(hide_opcoes)
      $("#"+map_id).bind('touchstart',hide_opcoes)


    scope.$on 'mapInit', addControl



# vim: set ts=2 sw=2 sts=2 expandtab:
