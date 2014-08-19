class Dados
  constructor: () ->
    @clear()

  clear: () =>
    @marcadores = []
    @categorias = {}
    @categorias_id = {}

  getCat: (m)=>
    cat=@categorias[m.cat]
    if cat
      return cat
    else
      @categorias[m.cat] = []
      @categorias_id[m.cat] = m.cat_id
      return @categorias[m.cat]

  addItem : (i,func_convert) =>
    geoItem = func_convert(i)
    m =  Marcador(geoItem)
    cat = @getCat(m)
    cat.append(m)

  getCatLatLng: (name) =>
      v = []
      for m, i in @categorias[name]
          v.append(m.getMark().getLatLng())
      return v

  catAddMarkers:(name,cluster) =>
    for m, i in @categorias[name]
      cluster.addLayer(m.getMark())

  addMarkersTo: (cluster) =>
    for k, i in dict.keys(@categorias)
      @catAddMarkers(k,cluster)

# vim: set ts=2 sw=2 sts=2 expandtab:
