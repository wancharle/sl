Dicionario = require('./utilidades').Dicionario

class Config
  constructor: (@apiconf)->
    @apiconf.register(@)

  parseOpcoes: (d)->
    @container_id =  d.get('container_id','map')
    @tab_id = "tab-"+ @container_id
    @map_id = "map-"+ @container_id
    @lista_id = "lista-"+ @container_id
    @configuracoes_id = "configuracoes-"+ @container_id
 
    @Icones =  d.get('icones', null)
    @esconder_icones =  d.get('esconder_icones', true)

    @clusterizar =  d.get('clusterizar', true)
    
    @useBsPopup = d.get('useBsPopup', true)
    @urlosm =  d.get('osmURL',"http://{s}.tile.osm.org/{z}/{x}/{y}.png")


   
  toJSON: ()->
    return {
      'container_id': @container_id
      'icones': @Icones
      'esconder_icones': @esconder_icones
      'clusterizar':  @clusterizar
      'useBsPopup': @useBsPopup
      'osmURL': @urlosm
    }

      
              
module.exports = {Config:Config}

# vim: set ts=2 sw=2 sts=2 expandtab:

