# classe responsavel pela visualizacao da aba opcoes

Popup = require('./bspopup').Popup
class PopupFontes
  constructor: (config,@dados) ->
    @idUrl = config.container_id + '-url'
    @idFunc = config.container_id + '-func'
    @popup = Popup.getIS(config)
    @config = config
    
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
    if @fonte_id >= 0 and @fonte_id != null
      @fonte.url = url
      @fonte.func_code = func_code
    else
      console.log('adicionando  nova fonte')
      @dados.addDataSource({url:url,func_code:func_code})
    $("##{@config.container_id}").trigger("fontes:update")

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
      
module.exports = {PopupFontes:PopupFontes}
# vim: set ts=2 sw=2 sts=2 expandtab:
