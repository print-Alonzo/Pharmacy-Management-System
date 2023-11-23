<%-- 
    Document   : employee_list
    Created on : 11 21, 23, 10:27:17 PM
    Author     : ccslearner
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, pharmacysystem.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Employee List</title>
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
    <body>
        <h1>Employee List</h1>
        <jsp:useBean id="E" class="pharmacysystem.employees" scope="page" />
        <% E.getAllEmployees(); %>
        <table border="1">
            <thead>
                <tr>
                    <th>Employee ID</th>
                    <th>First Name</th>
                    <th>Last Name</th>
                    <th>Position</th>
                    <th>Contact Number</th>
                    <th>Address</th>
                    <th>Salary</th>
                </tr>
            </thead>
            <tbody>
                <% for(int i = 0; i < E.employee_idList.size(); i++){ %>
                    <tr>
                        <td><%= E.employee_idList.get(i)%></td>
                        <td><%= E.first_nameList.get(i)%></td>
                        <td><%= E.last_nameList.get(i)%></td>
                        <td><%= E.positionList.get(i)%></td>
                        <td><%= E.contact_noList.get(i)%></td>
                        <td><%= E.addressList.get(i)%></td>
                        <td><%= E.salaryList.get(i)%></td>
                    </tr>
                <%} %>
            </tbody>
        </table>
    </body>
</html>
