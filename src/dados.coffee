Marcador = require('./marcador').Marcador

class Dados
  @EVENT_DATA_LOADED = 'dados:loaded.slmapa'
  @instances = {}

  @getIS: (config)->
    return Dados.instances[config.container_id]

  constructor: (sl)->
    Dados.instances[sl.config.container_id]=@
    @sl = sl
    @api = sl.slsapi
    @config = sl.config
    @clear()

  clear: =>
    @marcadores = {}

  addDataSource:(jsonDataSource)-> @dataPool.addDataSource(jsonDataSource)

  getFonte:(i)-> @dataPool.getDataSource(i)

  getFontes:-> @dataPool.getDataSources()

  get_data: () =>
    $("##{@config.container_id}").trigger("dados:carregando")
    @dataPool = SLSAPI.dataPool.createDataPool(@api.mashup)
    @dataPool.loadAllData()
    @api.off(SLSAPI.dataPool.DataPool.EVENT_LOAD_STOP)
    @api.on(SLSAPI.dataPool.DataPool.EVENT_LOAD_STOP, (dataPool)=>
      for source in dataPool.dataSources 
        @carregaDados(source.notes,source)

      $("##{@config.container_id}").trigger('dados:carregados')
      SLSAPI.events.trigger(@api.config.id,Dados.EVENT_DATA_LOADED)
    )

  carregaDados: (data,fonte)->
    console.log("fonte carregando: #{fonte.url}")
    try
      for geoItem in data
        @addItemMarkers(geoItem,fonte)
    catch e
      console.error(e.toString())
      @markers.fire("data:loaded")
      alert("Não foi possivel carregar os dados do mapa. Verifique se a fonte de dados está formatada corretamente.")
      return
  
  getItensCount:() ->
    # retorna o total de itens por url
    itens = 0
    for cat in @getCategorias()
      itens+= @getCatByName(cat).length
    return itens

  getCategoriaId: (cat_name)->
    for ds, i in @getFontes()
      catid =  ds.categories_id[cat_name]
      if catid
        return catid
    return null

  # retorna a lista de marcadores de uma determinada categoria
  getCatByName: (cat_name)->
    markers = []
    for ds, i in @getFontes()
      catmarkers =  ds.categories[cat_name]
      if catmarkers
        markers = markers.concat(catmarkers)
    return markers

  getFilhos: (pai_id)->
    list = []
    for ds,i in @dataPool.dataSources
      filhos = ds.notesChildren[pai_id]
      if filhos
        list=list.concat(filhos)

    return list

  addItemMarkers : (geoItem) =>
      m =  new Marcador(geoItem,@config)
      @marcadores[geoItem.hashid]=m

  getCatLatLng: (name) =>
      v = []
      for m, i in @categorias[name]
          v.push(m.getMark().getLatLng())
      return v

  catAddMarkers:(name,cluster) =>
    for m in @getCatByName(name)
      cluster.addLayer(@marcadores[m.hashid].getMark())
  
  addMarkersTo: (cluster) =>
    for cat in @getCategorias() #Object.keys(@categorias)
      @catAddMarkers(cat,cluster)

  getCategorias: ->
    cats = []
    for ds,i in @getFontes()
      for cat,i in Object.keys(ds.categories)
        if cat
          cats.push(cat)
    return cats

module.exports = {'Dados':Dados}

# vim: set ts=2 sw=2 sts=2 expandtab:
