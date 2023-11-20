package pharmacysystem;
import java.util.*;
import java.sql.*;


public class orders {
    public int orderID;
    public int supplierID;
    public String date_ordered;
    public String date_expired;
    public int medicine_id;
    public int quantity;
    public String order_status;
    public double priceSold;

    public int addOrder(){
        try{
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharmacy_db?allowPublicKeyRetrieval=true&useTimezone=true&serverTimezone=UTC&user=root&password=12345&useSSL=false");
            System.out.println("Connection success!");

            String sql = "INSERT INTO orders (supplierID, date_ordered, medicineID, quantity, expiryDate, priceSold, order_status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement psmt = conn.prepareStatement(sql);
            psmt.setInt(1, supplierID);
            psmt.setString(2, date_ordered);
            psmt.setInt(3, medicine_id);
            psmt.setInt(4, quantity);
            psmt.setString(5, date_expired);
            psmt.setDouble(6, priceSold);
            psmt.setString(7, "ordered");
            psmt.executeUpdate();
            psmt.close();
            conn.close();
            return 1;

        }catch(Exception e){
            System.out.println(e.getMessage());
            return 0;
        }
    }

    public int setOrderToReceived(int orderID){
        try{
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharmacy_db?allowPublicKeyRetrieval=true&useTimezone=true&serverTimezone=UTC&user=root&password=12345&useSSL=false");
            
            //get info from order
            String query = "SELECT * FROM orders WHERE orderID = " + orderID;
            PreparedStatement first = conn.prepareStatement(query);
            ResultSet rst = first.executeQuery();
            while(rst.next()){
                orderID = rst.getInt("orderID");
                supplierID = rst.getInt("supplierID");
                date_ordered = rst.getString("date_ordered");
                medicine_id = rst.getInt("medicineID");
                quantity = rst.getInt("quantity");
                date_expired = rst.getString("expiryDate");
                priceSold = rst.getDouble("priceSold");
                order_status = rst.getString("order_status");
            }
            System.out.println(orderID + " " + supplierID + date_ordered + " " +  medicine_id + " " + quantity + " " + date_expired + " " + priceSold + " " + order_status);
            first.close();

            //set stocks.
            stock s = new stock();
            s.quantity = quantity;
            s.medicineID = medicine_id;
            //s.dateReceived = "NOW()";
            s.dateExpire = date_expired;
            s.priceBought = priceSold;

            s.receive_stock();

            //set order to received.
            query = "UPDATE orders SET order_status = 'ordered' WHERE orderID = ?";
            PreparedStatement second = conn.prepareStatement(query);
            second.setInt(1, orderID);
            second.executeUpdate();

            second.close();
            conn.close();


            return 1;
        }catch(Exception e){
            System.out.println(e.getMessage());
            return 0;
        }
    }

    public static void main(String[] args){
        orders o = new orders();
        

        o.setOrderToReceived(1);
        o.setOrderToReceived(2);

    }



}
