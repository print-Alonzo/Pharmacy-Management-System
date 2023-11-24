<%-- 
    Document   : employee_add
    Created on : 11 25, 23, 4:12:23 AM
    Author     : ccslearner
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, pharmacysystem.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Add Employee</title>
    <style>
        <!-- Your existing styles remain unchanged -->

        /* Add new style for textboxes and dropdown */
        .input-box {
            margin-bottom: 10px;
        }

        .dropdown {
            width: 200px;
        }
    </style>
</head>
<body>
    <h1>Add Employee</h1>

    <form action="employee_add.jsp" method="post">
        <div class="input-box">
            <label>First Name:</label>
            <input type="text" name="firstName" required>
        </div>

        <div class="input-box">
            <label>Last Name:</label>
            <input type="text" name="lastName" required>
        </div>

        <div class="input-box">
            <label>Contact Number:</label>
            <input type="text" name="contactNumber" required>
        </div>

        <div class="input-box">
            <label>Password:</label>
            <input type="password" name="password" required>
        </div>

        <div class="input-box">
            <label>Address:</label>
            <input type="text" name="address" required>
        </div>

        <div class="input-box">
            <label>Position:</label>
            <select name="position" class="dropdown">
                <jsp:useBean id="E" class="pharmacysystem.employees" scope="page" />
                <% E.getALLPositions(); %>
                <% for (String pos : E.positionList) { %>
                    <option value="<%= pos %>"><%= pos %></option>
                <% } %>
            </select>
        </div>

        <input type="submit" value="Add Employee">
    </form>
    <% 
        // Check if form is submitted with data
        if (request.getMethod().equalsIgnoreCase("post")) {
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String contactNumber = request.getParameter("contactNumber");
            String password = request.getParameter("password");
            String address = request.getParameter("address");
            String position = request.getParameter("position");

            // Format first and last names to title case
            firstName =firstName.toLowerCase();
            firstName= firstName.substring(0, 1).toUpperCase() + firstName.substring(1);
            
            lastName = lastName.toLowerCase();
            lastName = lastName.substring(0, 1).toUpperCase() + lastName.substring(1);
            

            // Set values in the employees bean
            E.position = position;
            E.first_name = firstName;
            E.last_name = lastName;
            E.contact_no = Long.parseLong(contactNumber);
            E.password = password;
            E.address = address;

            // Add the employee to the database
            //E.addEmployee();
        }
    %>

    <div>
        <% 
            // Display a success message if the employee was added
            if (request.getMethod().equalsIgnoreCase("post") && E.addEmployee() == 1) {
        %>
            <p>Employee added successfully!</p>
        <% } %>
    </div>
</body>
</html>