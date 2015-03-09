# classe responsavel pela visualizacao da aba opcoes

   
  
class TabConfiguracoes
  constructor: (config)->
    @idUrlOSM = config.container_id + '-urlosm'
    @config = config
    
    @idClusterizar = @config.container_id + '-clusterizar'
    @idFontesDados = @config.container_id + '-ulFontesDados'
    @popupFontes = new PopupFontes(config)

    @render()

  renderFontes: ()->
    html = ""
    for fonte,i in @config.fontes.getFontes()
      html+="<li class='list-group-item'><span class='pull-right'><a class='link-alterar' data-fonte='#{i}' href='#'>Alterar</a> | <a class='link-remover'data-fonte='#{i}' href='#'>Remover</a></span> <a href='#{fonte.url}' target='_blank'>#{fonte.url}</a></span></li>"
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



    $("##{@config.configuracoes_id} button.searchlight-btn-salvar").on 'click', (ev) =>
      searchlight = new Searchlight(@config.toJSON())

    $("##{@config.configuracoes_id} button.searchlight-btn-add-fonte").on 'click', (ev) =>
      @popupFontes.setFonte(null,null)
      @popupFontes.renderPopup()

    
    $("##{@config.container_id}").on "fontes:update", (ev)=>
      @renderFontes()



# vim: set ts=2 sw=2 sts=2 expandtab:

