import java.io.*;
import java.sql.*;
import java.net.URLEncoder;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

@WebServlet("/AddStudentServlet")
@MultipartConfig
public class AddStudentServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // 1. Check/Create Image Folder
        File uploadDir = new File("C:/library_images/");
        if (!uploadDir.exists()) uploadDir.mkdirs();

        String name = request.getParameter("name");
        String rollNo = request.getParameter("roll_no");
        String className = request.getParameter("class_name");
        String section = request.getParameter("section");
        String dob = request.getParameter("dob");
        String contact = request.getParameter("contact");
        
        // --- 🔥 NEW UNIQUE ID LOGIC ---
        
        // Part 1: First 4 Letters of Name (Capitalized)
        // Example: "Siddhant" -> "SIDD"
        String namePart = (name != null && name.length() > 4) ? name.substring(0, 4).toUpperCase() : name.toUpperCase();
        
        // Part 2: Class Name + Section (Combined)
        // Example: Class="BCA", Section="A" -> "BCAA"
        String classPart = (className + section).replaceAll("\\s+", "").toUpperCase(); // Removes spaces just in case
        
        // Part 3: Last 4 Digits of Roll No
        // Example: "1205401465" -> "1465"
        String rollPart = "0000"; 
        if (rollNo != null && rollNo.length() >= 4) {
            rollPart = rollNo.substring(rollNo.length() - 4);
        } else if (rollNo != null) {
            rollPart = rollNo; // Use full roll no if it's short
        }

        // Final ID: SIDD-BCAA-1465
        String libraryId = namePart + "-" + classPart + "-" + rollPart;
        
        // ------------------------------
        
        String qrCodeUrl = "https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=" + libraryId;

        // Save Photo logic (Kept same as it works)
        Part filePart = request.getPart("photo");
        String fileName = "default.png";
        
        if (filePart != null && filePart.getSize() > 0) {
            fileName = libraryId + ".jpg"; 
            filePart.write("C:/library_images/" + fileName);
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_system", "root", "3001");
            
            String query = "INSERT INTO lib_students (name, roll_no, class_name, section, dob, contact, library_id, qr_code_url, photo_url) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, name);
            ps.setString(2, rollNo);
            ps.setString(3, className);
            ps.setString(4, section);
            ps.setString(5, dob);
            ps.setString(6, contact);
            ps.setString(7, libraryId);
            ps.setString(8, qrCodeUrl);
            ps.setString(9, fileName);
            
            ps.executeUpdate();
            response.sendRedirect("view_students.jsp?msg=Added");
            
        } catch (Exception e) {
            e.printStackTrace();
            String errorMessage = URLEncoder.encode(e.getMessage(), "UTF-8");
            response.sendRedirect("add_student.jsp?error=" + errorMessage);
        }
    }
}