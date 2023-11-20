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
    
    public static void main(String[] args){
        suppliers s = new suppliers();
        s.get_supplier_names();
        System.out.println(s.nameList);
    }
}
