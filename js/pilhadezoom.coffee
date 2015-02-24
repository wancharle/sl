
class PilhaDeZoom
  constructor: (sl) ->
    @pilha = []
    @sl = sl

    @id_undozoom = "#"+@sl.config.map_id+ " div.searchlight-undozoom" 
    html = ""
    html+="<a class='undo' title='desfazer zoom em grupo' href='#' onclick='SL(\"#{@sl.config.map_id}\").control.clusterCtr.pilha_de_zoom.desfazer()'>&nbsp;</a>"
    html+="<a class='redo' title='refazer zoom em grupo' href='#' onclick='SL(\"#{@sl.config.map_id}\").control.clusterCtr.pilha_de_zoom.refazer()'>&nbsp;</a>"
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

# vim: set ts=2 sw=2 sts=2 expandtab:
