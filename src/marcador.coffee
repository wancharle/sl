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
    @geoItem = geoItem

  onPopupOpen:()->
    img = document.getElementById('img-'+@geoItem.hashid)
    p = document.getElementById('pimg-'+@geoItem.hashid)
    if img.width > img.height
      img.width = 400
      p.width = 400
    else
      img.height = 200

    

  getTextoParaPopup: ()->
    extra = ""
    obj = @geoItem

    if obj.fotoURL.indexOf('.jpg') > 0
      foto= obj.fotoURL.replace('_250x250.jpg','_400x400.jpg')
    else
      foto = "#{obj.fotoURL}_400x400"
    if obj.fotoURL
      extra = "<p style='width:400px' id='pimg-#{@geoItem.hashid}'><img id='img-#{@geoItem.hashid}' src='#{foto}' /></p>"
    if obj.youtubeVideoId
        extra += "<div><iframe width='320px' height='240px' src='//www.youtube.com/embed/#{obj.youtubeVideoId}?rel=0' frameborder='0' allowfullscreen></iframe></div> "
    return @texto + extra
 
  getMark: () ->
    if @m == null
      p =  [@latitude,@longitude ]
      m = new L.Marker(p)
      m.setIcon(@icon)
      @m = m
      @m.slinfo = this
      @m.on('popupopen',()=> @onPopupOpen())
      if @config.ver_mais
        html="#{m.slinfo.texto}<p><a href='javascript:void(0);' onclick='Searchlight.PopupMarcador.show(\"#{@config.map_id}\")'>ver mais</a></p>"
      else
        html= @getTextoParaPopup()
      @m.bindPopup(html,{'maxWidth':640})
    return @m


module.exports = {Marcador:Marcador}

# vim: set ts=2 sw=2 sts=2 expandtab:
