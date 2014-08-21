# TODO: Considar caso com foco e desfoco


class PilhaDeZoom
  constructor: (sl) ->
    @pilha = []
    @sl = sl

    @id_undozoom = "#"+@sl.map_id+ " div.searchlight-undozoom" 
    html = ""
    html+="<a class='undo' title='desfazer zoom em grupo' href='#' onclick='SL(\""+@sl.map_id+"\").control.clusterCtr.pilha_de_zoom.desfazer()'>&nbsp;</a>"
    html+="<a class='redo' title='refazer zoom em grupo' href='#' onclick='SL(\""+@sl.map_id+"\").control.clusterCtr.pilha_de_zoom.refazer()'>&nbsp;</a>"
    html+="&nbsp;"
    $(@id_undozoom).append(html)
    $(@id_undozoom).hide()
    @undo_visivel = false
    @redo_visivel = false
    @undozoom_visivel = false
    @undo_index = 0
    @redo_index = 0
    @last_undo=null

  salva_zoom: ()=>
    zoom =  @sl.map.getZoom()
    center = @sl.map.getCenter()
    @pilha.push([center,zoom])
    #@pilha_redo = [] # TODO: pensar em uma forma melhor de zera a pulha do redo
    @last_undo=null
    @show_undo()
    @hide_redo()
    @undo_index = @pilha.length - 1

  desfazer: () =>
    if not @last_undo
      z =  @sl.map.getZoom()
      c = @sl.map.getCenter()
      @last_undo = [c,z]
      @pilha.push(@last_undo)

    if @undo_index==(@pilha.length - 1)
      @undo_index= ( @pilha.length - 2)

    [center,zoom] = @pilha[@undo_index]
    @undo_index -= 1
    
    if @undo_index<0
         @hide_undo()
    @show_redo()
    
    @sl.map.setView(center, zoom)

  refazer: () =>
    if @undo_index<0
      @undo_index=0

    [center,zoom] = @pilha[@undo_index+1]
    @undo_index+=1
    @sl.map.setView(center, zoom)
    if @undo_index>= @pilha.length - 1
         @hide_redo()
    @show_undo()


  show:() =>
    if not @undozoom_visivel
      $(@id_undozoom).show()
      @undozoom_visivel = true
    if not @undo_visivel
      @hide_undo()
    if not @redo_visivel
      @hide_redo()

  hide: () =>
    if not @undo_visivel and not @redo_visivel
      $(@id_undozoom).hide()
      @undozoom_visivel = false

  show_undo: () =>
    @undo_visivel = true
    @show()
    $(@id_undozoom+" a.undo").show()

  show_redo: () =>
    @redo_visivel = true
    @show()
    $(@id_undozoom+" a.redo").show()

  hide_undo: () =>
    $(@id_undozoom+" a.undo").hide()
    @undo_visivel = false
    @hide()

  hide_redo: () =>
    $(@id_undozoom+" a.redo").hide()
    @redo_visivel = false
    @hide()


  esta_vazia: () =>
    return @pilha.length ==0


class ClusterCtr
  constructor: (sl) ->
    @sl = sl
    @criaPopup()
    @pilha_de_zoom = new PilhaDeZoom(@sl)
    @clusters = {}
    
    @id_analise = "#"+@sl.map_id+ " div.searchlight-analise"
    $(@id_analise).append("<p class='center'><a href='#' onclick='SL(\""+@sl.map_id+"\").control.clusterCtr.desfocar()'>DESFOCAR</a></p>")
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

  clusterClick: (a=null) =>
    d = new Date()
    if (d.getTime() - @timeUltimoClick)>1500 # 2s
      @clickOrdem = 1
      @popupOrZoom(a)

    @timeUltimoClick = d.getTime()
           
  clusterDuploClick: ()=>
    @cancelPopup()

  zoomGrupo: ()=>
    @sl.map.closePopup()
    @pilha_de_zoom.salva_zoom()
    @cluster_clicado.layer.zoomToBounds()
 
  cancelPopup: () =>
    @clickOrdem = 2
    @zoomGrupo()

  mostraPopup: () =>
    @atualizaPopup()
    @popup.openOn(@sl.map)

  showPopup: () =>
    if @clickOrdem == 1
      @mostraPopup()
    @clickOrdem = 0

  desfocar: () =>
      @sl.map.closePopup()
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
        html += "<li><a title='Focar no subgrupo "+cat[0]+"'  href='#' onclick='SL(\""+@sl.map_id+"\").control.clusterCtr.focar(\""+cat[0]+"\");return true;'>"+cat[0]+"</a> ("+cat[1].length+")</li>"
      html +="</ul>"
    else
      html+='<ul class="icones">'
      for cat, i in cats_ord
        cat_id = @sl.dados.categorias_id[cat[0]]
        iconUrl = @sl.Icones[cat_id].options.iconUrl
        html += "<li>"
        html += "<p class='img'><a title='Focar no subgrupo "+cat[0]+"' href='#' onclick='SL(\""+@sl.map_id+"\").control.clusterCtr.focar(\""+cat[0]+"\")'><img src='"+iconUrl+"'></a></p>"
        html += "<p class='texto'><a title='Focar no subgrupo "+cat[0]+"' href='#' onclick=':SL(\""+@sl.map_id+"\").control.clusterCtr.focar(\""+cat[0]+"\")'>"+cat[1].length+"</a></p>"
        html +="</li>"
      html +="</ul>"

    html +="<p class='center'><input type='button' onclick='SL(\""+@sl.map_id+"\").control.clusterCtr.zoomGrupo();' value='expandir grupo' /></p>"
    html +="</div>"
    @popup.setContent(html)
          
  popupOrZoom: (cluster)=>
      @sl.map.closePopup()
      @popup.setLatLng(cluster.layer.getLatLng())
      obj = this
      if @clickOrdem == 1
        @cluster_clicado = cluster
        setTimeout(() =>
          @showPopup(@sl.map_id)
        , 600)

# vim: set ts=2 sw=2 sts=2 expandtab:
