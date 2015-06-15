# classe responsavel pela visualizacao da aba opcoes
PopupFontes = require('./popupFontes').PopupFontes
Popup = require('./bspopup').Popup

class TabConfiguracoes
  constructor: (config,@dados)->
    @config = config
   
    @idFontesDados = @config.container_id + '-ulFontesDados'
    @popupFontes = new PopupFontes(config,@dados)

    @idUrlOSM = config.container_id + '-urlosm'
    @idClusterizar = @config.container_id + '-clusterizar'
    
    @idUrlSLS = config.container_id + '-urlsls'
    @idUsuario = config.container_id + '-usuario'
    @idPassword = config.container_id + '-password'

    @containerQR = @config.container_id + '-qrcode'
    @idViewerTitle = @config.container_id + '-title'
    @idUsarCache = @config.container_id + '-usarcache'


    @render()
    @onLoginLogout()

  onLoginLogout:()->
    if @dados.api.user.isLogged()
      $("##{@config.container_id} .form-login").show()
      $("##{@config.container_id} .form-logout").hide()
    
      $("##{@config.container_id} .form-login .user").html(@dados.api.user.getUsuario())
    else
      $("##{@config.container_id} .form-logout").show()
      $("##{@config.container_id} .form-login").hide()


  onQRCodeClick: ()->
    self = @
    if @dados.api.user.isLogged()
      if not  @dados.api.mashup.title
        alert('Informe um titulo para sua visualização')
      else
        @dados.api.mashup.save(
          (mashup)=>
            @showQRcode(mashup.id)
         ,(err)->
            console.error('Não foi possivel se conectar com o Searchlight Storage:', err)
        )
          
    else
      alert('Voce precisa estar conectado ao Searchlight Storage')


  showQRcode: (mashupid)->
    popup = Popup.getIS(@config)
    popup.setTitle("<p  style='padding:0px;margin:0px;text-align:center'>QR code para o aplicativo Searchlight Mobile</p>")
    popup.setBody("<br><div style='width:300px;margin:0px auto;' id='#{@containerQR}' > </div><br><p style='text-align:center'> Abra o aplicativo Searchlight Mobile e escolha a opção 'Vincular Visualização'. Clique em 'gerar código' para gerar um código de vinculação. Posicione o smartphone adequadamente para ler o código QR acima.</p>")
    popup.show()
    url = "http://sl.wancharle.com.br/mashup/#{mashupid}/"
    $("##{@containerQR}").empty().qrcode({ width:300,height:300,mode:0,'text': url})

  onSalvar: ()->
    sl = SL("map-"+@config.container_id)

    $("##{@config.container_id}").off()
    $("##{@config.container_id} * ").off()
    sl.markers.off()
    sl.map.off()

    sl.markers.clearLayers()
    sl.map.remove()

    newconf = @config.apiconf.toJSON()
    newconf.namespace = Math.random()
    searchlight = new Searchlight(newconf)


  bind: ()->
    self = @
    $("##{@idClusterizar}").on 'change', (ev) ->
      self.config.clusterizar = @.checked


    $("##{@idUrlOSM}").on 'change', (ev) ->
      self.config.urlosm = $(@).val()

    $("##{@idUrl}").on 'change', (ev) ->
      self.config.url = $(@).val()

    $("##{@idUrlSLS}").on 'change', (ev) ->
      self.dados.api.config.serverURL = $(@).val()

    $("##{@idUsuario}").on 'change', (ev) ->
      self.config.slsUser = $(@).val()

    $("##{@idPassword}").on 'change', (ev) ->
      self.config.slsPassword = $(@).val()

    $("##{@idViewerTitle}").on 'change', (ev) ->
      self.dados.api.mashup.title = $(@).val()


    $("##{@config.configuracoes_id} button.searchlight-btn-login").on 'click', (ev) ->
      self.dados.api.user.login(self.config.slsUser, self.config.slsPassword)

    $("##{@config.configuracoes_id} button.searchlight-btn-logout").on 'click', (ev) ->
      self.dados.api.user.logout(()->self.onLoginLogout())

    $(document).on "#{SLSAPI.User.EVENT_LOGIN_FINISH} #{SLSAPI.User.EVENT_LOGIN_FAIL} #{SLSAPI.User.EVENT_LOGOUT_SUCCESS}", () ->
      self.onLoginLogout()


    $("##{@config.configuracoes_id} button.searchlight-btn-qrcodigo").on 'click', (ev) ->
      self.onQRCodeClick()
  
    $("##{@config.configuracoes_id} button.searchlight-btn-salvar").on 'click', (ev) ->
      self.onSalvar(ev)

    $("##{@config.configuracoes_id} button.searchlight-btn-add-fonte").on 'click', (ev) ->
      self.popupFontes.setFonte(null,null)
      self.popupFontes.renderPopup()

    $("##{@config.container_id}").on "fontes:update", (ev)->
      self.renderFontes()


  renderFontes: ()->
    html = ""
    for fonte,i in @dados.getFontes()
      html+="<li class='list-group-item'><span class='pull-right'><a class='link-alterar' data-fonte='#{i}' href='#'>Alterar</a> | <a class='link-remover' data-fonte='#{i}' href='#'>Remover</a></span> <a href='#{fonte.url}' target='_blank'>#{fonte.url}</a></span></li>"

    $("##{@idFontesDados}").html(html)

    # self aponta para classe atual devido quebra do escopo
    self = @

    $("##{@config.configuracoes_id} a.link-remover").on 'click', (ev) ->
      id_fonte = $(this).data('fonte')
      fonte = self.dados.getFonte(id_fonte)
      if confirm("tem certeza que deseja remover esta fonte de dados:\n#{fonte.url}")
        self.dados.removeFonte(id_fonte)
        self.renderFontes()


    $("##{@config.configuracoes_id} a.link-alterar").on 'click', (ev) ->
      id_fonte = $(this).data('fonte')
      fonte = self.dados.getFonte(id_fonte)
      self.popupFontes.setFonte(fonte,id_fonte)
      self.popupFontes.renderPopup(null,'Alterar') 


  render: ()->
    html="
