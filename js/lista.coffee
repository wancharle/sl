#classe responsavel pela visalizcao em lista
#

class TabList
  constructor: (lista_id,dados)->
    @lista_id = lista_id
    @dados = dados


  load: ()->
    html= '<table class="table">'
    for cat_name in @dados.getCategorias()
      for obj in @dados.getCatByName(cat_name)
        html= "#{html}<tr><td>#{obj.texto}</td><td>#{cat_name}</td></tr>"
    html = "#{html}</table>" 
    $("##{@lista_id}").html(html)
    console.log 'ok'

# vim: set ts=2 sw=2 sts=2 expandtab:
