import java.io.*;
import java.sql.*;
import java.time.LocalDate;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

@WebServlet("/IssueBookServlet")
public class IssueBookServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        String studentId = request.getParameter("student_id"); // Scanned from Student Card
        String bookId = request.getParameter("book_id");       // Scanned from Book
        
        // 1. Calculate Dates
        LocalDate issueDate = LocalDate.now();
        LocalDate dueDate = issueDate.plusDays(10); // 📅 The 10-Day Rule!

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_system", "root", "3001");
            
            // 2. Check if Book Quantity > 0
            PreparedStatement checkQty = con.prepareStatement("SELECT quantity FROM books WHERE book_id = ?");
            checkQty.setString(1, bookId);
            ResultSet rs = checkQty.executeQuery();
            
            if(rs.next() && rs.getInt("quantity") > 0) {
                
                // 3. Insert Issue Record
                String insertQuery = "INSERT INTO issue_records (student_id, book_id, issue_date, due_date, status) VALUES (?, ?, ?, ?, 'ISSUED')";
                PreparedStatement ps = con.prepareStatement(insertQuery);
                ps.setString(1, studentId);
                ps.setString(2, bookId);
                ps.setDate(3, java.sql.Date.valueOf(issueDate));
                ps.setDate(4, java.sql.Date.valueOf(dueDate));
                ps.executeUpdate();
                
                // 4. Decrease Book Quantity
                PreparedStatement updateQty = con.prepareStatement("UPDATE books SET quantity = quantity - 1 WHERE book_id = ?");
                updateQty.setString(1, bookId);
                updateQty.executeUpdate();
                
                // Success: Go back to the student's dashboard
                response.sendRedirect("student_issue_dashboard.jsp?id=" + studentId + "&msg=Success");
            } else {
                // Fail: Out of stock
                response.sendRedirect("student_issue_dashboard.jsp?id=" + studentId + "&msg=OutOfStock");
            }
            con.close();
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("student_issue_dashboard.jsp?id=" + studentId + "&msg=Error");
        }
    }
}