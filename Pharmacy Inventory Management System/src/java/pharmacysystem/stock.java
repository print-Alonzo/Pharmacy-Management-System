package pharmacysystem;

import java.sql.*;
import java.util.*;

public class stock {

    public int quantity;
    public int medicineID;
    public String dateReceived;
    public String dateExpire;
    public double priceBought;

    public ArrayList<Integer> stockIDList = new ArrayList<>();
    public ArrayList<Integer> medicineIDList = new ArrayList<>();
    public ArrayList<String> dateReceivedList = new ArrayList<>();
    public ArrayList<String> dateExpireList = new ArrayList<>();
    public ArrayList<Double> priceBoughtList = new ArrayList<>();
    
    public int receive_stock(){
        try{
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharmacy_db?allowPublicKeyRetrieval=true&useTimezone=true&serverTimezone=UTC&user=root&password=12345&useSSL=false");
            System.out.println("Connection successful.");
            PreparedStatement pstmt = conn.prepareStatement("CALL InsertMedicineStock(?, ?, NOW(), ?, ?)");
            pstmt.setInt(1, quantity);
            pstmt.setInt(2, medicineID);
            //pstmt.setString(3, dateReceived);
            pstmt.setString(3, dateExpire);
            pstmt.setDouble(4, priceBought);

            pstmt.executeUpdate();
            pstmt.close();
            conn.close();
            return 1;

        }catch(Exception e){
            System.out.println(e.getMessage());
            return 0;
        }

    }

    public static void main(String[] args){
        stock s = new stock();
        s.quantity = 50;
        s.medicineID = 6;
        s.dateReceived = "2023-10-10";
        s.dateExpire = "2027-10-10";
        s.priceBought = 10.0;
        s.receive_stock();
    }

}
=======
package pharmacysystem;

import java.sql.*;
import java.util.*;

public class stock {

    public int quantity;
    public int medicineID;
    public String dateReceived;
    public String dateExpire;
    public double priceBought;

    public ArrayList<Integer> stockIDList = new ArrayList<>();
    public ArrayList<Integer> medicineIDList = new ArrayList<>();
    public ArrayList<String> dateReceivedList = new ArrayList<>();
    public ArrayList<String> dateExpireList = new ArrayList<>();
    public ArrayList<Double> priceBoughtList = new ArrayList<>();
    
    public int receive_stock(){
        try{
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharmacy_db?allowPublicKeyRetrieval=true&useTimezone=true&serverTimezone=UTC&user=root&password=12345&useSSL=false");
            System.out.println("Connection successful.");
            PreparedStatement pstmt = conn.prepareStatement("CALL InsertMedicineStock(?, ?, ?, ?, ?)");
            pstmt.setInt(1, quantity);
            pstmt.setInt(2, medicineID);
            pstmt.setString(3, dateReceived);
            pstmt.setString(4, dateExpire);
            pstmt.setDouble(5, priceBought);

            pstmt.executeUpdate();
            pstmt.close();
            return 1;

        }catch(Exception e){
            System.out.println(e.getMessage());
            return 0;
        }

    }

    public static void main(String[] args){
        stock s = new stock();
        s.quantity = 50;
        s.medicineID = 5;
        s.dateReceived = "2023-10-10";
        s.dateExpire = "2027-10-10";
        s.priceBought = 10.0;
        s.receive_stock();
    }

}
