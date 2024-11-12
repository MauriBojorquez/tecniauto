<%-- 
    Document   : index
    Created on : 11 nov. 2024, 20:20:31
    Author     : mauri
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="Clases.Conexion" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.*" %>


<!DOCTYPE html>
<html>
<head>
    <title>Tecni Auto</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-color: white;
        }
        .login-container {
            text-align: center;
            border: 2px solid black;
            padding: 20px;
        }
        .login-container h1 {
            font-size: 24px;
            font-weight: bold;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-control {
            border: 2px solid black;
        }
        .btn-custom {
            border: 2px solid black;
            color: blue;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h1>Tecni Auto</h1>
        <form action="" method="post">
            <input type="hidden" name="accion" value="acceso">
            <div class="form-group">
                <label for="nombres">Usuario:</label>
                <input type="text" class="form-control" id="nombres" name="nombres" required>
            </div>
            <div class="form-group">
                <label for="claves">Clave:</label>
                <input type="password" class="form-control" id="claves" name="claves" required>
            </div>
            <button type="submit" name="accion" class="btn btn-custom">Acceso</button>
        </form>
    </div>


<%
    // Obtener los parámetros del formulario
    String nombres = request.getParameter("nombres");
    String claves = request.getParameter("claves");
    String accion = request.getParameter("accion");

    // Verificar si la acción es "acceso"
    if ("acceso".equals(accion)) {
        try {
            // Conectar a la base de datos
           Conexion conexion = new Conexion();
            Connection cnn = conexion.getConexion();
            // Consultar la base de datos para verificar las credenciales
            String sql = "SELECT * FROM usuarios WHERE nombres = ? AND claves = ?";
            PreparedStatement ps = cnn.prepareStatement(sql);
            ps.setString(1, nombres);
            ps.setString(2, claves);
            ResultSet rs = ps.executeQuery();

            // Verificar si existe un usuario con esas credenciales
            if (rs.next()) {
                response.sendRedirect("Listado.jsp?nombreEmpleado=" + nombres);
            } else {
                // Si las credenciales son incorrectas, mostrar un mensaje de error
                out.println("<script>alert('Usuario o clave incorrectos');</script>");
                out.println("<script>window.location.href='index.jsp';</script>");
            }

            // Cerrar la conexión
            rs.close();
            ps.close();
            cnn.close();
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<script>alert('Error al conectar con la base de datos');</script>");
            out.println("<script>window.location.href='index.jsp';</script>");
        }
    }
%>

</body>
</html>