<%-- 
    Document   : employee_delete_confirm.jsp
    Created on : 11 25, 23, 6:58:32 AM
    Author     : ccslearner
--%>

<!DOCTYPE html>
<%@ page import="pharmacysystem.employees" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<jsp:useBean id="E" class="pharmacysystem.employees" scope="page" />

<%
    // Assuming you have received the ID from a form submission
    String idString = request.getParameter("id");
    
    if (idString != null && !idString.isEmpty()) {
        int id = Integer.parseInt(idString);

        // Delete the employee
        int deleteResult = E.deleteEmployee(id);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delete Employee Confirmation</title>
</head>
<body>

    <h1>Delete Employee Confirmation</h1>

    <% if (deleteResult == 1) { %>
        <p>Employee with ID <%= id %> has been successfully deleted.</p>
    <% } else if (deleteResult == 5) { %>
        <p>No employee found with ID <%= id %>.</p>
    <% } else { %>
        <p>Failed to delete employee with ID <%= id %>. Please try again.</p>
    <% } %>

</body>
</html>
<%
    }
%>

