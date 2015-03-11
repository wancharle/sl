
class Marcador
  constructor:(geoItem,config)->
    @m = null
    @id = geoItem.id
    @config = config
    @instanceString = "SL(\"#{@config.map_id}\")"
    @latitude = parseFloat(geoItem.latitude.replace(',','.'))
    @longitude = parseFloat(geoItem.longitude.replace(',','.'))
    @texto = geoItem.texto
    if geoItem.icon
      @icon = geoItem.icon
    else
      @icon = window.SL_ICON_PADRAO
    
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
      html="#{m.slinfo.texto}<p><a href='javascript:void(0);' onclick='#{@instanceString}.bsPopup.showMarcador()'>ver mais</a></p>"
      @m.bindPopup(html,{'maxWidth':640})
    return @m

# vim: set ts=2 sw=2 sts=2 expandtab:
