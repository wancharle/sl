class Dados
  constructor: (sl)->
    @sl = sl
    @clear()

  clear: =>
    @marcadores = []
    @categorias = {}
    @categorias_id = {}

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
