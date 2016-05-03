<!-- ********** LOGIN ***********-->
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="X-UA-Compatible" content="IE=10" />
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Login Hipotecario</title>
        <link rel="shortcut icon" href="img/favicon.ico" type="image/x-icon" />
        <!--<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"></script>
        <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>-->
        <script src="js/jquery.min.js" type="text/javascript"></script>
        <link href="css/bootstrap.min.css" rel="stylesheet" type="text/css"/>
        <script src="js/funciones.js"></script>
        <link href="css/index.css" rel="stylesheet" type="text/css"/>
        <script>
            if (${param.cod==1}) {
                alert("Contraseña incorrecta");
            } else if (${param.cod==2}) {
                alert("Usuario no autorizado");
            }
        </script>
    </head>
    <body style="margin: 18%">
    <center>
        <div class="container">
            <!-- Modal -->
            <div class="modal fade" id="myModal" role="dialog">
                <div class="modal-dialog">

                    <!-- Modal content-->
                    <div class="modal-content"  style="width: 250px">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal">&times;</button>
                            <center><h4 class="modal-title">Cambio de Contraseña</h4></center>
                        </div>
                        <div class="modal-body" >
                            <form action="ServletRegistro" method="POST">
                                <div class="form-group">
                                    <label for="user" class="col-sm-6">Usuario:</label>
                                    <center>
                                        <input type="text" class="col-sm-6" class="form-control" name="user" id="user1" placeholder="Usuario">
                                    </center>
                                </div>
                                <br><br>
                                <div class="form-group">
                                    <label for="pwd" class="col-sm-6" >Contraseña:</label>
                                    <center>
                                        <input type="password" class="col-sm-6" class="form-control" name="psw" id="psw1" placeholder="Contraseña nueva">
                                    </center>
                                </div>
                                <br><br>
                                <center><input type="submit" class="btn btn-info" value="Registrar"></center>
                            </form>
                        </div>
                    </div>

                </div>
            </div>

        </div>
    </center>

    <center>
        <div class="panel panel-default" style="width: 480px;height: 280px">
            <form action="ServletLogin" method="Post">
                <table role="table" align="center" style="height: 100%;width: 100%">
                    <!-- cabecera de login-->
                    <thead>
                    <th colspan="3" style="background-color: #00A94E">
                        <img src="img/Logo IBK verde.jpg" alt=""/>
                        <b><h3 id="txt" style="font-family: Calibri">Control de Accesos</h3></b>
                    </th>
                    </thead>

                    <tbody>

                        <tr>
                            <td><br><br><br><label class="col-sm-3" for="user" >Usuario:</label></td>
                            <td><br><br><br><input type="text" class="col-sm-16" class="form-control" id="user" name="user" placeholder="Ingrese usuario"></td>
                            <td  rowspan="3" style="padding-left: 25px">

                                <img id="hi_img" src="img/hipotecario.jpg" style="margin-top: 5px;margin-bottom: 20px"/>

                            </td>

                        </tr>
                        <tr>
                            <td ><br><label class="col-sm-3" style="margin-top: 5px" for="pwd" >Contraseña:</label></td>
                            <td ><br><input class="col-sm-16" style="margin-top: 5px" type="password" class="form-control" id="psw" name="psw" placeholder="Ingrese contraseña"></td>

                        </tr>
                        <tr>
                            <td colspan="2"><br><p style="margin-left: 115px;margin-top: -20px;color: #ffffff">Contraseña incorrecta</p></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td>

                            </td>
                            <td>
                    <center>
                        <br><input type="submit" id="login" style="width:125px;align-items: center;margin-top: -40px;margin-right: 20px;background: #00A94E;color: white" class="btn btn-default" value="Login">
                    </center>
                    </td>
                    <td>
                    <center>

                        <br><button type="button" style="margin-top: -40px;margin-right: -15px;font-family: Calibri;background: #00A94E;color: white" class="btn btn-default" data-toggle="modal" data-target="#myModal">Olvidé mi contraseña</button>
                    </center>
                    </td>
                    </tr>

                    </tbody>
                </table>
            </form>

            <!-- Modal Registro -->
            <div class="modal fade" id="registro" role="dialog">
                <div class="modal-dialog modal-sm" style="width:20%"> 

                    <!-- Modal content-->
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal">&times;</button>
                            <center><h4 class="modal-title">Cambio de Contraseña</h4></center>
                        </div>
                        <div class="modal-body" >
                            <div class="form-group">
                                <label for="user" class="col-sm-6">Usuario:</label>
                                <center>
                                    <input type="text" class="col-sm-6" class="form-control" id="user1" placeholder="Usuario">
                                </center>
                            </div>
                            <br><br>
                            <div class="form-group">
                                <label for="pwd" class="col-sm-6" >Contraseña:</label>
                                <center>
                                    <input type="password" class="col-sm-6" class="form-control" id="psw1" placeholder="Contraseña nueva">
                                </center>
                            </div>
                            <br><br>
                            <center><button type="button" onclick="ver();" class="btn btn-info">Registrar</button></center>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </center>
    <script src="js/bootstrap.min.js"></script>
</body>
</html>
