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
        <jsp:useBean id="G" class="pharmacysystem.employees" scope="session" />
        <jsp:useBean id="H" class="pharmacysystem.transactions" scope="session" />
        <jsp:useBean id="I" class="pharmacysystem.medicines" scope="session" />
<%
        int med_id = Integer.parseInt(request.getParameter("medID_to_buy"));
        int quantity = Integer.parseInt(request.getParameter("quantity_to_buy"));
        int cashier_id = Integer.parseInt(request.getParameter("cashier_id"));
        int pharmacist_id = Integer.parseInt(request.getParameter("pharmacist_id"));
        String pharmacist_password = request.getParameter("pharmacist_password");
        String date_sold = request.getParameter("date_sold");
        
        if (I.check_if_medID_exists(med_id) == 1) {
            if (G.check_password(pharmacist_id, pharmacist_password) == 1 && H.checkStock(med_id) >= quantity) {
                H.cashierID = cashier_id;
                H.pharmacistID = pharmacist_id;
                H.transactionDate = date_sold;
                H.addTransaction(Integer.parseInt(request.getParameter("quantity_to_buy")), med_id);
%>
                <h3>Purchase Complete</h3><br>
                Medicine ID: <%=med_id%><br>
                Quantity: <%=quantity%><br>
                Cashier ID: <%=cashier_id%><br>
                Pharmacist ID: <%=pharmacist_id%><br>
                Date Sold: <%=date_sold%><br>
<%
            } else if (H.checkStock(med_id) < quantity){
%>
                <h3>Purchase Failed. There is not enough stock for the purchase. Restock is needed.</h3>
<%
            } else {
%>
                <h3>Purchase Fail. Check Pharmacist Details.</h3>
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
