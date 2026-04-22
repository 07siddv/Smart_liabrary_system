import java.io.*;
import java.sql.*;
import java.time.LocalDate;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

@WebServlet("/ProcessIssueServlet")
public class ProcessIssueServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        String studentId = request.getParameter("student_id");
        String scannedBookQr = request.getParameter("book_id"); // This is now "PYTH-JAME-2023"
        
        LocalDate issueDate = LocalDate.now();
        LocalDate dueDate = issueDate.plusDays(10); 

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_system", "root", "3001");
            
            // 1. Find Book ID (Int) using the Scanned Unique ID (String)
            // We need the internal integer ID for the transaction table, or we can store the string.
            // Let's look up the Integer ID first to keep data consistent.
            
            int internalBookId = -1;
            PreparedStatement findBook = con.prepareStatement("SELECT book_id, quantity FROM books WHERE unique_id = ?");
            findBook.setString(1, scannedBookQr);
            ResultSet rs = findBook.executeQuery();
            
            if(rs.next() && rs.getInt("quantity") > 0) {
                internalBookId = rs.getInt("book_id");
                
                // 2. Insert Transaction
                String insertQuery = "INSERT INTO book_transactions (student_id, book_id, issue_date, due_date, status) VALUES (?, ?, ?, ?, 'ISSUED')";
                PreparedStatement ps = con.prepareStatement(insertQuery);
                ps.setString(1, studentId);
                ps.setInt(2, internalBookId); // Storing the Integer ID reference
                ps.setDate(3, java.sql.Date.valueOf(issueDate));
                ps.setDate(4, java.sql.Date.valueOf(dueDate));
                ps.executeUpdate();
                
                // 3. Decrease Quantity
                PreparedStatement updateQty = con.prepareStatement("UPDATE books SET quantity = quantity - 1 WHERE book_id = ?");
                updateQty.setInt(1, internalBookId);
                updateQty.executeUpdate();
                
                response.sendRedirect("student_issue_dashboard.jsp?id=" + studentId + "&msg=Success");
            } else {
                // Book not found OR Out of stock
                response.sendRedirect("student_issue_dashboard.jsp?id=" + studentId + "&msg=OutOfStock");
            }
            con.close();
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("student_issue_dashboard.jsp?id=" + studentId + "&msg=Error");
        }
    }
}