import java.sql.*;

public class FixDB_Date {
    public static void main(String[] args) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_system", "root", "3001");
            Statement stmt = con.createStatement();
            
            // This adds the missing 'entry_date' column
            stmt.executeUpdate("ALTER TABLE books ADD COLUMN entry_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP");
            
            System.out.println("✅ Database Fixed! 'entry_date' column added.");
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
            // If it says "Duplicate column name", that means it's already there!
        }
    }
}