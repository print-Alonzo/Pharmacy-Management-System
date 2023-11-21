package pharmacysystem;

import java.sql.*;
import java.util.ArrayList;


public class stockreport {
    //received table
    public ArrayList<Integer> medicineIDList1 = new ArrayList<>();
    public ArrayList<String> brandNameList1 = new ArrayList<>();
    public ArrayList<Integer> yearList1 = new ArrayList<>();
    public ArrayList<Integer> monthList1 = new ArrayList<>();
    public ArrayList<Integer> received1 = new ArrayList<>();
    
    //expiring table
    public ArrayList<Integer> medicineIDList2 = new ArrayList<>();
    public ArrayList<String> brandNameList2 = new ArrayList<>();
    public ArrayList<Integer> yearList2 = new ArrayList<>();
    public ArrayList<Integer> monthList2 = new ArrayList<>();
    public ArrayList<Integer> expired2 = new ArrayList<>();

    //sold table
    public ArrayList<Integer> medicineIDList3 = new ArrayList<>();
    public ArrayList<String> brandNameList3 = new ArrayList<>();
    public ArrayList<Integer> yearList3 = new ArrayList<>();
    public ArrayList<Integer> monthList3 = new ArrayList<>();
    public ArrayList<Integer> sold3 = new ArrayList<>();

    public int generateStockReport(){
        try{
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharmacy_db?allowPublicKeyRetrieval=true&useTimezone=true&serverTimezone=UTC&user=root&password=12345678&useSSL=false");
            String query1 = "SELECT i.medicine_id, i.brand_name, YEAR(s.dateReceived) AS 'year_report', MONTH(s.dateReceived) AS 'month_report', COUNT(s.stock_id) AS 'Amount Received' \n" +
                            "FROM medicine_stock s LEFT JOIN medicine_info i \n" + 
                                                "ON i.medicine_id = s.medicine_id \n" + 
                            "GROUP BY i.medicine_id, year_report, month_report \n" +
                            "ORDER BY year_report, month_report" ;
            PreparedStatement ps1 = conn.prepareStatement(query1);
            ResultSet rs1 = ps1.executeQuery();
            while(rs1.next()){
                // Extract data from the result set
                int medicineID = rs1.getInt("medicine_id");
                String brandName = rs1.getString("brand_name");
                int yearReport = rs1.getInt("year_report");
                int monthReport = rs1.getInt("month_report");
                int amountReceived = rs1.getInt("Amount Received");
                
                // Populate the ArrayLists
                medicineIDList1.add(medicineID);
                brandNameList1.add(brandName); // Add your brand name here
                yearList1.add(yearReport);
                monthList1.add(monthReport);
                received1.add(amountReceived);
            }
            ps1.close();
            
            
            String query2 = "SELECT i.medicine_id, i.brand_name, YEAR(t.transactionDate) AS 'year_report', MONTH(t.transactionDate) AS 'month_report', COUNT(s.stock_id) AS 'Amount Sold'\n" +
                            "FROM transactions t LEFT JOIN medicine_stock s\n" +
                            "                      ON s.transactionID = t.transactionID\n" +
                            "                      LEFT JOIN medicine_info i\n" +
                            "                      ON s.medicine_id = i.medicine_id\n" +
                            "GROUP BY i.medicine_id, year_report, month_report\n" +
                            "ORDER BY year_report, month_report";
            PreparedStatement ps2 = conn.prepareStatement(query2);
            ResultSet rs2 = ps2.executeQuery();
            while(rs2.next()){
                                // Extract data from the result set
                int medicineID = rs2.getInt("medicine_id");
                String brandName = rs2.getString("brand_name");
                int yearReport = rs2.getInt("year_report");
                int monthReport = rs2.getInt("month_report");
                int amountReceived = rs2.getInt("Amount Sold");
                
                // Populate the ArrayLists
                medicineIDList3.add(medicineID);
                brandNameList3.add(brandName); 
                yearList3.add(yearReport);
                monthList3.add(monthReport);
                sold3.add(amountReceived);
            }
            ps2.close();
            
            String query3 = "SELECT s.medicine_id, i.brand_name, YEAR(s.dateExpire) AS 'year_report', MONTH(s.dateExpire) AS 'month_report', COUNT(s.stock_id) AS 'Amount Expiring'\n" +
                            "FROM medicine_stock s LEFT JOIN medicine_info i\n" +
                            "					  ON s.medicine_id = i.medicine_id\n" +
                            "WHERE s.transactionID IS NULL\n" +
                            "GROUP BY s.medicine_id, year_report, month_report\n" +
                            "ORDER BY year_report, month_report";
            PreparedStatement ps3 = conn.prepareStatement(query3);
            ResultSet rs3 = ps3.executeQuery();
            while(rs3.next()){
                                            // Extract data from the result set
                int medicineID = rs3.getInt("medicine_id");
                String brandName = rs3.getString("brand_name");
                int yearReport = rs3.getInt("year_report");
                int monthReport = rs3.getInt("month_report");
                int amountReceived = rs3.getInt("Amount Expiring");
                
                // Populate the ArrayLists
                medicineIDList2.add(medicineID);
                brandNameList2.add(brandName);
                yearList2.add(yearReport);
                monthList2.add(monthReport);
                expired2.add(amountReceived);
            
            
            }
            rs3.close();
            conn.close();


            return 1;
        } catch(Exception e){
            System.out.println(e.getMessage());
            return 0;
        }
    }

    public static void main(String[] args){
        stockreport sr = new stockreport();
        sr.generateStockReport();
        for(String brand : sr.brandNameList2){
            System.out.println(brand);
        }
    }
    


}