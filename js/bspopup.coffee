
class Popup
  @instances = {}

  @getIS:(config)-> 
    # metodo de classe par obter instancias
    return Popup.instances[config.container_id] 
   
  constructor: (config) ->
    @config = config
    container_id = config.container_id
    Popup.instances[container_id] = this

    @id = "popup-#{container_id}" 
    config.popup_id = @id

    corpo="<div id=\"#{@id}\" class=\"modal fade\" data-role='dialog'>"
    corpo+=' <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h4 class="modal-title"></h4>
      </div>
      <div class="modal-body">
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default cancelar" data-dismiss="modal">Cancelar</button>
        <button type="button" class="btn btn-primary" data-dismiss="modal">OK</button>
      </div>
    </div><!-- /.modal-content -->
  </div><!-- /.modal-dialog -->
</div>'
    if not $("##{@id}").length
      $("body").prepend(corpo)

   
  show: ->
    $("##{@id}").modal('show')

  close: ->
    $("##{@id}").modal('hide')

  setTitle: (title) ->
    $("##{@id} h4.modal-title").html(title)

  setBody: (body,button_title='OK',callback=null,cancelar=false,callback_cancelar = null) ->
    $("##{@id} div.modal-body").html(body)
    $("##{@id} div.modal-footer button.btn-primary").html(button_title) 

    if not cancelar
      $("##{@id} div.modal-footer button.cancelar").hide()
    else
      $("##{@id} div.modal-footer button.cancelar").show()


    if callback_cancelar
      $("##{@id} div.modal-footer button.cancelar").off('click')
      $("##{@id} div.modal-footer button.cancelar").on('click',callback_cancelar)

    $("##{@id}").off('hide.bs.modal')
    $("##{@id}").on('hide.bs.modal',callback)

# vim: set ts=2 sw=2 sts=2 expandtab:
