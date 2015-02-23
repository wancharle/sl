
class Config
  constructor: (opcoes)->
    d = new Dicionario(opcoes)

    @container_id =  d.get('container_id','map')
    @tab_id = "tab-"+ @container_id
    @map_id = "map-"+ @container_id
    @lista_id = "lista-"+ @container_id
    @opcoes_id = "opcoes-"+ @container_id
 
    @Icones =  d.get('icones', null)
    @esconder_icones =  d.get('esconder_icones', true)
    @clusterizar =  d.get('clusterizar', true)
    @useBsPopup = d.get('useBsPopup', true)

    @urlosm =  d.get('url_osm',"http://{s}.tile.osm.org/{z}/{x}/{y}.png")
    @url =  d.get('url', null)
    if not @url
        @url = decodeURIComponent(getURLParameter("data"))
    
    # funcao de conversao para  geoJSON
    func = (item) -> return item
    @func_convert = d.get('convert',func)




# vim: set ts=2 sw=2 sts=2 expandtab:

