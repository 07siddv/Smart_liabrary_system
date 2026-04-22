import java.io.*;
import java.sql.*;
import java.time.LocalDate;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

@WebServlet("/ProcessReturnServlet")
public class ProcessReturnServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        String studentId = request.getParameter("student_id");
        String bookUniqueId = request.getParameter("book_unique_id"); // E.g., "PYTH-JAME-2023"
        LocalDate today = LocalDate.now();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_system", "root", "3001");
            
            // 1. Get internal Book ID from the scanned Unique ID
            int bookId = -1;
            PreparedStatement getBook = con.prepareStatement("SELECT book_id FROM books WHERE unique_id = ?");
            getBook.setString(1, bookUniqueId);
            ResultSet rsBook = getBook.executeQuery();
            
            if(rsBook.next()) {
                bookId = rsBook.getInt("book_id");

                // 2. Check if this student currently has this book ISSUED
                String checkQuery = "SELECT trans_id FROM book_transactions WHERE student_id=? AND book_id=? AND status='ISSUED'";
                PreparedStatement checkPs = con.prepareStatement(checkQuery);
                checkPs.setString(1, studentId);
                checkPs.setInt(2, bookId);
                ResultSet rsCheck = checkPs.executeQuery();
                
                if(rsCheck.next()) {
                    // --- SUCCESS: BOOK FOUND & ISSUED ---
                    
                    // 3. Update Transaction (Mark as Returned)
                    PreparedStatement updateTrans = con.prepareStatement("UPDATE book_transactions SET return_date=?, status='RETURNED' WHERE student_id=? AND book_id=? AND status='ISSUED'");
                    updateTrans.setDate(1, java.sql.Date.valueOf(today));
                    updateTrans.setString(2, studentId);
                    updateTrans.setInt(3, bookId);
                    updateTrans.executeUpdate();
                    
                    // 4. Increase Book Quantity (+1)
                    PreparedStatement updateQty = con.prepareStatement("UPDATE books SET quantity = quantity + 1 WHERE book_id = ?");
                    updateQty.setInt(1, bookId);
                    updateQty.executeUpdate();
                    
                    response.sendRedirect("student_return_dashboard.jsp?id=" + studentId + "&msg=Returned");
                } else {
                    // Error: Student didn't borrow this book
                    response.sendRedirect("student_return_dashboard.jsp?id=" + studentId + "&msg=NotIssued");
                }
            } else {
                 // Error: Invalid Book QR
                 response.sendRedirect("student_return_dashboard.jsp?id=" + studentId + "&msg=InvalidBook");
            }
            con.close();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}