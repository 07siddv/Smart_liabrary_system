import java.sql.*;

public class DbConnection {
    public static Connection getConnection() {
        Connection con = null;
        try {
            // 1. Load the Driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // 2. Connect to Database (CHANGE PASSWORD BELOW IF NOT 'root')
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_system", "root", "3001");
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return con;
    }

    // A small main method to test if it works right now
    public static void main(String[] args) {
        Connection con = getConnection();
        if(con != null) {
            System.out.println("SUCCESS! Database is connected.");
        } else {
            System.out.println("FAILED. Check your database password.");
        }
    }
}