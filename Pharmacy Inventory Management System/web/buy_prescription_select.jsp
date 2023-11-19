
<%-- 
    Document   : buy_prescription_processing
    Created on : 11 18, 23, 2:12:42 PM
    Author     : ccslearner
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, pharmacysystem.*" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Select Prescription Medicine</title>
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
        input[type="password"]{
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

<!-- Display Info of Medicine/s with either the brand name or generic name -->
<h1>Available Prescription Medicines</h1>
<jsp:useBean id="A" class="pharmacysystem.medicines" scope="session" />
<%
    String searched_name = request.getParameter("name");
    A.get_meds_with_name(searched_name, 1);
    for (int i = 0; i < A.medicineIDList.size(); i++) {
        A.get_info(A.medicineIDList.get(i));
%>
        <div class="medicine-info">
            Medicine ID: <%=A.medicineID%><br>
            Brand Name: <%=A.brand_name%><br>
            Generic Name: <%=A.generic_name%><br>
            Volume (in ml): <%=A.volume_ml%><br>
            Dosage (in mg): <%=A.dosage_mg%><br>
            Category: <%=A.category%><br>
            Price: <%=A.sellingPrice%><br>
            Description: <%=A.description%><br>
            Dosage Instructions: <%=A.dosage_instructions%><br>
            Date Added: <%=A.date_added%><br>
        </div>
<%
    }
%>

<!-- Prompt the user to enter the med_id of the medicine they want to buy and the quantity -->
<form action="buy_prescription_processing.jsp">
    <label for="medID_to_buy">Enter ID of medicine to buy:</label>
    <input type="text" id="medID_to_buy" name="medID_to_buy" required><br>

    <label for="quantity_to_buy">Enter Quantity:</label>
    <input type="number" id="quantity_to_buy" name="quantity_to_buy" placeholder="0" step="1" max="9999999" required /><br>

    <label for="cashier_id">Enter Cashier ID:</label>
    <input type="text" id="cashier_id" name="cashier_id" required><br>

    <label for="pharmacist_id">Enter Pharmacist ID:</label>
    <input type="text" id="pharmacist_id" name="pharmacist_id" required><br>

    <label for="pharmacist_password">Enter Password of Pharmacist:</label>
    <input type="password" id="pharmacist_password" name="pharmacist_password" required><br>

    <input type="submit" value="Submit"><br>
</form>

</body>
</html>

