
class Popup
  constructor: (sl,container_id) ->
    @sl = sl
    @container_id = container_id
    @id = "popup-#{container_id}" 
    corpo="<div id=\"#{@id}\" class=\"modal fade\" data-role='dialog'>"
    corpo+=' <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h4 class="modal-title"></h4>
      </div>
      <div class="modal-body">
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" data-dismiss="modal">OK</button>
      </div>
    </div><!-- /.modal-content -->
  </div><!-- /.modal-dialog -->
</div>'

    $("body").prepend(corpo)

  show: ->
    $("##{@id}").modal('show')

  close: ->
    $("##{@id}").modal('hide')

  setTitle: (title) ->
    $("##{@id} h4.modal-title").html(title)

  setBody: (body) ->
    $("##{@id} div.modal-body").html(body)

  showMarcador: ->
    m=@sl.control.ultimo_marcador_clicado #TODO: colocar privado. criar metodo para retorna essa info
    if m.slinfo.title
      @setTitle(m.slinfo.title)
    else
      @setTitle("")
    @setBody(m.slinfo.texto)
    @show()

# vim: set ts=2 sw=2 sts=2 expandtab:
