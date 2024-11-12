<%-- 
    Document   : Listado
    Created on : 11 nov. 2024, 20:21:11
    Author     : mauri
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="javax.servlet.http.HttpServletRequest" %>
<%@ page import="javax.servlet.http.HttpServletResponse" %>

<!DOCTYPE html>
<html>
<head>
    <title>Tecni Auto</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            font-family: Arial, sans-serif;
        }
        .header {
            text-align: center;
            font-size: 24px;
            font-weight: bold;
            border: 2px solid black;
            padding: 10px;
            margin-bottom: 20px;
        }
        .employee {
            text-align: right;
            font-size: 18px;
            margin-bottom: 20px;
        }
        .materials-list, .selected-materials {
            height: 400px;
            padding: 20px;
            overflow-y: auto;
        }
        .materials-list {
            border: 2px solid red;
        }
        .selected-materials {
            border: 2px solid blue;
        }
        .materials-list h3, .selected-materials h3 {
            font-size: 24px;
            font-weight: bold;
        }
        .materials-list h3 {
            color: red;
        }
        .materials-list ul {
            list-style-type: none;
            padding: 0;
        }
        .materials-list ul li {
            font-size: 18px;
            cursor: pointer;
        }
        .buttons {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
        }
        .buttons button {
            width: 48%;
            font-size: 18px;
            padding: 10px;
            border: 2px solid black;
        }
        .buttons .btn-danger {
            color: red;
        }
    </style>
</head>
<%
    String nombreEmpleado = request.getParameter("nombreEmpleado");

    // Verificar si el nombre del empleado no es nulo, de lo contrario redirigir a index.jsp
    if (nombreEmpleado == null) {
        response.sendRedirect("index.jsp");
    }
%>


<body>
    <div class="header">Tecni Auto</div>
    <div class="employee">Empleado:<%= nombreEmpleado %></div>
    <div class="container">
        <div class="row">
            <div class="col-md-5 materials-list">
                <h3>Lista de Materiales</h3>
                <h4>LIJAS</h4>
                <ul id="lijas">
                    <li onclick="addMaterial('Lija 80')">Lija 80</li>
                    <li onclick="addMaterial('Lija 120')">Lija 120</li>
                    <li onclick="addMaterial('Lija 180')">Lija 180</li>
                    <li onclick="addMaterial('Lija 220')">Lija 220</li>
                    <li onclick="addMaterial('Lija 320')">Lija 320</li>
                    <li onclick="addMaterial('Lija 400')">Lija 400</li>
                    <li onclick="addMaterial('Lija 400 Agua')">Lija 400 Agua</li>
                </ul>
                <h4>DISCOS</h4>
                <ul id="discos">
                    <li onclick="addMaterial('Disco 40')">Disco 40</li>
                    <li onclick="addMaterial('Disco 80')">Disco 80</li>
                    <li onclick="addMaterial('Disco 120')">Disco 120</li>
                    <li onclick="addMaterial('Disco 180')">Disco 180</li>
                    <li onclick="addMaterial('Disco 220')">Disco 220</li>
                    <li onclick="addMaterial('Disco 320')">Disco 320</li>
                    <li onclick="addMaterial('Disco 400')">Disco 400</li>
                </ul>
            </div>
            <div class="col-md-7 selected-materials">
                <h3>Materiales seleccionados</h3>
                <ul id="selected-materials">
                    <!-- Selected materials will appear here -->
                </ul>
            </div>
        </div>
        <div class="row buttons">
            <button class="btn btn-primary" onclick="sendMaterials()">Enviar</button>
            <button class="btn btn-danger" onclick="clearMaterials()">Eliminar</button>
            <button class="btn btn-secondary" onclick="logout()">Salir</button>
        </div>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.3.1/jspdf.umd.min.js"></script>
    <script>
        function addMaterial(material) {
            const ul = document.getElementById('selected-materials');
            const li = document.createElement('li');
            li.textContent = material;
            ul.appendChild(li);
        }

        function sendMaterials() {
            const ul = document.getElementById('selected-materials');
            const materials = [];
            for (let i = 0; i < ul.children.length; i++) {
                materials.push(ul.children[i].textContent);
            }

            // Generate PDF
            const { jsPDF } = window.jspdf;
            const doc = new jsPDF();

            doc.text("Reporte de Materiales", 10, 10);
            doc.text("Empleado: <%=nombreEmpleado%>", 10, 20);
            doc.text("Materiales seleccionados:", 10, 30);

            materials.forEach((material, index) => {
                doc.text(material, 10, 40 + (index * 10));
            });

            doc.save("reporte_materiales.pdf");

            // Send materials to server
            fetch('MaterialServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ materials: materials })
            }).then(response => response.json())
              .then(data => {
                  if (data.success) {
                      alert('Materials sent successfully!');
                      location.reload(); // Refresh the page
                  } else {
                      alert('Failed to send materials.');
                  }
              });
        }

        function clearMaterials() {
            const ul = document.getElementById('selected-materials');
            ul.innerHTML = '';
        }

        function logout() {
            window.location.href = 'index.jsp';
        }
    </script>
</body>
</html>