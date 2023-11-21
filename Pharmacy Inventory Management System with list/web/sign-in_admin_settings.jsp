<%-- 
    Document   : sign-in_admin_settings
    Created on : 11 19, 23, 11:06:54 PM
    Author     : ccslearner
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, pharmacysystem.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Admin Settings</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            text-align: center;
        }

        h1 {
            color: #333;
        }

        a {
            text-decoration: none;
            color: #007bff;
            font-weight: bold;
            font-size: 18px;
            margin: 10px;
            display: inline-block;
            padding: 10px;
            border: 2px solid #007bff;
            border-radius: 5px;
            transition: background-color 0.3s, color 0.3s;
        }

        a:hover {
            background-color: #007bff;
            color: #fff;
        }
    </style>
</head>
<body>

<!-- Admin Settings -->
<h1>Admin Settings</h1>
<jsp:useBean id="B" class="pharmacysystem.employees" scope="session" />
<%
    int entered_id_no = Integer.parseInt(request.getParameter("id_no"));
    String entered_password = request.getParameter("password");
    if (B.check_password(entered_id_no, entered_password) != 1) {
%>
        <p>Incorrect Account Information Entered</p>
<%
    } else {
%>       
        <a href="order_stock_search.html">Order from Supplier</a><br>
        <a href="update_order_status.jsp">Update Order Status</a><br>
        <a href="employee_list.jsp">Employee List</a><br>
        <a href="supplier_list.jsp">Supplier List</a><br>
        <a href="monthly_sales_expenses_report.jsp">Generate Monthly Sales and Expenses Report</a><br>
        <a href="yearly_sales_expenses_report.jsp">Generate Yearly Monthly Sales and Expenses Report</a><br>
        <a href="monthly_stock_report.jsp">Generate Monthly Stock Report By Medicine</a><br>
<%
    }
%>

</body>
</html>

t By Medicine</a><br>
<%
    }
%>

</body>
</html>

