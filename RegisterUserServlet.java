import java.io.*;
import java.sql.*;
import jakarta.servlet.*;            // If this line is red, see note below
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

@WebServlet("/RegisterUserServlet")
public class RegisterUserServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Get data from the HTML form
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String pass = request.getParameter("password");
        String address = request.getParameter("address");
        String photo = request.getParameter("photo");

        try {
            // 2. Connect to Database
            Connection con = DbConnection.getConnection();
            
            // 3. Insert Data
            String query = "INSERT INTO users (name, email, password, address, photo) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, pass);
            ps.setString(4, address);
            ps.setString(5, photo);
            
            ps.executeUpdate();
            
            // 4. Success! Go to login page
            response.sendRedirect("index.jsp");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}