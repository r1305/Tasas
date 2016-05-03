//valida los campos del formulario según las restricciones
$(function ()
{
    $("#formulario").validate();
});

//si el motivo de baja de tasa es Actualización de ADQ
//mandará una alerta para que ingrese sustento
function motivo(){
    
    var m=document.getElementById("mot").value;
    if(m==="ADQ"){
        alert("Ingrese Sustento");
    }
}

//Valida si el producto es compra deuda
//el tipo de inmueble es Bien terminado por defecto
function compra(){
    var deuda=document.getElementById("prod").value;
    if(deuda==="Compra deuda"){
        $("#tipo").val("Bien Terminado");
        $("#tipo").prop('disabled', 'disabled');
    }else{
        $("#tipo").prop('disabled', false);
    }
}
function ci(){
    var c=document.getElementById("cuota1").checked;
    if(c){
        $("#cuotaI").val("0");
        $('#prod').val('Compra deuda');
        $('#prod').prop('disabled', 'disabled');
    }else{
        $("#prod").prop('disabled', false);
    }
}


//resta el valor inmueble y cuota inicial para mostrar el monto de financiamiento
function r()
{
    var valorI = document.getElementById("valorI").value;
    var cuotaI = document.getElementById("cuotaI").value;
    var resta=valorI-cuotaI;
    document.getElementById("prestamo").value=resta;
    
}

//valida que la tasa mínima para Mi Vivienda sea de 10
function producto(){
    var prod=document.getElementById("prod").value;
    var tasa=document.getElementById("tasaS").value;
    if(prod==="Mi Vivienda"){
        if(tasa<10){
            alert("No puede solicitar una tasa menor a 10")
        }
    }
}

//validamos que las reevaluaciones no excedan el número de intentos (2) máximo
//para la RED
function repe()
{
    var tasaR = document.getElementById("tasaR").value;
    var idR = document.getElementById("idR").value;
    var comentarioR = document.getElementById("comentarioR").value;
    var imagen=document.getElementById("imagen").value;
    
    $.post('ServletRepechaje', {
            tasaR: tasaR,
            idR: idR,
            comentarioR: comentarioR,
            imagen:imagen

        }, function (responseText) {
            if (responseText === "success") {
                $('#repe').trigger("reset");
                alert("¡Solicitud Registrada!");
                location.reload();
            }else if (responseText === "repetido") {
                $('#repe').trigger("reset");
                alert("¡El máximo número de veces para esta solicitud es de 2!");
                location.reload();
            } else {
                alert("¡Error al enviar solicitud!");
            }
        });
}

//validamos que las reevaluaciones no excedan el número de intentos (2) máximo
//para la FFVV
function repeFFVV()
{
    var tasaR = document.getElementById("tasaR").value;
    var idR = document.getElementById("idR").value;
    var comentarioR = document.getElementById("comentarioR").value;
    var imagen=document.getElementById("imagen").value;
    
    $.post('ServletRepechajeFFVV', {
            tasaR: tasaR,
            idR: idR,
            comentarioR: comentarioR,
            imagen:imagen

        }, function (responseText) {
            if (responseText === "success") {
                $('#repe').trigger("reset");
                alert("¡Solicitud Registrada!");
                location.reload();
            }else if (responseText === "repetido") {
                $('#repe').trigger("reset");
                alert("¡El máximo número de veces para esta solicitud es de 2!");
                location.reload();
            } else {
                alert("¡Error al enviar solicitud!");
            }
        });
}

//validamos si el valor inmueble esta entre 14 y 70 UITs
//se manda una alerta que el producto puede ser calificado como Mi Vivienda
//1 UIT=3950
function mv(){
    var v=document.getElementById("valorI").value;
    var vi=document.getElementById("vivienda").value;
    var moneda=document.getElementById("moneda").value;
    var prod=document.getElementById("prod").value;
    
    if(prod==="Hipotecario" && vi==="Primera" && v>=55300 && v<=276500 && moneda==="Soles"){
        
            alert("Esta solicitud podría calificar como Mi Vivienda");
            alert("Ingrese sustento de la solicitud en comentarios");
        
    }
}

$(document).on("click", ".open-añadir", function () {
     var myBookId = $(this).data('id');
     //$("#test3").val(myBookId);
     $("#idA").val( myBookId );
});

$(document).on("click", ".open-reenvio", function () {
     var myBookId = $(this).data('id');
     //$("#test3").val(myBookId);
     $("#idR").val( myBookId );
});

//deshabilitar función de ver código fuente y F12
document.onkeypress = function (event) {
 event = (event || window.event);
 if (event.keyCode == 123) {
 //alert('No F-12');
 return false;
 }
 }
 document.onkeydown = function (event) {
 event = (event || window.event);
 if (event.keyCode == 123) {
 //alert('No F-keys');
 return false;
 }
 }

//filtro de tablas
$(document).bind("contextmenu", function (e) {
    e.preventDefault();
});

//buscar las coincidencias en las tablas
$(document).ready(function () {

    (function ($) {

        $('#f1').keyup(function () {

            var rex = new RegExp($(this).val(), 'i');
            $('.searchable tr').hide();
            $('.searchable tr').filter(function () {
                return rex.test($(this).text());
            }).show();
        });
    }(jQuery));
});
$(document).ready(function () {
    (function ($) {

        $('#f2').keyup(function () {

            var rex = new RegExp($(this).val(), 'i');
            $('.searchable1 tr').hide();
            $('.searchable1 tr').filter(function () {
                return rex.test($(this).text());
            }).show();
        });
    }(jQuery));
});
$(document).ready(function () {
    (function ($) {

        $('#f3').keyup(function () {

            var rex = new RegExp($(this).val(), 'i');
            $('.searchable2 tr').hide();
            $('.searchable2 tr').filter(function () {
                return rex.test($(this).text());
            }).show();
        });
    }(jQuery));
});