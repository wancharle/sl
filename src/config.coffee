Dicionario = require('./utilidades').Dicionario

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

      
              
module.exports = {Config:Config}

# vim: set ts=2 sw=2 sts=2 expandtab:

