import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

@WebServlet("/ReturnBookServlet")
public class ReturnBookServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        String bookId = request.getParameter("book_id");
        
        try {
            // 1. Connect
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_system", "root", "3001");
            
            // 2. INCREASE Quantity by 1 (Return)
            PreparedStatement ps = con.prepareStatement("UPDATE books SET quantity = quantity + 1 WHERE book_id = ?");
            ps.setString(1, bookId);
            ps.executeUpdate();
            
            // 3. Success - Redirect to Dashboard
            response.sendRedirect("admin_dashboard.jsp?msg=BookReturnedSuccessfully");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}