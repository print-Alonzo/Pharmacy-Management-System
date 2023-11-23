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
    <title>Select OTC Medicine By Symptom</title>
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

<!-- Display Info of Over-the-counter Medicines by Category -->
<h1>Available Over-the-counter <%= request.getParameter("symptom") %> Medicines</h1>
<jsp:useBean id="S" class="pharmacysystem.symptoms" scope="session" />
<jsp:useBean id="T" class="pharmacysystem.medicines" scope="session" />
<%
    String searched_symptom = request.getParameter("symptom");
    S.get_meds_from_symptom(searched_symptom);
    if (S.med_idList.size() > 0) {
        for (int i = 0; i < S.med_idList.size(); i++) {
            T.get_info(S.med_idList.get(i));
%>
            <div class="medicine-info">
                Medicine ID: <%= T.medicineID %><br>
                Brand Name: <%= T.brand_name %><br>
                Generic Name: <%= T.generic_name %><br>
                Volume (in ml): <%= T.volume_ml %><br>
                Dosage (in mg): <%= T.dosage_mg %><br>
                Category: <%= T.category %><br>
                Price: <%= T.sellingPrice %><br>
                Description: <%= T.description %><br>
                Symptom: <%= S.symptom_nameList.get(i) %><br>
                Relation Description: <%= S.relation_descriptionList.get(i) %><br>
            </div>

<%      }
%>

        <form action="buy_otc_processing.jsp">
            <label for="medID_to_buy">Enter ID of medicine to buy:</label>
            <input type="text" id="medID_to_buy" name="medID_to_buy" required><br>

            <label for="quantity_to_buy">Enter Quantity:</label>
            <input type="number" id="quantity_to_buy" name="quantity_to_buy" placeholder="0" step="1" min="1" max="9999999" required /><br>

            <label for="cashier_id">Enter Cashier ID:</label>
            <input type="text" id="cashier_id" name="cashier_id" required><br>

            <label for="date_sold">Enter Date:</label>
            <input type="date" id="date_sold" name="date_sold" required /><br>

            <input type="submit" value="Submit"><br>
        </form>

<%  } else {
%>
        <h3>No medicine found in the specified symptom</h3><br><br>
<%  }
%>    


</body>
</html>

