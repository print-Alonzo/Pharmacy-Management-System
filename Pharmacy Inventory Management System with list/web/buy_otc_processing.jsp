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
        <jsp:useBean id="J" class="pharmacysystem.transactions" scope="session" />
        <jsp:useBean id="K" class="pharmacysystem.medicines" scope="session" />
<%
        int med_id = Integer.parseInt(request.getParameter("medID_to_buy"));
        int quantity = Integer.parseInt(request.getParameter("quantity_to_buy"));
        int cashier_id = Integer.parseInt(request.getParameter("cashier_id"));
        int pharmacist_id = -1;
        String date_sold = request.getParameter("date_sold");
        
        if (K.check_if_medID_exists(med_id) == 1) {
            if (J.checkStock(med_id) >= quantity) {
                J.cashierID = cashier_id;
                J.pharmacistID = pharmacist_id;
                J.transactionDate = date_sold;
                J.addTransaction(Integer.parseInt(request.getParameter("quantity_to_buy")), med_id);
%>
                <h3>Purchase Complete</h3><br>
                Medicine ID: <%=med_id%><br>
                Quantity: <%=quantity%><br>
                Cashier ID: <%=cashier_id%><br>
                Date Sold: <%=date_sold%><br>
<%
            } else {
%>
                <h3>Purchase Failed. There is not enough stock for the purchase. Restock is needed.</h3>              
<%
            }
        } else {
%>
                <h3>Purchase Fail. Medicine ID does not exist.</h3>
<%
        }
%>
    </body>
</html>
