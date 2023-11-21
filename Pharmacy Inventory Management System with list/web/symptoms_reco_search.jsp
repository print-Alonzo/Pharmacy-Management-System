<%-- 
    Document   : buy_otc_by_category
    Created on : 11 18, 23, 2:48:44 PM
    Author     : ccslearner
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, pharmacysystem.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Search Medicine By Symptom</title>
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

        form {
            margin-top: 20px;
            max-width: 400px;
            margin-left: auto;
            margin-right: auto;
            text-align: left;
        }

        label {
            display: block;
            margin-bottom: 10px;
            color: #007bff;
        }

        select {
            width: 100%;
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

<!-- Search Medicine By Category Form -->
<h1>Search Medicine By Symptom</h1>
<jsp:useBean id="R" class="pharmacysystem.symptoms" scope="session" />
<% R.get_all_symptom_names(); %>

<form action="symptoms_reco_select.jsp">
    <label for="symptom">Symptom:</label>
    <select id="symptom" name="symptom" value="Select Symptom">
        <% for (int i = 0; i < R.symptom_nameList.size(); i++) { %>
            <option><%= R.symptom_nameList.get(i) %></option>
        <% } %>
    </select><br>

    <input type="submit" value="Submit">
</form>

</body>
</html>

