
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

window.string2function = (func_code) ->
  #converte uma string para funcao          code = fonte.func_code
  re = /.*function *(\w*) *\( *(\w*) *\) *\{/mg;
  if ((m = re.exec(func_code)) != null) 
    if (m.index == re.lastIndex) 
      re.lastIndex++
    
    nome = m[1] 
    return eval("window['#{nome}']=#{func_code}")
  else
    return null

# parseFloatPTBR :: String -> Float
#
# Converte uma string de um numero float no formato internacional e brasileiro num numero Float
# 
# Exemplos:
# > parseFloatPTBR(20.1)
# 20.1
# > parseFloatPTBR("20.1")
# 20.1
# > parseFloatPTBR("20,1")
# 20.1
# > parseFloatPTBR("-20.1")
# -20.1
# > parseFloatPTBR("-20,1")
# -20.1
parseFloatPTBR = (str) ->
  itens = String(str).match(/^(-*\d+)([\,\.]*)(\d+)?$/)
  if itens[2]
    return parseFloat(itens[1]+"."+itens[3])
  else
    return parseFloat(itens[1])
window.parseFloatPTBR = parseFloatPTBR

module.exports = {Dicionario:Dicionario}
# vim: set ts=2 sw=2 sts=2 expandtab:
