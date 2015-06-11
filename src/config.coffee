Dicionario = require('./utilidades').Dicionario

class ConfigFontes
  constructor: (d)->
    @fontes = []
 
    fontes_array = d.get('fontes',null)
    if not fontes_array
      url =  d.get('url', null)
      if not url
          url = decodeURIComponent(getURLParameter("data"))
      # funcao de conversao para  geoJSON
      func = (item) -> return item
      func_code = d.get('convert',func)
      @addFonte { url: url, func_code: func_code }
    else
      for fonte, index in fontes_array
        @addFonte(fonte)

  addFonte: (fonte) ->
    if fonte.url and typeof fonte.func_code is 'function'
      @fontes.push(fonte)
    else
      if typeof fonte.func_code is 'string'
        try
            fonte.func_code = string2function(fonte.func_code)
        catch e
          console.error e,'Error ao tentar criar funcao de conversao apartir de texto'
        @fontes.push(fonte)
      else
        console.error "Error de configuração de fonte:",fonte

  removeFonte: (i) ->
    @fontes.splice(i,1)
    
  getFontes:() ->
    return @fontes

  toJSON:() ->
    array = []
    for f,i in @fontes
      f.func_code = f.func_code.toString()
      array.push(f)
    return array

  updateFonte: (url,func_code, id) ->
    fonte = {url:url,func_code:func_code}
    @fontes[id]=fonte

  getFonte: (i) ->
    return @fontes[i]
    #else
    #  console.error "Error: fonte nº#{i} não esta configurada. Fontes: ", @fontes
    #  return null

class Config
  constructor: (opcoes)->
    d = new Dicionario(opcoes)
    @d = d
    @container_id =  d.get('container_id','map')
    @tab_id = "tab-"+ @container_id
    @map_id = "map-"+ @container_id
    @lista_id = "lista-"+ @container_id
    @configuracoes_id = "configuracoes-"+ @container_id
 
    @Icones =  d.get('icones', null)
    @esconder_icones =  d.get('esconder_icones', true)

    @clusterizar =  d.get('clusterizar', true)
    @usarCache =  d.get('usarCache', true)
    @noteid = d.get('noteid',null)
    
    @useBsPopup = d.get('useBsPopup', true)
    @urlosm =  d.get('url_osm',"http://{s}.tile.osm.org/{z}/{x}/{y}.png")

    @slsUser = d.get('sls_user','')
    @slsPassword = ''
    @urlsls =  d.get('url_sls',"http://sl.wancharle.com.br")
    @viewerTitle = d.get('viewerTitle','')

    @fontes = new ConfigFontes(d)
   
  toJSON: ()->
    return {
      'container_id': @container_id
      'icones': @icones
      'esconder_icones': @esconder_icone
      'clusterizar':  @clusterizar
      'useBsPopup': @useBsPopup
      'url_osm': @urlosm
      'url_sls': @urlsls
      'sls_user':@slsUser
      'viewerTitle':@viewerTitle
      'usarCache':@usarCache
      'fontes': @fontes.toJSON()
    }

      
              
module.exports = {Config:Config,ConfigFontes:ConfigFontes}

# vim: set ts=2 sw=2 sts=2 expandtab:

