import java.io.*;
import java.sql.*;
import java.net.URLEncoder;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

@WebServlet("/AddBookServlet")
@MultipartConfig
public class AddBookServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // 1. Get data from form
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String qty = request.getParameter("quantity");
        String dept = request.getParameter("department");
        String year = request.getParameter("year");

        // --- 🧠 SMART BOOK ID GENERATION ---
        // Logic: First 4 chars of Title + First 4 of Author + Year
        // Example: "Python" + "James" + "2023" = "PYTH-JAME-2023"
        
        String tPart = (title.length() > 4) ? title.substring(0, 4) : title;
        String aPart = (author.length() > 4) ? author.substring(0, 4) : author;
        
        // Remove spaces and make Uppercase
        String cleanTitle = tPart.replaceAll("\\s+", "").toUpperCase();
        String cleanAuthor = aPart.replaceAll("\\s+", "").toUpperCase();
        
        String uniqueBookId = cleanTitle + "-" + cleanAuthor + "-" + year;
        // ------------------------------------

        // 2. Generate QR Code (Now contains ONLY the Unique ID)
        String qrCodeLink = "https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=" + uniqueBookId;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_system", "root", "3001");
            
            // 3. Insert into Database (Added unique_id column)
            String query = "INSERT INTO books (title, author, quantity, qr_code, department, publication_year, unique_id) VALUES (?, ?, ?, ?, ?, ?, ?)";
            
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, title);
            ps.setString(2, author);
            ps.setString(3, qty);
            ps.setString(4, qrCodeLink);
            ps.setString(5, dept);
            ps.setString(6, year);
            ps.setString(7, uniqueBookId); // Save the new ID
            
            ps.executeUpdate();
            
            response.sendRedirect("view_books.jsp?msg=BookAdded");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}