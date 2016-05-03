//descarga las imagenes en la ruta establecida
function descargar(){
    var cod=document.getElementById("cod").value;
    $.post('ServletDescargas', {
            cod: cod

        }, function (responseText) {
            if (responseText === "no hay nada") {
                alert("¡No hay archivos adjuntos!");
                
            } else {
                alert("Los archivos se encuentran en: \n"+responseText);
            }
        });
}

