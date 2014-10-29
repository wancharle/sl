#classe responsavel pela visalizcao em lista
#

class TabList
  constructor: (lista_id,sl)->
    @sl = sl
    @popup = @sl.bsPopup
    @lista_id = lista_id
    @dados = sl.dados
    if not window.SLTabList
        window.SLTabList = {}  
    window.SLTabList[lista_id]=this


  _instancia: ->  "window.SLTabList[\"#{@lista_id}\"]"

  load: ()->
    html= '<table class="table">'
    for cat_name in @dados.getCategorias()
      for obj,i in @dados.getCatByName(cat_name)
        html= "#{html}<tr><td><a href=\"javascript:void(0);\" onclick='javascript:#{@_instancia()}.open(#{i},\"#{cat_name}\");false;'> #{cat_name}</a></td><td>#{obj.texto}</td></tr>"
    html = "#{html}</table>" 
    $("##{@lista_id}").html(html)
    console.log 'TabList carragado'

  open: (i,cat_name) ->
    obj= @dados.getCatByName(cat_name)[i]

    @popup.setTitle(obj.cat)
    @popup.setBody(obj.texto)
    @popup.show()
    return false
    
     
# vim: set ts=2 sw=2 sts=2 expandtab:
