
<%@page import="ibk.dto.Conexion"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!--libreria para hacer la conexión a la base de datos-->
<%@taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<!--libreria para recorrer las filas que devuelvan los query-->
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="X-UA-Compatible" content="IE=10" />
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Formulario</title>
        <link rel="shortcut icon" href="img/favicon.ico" type="image/x-icon" />
        <!--<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"></script>
        <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>-->
        <script src="js/jquery.min.js" type="text/javascript"></script>       
        <link href="css/bootstrap.min.css" rel="stylesheet" type="text/css"/>
        <!--scripts para validar formulario de forma automática-->
        <!--<script src="http://jqueryvalidation.org/files/dist/jquery.validate.min.js"></script>
        <script src="http://jqueryvalidation.org/files/dist/additional-methods.min.js"></script>-->
        <script src="js/additional-methods.min.js" type="text/javascript"></script>
        <script src="js/additional-methods.min.js" type="text/javascript"></script>
        <link href="css/formulario.css" rel="stylesheet" type="text/css"/>
        <script src="js/formulario.js" type="text/javascript"></script>
        <script>
            <%
                Cookie cookie = null;
                Cookie[] cookies = null;
                // Get an array of Cookies associated with this domain
                cookies = request.getCookies();
                String nombre = "";
                for (int i = 0; i < cookies.length; i++) {
                    if (cookies[i].getName().equals("user")) {
                        nombre = cookies[i].getValue();
                    }
                }

                if (nombre == null || nombre.equals("") || nombre.length() > 8) {
                    response.sendRedirect("index.jsp");
                }
            %>
        </script>
    </head>
    <body>
        <!--recibe el registro del usuario logeado-->
        <% String user = nombre;%>
        <!--conexión a la BD-->
        <sql:setDataSource var="snapshot" driver="com.microsoft.sqlserver.jdbc.SQLServerDriver"
                           url="jdbc:sqlserver://b27279ch3w7"
                           user="chip"  password="jedi1234"/>
        <!-- query para obtener la cantidad de solicitudes pendientes del usuario logeado-->
        <sql:query dataSource="${snapshot}" var="n">
            select COUNT(*) as numero from Phoenix.Formulario where Estado='Pendiente' and  [Usuario]='<%=user%>'
        </sql:query>
        <!-- query para obtener la cantidad de solicitudes aceptadas del usuario logeado-->
        <sql:query dataSource="${snapshot}" var="a">
            select COUNT(*) as numero from Phoenix.Formulario where Estado='Aceptada' and [Usuario]='<%=user%>'
        </sql:query>
        <!-- query para obtener la cantidad de solicitudes rechazadas del usuario logeado-->
        <sql:query dataSource="${snapshot}" var="r">
            select COUNT(*) as numero from Phoenix.Formulario where Estado='ContraOferta' and  [Usuario]='<%=user%>'
        </sql:query>
        <!--Query para mostrar las solicitudes pendientes con formato de monedas y fechas-->
        <sql:query dataSource="${snapshot}" var="result">

            SELECT *,case Moneda
            when 'Dolares' then '$ '+replace(convert(nvarchar(20),convert(money,round(Prestamo,0,0)),1),'.00','')
            when 'Soles' then 'S/. '+replace(convert(nvarchar(20),convert(money,round(Prestamo,0,0)),1),'.00','') 
            end As prestamo,
            convert(nvarchar(255),DAY(fecha_solicitud))+'-'+convert(nvarchar(255),MONTH(fecha_solicitud))+'-'+convert(nvarchar(255),YEAR(fecha_solicitud)) as solicitud
            FROM [BD_CHIP].[Phoenix].[Formulario] where  [Usuario]='<%=user%>' and Estado='Pendiente' order by 1
        </sql:query>
        <!--Query para mostrar las solicitudes aceptadas con formato de monedas y fechas-->
        <sql:query dataSource="${snapshot}" var="aceptada">
            SELECT *,case Moneda
            when 'Dolares' then '$ '+replace(convert(nvarchar(20),convert(money,round(Prestamo,0,0)),1),'.00','')
            when 'Soles' then 'S/. '+replace(convert(nvarchar(20),convert(money,round(Prestamo,0,0)),1),'.00','') 
            end As prestamo,
            DATEDIFF(HH,fecha_solicitud,fecha_respuesta) as rpta,
            convert(nvarchar(255),DAY(fecha_respuesta))+'-'+convert(nvarchar(255),MONTH(fecha_respuesta))+'-'+convert(nvarchar(255),YEAR(fecha_respuesta)) as aprobacion
            FROM [BD_CHIP].[Phoenix].[Formulario] where  [Usuario]='<%=user%>' and Estado='Aceptada' and dias >=0 order by 1
        </sql:query>
        <!--Query para mostrar las solicitudes rechazadas con formato de monedas y fechas-->
        <sql:query dataSource="${snapshot}" var="contra">
            SELECT *,case Moneda
            when 'Dolares' then '$ '+replace(convert(nvarchar(20),convert(money,round(Prestamo,0,0)),1),'.00','')
            when 'Soles' then 'S/. '+replace(convert(nvarchar(20),convert(money,round(Prestamo,0,0)),1),'.00','') 
            end As prestamo,
            DATEDIFF(HH,fecha_solicitud,fecha_respuesta) as rpta,
            convert(nvarchar(255),DAY(fecha_respuesta))+'-'+convert(nvarchar(255),MONTH(fecha_respuesta))+'-'+convert(nvarchar(255),YEAR(fecha_respuesta)) as aprobacion
            FROM [BD_CHIP].[Phoenix].[Formulario] where  [Usuario]='<%=user%>' and Estado='ContraOferta' and dias>=0 order by 1
        </sql:query>
        <!--Logo y banner según IBK-->
        <%Conexion c = new Conexion();%>
    <center>
        <div class="main" role="main" style="width: 100%">
            <div class="header" style="width: 60%">
                <img src="img/Logo Ibk_verde_sinfondo.png" alt=""/>
                <!-- cerrar sesión del usuario logeado -->
                <a href="ServletLogout" id="logout">Cerrar sesión <span class="glyphicon glyphicon-log-in"></span></a>
            </div>
            <br>
            <br>
            <br>
            <div style="background-color: #00A94E;height: 50px;text-align:center">
                <table height="50" align="center" >
                    <tr>
                        <td style="color: #ffffff;font-size: 22px"><b>¡Hola! <%=c.getNombre(user)%></b></td>
                    </tr>
                </table>
            </div>
        </div>
    </center>
    <br>
    <center>
        <div class="container" align="center" style="width: 88.5%">
            <br>
            <h3 style="color: grey"><b>El acuerdo de servicio es de 24 horas para la atención de solicitudes</b></h3>
            <br>
            <br>
            <!--Tabs de bandeja de solicitudes-->
            <ul class="nav nav-tabs nav-justified">
                <li class="active"><a data-toggle="tab" href="#enviadas" style="color:#0060B3"><b>Enviadas (<c:forEach var="b" items="${n.rows}">${b.numero}</c:forEach>)</b></a></li>
                <li><a data-toggle="tab" href="#aceptadas" style="color: #0060B3"><b>Aceptadas (<c:forEach var="b" items="${a.rows}">${b.numero}</c:forEach>)</b></a></li>
                <li><a data-toggle="tab" href="#contraOfertas" style="color: #0060B3"><b>Contra Ofertas (<c:forEach var="b" items="${r.rows}">${b.numero}</c:forEach>)</b></a></li>
                    <li><a data-toggle="tab" href="#solicitud" style="color: #0060B3"><b>Solicitud</b></a></li>
                </ul>

                <div class="tab-content" class="tab-content" style="margin-top: 15px">
                    <!--Tab de solicitudes pendientes-->
                    <div id="enviadas" class="tab-pane fade in active" style="margin-top: 15px;">
                        <div class="container" style="overflow-y: scroll;width: 100%"> 
                            <div class="input-group">
                                <span class="input-group-addon" onclick="location.reload();">
                                    <span class="glyphicon glyphicon-refresh"></span>
                                    Actualizar
                                </span>
                                <input id="f1" type="text" class="form-control" placeholder="Ingrese consulta...">
                            </div>
                            <table class="table" border="1" id="t1" name="t1">
                                <thead>
                                    <tr>
                                        <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%">
                                            <b>Fecha de Solicitud</b>
                                        </th>
                                        <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="8%"><b>DNI</b></th>
                                        <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%"><b>Monto Solicitado</b></th>
                                        <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="8%"><b>Moneda</b></th>
                                        <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%"><b>Plazo</b></th>
                                        <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%"><b>Producto</b></th>
                                        <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%"><b>Tasa ADQ</b></th>
                                        <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%"><b>Tasa Solicitada</b></th>
                                        <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="14%"><b>Motivo</b></th>
                                        <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" ><b>Adjunto</b></th>
                                    </tr>
                                </thead>
                            </table>
                        </div>
                        <div class="container" style="overflow-y: scroll;margin-top: -20px;max-height: 600px;width: 100%">    
                            <table class="table" border="1">
                                <tbody class="searchable">
                                <c:forEach var="row" items="${result.rows}">
                                    <tr style="text-align: center">
                                        <td style="font-size: 12px;vertical-align:middle;" width="10%">
                                            <a style="color: #000000" href="enviadas.jsp?cod=${row.Id}">${row.solicitud}</a>
                                        </td>
                                        <td style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="8%">${row.Cod_doc}</td>
                                        <td style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%">${row.prestamo}</td>
                                        <td style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="8%">${row.Moneda}</td>
                                        <td style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%">${row.Plazo}</td>
                                        <td style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%">${row.Producto_origen}</td>
                                        <td style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%">${row.Tasa_ADQ}</td>
                                        <td style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%">${row.Tasa_Solicitada}</td>                                  
                                        <td style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="14%">${row.Motivo}</td>
                                        <td style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" >
                                            <a data-toggle="modal" data-id="${row.Id}" title="Añadir foto" class="open-añadir btn btn-primary" href="#añadir">
                                                <span class="glyphicon glyphicon-picture"></span>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
                <!--Tab de solicitudes aceptadas-->
                <div id="aceptadas" class="tab-pane fade" style="margin-top: 15px">
                    <div class="container" style="overflow-y: scroll;width: 100%">
                        <div class="input-group">
                            <span class="input-group-addon" onclick="location.reload();">
                                <span class="glyphicon glyphicon-refresh"></span>
                                Actualizar
                            </span>
                            <input id="f2" type="text" class="form-control" placeholder="Ingrese consulta...">
                        </div>
                        <table class="table" border="1">
                            <thead>
                                <tr>

                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%">
                                        <b>Fecha de Aprobación</b>
                                    </th>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="8%"><b>DNI</b></th>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%"><b>Monto Solicitado</b></th>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="8%"><b>Moneda</b></th>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="8%"><b>Plazo</b></th>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%"><b>Producto</b></th>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%"><b>Tasa Aprobada</b></th>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%"><b>Vigencia (dias)</b></th>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="14%"><b>Motivo</b></th>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" ><b>Reenvio</b></th>
                                </tr>
                            </thead>
                        </table>
                    </div>
                    <div class="container" style="overflow-y: scroll;margin-top: -20px;max-height: 600px;width: 100%">    
                        <table class="table" border="1">
                            <tbody class="searchable1">
                                <c:forEach var="row" items="${aceptada.rows}">
                                    <tr style="text-align: center">                                  
                                        <td style=";font-size: 12px;text-align: center;vertical-align:middle;color: #000000" align="center" width="10%">
                                            <a style="color: #000000" href="respondidas.jsp?cod=${row.Id}">${row.aprobacion}</a>
                                        </td>
                                        <td style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="8%">${row.Cod_doc}</td>
                                        <td style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%">${row.prestamo}</td>
                                        <td style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="8%">${row.Moneda}</td>
                                        <td style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="8%">${row.Plazo}</td>
                                        <td style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%">${row.Producto_origen}</td>
                                        <td style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%">${row.Tasa_aceptada}</td>
                                        <td style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%">${row.dias}
                                            <c:choose>
                                                <c:when test="${row.dias>20}">
                                                    <span align="center" style="color:#009150; font-family: Webdings; font-weight:bold">n</span>
                                                </c:when>
                                                <c:when test="${row.dias>10 and row.dias<21}">
                                                    <span align="center" style="color:#009150; font-family: Webdings; font-weight:bold">n</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span align="center" style="color:red; font-family: Webdings; font-weight:bold">n</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td> 
                                        <td style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="14%">${row.Motivo}</td>
                                        <td style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" >
                                            <a data-toggle="modal" data-id="${row.Id}" class="open-reenvio btn btn-primary" href="#reenvio" >
                                                <span class="glyphicon glyphicon-repeat"></span>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
                <!--Tab de solicitudes rechazadas-->
                <div id="contraOfertas" class="tab-pane fade" style="margin-top: 15px">
                    <div class="container" style="overflow-y: scroll;width: 100%">
                        <div class="input-group">
                            <span class="input-group-addon" onclick="location.reload();">
                                <span class="glyphicon glyphicon-refresh"></span>
                                Actualizar
                            </span>
                            <input id="f3" type="text" class="form-control" placeholder="Ingrese consulta...">
                        </div>
                        <table class="table" border="1">
                            <thead>
                                <tr>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%">
                                        <b>Fecha de Aprobación</b>
                                    </th>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="8%"><b>DNI</b></th>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%"><b>Monto Solicitado</b></th>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="8%"><b>Moneda</b></th>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="8%"><b>Plazo</b></th>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%"><b>Producto</b></th>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="8%"><b>Tasa Mínima</b></th>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="8%"><b>Tasa Solicitada</b></th>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="8%"><b>Vigencia (dias)</b></th>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="14%"><b>Motivo</b></th>
                                    <th style=";font-size: 12px;text-align: center;vertical-align:middle;" align="center" ><b>Reenvio</b></th>
                                </tr>
                            </thead>
                        </table>
                    </div>
                    <div class="container" style="overflow-y: scroll;margin-top: -20px;max-height: 600px;width: 100%">    
                        <table class="table" border="1">
                            <tbody class="searchable3" data-filter="#f3">
                                <c:forEach var="row" items="${contra.rows}">
                                    <tr style="text-align: center">
                                        <td style=";font-size: 12px;text-align: center;vertical-align:middle;color: #000000" align="center" width="10%">
                                            <a style="color: #000000" href="respondidas.jsp?cod=${row.Id}">${row.aprobacion}</a>
                                        </td>
                                        <td style="font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="8%">${row.Cod_doc}</td>
                                        <td style="font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%">${row.prestamo}</td>
                                        <td style="font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="8%">${row.Moneda}</td>
                                        <td style="font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="8%">${row.Plazo}</td>
                                        <td style="font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="10%">${row.Producto_origen}</td>
                                        <td style="font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="8%">${row.Tasa_Aceptada}</td>
                                        <td style="font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="8%">${row.Tasa_Solicitada}</td> 
                                        <td style="font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="8%">${row.dias}
                                            <c:choose>
                                                <c:when test="${row.dias>10}">
                                                    <span align="center" style="color:#009150; font-family: Webdings; font-weight:bold">n</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span align="center" style="color:#009150; font-family: Webdings; font-weight:bold">n</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td> 

                                        <td style="font-size: 12px;text-align: center;vertical-align:middle;" align="center" width="14%">${row.Motivo}</td>
                                        <td style="font-size: 12px;text-align: center;vertical-align:middle;" align="center">
                                            <a data-toggle="modal" data-id="${row.Id}" class="open-reenvio btn btn-primary" href="#reenvio">
                                                <span class="glyphicon glyphicon-repeat"></span>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
                <!--Tab de formulario-->
                <div id="solicitud" class="tab-pane fade">
                    <center>
                        <div class="panel panel-default" style="width: 43%;margin-top: 20px"> 

                            <form id="formulario" name="formulario" action="ServletFormulario" method="POST" enctype="multipart/form-data">
                                <table align='center' style="width: 98%;margin-top: 5px" >
                                    <thead>
                                    <th style="background-color: #00A94E;color: #ffffff;font-family: Calibri;height: 30px;text-align: center" colspan="2"><b>Solicitud de TASA</b></th>
                                    </thead>

                                    <tbody>
                                        <tr>
                                            <td><br>Nombre del Cliente</td>
                                            <td>
                                                <br><input class="form-control" type='text' id='nombre' name="nombre" required="true" pattern="[Aa-Zz]" placeholder="Ejm: Apellido, Nombre">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>DNI</td>
                                            <td>
                                                <input class="form-control" type='text' id='dni' name="dni" required="true" pattern="[0-9]{8}" placeholder="Ingrese DNI">
                                                <input type="text" value="<%=user%>" name="user" hidden="">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Valor Inmueble</td>
                                            <td>
                                                <input class="form-control" type='text' id='valorI' name="valorI" onchange="r();" placeholder="Ingrese valor del inmueble"required="true" pattern="[0-9]+([,\.][0-9]+)?">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Cuota inicial</td>
                                            <td><input class="form-control" type='text' id='cuotaI' name="cuotaI" onchange="r();" pattern="[0-9]+([,\.][0-9]+)?" required="" placeholder="Ingrese cuota inicial">
                                                <input type="checkbox" id="cuota1" onclick="ci();">No aplica</td>
                                        </tr>
                                        <tr>
                                            <td>Financiamiento</td>
                                            <td>
                                                <input class="form-control" type='text' id='prestamo' name="prestamo" required="" readonly="">
                                            </td>
                                        </tr>                                  
                                        <tr>
                                            <td>Moneda</td>
                                            <td>
                                                <select class="form-control" id="moneda" name="moneda">
                                                    <option>Soles</option>
                                                    <option>Dolares</option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Plazo</td>
                                            <td><input class="form-control" type='text' id='pl' name="plazo" pattern="[0-9]+([,\.][0-9]+)?" required="" placeholder="Ingrese plazo en meses"></td>
                                        </tr>
                                        <tr>
                                            <td>Producto</td>
                                            <td>
                                                <select class="form-control" id="prod" name="prod" onchange="compra();">
                                                    <option>Hipotecario</option>
                                                    <option>Préstamo con Garantía Hipotecaria</option>
                                                    <option>Libre Disponibilidad con Garantía Hipotecaria</option>
                                                    <option>Compra deuda</option> 
                                                    <option>Mi Vivienda</option>
                                                    <option>Crédito con ampliación</option>
                                                    <option>Crédito para construcción</option>
                                                    <option>Techo Propio</option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Medio de Calificación</td>
                                            <td>
                                                <select class="form-control" id="medio" name="medio">
                                                    <option>Tradicional</option>
                                                    <option>Ahorro casa</option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Mes estimado para desembolso</td>
                                            <td>
                                                <select class="form-control" id="mes" name="mes">
                                                    <option>Enero</option>
                                                    <option>Febrero</option>
                                                    <option>Marzo</option>
                                                    <option>Abril</option>
                                                    <option>Mayo</option>
                                                    <option>Junio</option>
                                                    <option>Julio</option>
                                                    <option>Agosto</option>
                                                    <option>Setiembre</option>
                                                    <option>Octubre</option>
                                                    <option>Noviembre</option>
                                                    <option>Diciembre</option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Tipo de inmueble</td>
                                            <td>
                                                <select class="form-control" id="tipo" name="tipo">
                                                    <option>Bien Futuro</option>
                                                    <option>Bien Terminado</option>
                                                    <option>Proyecto otro banco</option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Vivienda</td>
                                            <td>
                                                <select class="form-control" id="vivienda" name="vivienda" onchange="mv();">
                                                    <option>Primera</option>
                                                    <option>Segunda</option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Tasa ADQ</td>
                                            <td><input class="form-control" type='text' id='adq' name="adq" onchange="mv();"  pattern="[0-9]+([,\.][0-9]+)?" placeholder="Ingrese tasa ADQ en %" required="">
                                                <input type="checkbox" id="adq1" onclick="adq.value = 0">No aplica</td>

                                        </tr>
                                        <tr>
                                            <td>Tasa solicitada</td>
                                            <td><input class="form-control" type='text' id='tasaS' onchange="producto()" name="tasaS" pattern="[0-9]+([,\.][0-9]+)?" min="7" placeholder="Ingrese tasa solicitada en %" required=""></td>
                                        </tr>
                                        <tr>
                                            <td>Motivo de Baja de Tasa</td>
                                            <td>
                                                <select class="form-control" onchange="motivo()" id="mot" name="mot">
                                                    <option>Competencia</option>
                                                    <option value="ADQ">Actualización de Tasa ADQ</option>
                                                    <option>Compra deuda</option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Segmento</td>
                                            <td>
                                                <select class="form-control" id="segmento" name="segmento">
                                                    <option>1A</option>
                                                    <option>1BC</option>
                                                    <option>2</option>
                                                    <option>3</option>
                                                    <option>4</option>
                                                    <option>5</option>
                                                    <option>6</option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Tenencia de Productos IB</td>
                                            <td>
                                                <br>
                                                <input type="checkbox" value="cts" id="cts" name="cts"> CTS<br>
                                                <input type="checkbox" value="planilla" id="planilla" name="planilla"> Planilla<br>
                                                <input type="checkbox" id="otros" onclick="otrosText.disabled = !this.checked">Otros
                                                <input type="text" name="otros" id="otrosText" disabled="disabled" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="control-label">Comentarios</td>
                                            <td><br><textarea type="text" id="comentarioF" name="comentarioF" class="form-control" maxlength="255"></textarea></td>
                                        </tr>
                                        <tr>
                                            <td rowspan="2">Archivos Adjuntos</td>
                                            <td align="center">
                                                <br><input type="file" name="f1" class="form-control">
                                                <br><input type="file" name="f2" class="form-control">
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                                <br>
                                <center><input type="submit" class="btn btn-success" value="Enviar Solicitud" ></center>
                            </form>
                            <br>

                        </div>
                    </center>
                </div>
            </div>
            <!--modal añadir foto-->
            <div class="modal fade" id="añadir" role="dialog">
                <div class="modal-dialog modal-sm" style="width: 350px"> 

                    <!-- Modal content-->
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal">&times;</button>
                            <center><h4 class="modal-title">Añadir Archivo</h4></center>
                        </div>
                        <div class="modal-body">

                            <form action="Imagen" method="post" enctype="multipart/form-data">

                                <br><input type="file" name="archivo"/>
                                <br><input type="text" name="idA" id="idA" hidden="">
                                <br><input type="text" name="page" value="formulario.jsp" hidden="">
                                <br><input type="submit" value="Registrar">
                            </form>
                        </div>
                    </div>

                </div>
            </div>
            <!-- Modal de reenvio-->
            <div class="modal fade" id="reenvio" role="dialog">
                <div class="modal-dialog modal-sm" style="width: 450px"> 

                    <!-- Modal content-->
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal">&times;</button>
                            <center><h4 class="modal-title">Nueva Propuesta</h4></center>
                        </div>
                        <div class="modal-body">
                            <form action="ServletRepechaje" method="post" enctype="multipart/form-data">
                                <br>Nueva Tasa<input type="text" class="form-control" name="tasaR" id="tasaR"  />
                                <br><input type="text" name="idR" id="idR" hidden="">
                                <br><input type="file" name="imagen"  id="imagen"/>
                                <br>Comentario<textarea type="textarea" id="comentarioR" name="comentarioR" class="form-control" maxlength="255" placeholder="Motivo de la nueva tasa"></textarea>

                                <br><input type="submit" value="Registrar">
                            </form>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </center>

    <script src="js/bootstrap.min.js"></script>
</body>
</html>
