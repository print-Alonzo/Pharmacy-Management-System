package pharmacysystem;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

public class transactions {
    public int transactionID;
    public float priceBought;
    public int cashierID;
    public int pharmacistID;
    public String transactionDate;

    public int addTransaction(int quantity, int medID){
        try{
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharmacy_db?allowPublicKeyRetrieval=true&useTimezone=true&serverTimezone=UTC&user=root&password=12345&useSSL=false");
            //create a transaction record.
            String statement1 = "INSERT INTO transactions(priceBought, cashier, pharmacist, transactionDate)" + 
                            "VALUES(?, ?, ?, ?)";
            PreparedStatement ps1 = conn.prepareStatement(statement1);
            ps1.setDouble(1, priceBought);
            ps1.setInt(2, cashierID);
            if(pharmacistID == -1)
                ps1.setInt(3, pharmacistID);
            else   
                ps1.setObject(3, null);
            ps1.setString(4, transactionDate);
            ps1.executeUpdate();
            ps1.close();
        

            //set x amounts of medicine_stock WHERE medicine_id == medID to transactionRecord = transactionRecord.
            String statement2 = "UPDATE medicine_stock SET transactionID = MAX(transactions.transactionID) WHERE medicine_id = ? AND dateExpire > NOW() ORDER BY dateExpire ASC LIMIT = ?";
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
}
