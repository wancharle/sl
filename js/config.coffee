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
      console.error "Error de configuração de fonte:",fonte

  removeFonte: (i) ->
    @fontes.splice(i,1)
    
  getFontes:() ->
    return @fontes

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
    
    @useBsPopup = d.get('useBsPopup', true)

    @urlosm =  d.get('url_osm',"http://{s}.tile.osm.org/{z}/{x}/{y}.png")
    @fontes = new ConfigFontes(d)
   
  toJSON: ()->
    return {
      'container_id': @container_id
      'icones': @icones
      'esconder_icones': @esconder_icone
      'clusterizar':  @clusterizar
      'useBsPopup': @useBsPopup
      'url_osm': @urlosm
      'fontes': @fontes.getFontes()
    }

      
              



# vim: set ts=2 sw=2 sts=2 expandtab:

