<%-- 
    Document   : order_stock
    Created on : 11 20, 23, 3:32:48 AM
    Author     : ccslearner
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, pharmacysystem.*" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
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

            .order-info {
                margin: 20px 0;
                padding: 10px;
                border: 2px solid #007bff;
                border-radius: 10px;
                text-align: left;
            }

            form {
                margin-top: 20px;
                text-align: left;
            }

            label {
                display: block;
                margin-bottom: 10px;
                color: #007bff;
            }

            input[type="text"],
            input[type="number"],
            input[type="date"]{
                width: 50%;
                padding: 10px;
                margin-bottom: 15px;
                box-sizing: border-box;
            }

            input[type="submit"] {
                background-color: #007bff;
                color: #fff;
                padding: 10px 20px;
                font-size: 16px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                transition: background-color 0.3s, color 0.3s;
            }

            input[type="submit"]:hover {
                background-color: #0056b3;
            }
        </style>
    </head>
    <body>
        <h1>Update Order Status</h1>
        <jsp:useBean id="Q" class="pharmacysystem.orders" scope="session" />
        <%
            Q.get_sent_orders();
            for (int i = 0; i < Q.orderIDList.size(); i++) {
                Q.get_order_info(Q.orderIDList.get(i));
        %>
                <div class="order-info">
                    Order ID: <%=Q.orderID%><br>
                    Supplier ID: <%=Q.supplierID%><br>
                    Date Ordered: <%=Q.date_ordered%><br>
                    Expiry Date: <%=Q.date_expired%><br>
                    Medicine ID: <%=Q.medicine_id%><br>
                    Quantity: <%=Q.quantity%><br>
                    Order Status: <%=Q.order_status%><br>
                    Supplier Unit Price: <%=Q.priceSold%><br>
                </div>
        <%
            }
        %> 

        <!-- Prompt the user to enter the med_id of the medicine they want to buy and the quantity -->
        <form action="update_order_status_processing.jsp">
            <label for="order_received">Enter ID of medicine to order:</label>
            <input type="text" id="order_received" name="order_received" required><br>
            
            <input type="submit" value="Submit"><br>
        </form>
        
    </body>
</html>
