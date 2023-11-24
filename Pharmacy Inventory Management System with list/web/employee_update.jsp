<%-- 
    Document   : employee_update
    Created on : 11 25, 23, 5:26:08 AM
    Author     : ccslearner
--%>

<%@ page import="pharmacysystem.employees, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<jsp:useBean id="E" class="pharmacysystem.employees" scope="page" />

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Employee</title>
    
</head>
<body>

    <h1>Update Employee</h1>

    <form action="employee_update.jsp" method="post">
        <label for="id">Employee ID:</label>
        <input type="text" id="id" name="id" required>

        <label for="column">Select Field to Update:</label>
        <select id="column" name="column" required>
            <option value="position_name">Position</option>
            <option value="first_name"> First Name </option>
            <option value="last_name"> Last Name </option>
            <option value="contact_no"> Contact Number </option>
            <option value="pw"> Password </option>
            <option value="address"> Address </option>
           

        <label for="value">New Value:</label>
        <input type="text" id="value" name="value" required>

        <input type="submit" value="Update Employee">
    </form>
        
    <%
    // Assuming you have received these parameters from a form submission
    int updateResult = 0;
    if (request.getParameter("id") != null && request.getParameter("column") != null && request.getParameter("value") != null){
        int id = Integer.parseInt(request.getParameter("id"));
        String column = request.getParameter("column");
        String value = request.getParameter("value");
        updateResult = E.updateEmployee(id, column, value);
    }
    // Update the employee
    
    %>
    <% if (updateResult == 1) { %>
        <p>Employee updated successfully!</p>
       
    <% } else { %>
        <p>Failed to update employee. Please try again.</p>
    <% } %>

</body>
</html>