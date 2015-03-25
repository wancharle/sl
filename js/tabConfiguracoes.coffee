# classe responsavel pela visualizacao da aba opcoes

   
  
class TabConfiguracoes
  constructor: (config)->
    @idUrlOSM = config.container_id + '-urlosm'
    @config = config
    
    @idClusterizar = @config.container_id + '-clusterizar'
    @idFontesDados = @config.container_id + '-ulFontesDados'
    @popupFontes = new PopupFontes(config)

    @containerQR = @config.container_id + '-qrcode'

    @render()

  renderFontes: ()->
    html = ""
    for fonte,i in @config.fontes.getFontes()
      html+="<li class='list-group-item'><span class='pull-right'><a class='link-alterar' data-fonte='#{i}' href='#'>Alterar</a> | <a class='link-remover' data-fonte='#{i}' href='#'>Remover</a></span> <a href='#{fonte.url}' target='_blank'>#{fonte.url}</a></span></li>"

    $("##{@idFontesDados}").html(html)

    # amarra eventos da lista
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
<button type='button' class='btn btn-default searchlight-btn-salvar'>Salvar</button>
<button type='button' class='btn btn-default searchlight-btn-qrcodigo'>Gerar código para o Searchlight Mobile</button>

</fieldset>
</form>"

    $("##{@config.configuracoes_id}").html(html)
    @renderFontes()
    @bind()

  bind: ()->
    self = @
    $("##{@idClusterizar}").on 'change', (ev) ->
      self.config.clusterizar = @.checked

    $("##{@idUrlOSM}").on 'change', (ev) ->
      self.config.urlosm = $(@).val()

    $("##{@idUrl}").on 'change', (ev) ->
      self.config.url = $(@).val()



    $("##{@config.configuracoes_id} button.searchlight-btn-qrcodigo").on 'click', (ev) =>
      popup = Popup.getIS(@config)
      popup.setTitle("<p  style='padding:0px;margin:0px;text-align:center'>QR code para o aplicativo Searchlight Mobile</p>")
      popup.setBody("<div style='width:300px;margin:0px auto;' id='#{@containerQR}' > </div><br/><p style='text-align:center'> Abra o aplicativo Searchlight Mobile e escolha a opção 'Vincular Visualização'. Posicione o smartphone adequadamente para ler o código QR abaixo:</p>")
      popup.show()
      url = "http://sl.wancharle.com/note/id=#{md5(JSON.stringify(@config.toJSON()))}"
      $("##{@containerQR}").empty().qrcode({ width:300,height:300,mode:0,'text': url})

    $("##{@config.configuracoes_id} button.searchlight-btn-salvar").on 'click', (ev) =>
      sl = SL("map-"+@config.container_id)
 
      $("##{@config.container_id}").off()
      $("##{@config.container_id} * ").off()
      sl.markers.off()
      sl.map.off()

      sl.markers.clearLayers()
      sl.map.remove()

      searchlight = new Searchlight(@config.toJSON())

    $("##{@config.configuracoes_id} button.searchlight-btn-add-fonte").on 'click', (ev) =>
      @popupFontes.setFonte(null,null)
      @popupFontes.renderPopup()

    
    $("##{@config.container_id}").on "fontes:update", (ev)=>
      @renderFontes()



# vim: set ts=2 sw=2 sts=2 expandtab:

