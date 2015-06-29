#classe responsavel pela visalizcao em lista

Popup = require('./bspopup').Popup
Dados = require('./dados').Dados
class TabList
  @instances = {}
  @getIS: (config)-> TabList.instances[config.container_id]
  
  constructor: (config)->
    @config = config
    TabList.instances[@config.container_id] = @

    @popup = Popup.getIS(config)
    @lista_id = @config.lista_id
    @dados = Dados.getIS(config)

    # sempre que carregar os dados tablist se carrega
    $("##{@config.container_id}").on 'dados:carregados', () =>
      @load()


  load: ()->
    html= '<table class="table">'
    for cat_name in @dados.getCategorias()
      for obj,i in @dados.getCatByName(cat_name)
        if cat_name == 'undefined'
          cat_str = obj.user.username
        else 
          cat_str = cat_name
        html= "#{html}<tr><td><a href='javascript:void(0);' data-index='#{i}' data-cat='#{cat_name}' class='tablist-item'> #{cat_str}</a></td><td>#{obj.texto or obj.comentarios}</td></tr>"
    html = "#{html}</table>" 

    $("##{@lista_id}").html(html)

    # amarando eventos
    self = @
    $("##{@lista_id} a.tablist-item").on 'click', (ev) ->
      i = $(this).data('index')
      cat_name = $(this).data('cat')
      self.open(i,cat_name) 

    console.log 'TabList carregado'

  open: (i,cat_name) ->
    obj= @dados.getCatByName(cat_name)[i]

    @popup.setTitle(obj.cat)
    @popup.setBody(obj.texto)
    @popup.show()
    return false
    
module.exports = {TabList:TabList}
# vim: set ts=2 sw=2 sts=2 expandtab:
