    pacc_jsonp = "http://sl.wancharle.com.br/note/lista?notebook=5514580391f57bdf0d0ba65b"
    google_spreadsheet_url = "https://docs.google.com/spreadsheet/pub?key=0AhU-mW4ERuT5dHBRcGF5eml1aGhnTzl0RXh3MHdVakE&single=true&gid=0&output=html"

    function convert_item_porto(item){
            item_convertido = {}
            item_convertido.longitude = ""+item.longitude
        item_convertido.latitude = "" +item.latitude
    item_convertido.id_parent=    "-22.0000000-43.0000000204312789d72fea132341c532cd4aaea"
	item_convertido.title = item.user.username
        item_convertido.texto ="Usuario: "+ item.user.username
	item_convertido.texto+="<br>Data: "+item.createdAt
	if (item.categoria)
		item_convertido.texto+="<br>Categoria: "+item.categoria
	if (item.comentarios)
		item_convertido.texto+="<br>Comentário: "+item.comentarios
	if (item.fotoURL)
		item_convertido.texto+="<br>Foto: <img height='200px' src='"+item.fotoURL+"'>"///JSON.stringify(item).replace(/,/g,'<br/>')
        item_convertido.cat = item.categoria
        return item_convertido 
    } 
function slwan(data){
	SL('map-porto').carregaDados(data);
}
function portoalegre_cc(map_id){
   
    conf = {
        'dataSources':[ 
        {url:pacc_jsonp,'func_code':convert_item_porto.toString()},
        {url:google_spreadsheet_url,'func_code': 'function (i){return i}'}
        ],
       // 'icones':Icones,
        'container_id':'porto'
        }   
    mps2 = new Searchlight(conf)
}

$(document).ready(function(){
   console.log('ready') 
   //main()
   portoalegre_cc();
    });