<form >
<br>
<fieldset>
<legend>Fontes de dados</legend>
  <div class='form-group'>
    <ul class='list-group' id='#{@idFontesDados}'></ul>
    <button type='button' class='btn btn-primary searchlight-btn-add-fonte'>Adicionar fonte</button>
  </div>
</fieldset>

<br>
<fieldset>
<legend>Mapa</legend>
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

<br>
<fieldset>
<legend>Searchlight Storage</legend>
  <div class='form-group'>
    <label for='urlsls'>Servidor Searchlight Storage</label>
      <input type='url' class='form-control' value='#{@dados.api.config.serverURL}' id='#{@idUrlSLS}' placeholder='informe o endereço do Searchlight Storage'>
  </div>
  <div class='form-inline form-logout'>
    <div class='form-group'>
      <label for='urlsls'>Usuario</label>
      <input type='text' class='form-control' value='' id='#{@idUsuario}' placeholder='usuario'>
    </div>

    <div class='form-group'>
      <label for='urlsls'>Senha</label>
      <input type='password' class='form-control' value='' id='#{@idPassword}' placeholder='senha'>
    </div>
    <button type='button' class='btn btn-default searchlight-btn-login'>conectar</button>
  </div>
  <div class='form-group form-login'>
    <p>Logado como: <span class='user'></span><p>
    <button type='button' class='btn btn-default searchlight-btn-logout'>desconectar</button>
  </div>
</fieldset>

<br>
<fieldset>
<legend>Compartilhamento</legend>
  <div class='form-group'>
    <label for='viewerTitle'>Título</label>
    <input type='text' class='form-control' value='#{@dados.api.mashup.title}' id='#{@idViewerTitle}' placeholder='informe o título da sua visualização'>
  </div>

  <button type='button' class='btn btn-default searchlight-btn-compartilhar'>Compartilhar</button>
  <button type='button' class='btn btn-default searchlight-btn-qrcodigo'>Vincular com Searchlight Mobile</button>
</fieldset>

<br>
<fieldset>
<legend> </legend>
  <button type='button' class='btn btn-default searchlight-btn-salvar'>Aplicar</button>
</fieldset>
</form>"

    $("##{@config.configuracoes_id}").html(html)
    @renderFontes()
    @bind()

module.exports = {TabConfiguracoes:TabConfiguracoes}
# vim: set ts=2 sw=2 sts=2 expandtab:

