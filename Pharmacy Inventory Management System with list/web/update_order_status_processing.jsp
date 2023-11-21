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
        <jsp:useBean id="R" class="pharmacysystem.orders" scope="session" />
<%
        int order_id = Integer.parseInt(request.getParameter("order_received"));
        
        if (R.check_if_orderID_exists(order_id) == 1) {
            R.setOrderToReceived(order_id);
%>
            <h3>Order Received</h3><br>
<%
        } else {
%>
            <h3>Order not received. Order ID does not exist.</h3>
<%
        } 
%>
    </body>
</html>
