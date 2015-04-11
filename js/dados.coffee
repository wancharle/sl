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
    @marcadores = {}
    @marcadores_filhos = {}
    @categorias = {}
    @categorias_id = {}

  get_data_fonte: (fonte,i)=> 
    # obtendo dados
    console.log(@config)
    if @config.usarCache and @config.noteid
      getJSON("#{@config.urlsls}/note/listaExternal?noteid=#{@config.noteid}&fonteIndex=#{i}", (data)=>
              fonte2 ={ url:fonte.url,func_code: (i)-> return i}           
              @carregaDados(data,fonte2)
      )
      return
    if fonte.url.indexOf("docs.google.com/spreadsheet") > -1 
      Tabletop.init( { 'key':fonte.url, 'callback':  (data)=>
          @carregaDados(data,fonte)
      , 'simpleSheet': true } )
    else
      if fonte.url.slice(0,4)=="http"
        if fonte.url.slice(-4)==".csv"
          Papa.parse(fonte.url, {
            header:true,
            download: true,
            error: ()-> alert("Erro ao baixar arquivo csv da fonte de dados:\n#{fonte.url}"),
            complete: (results, file) =>
              @carregaDados(results['data'],fonte)
            })

        else
          getJSONP(fonte.url, (data)=>
              @carregaDados(data,fonte)
          )
      else
        getJSON(fonte.url, (data) =>
          @carregaDados(data,fonte)
        )

  get_data: () =>
    obj = this
    @fontes_carregadas = []
    $("##{@config.container_id}").trigger("dados:carregando")
    for fonte, i in @config.fontes.getFontes()
      #fonte = @config.fontes.getFonte("0") # todo generalizar para mis de uma fonte.
      @get_data_fonte(fonte,i)


  carregaDados: (data,fonte)->
    @fontes_carregadas.push(fonte)
    try
      for d, i in data
        @addItem(d,fonte.func_code)
    catch e
      console.error(e.toString())
      @markers.fire("data:loaded")
      alert("Não foi possivel carregar os dados do mapa. Verifique se a fonte de dados está formatada corretamente.")
      return
    if @fontes_carregadas.length == @config.fontes.getFontes().length
      $("##{@config.container_id}").trigger('dados:carregados')
  
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

  getFilhos: (pai_id)->
    m = @marcadores_filhos[pai_id] 
    if m 
      return m
    else
      return [] 

  adicioneFilho: (pai_id,filho) ->
    if not @marcadores_filhos[pai_id]
      @marcadores_filhos[pai_id] = [ ]
    @marcadores_filhos[pai_id].push(filho)

  addItem : (i,func_convert) =>
    try
      geoItem = func_convert(i)
    catch e 
      if Searchlight.debug
        console.error("Erro em Dados::addItem: #{e.message}",i)
      geoItem = null
          
    if geoItem
      # se o objeto nao tiver id um hash_id eh gerado.
      if not geoItem.id
       geoItem.id = "#{parseFloat(geoItem.latitude).toFixed(7)}#{parseFloat(geoItem.longitude).toFixed(7)}#{md5(JSON.stringify(geoItem))}" 

      m =  new Marcador(geoItem,@config)
      @marcadores[m.id]  = m
      if geoItem.id_parent
        @adicioneFilho(geoItem.id_parent,m)


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
