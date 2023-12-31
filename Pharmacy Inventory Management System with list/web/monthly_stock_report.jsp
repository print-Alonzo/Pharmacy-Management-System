<%-- 
    Document   : monthly_stock_report
    Created on : 11 21, 23, 5:12:01 PM
    Author     : ccslearner
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, pharmacysystem.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Monthly Stock Report</title>
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
</head>
<body>
    <h1>Monthly Stock Report</h1>
    <jsp:useBean id="Z" class="pharmacysystem.stockreport" scope="session" />
    <%
        Z.generateStockReport();
    %>

    <div>
        <h2>Stocks Received:</h2>
        <table border="1">
            <thead>
                <tr>
                    <th>Year</th>
                    <th>Month</th>
                    <th>Medicine ID</th>
                    <th>Brand Name</th>
                    <th>Amount Received</th>
                </tr>
            </thead>
            <tbody>
                <% for(int i = 0; i < Z.medicineIDList1.size(); i++){ %>
                    <tr>
                        <td><%= Z.yearList1.get(i)%></td>
                        <td><%= Z.monthList1.get(i)%></td>
                        <td><%= Z.medicineIDList1.get(i)%></td>
                        <td><%= Z.brandNameList1.get(i)%></td>
                        <td><%= Z.received1.get(i)%></td>
                    </tr>
                <% System.out.println(i);} %>
            </tbody>
        </table>
    </div>

    <div>
        <h2>Stocks Sold:</h2>
        <table border="1">
            <thead>
                <tr>
                    <th>Year</th>
                    <th>Month</th>
                    <th>Medicine ID</th>
                    <th>Brand Name</th>
                    <th>Stocks Sold</th>
                </tr>
            </thead>
            <tbody>
                <% for(int i = 0; i < Z.medicineIDList3.size(); i++){ %>
                    <tr>
                        <td><%= Z.yearList3.get(i)%></td>
                        <td><%= Z.monthList3.get(i)%></td>
                        <td><%= Z.medicineIDList3.get(i)%></td>
                        <td><%= Z.brandNameList3.get(i)%></td>
                        <td><%= Z.sold3.get(i)%></td>
                    </tr>
                <% System.out.println(i);} %>
            </tbody>
        </table>
    </div>
    
    <div>
        <h2>Stock Expiry Dates:</h2>
        <table border="1">
            <thead>
                <tr>
                    <th>Year</th>
                    <th>Month</th>
                    <th>Medicine ID</th>
                    <th>Brand Name</th>
                    <th>Stocks to Expire</th>
                </tr>
            </thead>
            <tbody>
                <% for(int i = 0; i < Z.medicineIDList2.size(); i++){ %>
                    <tr>
                        <td><%= Z.yearList2.get(i)%></td>
                        <td><%= Z.monthList2.get(i)%></td>
                        <td><%= Z.medicineIDList2.get(i)%></td>
                        <td><%= Z.brandNameList2.get(i)%></td>
                        <td><%= Z.expired2.get(i)%></td>
                    </tr>
                <% System.out.println(i);} %>
            </tbody>
        </table>
    </div>
</body>
</html>
