# classe responsavel pela visualizacao da aba opcoes
PopupFontes = require('./popupFontes').PopupFontes

class TabConfiguracoes
  constructor: (config)->
    @config = config
   
    @idFontesDados = @config.container_id + '-ulFontesDados'
    @popupFontes = new PopupFontes(config)

    @idUrlOSM = config.container_id + '-urlosm'
    @idClusterizar = @config.container_id + '-clusterizar'
    
    @idUrlSLS = config.container_id + '-urlsls'
    @idUsuario = config.container_id + '-usuario'
    @idPassword = config.container_id + '-password'

    @containerQR = @config.container_id + '-qrcode'
    @idViewerTitle = @config.container_id + '-title'
    @idUsarCache = @config.container_id + '-usarcache'

    @slsapi = new SLSAPI({serverURL:@config.urlsls})
    @slsapi.notebook.getByName('mapas',(data)=> @notebookConfigs=data[0].id)

    @render()
    @onLoginLogout()

  onLoginLogout:()->
    if @slsapi.user.isLogged()
      $("##{@config.container_id} .form-login").show()
      $("##{@config.container_id} .form-logout").hide()
    
      $("##{@config.container_id} .form-login .user").html(@slsapi.user.getUsuario())
    else
      $("##{@config.container_id} .form-logout").show()
      $("##{@config.container_id} .form-login").hide()


  onQRCodeClick: ()->
    self = @
    if @slsapi.user.isLogged()
      if not  @config.viewerTitle
        alert('Informe um titulo para sua visualização')
      else
        hashid = md5(JSON.stringify(@config.viewerTitle))
        @slsapi.notes.getByQuery("user=#{self.slsapi.user.user_id}&hid=#{hashid}",
          (data)->
            if data.length > 0
              note = data[0]
              # view ja existe entao vamos substituir
              self.slsapi.notes.update(note.id,{config:self.config.toJSON()},
                ()->
                  self.showQRcode(hashid)
                ,()->
                  alert('Não foi possivel se conectar com Searchlight Storage')
              )
            else
              # view nao existe deve registar
              note = {}
              console.log('entrei')
              note.config = self.config.toJSON()

              console.log('passei')
              note.longitude = 0.0
              note.latitude = 0.0
              note.hid = hashid
              note.user= self.slsapi.user.user_id
              self.slsapi.notes.enviar(note,self.notebookConfigs,
                ()->
                  self.showQRcode(hashid)
                ,(error)-> 
                  console.log(arguments)
                  alert('Não foi possivel conectar com SearchLight Storage')
              )
          ,() ->
            alert('Não foi possivel se conectar com Searchlight Storage')
        )
    else
      alert('Voce precisa estar conectado ao Searchlight Storage')


  showQRcode: (hashid)->
    popup = Popup.getIS(@config)
    popup.setTitle("<p  style='padding:0px;margin:0px;text-align:center'>QR code para o aplicativo Searchlight Mobile</p>")
    popup.setBody("<br><div style='width:300px;margin:0px auto;' id='#{@containerQR}' > </div><br><p style='text-align:center'> Abra o aplicativo Searchlight Mobile e escolha a opção 'Vincular Visualização'. Clique em 'gerar código' para gerar um código de vinculação. Posicione o smartphone adequadamente para ler o código QR acima.</p>")
    popup.show()
    url = "http://sl.wancharle.com/note/?hid=#{hashid}"
    $("##{@containerQR}").empty().qrcode({ width:300,height:300,mode:0,'text': url})

  onSalvar: ()->
    sl = SL("map-"+@config.container_id)

    $("##{@config.container_id}").off()
    $("##{@config.container_id} * ").off()
    sl.markers.off()
    sl.map.off()

    sl.markers.clearLayers()
    sl.map.remove()

    searchlight = new Searchlight(@config.toJSON())


  bind: ()->
    self = @
    $("##{@idClusterizar}").on 'change', (ev) ->
      self.config.clusterizar = @.checked

    $("##{@idUsarCache}").on 'change', (ev) ->
      self.config.usarCache = @.checked

    $("##{@idUrlOSM}").on 'change', (ev) ->
      self.config.urlosm = $(@).val()

    $("##{@idUrl}").on 'change', (ev) ->
      self.config.url = $(@).val()

    $("##{@idUrlSLS}").on 'change', (ev) ->
      self.config.urlsls = $(@).val()

    $("##{@idUsuario}").on 'change', (ev) ->
      self.config.slsUser = $(@).val()

    $("##{@idPassword}").on 'change', (ev) ->
      self.config.slsPassword = $(@).val()

    $("##{@idViewerTitle}").on 'change', (ev) ->
      self.config.viewerTitle = $(@).val()


    $("##{@config.configuracoes_id} button.searchlight-btn-login").on 'click', (ev) ->
      self.slsapi.user.login(self.config.slsUser, self.config.slsPassword)

    $("##{@config.configuracoes_id} button.searchlight-btn-logout").on 'click', (ev) ->
      self.slsapi.user.logout(()->self.onLoginLogout())

    $(document).on 'slsapi.user:loginFinish slsapi.user:loginFail', () ->
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
    for fonte,i in @config.fontes.getFontes()
      html+="<li class='list-group-item'><span class='pull-right'><a class='link-alterar' data-fonte='#{i}' href='#'>Alterar</a> | <a class='link-remover' data-fonte='#{i}' href='#'>Remover</a></span> <a href='#{fonte.url}' target='_blank'>#{fonte.url}</a></span></li>"

    $("##{@idFontesDados}").html(html)

    # self aponta para classe atual devido quebra do escopo
    self = @

    $("##{@config.configuracoes_id} a.link-remover").on 'click', (ev) ->
      id_fonte = $(this).data('fonte')
      fonte = self.config.fontes.getFonte(id_fonte)
      if confirm("tem certeza que deseja remover esta fonte de dados:\n#{fonte.url}")
        self.config.fontes.removeFonte(id_fonte)
        self.renderFontes()


    $("##{@config.configuracoes_id} a.link-alterar").on 'click', (ev) ->
      id_fonte = $(this).data('fonte')
      fonte = self.config.fontes.getFonte(id_fonte)
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
      <input type='url' class='form-control' value='#{@config.urlsls}' id='#{@idUrlSLS}' placeholder='informe o endereço do Searchlight Storage'>
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
    <input type='text' class='form-control' value='#{@config.viewerTitle}' id='#{@idViewerTitle}' placeholder='informe o título da sua visualização'>
  </div>
   <div class='checkbox'>
    <label>
      <input type='checkbox' #{if @config.usarCache then "checked" else ""} id='#{@idUsarCache}'> Fazer cache dos dados no Searchlight Service
    </label>
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

