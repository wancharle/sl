  
dataview =
  corrigeImagem: (geoItem) ->
    img = document.getElementById('img-'+geoItem.hashid)
    p = document.getElementById('pimg-'+geoItem.hashid)
    if img.width > img.height
      img.width = 400
      p.width = 400
    else
      img.height = 200

  getTextoParaPopup: (geoItem,texto)->
    extra = ""
    obj = geoItem

    if obj.fotoURL
      if obj.fotoURL.indexOf('.jpg') > 0
        foto= obj.fotoURL.replace('_250x250.jpg','_400x400.jpg')
      else
        foto = "#{obj.fotoURL}_400x400"
      extra = "<p style='width:400px' id='pimg-#{geoItem.hashid}'><img id='img-#{geoItem.hashid}' src='#{foto}' /></p>"
    if obj.youtubeVideoId
        extra += "<div><iframe width='320px' height='240px' src='//www.youtube.com/embed/#{obj.youtubeVideoId}?rel=0' frameborder='0' allowfullscreen></iframe></div> "
    if texto
      return texto + extra
    else
      return extra
 

module.exports = dataview 

# vim: set ts=2 sw=2 sts=2 expandtab:
