# classe responsavel pela visualizacao da aba opcoes
Popup = require('./bspopup').Popup

class TabConfiguracoes
  constructor: (config,@dados)->
    @config = config

    @idUrlOSM = config.container_id + '-urlosm'
    @idClusterizar = @config.container_id + '-clusterizar'
    @idEsconderIcones = @config.container_id + '-esconder-icones'
    @idVerMais = @config.container_id + '-ver-mais'
    @idUseBsPopup = @config.container_id + '-use-popup'
    
    @idUrlSLS = config.container_id + '-urlsls'
    @idUsuario = config.container_id + '-usuario'
    @idPassword = config.container_id + '-password'

    @containerQR = @config.container_id + '-qrcode'
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
    @showQRcode(@dados.api.mashup.id)
          


  showQRcode: (mashupid)->
    popup = Popup.getIS(@config)
    popup.setTitle("<p  style='padding:0px;margin:0px;text-align:center'>QR code para o aplicativo Searchlight Collector</p>")
    popup.setBody("<br><div style='width:300px;margin:0px auto;' id='#{@containerQR}' > </div><br><p style='text-align:center'> Abra o aplicativo Searchlight Collector e escolha a opção 'Escolher serviço de coleta'. Clique em 'vincular serviço' e posicione o smartphone adequadamente para ler o código QR acima.</p>")
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
    $("##{@idEsconderIcones}").on 'change', (ev) ->
      self.config.esconder_icones = @.checked
    $("##{@idVerMais}").on 'change', (ev) ->
      self.config.ver_mais = @.checked
    $("##{@idUseBsPopup}").on 'change', (ev) ->
      self.config.useBsPopup = @.checked


    $("##{@idUrlOSM}").on 'change', (ev) ->
      self.config.urlosm = $(@).val()

    $("##{@config.configuracoes_id} button.searchlight-btn-qrcodigo").on 'click', (ev) ->
      self.onQRCodeClick()
  
    $("##{@config.configuracoes_id} button.searchlight-btn-salvar").on 'click', (ev) ->
      self.onSalvar(ev)

  
  render: ()->
    html="
<form >
<br/>
<fieldset>
<legend>Mashup</legend>
    <p>#{@dados.api.mashup.title} <a class='' target='_blank' href='http://sl.wancharle.com.br/mashup/edit/?id=#{@dados.api.mashup.id}'><span class='glyphicon glyphicon-edit'></span> Editar Mashup</a>
</p>
  <button type='button' class='btn btn-default searchlight-btn-compartilhar'>Compartilhar</button>
  <button type='button' class='btn btn-default searchlight-btn-qrcodigo'>Vincular com Searchlight Mobile</button>
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
  <div class='checkbox'>
    <label>
      <input type='checkbox' #{if @config.esconder_icones then "checked" else ""} id='#{@idEsconderIcones}'> Esconder ícones nos níveis de zoom superiores
    </label>
  </div>
  <div class='checkbox'>
    <label>
      <input type='checkbox' #{if @config.ver_mais then "checked" else ""} id='#{@idVerMais}'> Opção 'ver mais' nos popups dos marcadores
    </label>
  </div>
  <div class='checkbox'>
    <label>
      <input type='checkbox' #{if @config.useBsPopup then "checked" else ""} id='#{@idUseBsPopup}'> Agrupamento exibe popup do grupo de forma modal
    </label>
  </div>
</fieldset>

<br>
<fieldset>
<legend> </legend>
  <button type='button' class='btn btn-default searchlight-btn-salvar'>Aplicar</button>
</fieldset>
</form>"

    $("##{@config.configuracoes_id}").html(html)
    @bind()

module.exports = {TabConfiguracoes:TabConfiguracoes}
# vim: set ts=2 sw=2 sts=2 expandtab:

