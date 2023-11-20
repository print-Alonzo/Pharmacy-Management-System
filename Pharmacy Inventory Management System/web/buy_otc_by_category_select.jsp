<%-- 
    Document   : buy_otc_by_category_processing
    Created on : 11 18, 23, 2:54:19 PM
    Author     : ccslearner
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Select OTC Medicine By Category</title>
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
        input[type="number"] {
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

<!-- Display Info of Over-the-counter Medicines by Category -->
<h1>Available Over-the-counter <%= request.getParameter("category") %> Medicines</h1>
<jsp:useBean id="A" class="pharmacysystem.medicines" scope="session" />
<%
    String searched_category = request.getParameter("category");
    A.get_meds_with_category(searched_category);
    if (A.medicineIDList.size() > 0) {
        for (int i = 0; i < A.medicineIDList.size(); i++) {
            A.get_info(A.medicineIDList.get(i));
%>
            <div class="medicine-info">
                Medicine ID: <%= A.medicineID %><br>
                Brand Name: <%= A.brand_name %><br>
                Generic Name: <%= A.generic_name %><br>
                Volume (in ml): <%= A.volume_ml %><br>
                Dosage (in mg): <%= A.dosage_mg %><br>
                Category: <%= A.category %><br>
                Price: <%= A.sellingPrice %><br>
                Description: <%= A.description %><br>
            </div>

<%      }
%>

        <form action="buy_otc_processing.jsp">
            <label for="medID_to_buy">Enter ID of medicine to buy:</label>
            <input type="text" id="medID_to_buy" name="medID_to_buy" required><br>

            <label for="quantity_to_buy">Enter Quantity:</label>
            <input type="number" id="quantity_to_buy" name="quantity_to_buy" placeholder="0" step="1" max="9999999" required /><br>

            <label for="cashier_id">Enter Cashier ID:</label>
            <input type="text" id="cashier_id" name="cashier_id" required><br>

            <input type="submit" value="Submit">
        </form>

<%  } else {
%>
        <h3>No medicine found in the specified category</h3><br><br>
<%  }
%>    


</body>
</html>

