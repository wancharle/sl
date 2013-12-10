#import normais
import stdlib

#imports de arquivos javascripts crus
#import libs.leaflet05
#import libs.spin
#import libs.leaflet.spin

L.Icon.Default.imagePath = "images/leaflet"
#import libs.leaflet.markercluster.markercluster
#import libs.jquery191min
#import libs.jquery.getUrlParam
#import libs.tabletop
#import control
import utilidades


import controle
import dados
# marcadores
SENADO_FEDERAL = [-15.799088, -47.865350]
UFES = [-20.277233,-40.303752 ]
CT = [-20.273530, -40.305448]
CEMUNI = [ -20.279483,-40.302690]
BIBLIOTECA = [-20.276519, -40.304503]

public_spreadsheet_url = 'https://docs.google.com/spreadsheet/pub?key=0AhU-mW4ERuT5dHBRcGF5eml1aGhnTzl0RXh3MHdVakE&single=true&gid=0&output=html'
attribution = 'Map generated by <a href="http://wancharle.github.com/Searchlight">Searchlight</a>,  Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a>'
L.Icon.Default.imagePath=getSLpath()+"../images/leaflet"

def main():
    mainf = getURLParameter("mainf") # define uma funcao de inicializacao
    if mainf:
       eval(mainf+"()")
    else:
       mps = new Searchlight()
       window.onSLcarregaDados=def(sl):
            sl.autoZoom()
    
window.main = main
sl_IconCluster = new L.DivIcon({ html: '<div><span>1</span></div>', className: 'marker-cluster marker-cluster-small', iconSize: new L.Point(40, 40) });
sl_IconePadrao = new L.Icon.Default()

# referencia para callback
referencia_atual = None
sl_referencias = {}
def SL(map_id):
    "funcao global para pegar a referencia do objeto mapa"
    return sl_referencias[map_id]
window.SL = SL

class Searchlight:

    def __init__(self,opcoes={}):
    
        nonlocal referencias
        d = Dicionario(opcoes)
        self.map_id =  d.get('map_id','map')
        sl_referencias[self.map_id]  = self 


        self.Icones =  d.get('icones', None)
        self.esconder_icones =  d.get('esconder_icones', True)
        self.clusterizar =  d.get('clusterizar', True)

        self.urlosm =  d.get('url_osm',"http://{s}.tile.osm.org/{z}/{x}/{y}.png")
        self.url =  d.get('url', None)
        if not self.url:
            self.url = decodeURIComponent(getURLParameter("data"))
        
        # funcao de conversao para  geoJSON
        func = def(item): return item
        self.func_convert = d.get('convert',func)
   
        self.create()
        
        self.dados =  Dados()
        self.get_data()
          

    def create(self):
        self.CamadaBasica = L.tileLayer(self.urlosm,  { 'attribution': attribution, 'maxZoom': 18 })
        self.map = L.map(self.map_id, {layers:[self.CamadaBasica],'center': SENADO_FEDERAL,'zoom': 13}) #TODO: mudar centro e zoom 
        
        # criando camada com clusters
        if self.clusterizar:
            self.markers = new L.MarkerClusterGroup({ zoomToBoundsOnClick: false})
        else:
            self.markers = new L.FeatureGroup()
        self.map.addLayer(self.markers)
       
        # criando classe para controlar o mapa
        self.control =  Controle(self)
    
    def get_data(self):

        obj = self
        self.markers.fire("data:loading")
       
        # obtendo dados
        if self.url.indexOf("docs.google.com/spreadsheet") > -1 :
            Tabletop.init( { 'key': self.url, 'callback': def (data):
                obj.carregaDados(data)
            , 'simpleSheet': true } )
        else:
            if self.url[:4]=="http":
                getJSONP(self.url, def (data):
                    obj.carregaDados(data)
                )
            else:
                getJSON(self.url, def (data):
                    obj.carregaDados(data)
                )
    
    def add_itens_gdoc(self,data):
        for d in data:
            p =  [parseFloat(d.latitude.replace(',','.')), parseFloat(d.longitude.replace(',','.'))] 
            L.marker(p).addTo(self.basel).bindPopup(d.textomarcador)
        self.map.addLayer(self.basel);
        self.map.fitBounds(self.basel.getBounds())

    def autoZoom(self):
        self.map.fitBounds(self.markers.getBounds())

    def carregaDados(self, data):
        try:
            for d in data:
                self.addItem(d) 
        except:
            self.markers.fire("data:loaded") 
            alert("Não foi possivel carregar os dados do mapa. Verifique se a fonte de dados está formatada corretamente.")
            return 
        self.markers.clearLayers()
        self.dados.addMarkersTo(self.markers)
        
        if self.map.getBoundsZoom(self.markers.getBounds()) == self.map.getZoom():
            self.carregando = False 
        else:
            self.map.fitBounds(self.markers.getBounds())
            self.carregando = True
   
        self.control.addCatsToControl(self.map_id)
        self.markers.fire("data:loaded")
        self.control.atualizarIconesMarcVisiveis()

        if self.carregando == False and window['onSLcarregaDados'] != undefined:
                onSLcarregaDados(self)
        
    def addItem(self,item):
        self.dados.addItem(item,self.func_convert)

    def mostrarCamadaMarkers(self):
        self.map.addLayer(self.markers)
        self.map.setView(self.map_ultimo_center, self.map_ultimo_zoom)

    def esconderCamadaMarkers(self):
        self.map.removeLayer(self.markers)
        self.map_ultimo_zoom =  self.map.getZoom()
        self.map_ultimo_center = self.map.getCenter()


