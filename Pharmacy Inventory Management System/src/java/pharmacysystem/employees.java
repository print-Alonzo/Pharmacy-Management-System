/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package pharmacysystem;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.*;

/**
 *
 * @author ccslearner
 */
public class employees {
    public int employee_id;
    public String position;
    public String first_name;
    public String last_name;
    public Long contact_no;
    public String password;
    public String address;
    public Double salary;
    
    public ArrayList<Integer> employee_idList = new ArrayList<>();
    
    private String database = "jdbc:mysql://localhost:3306/pharmacy_db?user=root&password=12345678&useTimezone=true&serverTimezone=UTC&useSSL=false";
    
    public employees() {
        
    }
    
    public void clear_array() {
        employee_idList.clear();
    }
    
    public void get_info(int id_no) {
        try {
            Connection conn = DriverManager.getConnection(database);
            String query = "SELECT e.employee_id AS id, e.position_name AS position, e.first_name AS first_name, e.last_name AS last_name, e.contact_no AS contact_no, e.pw AS password, e.address AS address, p.salary AS salary FROM employees e JOIN position p ON e.position_name = p.position_name WHERE e.employee_id = ?";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, id_no);
            ResultSet rst = pstmt.executeQuery();
            while (rst.next()) {
                employee_id = rst.getInt("id");
                position = rst.getString("position");
                first_name = rst.getString("first_name");
                last_name = rst.getString("last_name");
                contact_no = rst.getLong("contact_no");
                password = rst.getString("password");
                address = rst.getString("address");
                salary = rst.getDouble("salary");
            }
            pstmt.close();
            conn.close();
            
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
    
    public int check_password(int id_no, String password) {
        try {
            Connection conn = DriverManager.getConnection(database);
            String query = "SELECT pw FROM employees WHERE employee_id = ? AND position_name = 'Pharmacist'";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, id_no);
            ResultSet rst = pstmt.executeQuery();
            while (rst.next()) {
                if (rst.wasNull())
                    return 0;
                
                if (password.equals(rst.getString("pw")))
                    return 1;
                else
                    return 0;
            }
            pstmt.close();
            conn.close();
            
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        
        return 0;
    }
    
    public void get_employees_in_position(String position) {
        try {
            Connection conn = DriverManager.getConnection(database);
            String query = "SELECT employee_id FROM employees WHERE position_name = ? ORDER BY employee_id";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setString(1, position);
            ResultSet rst = pstmt.executeQuery();
            clear_array();
            while (rst.next()) {
                employee_idList.add(rst.getInt("employee_id"));
            }
            pstmt.close();
            conn.close();
            
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
    
    public static void main(String[] args){
        employees e = new employees();
        System.out.println(e.check_password(1, "12345"));
    }
}
