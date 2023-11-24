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
    
    public ArrayList<Integer> orderIDList = new ArrayList<>();
    
    private String database = "jdbc:mysql://localhost:3306/pharmacy_db?user=root&password=12345678&useTimezone=true&serverTimezone=UTC&useSSL=false";
    
    public void clear_array() {
        orderIDList.clear();
    }
    
    public int check_if_orderID_exists(int id_no) {
        try {
            Connection conn = DriverManager.getConnection(database);
            String query = "SELECT orderID FROM orders WHERE orderID = ? AND order_status = 'ordered'";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, id_no);
            ResultSet rst = pstmt.executeQuery();
            while (rst.next()) {
                if (rst.getInt("orderID") == id_no)
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
    
    
    public void get_order_info(int id_no) {
        try {
            Connection conn = DriverManager.getConnection(database);
            String query = "SELECT orderID, supplierID, date_ordered, medicineID, quantity, expiryDate, priceSold, order_status FROM orders WHERE orderID = ?";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, id_no);
            ResultSet rst = pstmt.executeQuery();
            while (rst.next()) {
                orderID = rst.getInt("orderID");
                supplierID = rst.getInt("supplierID");
                date_ordered = rst.getString("date_ordered");
                date_expired = rst.getString("expiryDate");
                medicine_id = rst.getInt("medicineID");
                quantity = rst.getInt("quantity");
                order_status = rst.getString("order_status");
                priceSold = rst.getDouble("priceSold");
            }
            pstmt.close();
            conn.close();
            
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
    
    public void get_sent_orders() {
        try {
            Connection conn = DriverManager.getConnection(database);
            String query = "SELECT orderID FROM orders WHERE order_status = 'ordered' ORDER BY orderID";
            PreparedStatement pstmt = conn.prepareStatement(query);
            ResultSet rst = pstmt.executeQuery();
            clear_array();
            while (rst.next()) {
                orderIDList.add(rst.getInt("orderID"));
            }
            pstmt.close();
            conn.close();
            
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
    
    public String addTwoYears(String inputDate, int id) {
        // Split the input date into year, month, and day
        String[] parts = inputDate.split("-");
        int year = Integer.parseInt(parts[0]);
        int month = Integer.parseInt(parts[1]);
        int day = Integer.parseInt(parts[2]);

        // Add two years to the year part
        if(id%2==0){
            year += 2;
        } else {
            year += 3;
        }

        // Format the result back to the string
        return String.format("%04d-%02d-%02d", year, month, day);
    }


    public int addOrder(){
        try{
            Connection conn = DriverManager.getConnection(database);
                    
            String sql = "INSERT INTO orders (supplierID, date_ordered, medicineID, quantity, expiryDate, priceSold, order_status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement psmt = conn.prepareStatement(sql);
            psmt.setInt(1, supplierID);
            psmt.setString(2, date_ordered);
            psmt.setInt(3, medicine_id);
            psmt.setInt(4, quantity);
            
            date_expired = addTwoYears(date_ordered, medicine_id);
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
            Connection conn = DriverManager.getConnection(database);
            
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
            query = "UPDATE orders SET order_status = 'sent' WHERE orderID = ?";
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
        o.supplierID = 2;
        o.date_ordered = "2023-01-11";
        o.medicine_id = 1;
        o.quantity = 1;
        o.priceSold = 1.00;
        System.out.println(o.addOrder());
        System.out.println(o.date_expired);

    }



}
