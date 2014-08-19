
class Marcador
  constructor:(geoItem)->
    @m = null
    @latitude = parseFloat(geoItem.latitude.replace(',','.'))
    @longitude = parseFloat(geoItem.longitude.replace(',','.'))
    @texto = geoItem.texto
    if geoItem.icon
      @icon = geoItem.icon
    else
      @icon = sl_IconePadrao
    
    if geoItem.cat
      @cat_id = geoItem.cat_id
      @cat = geoItem.cat.replace(",","").replace('"','')
    else
      @cat = "descategorizado"
      @cat_id = 1

  getMark: () =>
    if @m == null
      p =  [@latitude,@longitude ]
      m = new L.Marker(p)
      m.setIcon(@icon)
      @m = m
      @m.slinfo = this
      @m.bindPopup(m.slinfo.texto,{'maxWidth':640})
    return @m

# vim: set ts=2 sw=2 sts=2 expandtab:
