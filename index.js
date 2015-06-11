pacc_jsonp = "http://sl.wancharle.com.br/note/lista?notebook=5514580391f57bdf0d0ba65b"


function convert_item_porto(item){
        item_convertido = {}
        item_convertido.longitude = ""+item.longitude
        item_convertido.latitude = "" +item.latitude
    item_convertido.id_parent=    "-22.0000000-43.000000017f5a766a4ba26d59e8d5a9af8f159ad"
	item_convertido.title = item.user.username
        item_convertido.texto ="Usuario: "+ item.user.username
	item_convertido.texto+="<br>Data: "+item.data_hora
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
        'url':pacc_jsonp,
        'convert':convert_item_porto,
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

