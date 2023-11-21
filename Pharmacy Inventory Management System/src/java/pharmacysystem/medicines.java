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
    public int stock;
    public int supplier_id;
    public String supplier_name;
    
    public ArrayList<Integer> medicineIDList = new ArrayList<>();
    public ArrayList<String> categoryList = new ArrayList<>();
    
    private String database = "jdbc:mysql://localhost:3306/pharmacy_db?user=root&password=12345678&useTimezone=true&serverTimezone=UTC&useSSL=false";
    
    public medicines() {
        
    }
    
    public void clear_array() {
        medicineIDList.clear();
        categoryList.clear();
    }
    
    public void get_info(int id_no) {
        try {
            Connection conn = DriverManager.getConnection(database);
            String query = "SELECT medicine_id, generic_name, brand_name, volume_ml, dosage_mg, isPrescription, category, sellingPrice, description FROM medicine_info WHERE medicine_id = ?";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, id_no);
            ResultSet rst = pstmt.executeQuery();
            while (rst.next()) {
                medicineID = rst.getInt("medicine_id");
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
            }
            pstmt.close();
            conn.close();
            
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
    
    public void get_info_for_order(int id_no) {
        try {
            Connection conn = DriverManager.getConnection(database);
            String query = "SELECT m.medicine_id AS id, m.brand_name AS b_name, m.generic_name AS g_name, COUNT(ms.medicine_id) AS stock, m.supplierID AS s_id, m.sellingPrice as s_price FROM medicine_info m LEFT JOIN medicine_stock ms ON m.medicine_id = ms.medicine_id WHERE m.medicine_id = ? GROUP BY m.medicine_id ORDER BY m.medicine_id";
            String query2 = "SELECT supplierID, supp_name FROM supplier_info WHERE supplierID = ?";
            PreparedStatement pstmt = conn.prepareStatement(query);
            PreparedStatement pstmt2 = conn.prepareStatement(query2);
            pstmt.setInt(1, id_no);
            ResultSet rst = pstmt.executeQuery();
            while (rst.next()) {
                medicineID = rst.getInt("id");
                generic_name = rst.getString("g_name");
                brand_name = rst.getString("b_name");
                stock = rst.getInt("stock");
                sellingPrice = rst.getDouble("s_price");
                
                pstmt2.setInt(1, rst.getInt("s_id"));
                ResultSet rst2 = pstmt2.executeQuery();
                while (rst2.next()) {
                    supplier_id = rst2.getInt("supplierID");
                    supplier_name = rst2.getString("supp_name");
                }
            }
            pstmt.close();
            conn.close();
            
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
    
    public void get_all_meds() {
        try {
            Connection conn = DriverManager.getConnection(database);
            String query = "SELECT medicine_id FROM medicine_info ORDER BY medicine_id";
            PreparedStatement pstmt = conn.prepareStatement(query);
            ResultSet rst = pstmt.executeQuery();
            clear_array();
            while (rst.next()) {
                medicineIDList.add(rst.getInt("medicine_id"));
            }
            pstmt.close();
            conn.close();
            
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
    
    public void get_meds_with_name(String name, int isPrescription) {
        try {
            Connection conn = DriverManager.getConnection(database);
            String query = "SELECT m.medicine_id AS id, COUNT(ms.medicine_id) AS stock FROM medicine_info m LEFT JOIN medicine_stock ms ON m.medicine_id = ms.medicine_id WHERE (m.brand_name = ? OR m.generic_name = ?) AND m.isPrescription = ? GROUP BY m.medicine_id HAVING stock >= 0 ORDER BY m.medicine_id";
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
            Connection conn = DriverManager.getConnection(database);
            String query = "SELECT m.medicine_id AS id, COUNT(ms.medicine_id) AS stock FROM medicine_info m LEFT JOIN medicine_stock ms ON m.medicine_id = ms.medicine_id WHERE m.category = ? AND m.isPrescription = 0 GROUP BY m.medicine_id HAVING stock >= 0 ORDER BY m.medicine_id";
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
    
    public void get_supplier_meds(String name) {
        try {
            Connection conn = DriverManager.getConnection(database);
            String query = "SELECT m.medicine_id AS id FROM medicine_info m RIGHT JOIN supplier_info s ON m.supplierID = s.supplierID WHERE s.supp_name = ?";
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
    
    public void get_low_meds() {
        try {
            Connection conn = DriverManager.getConnection(database);
            String query = "SELECT m.medicine_id AS id, COUNT(ms.medicine_id) AS stock FROM medicine_info m LEFT JOIN medicine_stock ms ON m.medicine_id = ms.medicine_id GROUP BY m.medicine_id HAVING stock <= 10 ORDER BY m.medicine_id";
            PreparedStatement pstmt = conn.prepareStatement(query);
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
            Connection conn = DriverManager.getConnection(database);
            String query = "SELECT DISTINCT category FROM medicine_info WHERE isPrescription = 0 ORDER BY category";
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
    
    public int check_if_medID_exists(int id_no) {
        try {
            Connection conn = DriverManager.getConnection(database);
            String query = "SELECT medicine_id FROM medicine_info WHERE medicine_id = ?";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, id_no);
            ResultSet rst = pstmt.executeQuery();
            while (rst.next()) {
                if (rst.getInt("medicine_id") == id_no)
                    return 1;
            }
            pstmt.close();
            conn.close();
            
            return 0;
            
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return 0;
        }
    }
    
    public static void main(String[] args){
        medicines med = new medicines();
        System.out.println(med.check_if_medID_exists(1));
    }
}
