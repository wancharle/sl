class Dados
  @instances = {}

  @getIS: (config)->
    return Dados.instances[config.container_id]

  constructor: (sl)->
    Dados.instances[sl.config.container_id]=@
    @sl = sl
    @config = sl.config
    @clear()

  clear: =>
    @marcadores = []
    @categorias = {}
    @categorias_id = {}

  get_data_fonte: (fonte)=> 
    # obtendo dados
    if fonte.url.indexOf("docs.google.com/spreadsheet") > -1 
      Tabletop.init( { 'key':fonte.url, 'callback':  (data)=>
          @carregaDados(data)
      , 'simpleSheet': true } )
    else
      if fonte.url.slice(0,4)=="http"
        if fonte.url.slice(-4)==".csv"
          Papa.parse(fonte.url, {
            header:true,
            download: true,
            complete: (results, file) =>
              @carregaDados(results['data'])
            })

        else
          getJSONP(fonte.url, (data)=>
              @carregaDados(data)
          )
      else
        getJSON(fonte.url, (data) =>
          @carregaDados(data)
        )

  get_data: () =>
    obj = this
    $(@config.container_id).trigger("dados:carregando")
    fonte = @config.fontes.getFonte("0") # todo generalizar para mis de uma fonte.
    @get_data_fonte(fonte)
  
  carregaDados: (data)->
    @sl.carregaDados(data)

  getItensCount:() ->
    # retorna o total de itens por url
    itens = 0
    for cat in @getCategorias()
      itens+= @getCatByName(cat).length

    return itens

  getCatByName: (cat_name)->
    # retorna a lista de marcadores de uma determinada categoria
    return @categorias[cat_name]

  _getCatOrCreate: (m)=>
    cat=@categorias[m.cat]
    if cat
      return cat
    else
      @categorias[m.cat] = []
      @categorias_id[m.cat] = m.cat_id
      return @categorias[m.cat]

  addItem : (i,func_convert) =>
    geoItem = func_convert(i)
    if geoItem
      m =  new Marcador(geoItem,@sl.getIS())
      cat = @_getCatOrCreate(m)
      cat.push(m)

  getCatLatLng: (name) =>
      v = []
      for m, i in @categorias[name]
          v.push(m.getMark().getLatLng())
      return v

  catAddMarkers:(name,cluster) =>
    for m in @getCatByName(name)
      cluster.addLayer(m.getMark())

  
  addMarkersTo: (cluster) =>
    for cat in @getCategorias() #Object.keys(@categorias)
      @catAddMarkers(cat,cluster)

  getCategorias: ->
    return (cat for cat in Object.keys(@categorias))

# vim: set ts=2 sw=2 sts=2 expandtab:
