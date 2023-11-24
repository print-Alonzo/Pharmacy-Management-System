<%-- 
    Document   : employee_delete_input
    Created on : 11 25, 23, 6:57:19 AM
    Author     : ccslearner
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ page import="pharmacysystem.employees" %>
<jsp:useBean id="E" class="pharmacysystem.employees" scope="page" />

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delete Employee</title>
</head>
<body>

    <h1>Delete Employee</h1>

    <form action="employee_delete.jsp" method="post">
        <label for="id">Enter Employee ID to Delete:</label>
        <input type="text" id="id" name="id" required>

        <input type="submit" value="Submit">
    </form>

        <% String idString = request.getParameter("id");
       if (idString != null && !idString.isEmpty()) {
           int id = Integer.parseInt(idString);

           // Get employee information before deletion
           E.get_info(id);

           // Display employee information if ID is valid
           if (E.employee_id != 0) {
    %>
               <h2>Employee Information:</h2>
               <p>Employee ID: <%= E.employee_id %></p>
               <p>Position: <%= E.position %></p>
               <p>First Name: <%= E.first_name %></p>
               <p>Last Name: <%= E.last_name %></p>
               <p>Contact Number: <%= E.contact_no %></p>
               <p>Address: <%= E.address %></p>
               <p>Salary: <%= E.salary %></p>

               <form action="employee_delete_confirm.jsp" method="post">
                   <input type="hidden" name="id" value="<%= E.employee_id %>">
                   <input type="submit" value="Confirm Delete">
               </form>
    <%      } else {
               // Display a message if no employee is found with the provided ID
    %>
               <p>No employee found with ID <%= id %>.</p>
    <%
           }
       }
    %>

</body>
</html>
