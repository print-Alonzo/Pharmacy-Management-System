<%-- 
    Document   : supplier_list
    Created on : 11 21, 23, 10:35:47 PM
    Author     : ccslearner
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, pharmacysystem.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Supplier List</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 20px;
            text-align: center;
        }

        h1 {
            color: #007bff;
        }

        h2 {
            color: #007bff;
            margin-top: 30px;
        }

        table {
            width: 80%;
            margin: 20px auto;
            border-collapse: collapse;
            text-align: left;
        }

        th, td {
            padding: 10px;
            border-bottom: 1px solid #dee2e6;
        }

        th {
            background-color: #007bff;
            color: #fff;
        }

        tbody tr:hover {
            background-color: #f5f5f5;
        }
    </style>
</head>
<body>
    <h1>Supplier List</h1>
    <jsp:useBean id="S" class="pharmacysystem.suppliers" scope="page" />
    <% S.getAllSuppliers(); %>
    <table border="1">
        <thead>
            <tr>
                <th>Supplier ID</th>
                <th>Name</th>
                <th>Description</th>
                <th>Contact Number</th>
            </tr>
        </thead>
        <tbody>
            <% for(int i = 0; i < S.supplierIDList.size(); i++){ %>
                <tr>
                    <td><%= S.supplierIDList.get(i)%></td>
                    <td><%= S.nameList.get(i)%></td>
                    <td><%= S.descriptionList.get(i)%></td>
                    <td><%= S.contact_numberList.get(i)%></td>
                </tr>
            <%} %>
        </tbody>
    </table>
</body>
</html>