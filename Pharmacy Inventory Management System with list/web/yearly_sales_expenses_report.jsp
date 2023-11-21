<%-- 
    Document   : sales_expenses_report
    Created on : 11 22, 23, 2:29:48 AM
    Author     : ccslearner
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, pharmacysystem.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Sales and Expenses Report</title>
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
            width: 90%;
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
    <h1>Yearly Sales and Expenses Report</h1>
    <jsp:useBean id="report" class="pharmacysystem.sales" scope="page" />
    <% report.getAllSalesYearly(); %>
    <table border="1">
        <thead>
            <tr>
                <th>Year</th>
                <th>Total Sales</th>
                <th>Total Salary</th>
                <th>Total Costs</th>
                <th>Total Profits</th>
            </tr>
        </thead>
        <tbody>
            <% for(int i = 0; i < report.report_yearList.size(); i++){ %>
                <tr>
                    <td><%= report.report_yearList.get(i) %></td>
                    <td><%= report.total_salesList.get(i) %></td>
                    <td><%= report.total_salaryList.get(i) %></td>
                    <td><%= report.total_costsList.get(i) %></td>
                    <td><%= report.total_profitsList.get(i) %></td>
                </tr>
            <%} %>
        </tbody>
    </table>
</body>
</html>