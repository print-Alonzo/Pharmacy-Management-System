<%-- 
    Document   : order_list
    Created on : [Current Date], [Current Time]
    Author     : [Your Name]
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, pharmacysystem.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Order List</title>
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
    <h1>Order List</h1>
    <jsp:useBean id="orderBean" class="pharmacysystem.orders" scope="page" />
    <%
        orderBean.getAllOrders(); // Assuming this method populates order details
    %>
    <table>
        <thead>
            <tr>
                <th>Order ID</th>
                <th>Customer Name</th>
                <th>Date</th>
                <th>Total Amount</th>
                <th>Status</th>
                <!-- Additional headers if needed -->
            </tr>
        </thead>
        <tbody>
            <% 
                for(int i = 0; i < orderBean.orderIdList.size(); i++){ 
            %>
                <tr>
                    <td><%= orderBean.orderIdList.get(i) %></td>
                    <td><%= orderBean.customerNameList.get(i) %></td>
                    <td><%= orderBean.dateList.get(i) %></td>
                    <td><%= orderBean.totalAmountList.get(i) %></td>
                    <td><%= orderBean.statusList.get(i) %></td>
                    <!-- Additional data fields if needed -->
                </tr>
            <% 
                } 
            %>
        </tbody>
    </table>
</body>
</html>
