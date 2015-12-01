class Icones
  @icones = {}
  @getIcone: (id,config)->
    i = Icones.icones[id+""]
    if not i
      i = new L.icon(config.Icones[id+""])
      Icones.icones[id+""]=i
    return i

class Marcador
  constructor:(geoItem,config)->
    @config = config
    @m = null
    @id = geoItem.hashid
    @id_parent = geoItem.id_parent
    @latitude = parseFloatPTBR(geoItem.latitude)
    @longitude = parseFloatPTBR(geoItem.longitude)
    @texto = geoItem.texto or geoItem.comentarios
    if geoItem.icon_id
      @icon = Icones.getIcone(geoItem.icon_id,config)
    else
      @icon = window.SL_ICON_PADRAO
    
    if geoItem.cat
      @cat_id = geoItem.cat_id
      @cat = geoItem.cat.replace(",","").replace('"','')
    else
      @cat = "descategorizado"
      @cat_id = 1

    @title = geoItem.title

  getMark: () ->
    if @m == null
      p =  [@latitude,@longitude ]
      m = new L.Marker(p)
      m.setIcon(@icon)
      @m = m
      @m.slinfo = this
      html="#{m.slinfo.texto}<p><a href='javascript:void(0);' onclick='Searchlight.PopupMarcador.show(\"#{@config.map_id}\")'>ver mais</a></p>"
      @m.bindPopup(html,{'maxWidth':640})
    return @m


module.exports = {Marcador:Marcador}

# vim: set ts=2 sw=2 sts=2 expandtab:
