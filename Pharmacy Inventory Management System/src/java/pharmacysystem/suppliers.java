package pharmacysystem;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.*;

public class suppliers {
    public int supplierID;
    public String name;
    public String description;
    public String address;
    public Long contact_number;
    
    public ArrayList<String> nameList = new ArrayList<>();
    
    private String database = "jdbc:mysql://localhost:3306/pharmacy_db?user=root&password=12345678&useTimezone=true&serverTimezone=UTC&useSSL=false";
    
    public suppliers() {
        
    }
    
    public void clear_array() {
        nameList.clear();
    }
    
    public void get_supplier_names() {
        try {
            Connection conn = DriverManager.getConnection(database);
            String query = "SELECT supp_name FROM supplier_info ORDER BY supp_name";
            PreparedStatement pstmt = conn.prepareStatement(query);
            ResultSet rst = pstmt.executeQuery();
            clear_array();
            while (rst.next()) {
                nameList.add(rst.getString("supp_name"));
            }
            pstmt.close();
            conn.close();
            
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
    
    public int check_if_supplierID_exists(int id_no) {
        try {
            Connection conn = DriverManager.getConnection(database);
            String query = "SELECT supplierID FROM supplier_info WHERE supplierID = ?";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, id_no);
            ResultSet rst = pstmt.executeQuery();
            while (rst.next()) {
                if (rst.getInt("supplierID") == id_no)
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

    public int getAllSuppliers() {
        try {
            supplierIDList.clear();
            nameList.clear();
            descriptionList.clear();
            contact_numberList.clear();

            Connection conn = DriverManager.getConnection(database);
            String query = "SELECT * FROM supplier_info ORDER BY supplierID";
            PreparedStatement pstmt = conn.prepareStatement(query);
            ResultSet rst = pstmt.executeQuery();
            
            while (rst.next()) {
                supplierID = rst.getInt("supplierID");
                name = rst.getString("supp_name");
                description = rst.getString("supp_description");
                contact_number = rst.getLong("contact_number");

                supplierIDList.add(supplierID);
                nameList.add(name);
                descriptionList.add(description);
                contact_numberList.add(contact_number);
            }

            pstmt.close();
            conn.close();
            return 1;
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return 0;
        }
    }
    
    public static void main(String[] args){
        suppliers s = new suppliers();
        s.get_supplier_names();
        System.out.println(s.nameList);
    }
}
