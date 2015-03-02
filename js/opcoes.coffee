# classe responsavel pela visualizacao da aba opcoes

class FormOpcoes
  constructor: (tabOpcoes)->
    @tabOpcoes = tabOpcoes
    @idUrlOSM = @tabOpcoes.sl.config.container_id + '-urlosm'
    @idUrl = @tabOpcoes.sl.config.container_id + '-url'
    @idClusterizar = @tabOpcoes.sl.config.container_id + '-clusterizar'
  
  render: ()->
    html="
<form>
<div class='form-group'>
  <label for='urlosm'>Servidor Open Street Map</label>
  <input type='url' class='form-control' value='#{@tabOpcoes.sl.config.urlosm}' id='#{@idUrlOSM}' placeholder='informe uma url do tipo OSM'>
</div>
<div class='form-group'>
  <label for='url'>URL de dados</label>
  <input type='url' class='form-control' value='#{@tabOpcoes.sl.config.url}}id='#{@idUrl}' placeholder='informe o endereço público dos dados'>
  <p class='help-block'>Formatos aceitos: json, jsonp, csv e google spreadsheet.</p>
</div>
<div class='checkbox'>
  <label>
    <input type='checkbox' #{if @tabOpcoes.sl.config.clusterizar then "checked" else ""} id='#{@idClusterizar}'> Agrupar marcadores
  </label>
</div>
<button type='submit' class='btn btn-default searchlight-btn-salvar'>Salvar</button>
</form>"

    $("##{@tabOpcoes.opcoes_id}").html(html)
    @bind()

  bind: ()->
    self = @
    $("##{@idClusterizar}").on 'change', (ev) ->
      self.tabOpcoes.sl.config.clusterizar = @.checked

    $("##{@idUrlOSM}").on 'change', (ev) ->
      self.tabOpcoes.sl.config.urlosm = $(@).val()

    $("##{@idUrl}").on 'change', (ev) ->
      self.tabOpcoes.sl.config.url = $(@).val()



    $("button.searchlight-btn-salvar").on 'click', (ev) =>
      searchlight = new Searchlight(@tabOpcoes.sl.config.getJSON())


class TabOpcoes
  constructor: (opcoes_id,sl)->
    @sl = sl
    @popup = @sl.bsPopup
    @opcoes_id = opcoes_id
    @dados = sl.dados

    @form = new FormOpcoes(this)
    @form.render()


  _instancia: ->  "#{@sl.getIS()}.TabOpcoes"

  load: ()->
   console.log 'TabOpcoes carregado'

  open: (i,cat_name) ->
    obj= @dados.getCatByName(cat_name)[i]

    @popup.setTitle(obj.cat)
    @popup.setBody(obj.texto)
    @popup.show()
    return false
  

# vim: set ts=2 sw=2 sts=2 expandtab:

