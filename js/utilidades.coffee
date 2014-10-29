
window.getJSONP= (url,func)->
  $.ajax({ 'url': url, 'success': func, 'type':"POST", 'dataType': 'jsonp'})


window.getJSON= (url,func)->
  $.ajax({ 'url': url, 'success': func, 'dataType': "json", 'beforeSend': (xhr) ->
      if (xhr.overrideMimeType)
          xhr.overrideMimeType("application/json")
  ,'contentType': 'application/json','mimeType': "textPlain"})

window.getURLParameter= (name) ->
  $(document).getUrlParam(name)


class Dicionario
  constructor: (js_hash)->
    @keys=Object.keys(js_hash)
    @data = js_hash

  get: (key,value) =>
    if key in @keys
      return @data[key]
    else
      return value


class Popup
  constructor: (container_id) ->
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

    $("body").append(corpo)

  show: ->
    $("##{@id}").modal('show')

  setTitle: (title) ->
    $("##{@id} h4.modal-title").html(title)

  setBody: (body) ->
    $("##{@id} div.modal-body").html(body)


    

# vim: set ts=2 sw=2 sts=2 expandtab:
