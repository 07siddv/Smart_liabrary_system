import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

@WebServlet("/DeleteStudentServlet")
public class DeleteStudentServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        String rollNo = request.getParameter("roll_no");
        
        try {
            // 1. Connect
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_system", "root", "3001");
            
            // 2. DELETE Query
            PreparedStatement ps = con.prepareStatement("DELETE FROM lib_students WHERE roll_no = ?");
            ps.setString(1, rollNo);
            ps.executeUpdate();
            
            // 3. Success -> Go back to list
            response.sendRedirect("view_students.jsp?msg=StudentDeleted");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}