package pharmacysystem;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class transactions {
    public int transactionID;
    public double priceBought;
    public int cashierID;
    public int pharmacistID;
    public String transactionDate;
    
    private String database = "jdbc:mysql://localhost:3306/pharmacy_db?user=root&password=12345678&useTimezone=true&serverTimezone=UTC&useSSL=false";

    public int addTransaction(int quantity, int medID){
        try{
            Connection conn = DriverManager.getConnection(database);
            //get priceBought from medID.
            String query = "SELECT sellingPrice FROM medicine_info WHERE medicine_id = ?";
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setInt(1, medID);
            ResultSet rst = ps.executeQuery();
            while(rst.next())
                priceBought = rst.getDouble("sellingPrice");

            //create a transaction record.
            String statement1 = "INSERT INTO transactions(priceBought, cashier, pharmacist, transactionDate)" + 
                            "VALUES(?, ?, ?, ?)";
            PreparedStatement ps1 = conn.prepareStatement(statement1);
            ps1.setDouble(1, priceBought*quantity);
            ps1.setInt(2, cashierID);
            if(pharmacistID != -1)
                ps1.setInt(3, pharmacistID);
            else   
                ps1.setObject(3, null);
            ps1.setString(4, transactionDate);
            ps1.executeUpdate();
            ps1.close();
        

            //set x amounts of medicine_stock WHERE medicine_id == medID to transactionRecord = transactionRecord
            String statement2 = "UPDATE medicine_stock SET transactionID = (SELECT MAX(transactionID) FROM transactions) WHERE medicine_id = ? AND transactionID is null AND dateExpire > NOW() ORDER BY dateExpire ASC LIMIT ?";
            PreparedStatement ps2 = conn.prepareStatement(statement2);
            ps2.setInt(1, medID);
            ps2.setInt(2, quantity);
            ps2.executeUpdate();
            ps2.close();

            return 1;

        } catch(Exception e) {
            System.out.println(e.getMessage());
            return 0;
        }
    }
       
    public int checkStock(int medID){
        try{
            Connection conn = DriverManager.getConnection(database);
            //get priceBought from medID.
            String query = "SELECT COUNT(ms.medicine_id) AS stock FROM medicine_info m LEFT JOIN medicine_stock ms ON m.medicine_id = ms.medicine_id WHERE m.medicine_id = ? AND ms.transactionID is null GROUP BY m.medicine_id";
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setInt(1, medID);
            ResultSet rst = ps.executeQuery();
            
            int stock = 0;
            while(rst.next())
                stock = rst.getInt("stock");

            return stock;

        } catch(Exception e) {
            System.out.println(e.getMessage());
            return 0;
        }
    }
}
