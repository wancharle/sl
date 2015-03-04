# classe responsavel pela visualizacao da aba opcoes
class PopupFontes
  constructor: (config) ->
    @idUrl = config.container_id + '-url'
    @idFunc = config.container_id + '-func'
    @popup = Popup.getIS(config)
    
  setFonte: (fonte=null,i=null) ->
    if i == null
      @fonte = {url:'',func_code: ''}
    else
      @fonte = fonte
    @fonte_id = i

  renderPopup: (callback=null,oktext='Adicionar')->
    html ="<div class='form-group'>
        <label for='#{@idUrl}' class='control-label'>URL</label>
        <input type='url' class='form-control' value='#{@fonte.url}' id='#{@idUrl}' placeholder='informe o endereço público dos dados'>
        <p class='help-block'>Formatos aceitos: json, jsonp, csv e google spreadsheet.</p>

        <label for='#{@idFunc}' class='control-label'>Código da função de conversão</label>
          <textarea rows='6' type='text' class='form-control' id='#{@idFunc}' placeholder='código para converter os dados no formato do searchlight'>#{@fonte.func_code}</textarea>
        <br/>
      </div>
    "

    @popup.setTitle('Cadastrar Fonte de Dados')
    self = @
    @popup.setBody(
      html,
      oktext,
      (e)-> return self.popupValidate(e),
      true,
      (e)-> self.popupCancel(e))
    @popup.show()
    @popupValido = false

  saveFonte: (url,func_code)->
    if @fonte_id >=0
      @fonte.url = url
      @fonte.func_code = func_code
    else
      @config.fontes.addFonte({url:url,func_code:func_code})

  popupValidate: (e)->
    url = $("##{@idUrl}").val()
    if url 
      func_code = $("##{@idFunc}").val()
      try
        func_name = "sl#{(new Date()).getTime()}"
        eval("#{func_name} = #{func_code}")
        func_code = eval(func_name)
        @popupValido = true
        @saveFonte(url,func_code)
      catch e
        alert(e.toString())
      
    if not @popupValido
      e.preventDefault()
      e.stopImmediatePropagation()
      return false 
    else 
      return true

  popupCancel: (e)->
    @popupValido = true
    return true

class FormOpcoes
  constructor: (config)->
    @idUrlOSM = config.container_id + '-urlosm'
    @config = config
    
    @idClusterizar = @config.container_id + '-clusterizar'
    @idFontesDados = @config.container_id + '-ulFontesDados'
    @popupFontes = new PopupFontes(config)

  render: ()->
    html="
<form >
<br>
<fieldset>
<legend>Fontes de dados</legend>
<div class='form-group'>
<ul class='list-group' id=#{@idFontesDados}'>
    "
    for fonte,i in @config.fontes.getFontes()
      html+="<li class='list-group-item'><span class='pull-right'><a class='link-alterar' data-fonte='#{i}' href='#'>Alterar</a> | <a class='link-remover'data-fonte='#{i}' href='#'>Remover</a></span> <a href='#{fonte.url}' target='_blank'>#{fonte.url}</a></span></li>"
    
    html+="</ul>
<button type='button' class='btn btn-primary searchlight-btn-add-fonte'>Adicionar fonte</button>
</div>
</fieldset>
<fieldset>
<legend>Opções do Mapa</legend>
<div class='form-group'>
  <label for='urlosm'>Servidor Open Street Map</label>
  <input type='url' class='form-control' value='#{@config.urlosm}' id='#{@idUrlOSM}' placeholder='informe uma url do tipo OSM'>
</div>

<div class='checkbox'>
  <label>
    <input type='checkbox' #{if @config.clusterizar then "checked" else ""} id='#{@idClusterizar}'> Agrupar marcadores
  </label>
</div>
</fieldset>

<fieldset>
<button type='submit' class='btn btn-default searchlight-btn-salvar'>Salvar</button>
</fieldset>
</form>"

    $("##{@config.opcoes_id}").html(html)
    @bind()

  bind: ()->
    self = @
    $("##{@idClusterizar}").on 'change', (ev) ->
      self.config.clusterizar = @.checked

    $("##{@idUrlOSM}").on 'change', (ev) ->
      self.config.urlosm = $(@).val()

    $("##{@idUrl}").on 'change', (ev) ->
      self.config.url = $(@).val()



    $("button.searchlight-btn-salvar").on 'click', (ev) =>
      searchlight = new Searchlight(@config.getJSON())

    $("##{@config.opcoes_id} button.searchlight-btn-add-fonte").on 'click', (ev) =>
      @popupFontes.setFonte(null,null)
      @popupFontes.renderPopup(fonte)

    $("##{@config.opcoes_id} a.link-alterar").on 'click', (ev) ->
      id_fonte = $(this).data('fonte')
      fonte = self.config.fontes.getFonte(id_fonte)
      self.popupFontes.setFonte(fonte,id_fonte)
      self.popupFontes.renderPopup(null,'Alterar') 
      
# vim: set ts=2 sw=2 sts=2 expandtab:
