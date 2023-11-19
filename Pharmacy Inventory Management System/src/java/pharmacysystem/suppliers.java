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
    
    public suppliers() {
        
    }
    
    public void clear_array() {
        nameList.clear();
    }
    
    public void get_supplier_names() {
        try {
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HOADB?useTimezone=true&serverTimezone=UTC&user=root&password=12345678&useSSL=false");
            String query = "SELECT name FROM supplier_info ORDER BY name";
            PreparedStatement pstmt = conn.prepareStatement(query);
            ResultSet rst = pstmt.executeQuery();
            clear_array();
            while (rst.next()) {
                nameList.add(rst.getString("name"));
            }
            pstmt.close();
            conn.close();
            
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
}
