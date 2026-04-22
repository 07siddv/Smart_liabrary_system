import java.sql.*;

public class TestDB {
    public static void main(String[] args) {
        System.out.println("--- TESTING DATABASE CONNECTION ---");
        
        try {
            // 1. Load Driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("✅ Driver Found!");

            // 2. Try to Connect (Update password if yours is not 'root')
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_system", "root", "3001");
            System.out.println("✅ Connection Success! Database is working.");
            
        } catch (ClassNotFoundException e) {
            System.out.println("❌ ERROR: MySQL Driver JAR is missing!");
            System.out.println("Make sure you have the mysql-connector jar in your lib folder.");
            
        } catch (SQLException e) {
            System.out.println("❌ ERROR: Could not connect to MySQL.");
            System.out.println("Reason: " + e.getMessage());
        }
        
        System.out.println("-----------------------------------");
    }
}