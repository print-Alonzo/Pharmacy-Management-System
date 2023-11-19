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

            .medicine-info {
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
        <h1>Order Medicine (View All)</h1>
        <jsp:useBean id="B" class="pharmacysystem.medicines" scope="session" />
        <%
            B.get_all_meds();
            for (int i = 0; i < B.medicineIDList.size(); i++) {
                B.get_info_for_order(B.medicineIDList.get(i));
        %>
                <div class="medicine-info">
                    Medicine ID: <%=B.medicineID%><br>
                    Brand Name: <%=B.brand_name%><br>
                    Generic Name: <%=B.generic_name%><br>
                    Stock: <%=B.stock%><br>
                    Supplier Name: <%=B.supplier_name%><br>
                    Unit Price: <%=B.supplier_name%><br>
                </div>
        <%
            }
        %>

        <!-- Prompt the user to enter the med_id of the medicine they want to buy and the quantity -->
        <form action="order_stock_processing.jsp">
            <label for="medID_to_order">Enter ID of medicine to order:</label>
            <input type="text" id="medID_to_order" name="medID_to_order" required><br>

            <label for="quantity_to_order">Enter Quantity:</label>
            <input type="number" id="quantity_to_order" name="quantity_to_order" placeholder="0" step="1" max="9999999" required /><br>

            <label for="date_of_order">Enter Date:</label>
            <input type="date" id="date_of_order" name="date_of_order" required /><br>

            <input type="submit" value="Submit"><br>
        </form>
        
    </body>
</html>
