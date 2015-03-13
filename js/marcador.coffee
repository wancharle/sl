class ListaFilhos
  constructor: (marcador_pai)->
    @dados = Dados.getIS(marcador_pai.config)
    @filhos = @dados.getFilhos(marcador_pai.id)

  getHTML: ()->
    html = '<hr/><h4>Anotações relacionadas</h4><div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">'
    for f , i in @filhos
      html+='<div class="panel panel-default">
                <div class="panel-heading" role="tab" id="heading'+i+'">
                <h4 class="panel-title"><a data-toggle="collapse" data-parent="#accordion" href="#collapse'+i+'" aria-expanded="true" aria-controls="collapse'+i+'">'
      html+=f.title+'</a></h4></div>'
      html+=' <div id="collapse'+i+'" class="panel-collapse collapse '+(if i<1 then 'in')+'" role="tabpanel" aria-labelledby="heading'+i+'">
                  <div class="panel-body">'+f.texto + '</div>
              </div>
            </div>'
    html += '</div>'
    return html

class Marcador
  constructor:(geoItem,config)->
    @m = null
    @id = geoItem.id
    @id_parent = geoItem.id_parent
    @config = config
    @latitude = parseFloat(geoItem.latitude.replace(',','.'))
    @longitude = parseFloat(geoItem.longitude.replace(',','.'))
    @texto = geoItem.texto
    if geoItem.icon
      @icon = geoItem.icon
    else
      @icon = window.SL_ICON_PADRAO
    
    if geoItem.cat
      @cat_id = geoItem.cat_id
      @cat = geoItem.cat.replace(",","").replace('"','')
    else
      @cat = "descategorizado"
      @cat_id = 1

    @title = geoItem.title

  getMark: () ->
    if @m == null
      p =  [@latitude,@longitude ]
      m = new L.Marker(p)
      m.setIcon(@icon)
      @m = m
      @m.slinfo = this
      html="#{m.slinfo.texto}<p><a href='javascript:void(0);' onclick='Searchlight.Marcador.show(\"#{@config.map_id}\")'>ver mais</a></p>"
      @m.bindPopup(html,{'maxWidth':640})
    return @m

  @show: (map_id) ->
    sl = SL(map_id)
    config = sl.config
    popup = Popup.getIS(config)
    m=Controle.getIS(config).ultimo_marcador_clicado.slinfo #TODO: colocar privado. criar metodo para retorna essa info

    if Searchlight.debug
      console.log(m)

    if m.title
      popup.setTitle(m.title)
    else
      popup.setTitle("")

    if not m.listaFilhos
      m.listaFilhos = new ListaFilhos(m)
    popup.setBody(m.texto+m.listaFilhos.getHTML())
    popup.show()


    

# vim: set ts=2 sw=2 sts=2 expandtab:
