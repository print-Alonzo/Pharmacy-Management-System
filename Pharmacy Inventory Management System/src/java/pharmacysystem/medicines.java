package pharmacysystem;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.*;

public class medicines {
    public int medicineID;
    public String generic_name;
    public String brand_name;
    public Double volume_ml;
    public Double dosage_mg;
    public int isPrescription;
    public String category;
    public Double sellingPrice;
    public String description;
    public String date_added;
    public int stock;
    public String supplier_name;
    
    public ArrayList<Integer> medicineIDList = new ArrayList<>();
    public ArrayList<String> categoryList = new ArrayList<>();
    
    public medicines() {
        
    }
    
    public void clear_array() {
        medicineIDList.clear();
    }
    
    public void get_info(int id_no) {
        try {
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HOADB?useTimezone=true&serverTimezone=UTC&user=root&password=12345678&useSSL=false");
            String query = "SELECT medicineID, generic_name, brand_name, volume_ml, dosage_mg, isPrescription, category, sellingPrice, description, date_added FROM medicines WHERE medicineID = ?";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, id_no);
            ResultSet rst = pstmt.executeQuery();
            while (rst.next()) {
                medicineID = rst.getInt("medicineID");
                generic_name = rst.getString("generic_name");
                brand_name = rst.getString("brand_name");
                volume_ml = rst.getDouble("volume_ml");
                if (rst.wasNull())
                    volume_ml = 0.0;
                
                dosage_mg = rst.getDouble("dosage_mg");
                if (rst.wasNull())
                    dosage_mg = 0.0;
                
                isPrescription = rst.getInt("isPrescription");
                category = rst.getString("category");
                sellingPrice = rst.getDouble("sellingPrice");
                description = rst.getString("description");
                date_added = rst.getString("date_added");
            }
            pstmt.close();
            conn.close();
            
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
    
    public void get_info_for_order(int id_no) {
        try {
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HOADB?useTimezone=true&serverTimezone=UTC&user=root&password=12345678&useSSL=false");
            String query = "SELECT m.medicineID AS id, m.brand_name AS b_name, m.generic_name AS g_name, COUNT(ms.medicineID) AS stock, m.supplierID AS s_id, m.sellingPrice as s_price FROM medicines m LEFT JOIN medicine_stock ms ON m.medicineID = ms.medicineID WHERE m.medicineID = ? GROUP BY m.medicineID ORDER BY m.medicineID";
            String query2 = "SELECT name FROM suppliers WHERE supplierID = ?";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, id_no);
            ResultSet rst = pstmt.executeQuery();
            while (rst.next()) {
                medicineID = rst.getInt("medicineID");
                generic_name = rst.getString("generic_name");
                brand_name = rst.getString("brand_name");
                stock = rst.getInt("stock");
                sellingPrice = rst.getDouble("s_price");
                
                PreparedStatement pstmt2 = conn.prepareStatement(query2);
                pstmt2.setInt(1, rst.getInt("s_id"));
                ResultSet rst2 = pstmt.executeQuery();
                
                while (rst2.next())
                    supplier_name = rst2.getString("name");
            }
            pstmt.close();
            conn.close();
            
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
    
    public void get_all_meds() {
        try {
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HOADB?useTimezone=true&serverTimezone=UTC&user=root&password=12345678&useSSL=false");
            String query = "SELECT medicineID FROM medicines ORDER BY medicineID";
            PreparedStatement pstmt = conn.prepareStatement(query);
            ResultSet rst = pstmt.executeQuery();
            clear_array();
            while (rst.next()) {
                medicineIDList.add(rst.getInt("medicineID"));
            }
            pstmt.close();
            conn.close();
            
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
    
    public void get_meds_with_name(String name, int isPrescription) {
        try {
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HOADB?useTimezone=true&serverTimezone=UTC&user=root&password=12345678&useSSL=false");
            String query = "SELECT m.medicineID AS id, COUNT(ms.medicineID) AS stock FROM medicines m LEFT JOIN medicine_stock ms ON m.medicineID = ms.medicineID WHERE (m.brand_name = ? OR m.generic_name = ?) AND m.isPrescription = ? GROUP BY m.medicineID HAVING stock > 0 ORDER BY m.medicineID";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setString(1, name);
            pstmt.setString(2, name);
            pstmt.setInt(3, isPrescription);
            ResultSet rst = pstmt.executeQuery();
            clear_array();
            while (rst.next()) {
                medicineIDList.add(rst.getInt("id"));
            }
            pstmt.close();
            conn.close();
            
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
    
    public void get_meds_with_category(String name) {
        try {
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HOADB?useTimezone=true&serverTimezone=UTC&user=root&password=12345678&useSSL=false");
            String query = "SELECT m.medicineID AS id, COUNT(ms.medicineID) AS stock FROM medicines m LEFT JOIN medicine_stock ms ON m.medicineID = ms.medicineID WHERE m.category = ? AND m.isPrescription = 0 GROUP BY m.medicineID HAVING stock > 0 ORDER BY m.medicineID";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setString(1, name);
            ResultSet rst = pstmt.executeQuery();
            clear_array();
            while (rst.next()) {
                medicineIDList.add(rst.getInt("id"));
            }
            pstmt.close();
            conn.close();
            
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
    
    public void get_category() {
        try {
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HOADB?useTimezone=true&serverTimezone=UTC&user=root&password=12345678&useSSL=false");
            String query = "SELECT DISTINCT category FROM medicines ORDER BY category";
            PreparedStatement pstmt = conn.prepareStatement(query);
            ResultSet rst = pstmt.executeQuery();
            clear_array();
            while (rst.next()) {
                categoryList.add(rst.getString("category"));
            }
            pstmt.close();
            conn.close();
            
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
}
