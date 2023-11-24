<%-- 
    Document   : employee_search
    Created on : 11 25, 23, 3:14:23 AM
    Author     : ccslearner
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, pharmacysystem.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Employee Search</title>
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
        .search-textbox {
            margin-right: 10px;
        }
    </style>
</head>
<body>
    <h1>Employee Search</h1>

    <form action="employee_search.jsp" method="post">
        <h2>Search by Name:</h2>
        <label>First Name:</label>
        <input type="text" name="firstName" class="search-textbox" required>
        <label>Last Name:</label>
        <input type="text" name="lastName" class="search-textbox" required>
        <input type="submit" value="Search">
    </form>

    <jsp:useBean id="E" class="pharmacysystem.employees" scope="page" />
    <% 
        // Check if form is submitted with names entered
        if (request.getMethod().equalsIgnoreCase("post")) {
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            if (firstName != null && lastName != null && !firstName.isEmpty() && !lastName.isEmpty()) {
                E.searchEmployee(firstName, lastName);
            } else {
                // Handle the case when either first name or last name is not entered
                E.first_name = "Please enter both first and last names.";
            }
        }
    %>

    <div>
        <% 
            // Display the search result or a message if no employees found
            if ("no employees found".equalsIgnoreCase(E.first_name) || E.employee_id == 0) {
        %>
        
            <p>No employees found.</p>
            
        <% } else { %>
        <p> Employee ID: <%=E.employee_id%> </p>
        <p> Name: <%=E.first_name%> <%=E.last_name%> </p>
        <p> Position: <%=E.position%></p>
        <p> Salary: <%=E.salary%></p>
        <p> Address: <%=E.address%></p>
        <p> Contact Number: <%=E.contact_no%> </p>
        <% } %>
    </div>
</body>
</html>
