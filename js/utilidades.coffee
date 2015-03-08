

window.getJSONP= (url,func)->
  $.ajax({ 
    'url': url, 'success': func,
    'error': (e,ee)-> 
      if ee == "error"
        alert('Erro ao baixar dados JSONP da fonte de dados\n'+url) 
    ,
    'type':"POST", 'dataType': 'jsonp'})


window.getJSON= (url,func)->
  $.ajax({ 'url': url, 'success': func, 'error': ()-> alert('Erro ao baixar dados JSONP da fonte de dados\n'+url) ,
  'dataType': "json", 'beforeSend': (xhr) ->
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

# vim: set ts=2 sw=2 sts=2 expandtab:
