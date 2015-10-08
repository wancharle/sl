var mainBowerFiles = require('main-bower-files');
var concat = require('concat');
var CleanCSS = require('clean-css');
var fs = require('fs');

var js_files = mainBowerFiles("**/*.js");
concat(js_files,"js/bowerdeps.js",function (error) { 
    if (error)  console.error(error);
    else console.log("Concatenando dependencias do bower:",js_files, "\n no arquivo js/bowerdeps.js\n");
});

var css_files = mainBowerFiles("**/*.css");
new CleanCSS({relativeTo:"./", target:"css/estilos.min.css"}).minify(css_files,function(error,minified){
    if (error)
        console.log(error);
    else{
        console.log("Concatenando dependencias de css do bower: ", css_files, " \n no arquivo css/estilos.min.css\n");
        fs.writeFile('css/estilos.min.css', minified.styles,"utf-8");
    }
});


