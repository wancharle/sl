class Controle
  constructor: (sl) ->
    @sl = sl
    @sl.map.addControl(new SLControl())
    @sl.map.addControl(new SLUndoRedoControl())
    @id_control = "#"+@sl.config.map_id+" div.searchlight-control"
    @id_opcoes = "#"+@sl.config.map_id+ " div.searchlight-opcoes" 
    @id_camadas = @id_opcoes + "ul"
    
    $(@id_control).mouseenter(@show_opcoes)
    $(@id_control).bind('touchstart',@show_opcoes)
    $("#"+@sl.config.map_id).mouseover(@hide_opcoes)
    $("#"+@sl.config.map_id).bind('touchstart',@hide_opcoes)

    #registrando eventos popup e markers
    
    @sl.map.on('zoomend', ()=>
        if @marcador_clicado == null
            @sl.map.closePopup()
        else
            @marcador_clicado = null
        if @clusterCtr.desfocou
            @clusterCtr.desfocou = false
            @clusterCtr.mostraPopup()

        @atualizarIconesMarcVisiveis()
        if @sl.carregando
            @sl.carregando = false
            if window['onSLcarregaDados'] != undefined
                onSLcarregaDados(@sl)

    )
   
    @sl.map.on('moveend', ()=>
        @atualizarIconesMarcVisiveis()
    )
    
    @sl.markers.on('click', (ev)=>
        @markerClick(ev)
    )
  
    @clusterCtr = new ClusterCtr(@sl)

  hide_opcoes : (event) =>
    $(@id_opcoes).hide()


  show_opcoes: (event) =>
      if not @clusterCtr.camadaAnalise
        $(@id_opcoes).show()

  registraEventosCamadaAnalise: ()=>
        @clusterCtr.camadaAnalise.on('click', (ev)=>
            @markerClick(ev)
        )

  atualizarIconesMarcVisiveis: () =>
      if @sl.config.esconder_icones
         if @sl.map.getZoom() >= 16
             @mostrarIconesMarcVisiveis()
         else
             @esconderIconesMarcVisiveis()

  mostrarIconesMarcVisiveis: () =>
      for m, i in @getMarcadoresVisiveis()
          m.setIcon(m.slinfo.icon)

  esconderIconesMarcVisiveis: ()=>
      markers = @getMarcadoresVisiveis()
      for m, i in markers 
          m.setIcon(window.SL_ICON_CLUSTER)

  getMarcadoresVisiveis:()=>
      if @clusterCtr.camadaAnalise
          marcadores =  @clusterCtr.camadaAnalise.getLayers() 
      else
          marcadores = @sl.markers.getLayers() 
      marcadores_visiveis = []
      for m of marcadores
          mark = marcadores[m]
          if mark.hasOwnProperty("slinfo")
              marcadores_visiveis.push(mark)
      return marcadores_visiveis

  markerClick: (ev) =>
      m = ev.layer
      @marcador_clicado = m
      @ultimo_marcador_clicado = m
      if @sl.config.esconder_icones
          if m.slinfo.ultimo_zoom
              @sl.map.setView(m.slinfo.ultimo_center,m.slinfo.ultimo_zoom)
              m.slinfo.ultimo_zoom = null 
              m.slinfo.ultimo_center = null
              @sl.map.closePopup()
          else
              m.slinfo.ultimo_zoom = @sl.map.getZoom()
              m.slinfo.ultimo_center = @sl.map.getCenter()
              center = new L.LatLng(m.slinfo.latitude,m.slinfo.longitude)
              @sl.map.setView(center, 18)
              #@showMarcadorPopup(m) 


  addCatsToControl: (map_id)=>
      if Object.keys(@sl.dados.categorias).length > 1
          op ="#"+map_id+ " div.searchlight-opcoes"
          ul =op + " ul"
          cats = []
          for k of  @sl.dados.categorias
              cats.push([k,@sl.dados.categorias[k].length])
          cats.sort( (a,b) -> b[1]-a[1])
          
          $(ul).empty()
          for c,i in cats
              $(ul).append("<li><input type='checkbox' checked name='"+map_id+"-cat' value='"+c[0]+"' class='categoria'/>"+c[0]+" ("+c[1]+")</li>")
          
          $(op).append("<p class='center'><input type='button' onclick='#{@sl.getIS()}.control.update();' value='Atualizar Mapa' /></p>")
      else
          if not $(@id_opcoes).hasClass("sem-categoria")
              $(@id_opcoes).addClass("sem-categoria")

  update:()=>
      $(@id_opcoes).hide()
      @clusterCtr.update()
      @sl.markers.clearLayers()

      if $("input:checkbox[name=#{@sl.config.map_id}-cat]:checked").size() > 0
          @sl.markers.fire("data:loading")
          setTimeout("#{@sl.getIS()}.control.carregaDados()",50)

  carregaDados:() =>
      # atualiza o mapa para a nova configuração de filtro
      #
      $("input:checkbox[name=#{@sl.config.map_id}-cat]:checked").each((index,element)=>
          cat=$(element).val()
          @sl.dados.catAddMarkers(cat,@sl.markers)
      )

      @sl.map.fitBounds(@sl.markers.getBounds())
      @sl.markers.fire("data:loaded")
      @sl.control.atualizarIconesMarcVisiveis()


# vim: set ts=2 sw=2 sts=2 expandtab:
