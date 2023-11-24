<%-- 
    Document   : employee_list_filter
    Created on : 11 25, 23, 1:41:13 AM
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

        /* Add new style for checkboxes */
        .filter-checkbox {
            margin-right: 10px;
        }
    </style>
    <script>
        // JavaScript function to allow only one checkbox to be checked
        function updateCheckbox(checkbox) {
            var checkboxes = document.getElementsByName("positionCheckbox");
            checkboxes.forEach(function (currentCheckbox) {
                if (currentCheckbox !== checkbox) {
                    currentCheckbox.checked = false;
                }
            });
        }
    </script>
</head>
<body>
    <h1>Employee List</h1>
    <jsp:useBean id="E" class="pharmacysystem.employees" scope="page" />
    <form action="employee_list_all.jsp" method="post">
        <h2>Filter by Position:</h2>
        <% 
            E.getPositions();
            for (String position : E.positionList) {
        %>
            <label class="filter-checkbox">
                <input type="checkbox" name="positionCheckbox" value="<%= position %>" onchange="updateCheckbox(this)">
                <%= position %>
            </label>
        <% } %>
        <input type="submit" value="Apply Filter">
    </form>

    
    <% 
        // Check if form is submitted with positions selected
        String selectedPosition = "none";
        if (request.getMethod().equalsIgnoreCase("post")) {
            selectedPosition = request.getParameter("positionCheckbox");
            if (selectedPosition != null && !selectedPosition.isEmpty()) {
                E.filterEmployeeByPosition(selectedPosition);
            } else {
                E.getAllEmployees();
            }
        } else {
            E.getAllEmployees();
        }
        

    %>

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
