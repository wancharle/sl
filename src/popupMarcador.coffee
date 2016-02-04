Dados = require('./dados').Dados
Popup = require('./bspopup').Popup

class ListaFilhos
  constructor: (marcador_pai)->
    @dados = Dados.getIS(marcador_pai.config)
    @filhos = @dados.getFilhos(marcador_pai.id)

  getHTML: ()->
    if @filhos.length > 0
      html = '<hr/><h4>Anotações relacionadas</h4><div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">'
      for f,i in @filhos
        html+='<div class="panel panel-default">
                  <div class="panel-heading" role="tab" id="heading'+i+'">
                  <h4 class="panel-title"><a data-toggle="collapse" data-parent="#accordion" href="#collapse'+i+'" aria-expanded="true" aria-controls="collapse'+i+'">'
        html+="#{f.title or f.user.username}</a></h4></div>"
        extra = ''
        if f.fotoURL
          extra  = "<img src='#{f.fotoURL}' width='350px' height='350px' />"
        if f.youtubeVideoId
          extra += "<iframe width='320px' height='240px' src='//www.youtube.com/embed/#{f.youtubeVideoId}?rel=0' frameborder='0' allowfullscreen></iframe> "
        html+=' <div id="collapse'+i+'" class="panel-collapse collapse '+(if i<1 then 'in')+'" role="tabpanel" aria-labelledby="heading'+i+'">
                    <div class="panel-body">'+"<p>#{f.texto or f.comentarios}</p>#{extra}</div>
                </div>
              </div>"
      html += '</div>'
      return html
    else
      return ""

class PopupMarcador
  @show: (marcador) ->
    m=marcador.slinfo
    popup = Popup.getIS(m.config)

    if Searchlight.debug
      console.log(m)

    if m.title
      popup.setTitle(m.title)
    else
      popup.setTitle("")

    if not m.listaFilhos
      m.listaFilhos = new ListaFilhos(m)
    popup.setBody(m.getTextoParaPopup()+m.listaFilhos.getHTML())
    popup.show()
    m.corrigeImagem()


module.exports = {PopupMarcador:PopupMarcador}

# vim: set ts=2 sw=2 sts=2 expandtab:

