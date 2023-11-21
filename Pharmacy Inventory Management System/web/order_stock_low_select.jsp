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
        <h1>Order Medicine (View By Supplier)</h1>
        <jsp:useBean id="G" class="pharmacysystem.medicines" scope="session" />
        <%
            G.get_low_meds();
            for (int i = 0; i < G.medicineIDList.size(); i++) {
                G.get_info_for_order(G.medicineIDList.get(i));
        %>
                <div class="medicine-info">
                    Medicine ID: <%=G.medicineID%><br>
                    Brand Name: <%=G.brand_name%><br>
                    Generic Name: <%=G.generic_name%><br>
                    Stock: <%=G.stock%><br>
                    Supplier ID: <%=G.supplier_id%><br>
                    Supplier Name: <%=G.supplier_name%><br>
                    Unit Price: <%=G.sellingPrice%><br>
                </div>
        <%
            }
        %>

        <!-- Prompt the user to enter the med_id of the medicine they want to buy and the quantity -->
        <form action="order_stock_processing.jsp">
            <label for="medID_to_order">Enter ID of medicine to order:</label>
            <input type="text" id="medID_to_order" name="medID_to_order" required><br>

            <label for="quantity_to_order">Enter Quantity:</label>
            <input type="number" id="quantity_to_order" name="quantity_to_order" placeholder="0" step="1" min="1" max="9999999" required /><br>

            <label for="date_of_order">Enter Date Of Order:</label>
            <input type="date" id="date_of_order" name="date_of_order" required /><br>
            
            <label for="expiration_date">Enter Expiration Date:</label>
            <input type="date" id="expiration_date" name="expiration_date" required /><br>
            
            <label for="price_of_supplier">Enter Unit Price:</label>
            <input type="number" id="price_of_supplier" name="price_of_supplier" placeholder="0" step="1" min="1" max="9999999" required /><br>
            
            <label for="supplier_id">Enter Supplier Id:</label>
            <input type="number" id="supplier_id" name="supplier_id" placeholder="0" step="1" min="1" max="9999999" required /><br>
            
            <input type="submit" value="Submit"><br>
        </form>
        
    </body>
</html>
