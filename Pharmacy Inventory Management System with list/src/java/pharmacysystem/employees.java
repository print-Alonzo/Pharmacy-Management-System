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
    public ArrayList<String> positionList = new ArrayList<>();
    public ArrayList<String> first_nameList = new ArrayList<>();
    public ArrayList<String> last_nameList = new ArrayList<>();
    public ArrayList<Long> contact_noList = new ArrayList<>();
    public ArrayList<String> addressList = new ArrayList<>();
    public ArrayList<Double> salaryList = new ArrayList<>();
    
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

    public int getAllEmployees(){
        try{
            employee_idList.clear();
            positionList.clear();
            first_nameList.clear();
            last_nameList.clear();
            contact_noList.clear();
            addressList.clear();
            salaryList.clear();
            
            
            Connection conn = DriverManager.getConnection(database);
            String query = "SELECT e.employee_id, e.position_name, e.first_name, e.last_name, e.contact_no, e.address, p.salary FROM employees e LEFT JOIN positions p ON e.position_name = p.position_name ORDER BY e.employee_id";
            PreparedStatement pstmt = conn.prepareStatement(query);
            ResultSet rst = pstmt.executeQuery();
            while(rst.next()){
                employee_id = rst.getInt("employee_id");
                position = rst.getString("position_name");
                first_name = rst.getString("first_name");
                last_name = rst.getString("last_name");
                contact_no = rst.getLong("contact_no");
                address = rst.getString("address");
                salary = rst.getDouble("salary");
                
                employee_idList.add(employee_id);
                positionList.add(position);
                first_nameList.add(first_name);
                last_nameList.add(last_name);
                contact_noList.add(contact_no);
                addressList.add(address);
                salaryList.add(salary);
                
            }
            pstmt.close();
            conn.close();
            return 1;
        }catch(Exception e){
            System.out.println(e.getMessage());
            return 0;
        }
    }



    /*
     * delete an employee.
     */
    public int deleteEmployee(int id){
        try {
            Connection conn = DriverManager.getConnection(database);
            String delete = "DELETE FROM employees WHERE employee_id = ? ";
            
            PreparedStatement pst1 = conn.prepareStatement(delete);
            pst1.setInt(1, id);
            int count = pst1.executeUpdate();
            if(count == 0){
                return 5;
            }
            

            pst1.close();
            conn.close();
            return 1;
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return 0;
        }
    }


    /*
     * change information about an employee.
     */
    public int updateEmployee(int id, String column, String value){
        try {
            Connection conn = DriverManager.getConnection(database);
            String update = "UPDATE employees SET ? = ? WHERE employee_id = ?";
            PreparedStatement pst = conn.prepareStatement(update);
            pst.setString(1, column);
            pst.setString(2, value);
            pst.setInt(3, id);
            int count = pst.executeUpdate();
            if(count == 0){
                return 5;
            }
            pst.close();
            conn.close();
            return 1;
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return 0;
        }

    }

    /*
     * filter employee by position.
     */
    public int filterEmployee(){
        try {
            Connection conn = DriverManager.getConnection(database);
            String sql = "SELECT * FROM employees WHERE position_name = ?";
            PreparedStatement pst = conn.prepareStatement(sql);
            ResultSet rst = pst.executeQuery();
            if(rst == null){
                first_name = "No employee Found.";
                return 5;
            }
            else{
                while(rst.next()){

                }
            }
            pst.close();
            conn.close();
            return 1;
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return 0;
        }

    }

    /*
     * search employee by name.
     */
    public int searchEmployee(String firstName, String lastName){
        try {
            firstName = firstName.toLowerCase();
            lastName = lastName.toLowerCase();
            Connection conn = DriverManager.getConnection(database);
            String search = "SELECT * FROM employees WHERE LOWER(employees.first_name) = ? AND LOWER(employees.last_name) = ?";
            PreparedStatement pst = conn.prepareStatement(search);
            pst.setString(1, firstName);
            pst.setString(2, firstName);
            ResultSet rst = pst.executeQuery();
            
            if (rst == null){
                first_name = "NO EMPLOYEE FOUND";
                return 5;
            }
            else{
                while(rst.next()){
                        employee_id = rst.getInt("employee_id");
                        position = rst.getString("position");
                        first_name = rst.getString("first_name");
                        last_name = rst.getString("last_name");
                        contact_no = rst.getLong("contact_no"); 
                        password = rst.getString("pw");
                        address = rst.getString("address");
                        salary = rst.getDouble("salary");  
                }
            }
            pst.close();
            conn.close();
            return 1;
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return 0;
        }
    }

    /*
     * add a new employee.
     */
    public int addEmployee(){
        try {
            Connection conn = DriverManager.getConnection(database);
            String add = "INSERT INTO EMPLOYEES (position_name, first_name, last_name, contact_no, pw, address) "
                            +"VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement pst = conn.prepareStatement(add);
            pst.setString(1, position);
            pst.setString(2, first_name);
            pst.setString(3, last_name);
            pst.setLong(4, contact_no);
            pst.setString(5, password);
            pst.setString(6, address);
            pst.executeUpdate();
            pst.close();
            conn.close();
            return 1;
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return 0;
        }
    }
    
    public static void main(String[] args){
        employees e = new employees();
        System.out.println(e.check_password(1, "12345"));
    }
}
