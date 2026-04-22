import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

@WebServlet("/AdminLoginServlet")
public class AdminLoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // 1. Get the username and password from the form
        String user = request.getParameter("username");
        String pass = request.getParameter("password");

        // 2. Check if they are correct (Hardcoded for safety)
        if ("admin".equals(user) && "admin123".equals(pass)) {
            
            // 3. Login Success! Create a "Session" to remember the admin is logged in
            HttpSession session = request.getSession();
            session.setAttribute("user", "admin");
            
            // 4. Send them to the Dashboard
            response.sendRedirect("admin_dashboard.jsp");
            
        } else {
            // 5. Login Failed! Tell them to try again
            response.getWriter().println("<h3 style='color:red; text-align:center;'>Wrong Password! <a href='admin_login.jsp'>Try Again</a></h3>");
        }
    }
}