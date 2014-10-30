# TODO:
#import libs.spin
#import libs.leaflet.spin

L.Icon.Default.imagePath = "images/leaflet"

# marcadores
SENADO_FEDERAL = [-15.799088, -47.865350]
UFES = [-20.277233,-40.303752 ]
CT = [-20.273530, -40.305448]
CEMUNI = [ -20.279483,-40.302690]
BIBLIOTECA = [-20.276519, -40.304503]

public_spreadsheet_url = 'https://docs.google.com/spreadsheet/pub?key=0AhU-mW4ERuT5dHBRcGF5eml1aGhnTzl0RXh3MHdVakE&single=true&gid=0&output=html'
attribution = 'Map generated by <a href="http://wancharle.github.com/Searchlight">Searchlight</a>,  Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a>'
L.Icon.Default.imagePath=getSLpath()+"../images/leaflet"

# TODO: mudar nome para SLmain
window.main= () ->
  mainf = getURLParameter("mainf") # define uma funcao de inicializacao
  if mainf
    eval(mainf+"()")
  else
    mps = new Searchlight()
    window.onSLcarregaDados= (sl) ->
      sl.autoZoom()
L.Icon.Default.imagePath = "/sl/images/leaflet";    
window.SL_ICON_CLUSTER = new L.DivIcon({ html: '<div><span>1</span></div>', className: 'marker-cluster marker-cluster-small', iconSize: [40,40],popupAnchor:[0,-35]});
window.SL_ICON_PADRAO = new L.Icon.Default()

# referencia para callback
referencia_atual = null
sl_referencias = {}
window.SL = (map_id) ->
    "funcao global para pegar a referencia do objeto mapa"
    return sl_referencias[map_id]

class Searchlight

  constructor: (opcoes={}) ->
    d = new Dicionario(opcoes)
    @container_id =  d.get('container_id','map')
    @tab_id = "tab-"+ @container_id
    @map_id = "map-"+ @container_id
    @lista_id = "lista-"+ @container_id
    @opcoes_id = "opcoes-"+ @container_id
    sl_referencias[@map_id]  = this 

    @Icones =  d.get('icones', null)
    @esconder_icones =  d.get('esconder_icones', true)
    @clusterizar =  d.get('clusterizar', true)
    @useBsPopup = d.get('useBsPopup', true)


    @urlosm =  d.get('url_osm',"http://{s}.tile.osm.org/{z}/{x}/{y}.png")
    @url =  d.get('url', null)
    if not @url
        @url = decodeURIComponent(getURLParameter("data"))
    
    # funcao de conversao para  geoJSON
    func = (item) -> return item
    @func_convert = d.get('convert',func)

    @create()
    
    @dados = new Dados(this)
    @tabList = new TabList(@lista_id,this)
    @get_data()

  getIS: =>  # retorna a string da instancia
    return "SL(\"#{@map_id}\")" 
  create: () =>
    # criando container:
    $("##{@container_id}").append("<ul class='nav nav-tabs' role='tablist'>
    <li class='active'><a data-toggle='tab' href='##{@tab_id}'>Mapa</a></li>
    <li><a data-toggle='tab' href='#tab-#{@lista_id}'>Lista</a></li>
    <li><a data-toggle='tab' href='#tab-#{@opcoes_id}'>Opções</a></li>
    </ul>
    <div class='tab-content'>
      <div class='tab-pane active' id='#{@tab_id}'><div id='#{@map_id}' > </div> </div>
      <div class='tab-pane' id='tab-#{@lista_id}' ><div id='#{@lista_id}'> </div> </div>
      <div class='tab-pane' id='tab-#{@opcoes_id}' > </div>
    </div> ")
    @bsPopup = new Popup(this,@container_id)

    @CamadaBasica = L.tileLayer(@urlosm,  { 'attribution': attribution, 'maxZoom': 18 })
    @map = L.map(@map_id, {layers:[@CamadaBasica],'center': SENADO_FEDERAL,'zoom': 13}) #TODO: mudar centro e zoom 
    
    # criando camada com clusters
    if @clusterizar
        @markers = new L.MarkerClusterGroup({ zoomToBoundsOnClick: false})
    else
        @markers = new L.FeatureGroup()
    @map.addLayer(@markers)
   
    # criando classe para controlar o mapa
    @control = new  Controle(this)
    
      
  get_data: () =>
    obj = this
    @markers.fire("data:loading")
   
    # obtendo dados
    if @url.indexOf("docs.google.com/spreadsheet") > -1 
      Tabletop.init( { 'key': @url, 'callback':  (data)=>
          @carregaDados(data)
      , 'simpleSheet': true } )
    else
      if @url.slice(0,4)=="http"
        if @url.slice(-4)==".csv"
          Papa.parse(@url, {
            header:true,
            download: true,
            complete: (results, file) =>
              @carregaDados(results['data'])
            })

        else
          getJSONP(@url, (data)=>
              @carregaDados(data)
          )
      else
        getJSON(@url, (data) =>
          @carregaDados(data)
        )

  add_itens_gdoc: (data) =>
    for d,i in data
      p =  [parseFloat(d.latitude.replace(',','.')), parseFloat(d.longitude.replace(',','.'))]
      L.marker(p).addTo(@basel).bindPopup(d.textomarcador)
    @map.addLayer(@basel)
    @map.fitBounds(@basel.getBounds())

  autoZoom: () =>
    @map.fitBounds(@markers.getBounds())

  carregaDados: ( data)=>
    try
      for d, i in data
        @addItem(d)
    catch e
      console.log(e)
      @markers.fire("data:loaded")
      alert("Não foi possivel carregar os dados do mapa. Verifique se a fonte de dados está formatada corretamente.")
      return
    console.log('dados carregados');
    @markers.clearLayers()
    @dados.addMarkersTo(@markers)
    
    if @map.getBoundsZoom(@markers.getBounds()) == @map.getZoom()
      @carregando = false
    else
      @map.fitBounds(@markers.getBounds())
      @carregando = true

    @control.addCatsToControl(@map_id)
    @tabList.load()
    @markers.fire("data:loaded")
    @control.atualizarIconesMarcVisiveis()

    if @carregando == false and window['onSLcarregaDados'] != undefined
      onSLcarregaDados(this)
    # ao terminar de carregar faz zoom automatico sobre area dos dados.
    @autoZoom() 
      
  addItem: (item) =>
    @dados.addItem(item,@func_convert)

  mostrarCamadaMarkers: () =>
    @map.addLayer(@markers)
    @map.setView(@map_ultimo_center, @map_ultimo_zoom)

  esconderCamadaMarkers: () =>
    @map.removeLayer(@markers)
    @map_ultimo_zoom =  @map.getZoom()
    @map_ultimo_center = @map.getCenter()

window.Searchlight = Searchlight

# vim: set ts=2 sw=2 sts=2 expandtab:
