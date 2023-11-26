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
import java.sql.SQLException;
import java.util.*;

/** 
 *  
 * @author ccslearner 
 */ 
public class symptoms {
    public int symptom_id;
    public String symptom_name;
    public String symptom_description;
    
    public ArrayList<Integer> symptom_idList = new ArrayList<>();
    public ArrayList<String> symptom_nameList = new ArrayList<>();
    public ArrayList<Integer> med_idList = new ArrayList<>();
    public ArrayList<String> relation_descriptionList = new ArrayList<>();
    
    private String database = "jdbc:mysql://localhost:3306/pharmacy_db?user=root&password=12345678&useTimezone=true&serverTimezone=UTC&useSSL=false";
    
    public symptoms() {
        
    }
    
    public void clear_arrays() {
        symptom_idList.clear();
        symptom_nameList.clear();
        med_idList.clear();
        relation_descriptionList.clear();
    }
    
    public void get_all_symptom_names() {
        try {
            Connection conn = DriverManager.getConnection(database);
            String query = "SELECT symptom_name FROM symptom ORDER BY symptom_name";
            PreparedStatement pstmt = conn.prepareStatement(query);
            ResultSet rst = pstmt.executeQuery();
            clear_arrays();
            while (rst.next()) {
                symptom_nameList.add(rst.getString("symptom_name"));
            }
            pstmt.close();
            conn.close();
            
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
    
    public void get_symptoms_info(int id_no) {
        try {
            Connection conn = DriverManager.getConnection(database);
            String query = "SELECT symptom_id, symptom_name, symptom_description FROM symptom WHERE symptom_id = ?";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, id_no);
            ResultSet rst = pstmt.executeQuery();
            while (rst.next()) {
                symptom_id = rst.getInt("symptom_id");
                symptom_name = rst.getString("symptom_name");
                symptom_description = rst.getString("symptom_description");
            }
            pstmt.close();
            conn.close();
            
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
    
    public void get_meds_from_symptom(String symptom_name) {
        try {
            Connection conn = DriverManager.getConnection(database);
            String query =  "SELECT s.symptom_name, s.symptom_description, m.medicine_id, m.generic_name, m.brand_name, sm.relation_description " +
                            "FROM symptom s JOIN symptom_and_medicine sm " +
                            "               ON s.symptom_ID = sm.symptom_ID " +
                            "               JOIN medicine_info m " +
                            "               ON sm.medicine_ID = m.medicine_ID " +
                            "               WHERE s.symptom_name = ? ";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setString(1, symptom_name);
            ResultSet rst = pstmt.executeQuery();
            clear_arrays();
            while (rst.next()) {
                symptom_nameList.add(rst.getString("s.symptom_name"));
                med_idList.add(rst.getInt("m.medicine_id"));
                relation_descriptionList.add(rst.getString("sm.relation_description"));
            }
            pstmt.close();
            conn.close();
            
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }

    private boolean isValidSymptomInput(String name, String description) {
        return name != null && !name.trim().isEmpty() && description != null && !description.trim().isEmpty();
    }

    public boolean addSymptom(String symptomName, String symptomDescription) {
        if (!isValidSymptomInput(symptomName, symptomDescription)) {
            System.out.println("Invalid symptom data provided.");
            return false;
        }

        try (Connection conn = DriverManager.getConnection(database)) {
            String query = "INSERT INTO symptom (symptom_name, symptom_description) VALUES (?, ?)";
            try (PreparedStatement pstmt = conn.prepareStatement(query)) {
                pstmt.setString(1, symptomName);
                pstmt.setString(2, symptomDescription);
                int affectedRows = pstmt.executeUpdate();
                if (affectedRows > 0) {
                    System.out.println("Symptom successfully added.");
                    return true;
                } else {
                    System.out.println("Symptom could not be added.");
                    return false;
                }
            }
        } catch (SQLException e) {
            System.out.println("SQL Exception: " + e.getMessage());
            return false;
        }
    }

    public ArrayList<String> filterSymptoms(String searchQuery) {
        ArrayList<String> symptoms = new ArrayList<>();
        try (Connection conn = DriverManager.getConnection(database)) {
            String query = "SELECT symptom_name, symptom_description FROM symptom WHERE symptom_name LIKE ? OR symptom_description LIKE ?";
            try (PreparedStatement pstmt = conn.prepareStatement(query)) {
                pstmt.setString(1, "%" + searchQuery + "%");
                pstmt.setString(2, "%" + searchQuery + "%");
                try (ResultSet rs = pstmt.executeQuery()) {
                    while (rs.next()) {
                        symptoms.add(rs.getString("symptom_name") + ": " + rs.getString("symptom_description"));
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("Error while filtering symptoms: " + e.getMessage());
        }
        return symptoms;
    }

    public ArrayList<String> listSymptoms() {
        ArrayList<String> symptoms = new ArrayList<>();
        try (Connection conn = DriverManager.getConnection(database)) {
            String query = "SELECT symptom_name FROM symptom";
            try (PreparedStatement pstmt = conn.prepareStatement(query);
                 ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    symptoms.add(rs.getString("symptom_name"));
                }
            }
        } catch (SQLException e) {
            System.out.println("Error while listing symptoms: " + e.getMessage());
        }
        return symptoms;
    }
    
    public static void main(String[] args){
        symptoms med = new symptoms();
        med.get_all_symptom_names();
        System.out.println(med.symptom_nameList);
    
        // Setting up a symptom to add
        String symptomName = "Headache";
        String symptomDescription = "Pain in the head or upper neck";
        boolean isAdded = med.addSymptom(symptomName, symptomDescription);
        System.out.println("Symptom added: " + isAdded);
    
        // Setting up a filter criteria
        String filterCriteria = "head";
        ArrayList<String> filteredSymptoms = med.filterSymptoms(filterCriteria);
        System.out.println("Filtered Symptoms: " + filteredSymptoms);
    
        // Listing all symptoms
        ArrayList<String> allSymptoms = med.listSymptoms();  
        System.out.println("All Symptoms: " + allSymptoms);
    }    
}
