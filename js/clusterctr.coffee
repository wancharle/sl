
class ClusterCtr
  constructor: (sl) ->
    @sl = sl
    @criaPopup()
    @pilha_de_zoom = new PilhaDeZoom(@sl)
    @clusters = {}
    
    @id_analise = "#"+@sl.config.map_id+ " div.searchlight-analise"
    $(@id_analise).append("<p class='center'><a href='#' onclick='#{@sl.getIS()}.control.clusterCtr.desfocar()'>DESFOCAR</a></p>")
    $(@id_analise).hide()

    @sl.map.on('dblclick', (a) =>
        @clusterDuploClick()
    )
    @registraEventosClusters()
    
  registraEventosClusters: () =>
    if @camadaAnalise
      @camadaAnalise.on('clusterdblclick', (a) =>
          a.layer.zoomToBounds()
      )
      @camadaAnalise.on('clusterclick', (a) =>
          a.layer.zoomToBounds()
      )
    else
      @sl.markers.on('clusterdblclick', (a) =>
          @clusterDuploClick(a)
      )
      @sl.markers.on('clusterclick',  (a) =>
          if Object.keys(@sl.dados.categorias).length > 1
              @clusterClick(a)
          else
              a.layer.zoomToBounds()
      )

    @clickOrdem = 0

  criaPopup: () =>
    popup = L.popup()
    @popup = popup
    @timeUltimoClick = new Date().getTime()
  
  closePopup: ()=>
    @sl.map.closePopup()
    @sl.bsPopup.close()

  clusterClick: (a=null) =>
    d = new Date()
    if (d.getTime() - @timeUltimoClick)>1500 # 2s
      @clickOrdem = 1
      @popupOrZoom(a)

    @timeUltimoClick = d.getTime()
           
  clusterDuploClick: ()=>
    @cancelPopup()

  zoomGrupo: ()=>
    @closePopup()
    @pilha_de_zoom.salva_zoom()
    @cluster_clicado.layer.zoomToBounds()
 
  cancelPopup: () =>
    @clickOrdem = 2
    @zoomGrupo()

  mostraPopup: () =>
    @atualizaPopup()
    if @sl.config.useBsPopup
      @sl.bsPopup.show()
    else
      @popup.openOn(@sl.map)

  showPopup: () =>
    if @clickOrdem == 1
      @mostraPopup()
    @clickOrdem = 0

  desfocar: () =>
      @closePopup()
      $(@id_analise).hide()
      @sl.map.removeLayer(@camadaAnalise)
      @sl.mostrarCamadaMarkers()
      @camadaAnalise = null
      @desfocou = true 
      @registraEventosClusters()

  focar: (cat) =>
      @sl.esconderCamadaMarkers()
      @camadaAnalise = new L.MarkerClusterGroup({ zoomToBoundsOnClick: false})
      @sl.map.addLayer(@camadaAnalise)
      @camadaAnalise.fire("data:loading") 
      cats = @getCatsCluster()
      for c, x in cats
          if cat == c[0]
              for m in c[1]
                  @camadaAnalise.addLayer(m)
      @sl.map.fitBounds(@camadaAnalise.getBounds())
      @camadaAnalise.fire("data:loaded") 
      @sl.control.registraEventosCamadaAnalise()
      @registraEventosClusters()
      $(@id_analise).show()
      @closePopup()
     
  update: () =>
      #apaga cache dos clusters 
      @clusters = {}

  getCatsCluster: () =>
    cluster_id = @cluster_clicado.layer._leaflet_id
    cluster_cats = @clusters[cluster_id]
    if cluster_cats
      return cluster_cats

    cats = {}
    for m, i in @cluster_clicado.layer.getAllChildMarkers()
      if m.slinfo
        cat = m.slinfo.cat
        if (cats[cat])
          cats[cat].push(m)
        else
          cats[cat]=[m]

    cats_ord =[]
    for cat, i in Object.keys(cats)
      cats_ord.push([cat,cats[cat]])
    cats_ord.sort( (a,b) -> b[1].length - a[1].length)  
    @clusters[cluster_id]=cats_ord
    return cats_ord

  atualizaPopup: () =>
    cats_ord = @getCatsCluster()
    #----
    html = "<div class='clusterPopup'>"
    if not @sl.Icones
      html+="<ul>"
      cat = cats_ord[0]
      for cat, i in cats_ord
        html += "<li><a title='Focar no subgrupo "+cat[0]+"'  href='#' onclick='SL(\""+@sl.config.map_id+"\").control.clusterCtr.focar(\""+cat[0]+"\");return true;'>"+cat[0]+"</a> ("+cat[1].length+")</li>"
      html +="</ul>"
    else
      html+='<ul class="icones">'
      for cat, i in cats_ord
        cat_id = @sl.dados.categorias_id[cat[0]]
        iconUrl = @sl.Icones[cat_id].options.iconUrl
        html += "<li>"
        html += "<p class='img'><a title='Focar no subgrupo "+cat[0]+"' href='#' onclick='SL(\""+@sl.config.map_id+"\").control.clusterCtr.focar(\""+cat[0]+"\")'><img src='"+iconUrl+"'></a></p>"
        html += "<p class='texto'><a title='Focar no subgrupo "+cat[0]+"' href='#' onclick=':SL(\""+@sl.config.map_id+"\").control.clusterCtr.focar(\""+cat[0]+"\")'>"+cat[1].length+"</a></p>"
        html +="</li>"
      html +="</ul>"

    html +="<p class='center'><input type='button' onclick='SL(\""+@sl.config.map_id+"\").control.clusterCtr.zoomGrupo();' value='expandir grupo' /></p>"
    html +="</div>"
    if @sl.config.useBsPopup
      @sl.bsPopup.setTitle("Dados sobre este do grupo")
      @sl.bsPopup.setBody(html)
    else
      @popup.setContent(html)
          
  popupOrZoom: (cluster)=>
      @sl.map.closePopup()
      @popup.setLatLng(cluster.layer.getLatLng())
      obj = this
      if @clickOrdem == 1
        @cluster_clicado = cluster
        setTimeout(() =>
          @showPopup(@sl.config.map_id)
        , 600)

# vim: set ts=2 sw=2 sts=2 expandtab:
