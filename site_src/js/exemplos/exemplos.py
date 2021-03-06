import stdlib

import portoalegre

OnibusAzul = new L.icon({ iconUrl:getSLpath()+"../images/onibus_azul.png",iconSize:     [45, 58], iconAnchor:   [23, 48], popupAnchor: [0, -40] })
OnibusVolta = new L.icon({ iconUrl:getSLpath()+"../images/onibus_volta.png",iconSize:     [45, 58], iconAnchor:   [23, 48], popupAnchor: [0, -40] })
pontos_inseridos = 0
def converte_item1(item):
    nonlocal pontos_inseridos
    item_convertido = {}
    item_convertido.longitude = ""+item.longitude
    item_convertido.latitude = "" +item.latitude
    item_convertido.texto = item.ponto + " ordem=" + item.ordem
    pontos_inseridos +=1
    if (pontos_inseridos < 68):
        item_convertido.icon = OnibusAzul
        item_convertido.cat_id = 1
        item_convertido.cat = 'IDA'
    else:
        item_convertido.cat_id = 2
        item_convertido.cat = 'VOLTA'
        item_convertido.icon = OnibusVolta
    
    return item_convertido


def onSlcarregaDados(sl):
    if sl.map_id== "map1" :
            v=sl.dados.getCatLatLng('IDA')
            polyline = L.polyline(v, {color: 'blue'}).addTo(sl.map);
            v=sl.dados.getCatLatLng('VOLTA')
            polyline = L.polyline(v, {color: 'black'}).addTo(sl.map);
            sl.autoZoom()

    if sl.map_id == "map_gdoc":
            sl.autoZoom()   
         
def exemplo1(): 

    osm='http://{s}.tile.cloudmade.com/bbcf9165c23646efbb1828828278c8bc/997/256/{z}/{x}/{y}.png';
    conf = {
        'url':"js/exemplos/121.json", 
        'convert':converte_item1,
        'map_id':'map1',
        'url_osm':osm,
        'esconder_icones': False,
        'clusterizar': False
    }
    mps = new Searchlight(conf);

       

 

def exemplo_gdoc():
    public_spreadsheet_url = 'https://docs.google.com/spreadsheet/pub?key=0AhU-mW4ERuT5dHBRcGF5eml1aGhnTzl0RXh3MHdVakE&single=true&gid=0&output=html';
    conf = {
            'url':public_spreadsheet_url, 
            'map_id':'map_gdoc',
            'esconder_icones':False
            }
    mps = new Searchlight(conf)




def exemplos():

    window.onSLcarregaDados = onSlcarregaDados 
    exemplo1() 
    exemplo_markercluster()
    exemplo_gdoc()
    portoalegre_cc('map')

window.exemplos = exemplos
