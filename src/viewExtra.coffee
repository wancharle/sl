#classe responsavel pela visalizcao extra

dataview = require('./dataview')
Dados = require('./dados').Dados
class ViewExtra
  @instances = {}
  @getIS: (config)-> ViewExtra.instances[config.container_id]
  
  constructor: (config)->
    @config = config
    ViewExtra.instances[@config.container_id] = @

    @view_id = @config.view_id
    @dados = Dados.getIS(config)

    # sempre que carregar os dados tablist se carrega
    $("##{@config.container_id}").on 'dados:carregados', () =>
      @load(true)

  renderPane: ()->
    if @config.viewExtra
      return "<div class='tab-pane' id='#{@view_id}'><div class='container-slv'> </div> </div>"
    return ""

  renderLi: ()->
    if @config.viewExtra
      return "<li class='viewExtra'><a data-toggle='tab' href='##{@view_id}'>Extra</a></li>"
    return ""

  load: (carregando)->
    dados = Dados.getIS(@config)
    slview = {mashup: @config.opcoes,dados:dados,id:@view_id}
    viewcode = @config.viewExtra
    result = (slv)->
      eval(viewcode)
    result.call({},slview)

module.exports = {ViewExtra:ViewExtra}
# vim: set ts=2 sw=2 sts=2 expandtab:
