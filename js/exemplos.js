(function(){var JSON,str,portoalegrecc_json,pacc_jsonp,Icones,OnibusAzul,OnibusVolta,pontos_inseridos;JSON=JSON||{};if(!JSON.stringify){
	JSON.stringify = function(obj) {
		var t = typeof (obj);
		if (t != "object" || obj === null) {
			// simple data type
			if (t == "string")
				obj = '"' + obj + '"';
			if (t == "function")
				return; // return undefined
			else
				return String(obj);
		} else {
			// recurse array or object
			var n, v, json = []
			var arr = (obj && obj.constructor == Array);
			for (n in obj) {
				v = obj[n];
				t = typeof (v);
				if (t != "function" && t != "undefined") {
					if (t == "string")
						v = '"' + v + '"';
					else if ((t == "object" || t == "function") && v !== null)
						v = JSON.stringify(v);
					json.push((arr ? "" : '"' + n + '":') + String(v));
				}
			}
			return (arr ? "[" : "{") + String(json) + (arr ? "]" : "}");
		}
	};
	}str=JSON.stringify;ValueError=function(message){var self=this;self.name="ValueError";self.message=message};ValueError.prototype=new Error();ValueError.prototype.constructor=ValueError;String.prototype.strip=String.prototype.trim;String.prototype.lstrip=String.prototype.trimLeft;String.prototype.rstrip=String.prototype.trimRight;String.prototype.join=function(iterable){return iterable.join(this)};String.prototype.zfill=function(size){var s,s;s=this;while(s.length<size){s="0"+s}return s};function list(iterable){if(typeof iterable==="undefined")iterable=[];var result,i;result=[];var _$rapyd$_Iter0=iterable;for(var _$rapyd$_Index0=0;_$rapyd$_Index0<_$rapyd$_Iter0.length;_$rapyd$_Index0++){i=_$rapyd$_Iter0[_$rapyd$_Index0];result.append(i)}return result}Array.prototype.append=Array.prototype.push;Array.prototype.find=Array.prototype.indexOf;Array.prototype.index=function(index){var val;val=this.find(index);if(val==-1){throw new ValueError(str(index)+" is not in list")}return val};Array.prototype.insert=function(index,item){this.splice(index,0,item)};Array.prototype.pop=function(index){if(typeof index==="undefined")index=this.length-1;return this.splice(index,1)[0]};Array.prototype.extend=function(array2){this.push.apply(this,array2)};Array.prototype.remove=function(item){var index;index=this.find(item);this.splice(index,1)};Array.prototype.copy=function(){return this.slice(0)};if(!Array.prototype.map){
	Array.prototype.map = function(callback, thisArg) {
		var T, A, k;
		if (this == null) {
			throw new TypeError(" this is null or not defined");
		}
		var O = Object(this);
		var len = O.length >>> 0;
		if ({}.toString.call(callback) != "[object Function]") {
			throw new TypeError(callback + " is not a function");
		}
		if (thisArg) {
			T = thisArg;
		}
		A = new Array(len);
		for (var k = 0; k < len; k++) {
			var kValue, mappedValue;
			if (k in O) {
				kValue = O[k];
				mappedValue = callback.call(T, kValue);
				A[k] = mappedValue;
			}
		}
		return A;
	};
	}function map(oper,arr){return arr.map(oper)}if(!Array.prototype.filter){
	Array.prototype.filter = function(filterfun, thisArg) {
		"use strict";
		if (this == null) {
			throw new TypeError(" this is null or not defined");
		}
		var O = Object(this);
		var len = O.length >>> 0;
		if ({}.toString.call(filterfun) != "[object Function]") {
			throw new TypeError(filterfun + " is not a function");
		}
		if (thisArg) {
			T = thisArg;
		}
		var A = [];
		var thisp = arguments[1];
		for (var k = 0; k < len; k++) {
			if (k in O) {
				var val = O[k]; // in case fun mutates this
				if (filterfun.call(T, val))
					A.push(val);
			}
		}
		return A;
	};
	}function filter(oper,arr){return arr.filter(oper)}function dict(iterable){var result,key;result={};var _$rapyd$_Iter1=iterable;for(var _$rapyd$_Index1=0;_$rapyd$_Index1<_$rapyd$_Iter1.length;_$rapyd$_Index1++){key=_$rapyd$_Iter1[_$rapyd$_Index1];result[key]=iterable[key]}return result}if(typeof Object.getOwnPropertyNames!=="function"){dict.keys=function(hash){var keys;keys=[];
		for (var x in hash) {
			if (hash.hasOwnProperty(x)) {
				keys.push(x);
			}
		}
		;return keys}}else{dict.keys=function(hash){return Object.getOwnPropertyNames(hash)}}dict.values=function(hash){var vals,key;vals=[];var _$rapyd$_Iter2=dict.keys(hash);for(var _$rapyd$_Index2=0;_$rapyd$_Index2<_$rapyd$_Iter2.length;_$rapyd$_Index2++){key=_$rapyd$_Iter2[_$rapyd$_Index2];vals.append(hash[key])}return vals};dict.items=function(hash){var items,key;items=[];var _$rapyd$_Iter3=dict.keys(hash);for(var _$rapyd$_Index3=0;_$rapyd$_Index3<_$rapyd$_Iter3.length;_$rapyd$_Index3++){key=_$rapyd$_Iter3[_$rapyd$_Index3];items.append([key,hash[key]])}return items};dict.copy=dict;dict.clear=function(hash){var key;var _$rapyd$_Iter4=dict.keys(hash);for(var _$rapyd$_Index4=0;_$rapyd$_Index4<_$rapyd$_Iter4.length;_$rapyd$_Index4++){key=_$rapyd$_Iter4[_$rapyd$_Index4];delete hash[key]}};portoalegrecc_json="http://portoalegre.cc/causes/visibles?topLeftY=-29.993308319952344&topLeftX=-51.05793032165525&bottomRightY=-30.127023880027313&bottomRightX=-51.34906801696775&currentZoom=1&maxZoom=6";pacc_jsonp="https://dl.dropbox.com/u/877911/portoalegre.js";Icones={};Icones["1"]=new L.icon({iconUrl:"images/pin_1.png",iconSize:[45,58],iconAnchor:[23,48],popupAnchor:[0,-40]});Icones["2"]=new L.icon({iconUrl:"images/pin_2.png",iconSize:[45,58],iconAnchor:[23,48],popupAnchor:[0,-40]});Icones["3"]=new L.icon({iconUrl:"images/pin_3.png",iconSize:[45,58],iconAnchor:[23,48],popupAnchor:[0,-40]});Icones["4"]=new L.icon({iconUrl:"images/pin_4.png",iconSize:[45,58],iconAnchor:[23,48],popupAnchor:[0,-40]});Icones["5"]=new L.icon({iconUrl:"images/pin_5.png",iconSize:[45,58],iconAnchor:[23,48],popupAnchor:[0,-40]});Icones["6"]=new L.icon({iconUrl:"images/pin_6.png",iconSize:[45,58],iconAnchor:[23,48],popupAnchor:[0,-40]});Icones["7"]=new L.icon({iconUrl:"images/pin_7.png",iconSize:[45,58],iconAnchor:[23,48],popupAnchor:[0,-40]});Icones["8"]=new L.icon({iconUrl:"images/pin_8.png",iconSize:[45,58],iconAnchor:[23,48],popupAnchor:[0,-40]});Icones["9"]=new L.icon({iconUrl:"images/pin_9.png",iconSize:[45,58],iconAnchor:[23,48],popupAnchor:[0,-40]});Icones["10"]=new L.icon({iconUrl:"images/pin_10.png",iconSize:[45,58],iconAnchor:[23,48],popupAnchor:[0,-40]});Icones["11"]=new L.icon({iconUrl:"images/pin_11.png",iconSize:[45,58],iconAnchor:[23,48],popupAnchor:[0,-40]});Icones["12"]=new L.icon({iconUrl:"images/pin_12.png",iconSize:[45,58],iconAnchor:[23,48],popupAnchor:[0,-40]});function portoalegre_cc(map_id){if(typeof map_id==="undefined")map_id="map";var convert_item_porto,mps2;convert_item_porto=function(item){var item_convertido;item_convertido={};item_convertido.longitude=""+item.cause.longitude;item_convertido.latitude=""+item.cause.latitude;item_convertido.texto=item.cause.category_name;item_convertido.cat=item.cause.category_name;item_convertido.cat_id=item.cause.category_id;item_convertido.icon=Icones[item_convertido.cat_id];return item_convertido};mps2=new Searchlight(pacc_jsonp,convert_item_porto,map_id,Icones)}window.portoalegre_cc=portoalegre_cc;OnibusAzul=new L.icon({iconUrl:getSLpath()+"../images/onibus_azul.png",iconSize:[45,58],iconAnchor:[23,48],popupAnchor:[0,-40]});OnibusVolta=new L.icon({iconUrl:getSLpath()+"../images/onibus_volta.png",iconSize:[45,58],iconAnchor:[23,48],popupAnchor:[0,-40]});pontos_inseridos=0;function converte_item1(item){var item_convertido;item_convertido={};item_convertido.longitude=""+item.longitude;item_convertido.latitude=""+item.latitude;item_convertido.texto=item.ponto+" ordem="+item.ordem;pontos_inseridos+=1;if(pontos_inseridos<68){item_convertido.icon=OnibusAzul;item_convertido.cat_id=1;item_convertido.cat="IDA"}else{item_convertido.cat_id=2;item_convertido.cat="VOLTA";item_convertido.icon=OnibusVolta}return item_convertido}function onSlcarregaDados(sl){var v,polyline,v,polyline;if(sl.map_id=="map1"){v=sl.dados.getCatLatLng("IDA");polyline=L.polyline(v,{color:"blue"}).addTo(sl.map);v=sl.dados.getCatLatLng("VOLTA");polyline=L.polyline(v,{color:"black"}).addTo(sl.map);sl.autoZoom()}if(sl.map_id=="map_gdoc"){sl.autoZoom()}}function exemplo1(){var osm,mps;osm="http://{s}.tile.cloudmade.com/bbcf9165c23646efbb1828828278c8bc/997/256/{z}/{x}/{y}.png";mps=new Searchlight("js/exemplos/121.json",converte_item1,"map1",null,false,false,osm)}function exemplo_gdoc(){var public_spreadsheet_url,mps;public_spreadsheet_url="https://docs.google.com/spreadsheet/pub?key=0AhU-mW4ERuT5dHBRcGF5eml1aGhnTzl0RXh3MHdVakE&single=true&gid=0&output=html";mps=new Searchlight(public_spreadsheet_url,null,"map_gdoc",null,true,false)}function exemplos(){window.onSLcarregaDados=onSlcarregaDados;exemplo1();exemplo_markercluster();exemplo_gdoc();portoalegre_cc("map")}window.exemplos=exemplos})();