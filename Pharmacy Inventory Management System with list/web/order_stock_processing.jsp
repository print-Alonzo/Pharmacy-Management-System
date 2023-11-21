<%-- 
    Document   : buy_prescription_processing
    Created on : 11 21, 23, 12:30:47 AM
    Author     : ccslearner
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, pharmacysystem.*" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <jsp:useBean id="M" class="pharmacysystem.medicines" scope="session" />
        <jsp:useBean id="N" class="pharmacysystem.orders" scope="session" />
        <jsp:useBean id="O" class="pharmacysystem.suppliers" scope="session" />
<%
        int med_id = Integer.parseInt(request.getParameter("medID_to_order"));
        int quantity = Integer.parseInt(request.getParameter("quantity_to_order"));
        String order_date = request.getParameter("date_of_order");
        String expiration_date = request.getParameter("expiration_date");
        Double price_of_supplier = Double.parseDouble(request.getParameter("price_of_supplier"));
        int supplier_id = Integer.parseInt(request.getParameter("supplier_id"));
        
        if (M.check_if_medID_exists(med_id) == 1 && O.check_if_supplierID_exists(supplier_id) == 1) {
            N.supplierID = supplier_id;
            N.date_ordered = order_date;
            N.medicine_id = med_id;
            N.quantity = quantity;
            N.priceSold = price_of_supplier;
            N.addOrder();
%>
            <h3>Order Complete</h3><br>
            Supplier ID: <%=supplier_id%><br>
            Date of Order: <%=order_date%><br>
            Product Expiry Date: <%=N.date_expired%><br>
            Medicine ID: <%=med_id%><br>
            Quantity: <%=quantity%><br>
            Order Status: Ordered<br>
            Unit Price of Ordered Product: <%=price_of_supplier%><br>
<%
        } else if (M.check_if_medID_exists(med_id) == 0) {
%>
                <h3>Purchase Failed. Medicine ID does not exist.</h3>
<%
        } else {
%>
                <h3>Purchase Failed. Supplier ID does not exist.</h3>
<%
        } 
%>
    </body>
</html>
