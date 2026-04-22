import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

@WebServlet("/StudentLoginServlet")
public class StudentLoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        String libId = request.getParameter("library_id");
        String pass = request.getParameter("password");
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_system", "root", "3001");
            
            // Check ID and Password (Password is Contact No by default)
            PreparedStatement ps = con.prepareStatement("SELECT * FROM lib_students WHERE library_id=? AND contact=?");
            ps.setString(1, libId);
            ps.setString(2, pass);
            
            ResultSet rs = ps.executeQuery();
            
            if(rs.next()) {
                // Login Success
                HttpSession session = request.getSession();
                session.setAttribute("student_id", rs.getString("library_id"));
                session.setAttribute("student_name", rs.getString("name"));
                session.setAttribute("student_photo", rs.getString("photo_url"));
                
                response.sendRedirect("my_library.jsp");
            } else {
                // Login Failed
                response.sendRedirect("student_login.jsp?error=Invalid");
            }
            con.close();
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("student_login.jsp?error=Error");
        }
    }
}