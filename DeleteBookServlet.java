import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

@WebServlet("/DeleteBookServlet")
public class DeleteBookServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        String bookId = request.getParameter("id");
        
        try {
            // 1. Connect
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_system", "root", "3001");
            
            // 2. DELETE Query
            PreparedStatement ps = con.prepareStatement("DELETE FROM books WHERE book_id = ?");
            ps.setString(1, bookId);
            ps.executeUpdate();
            
            // 3. Redirect back to View Books
            response.sendRedirect("view_books.jsp?msg=BookDeleted");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}