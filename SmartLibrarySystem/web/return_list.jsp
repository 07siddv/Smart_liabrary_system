<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Return Book</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background-color: #f4f6f9; padding: 20px; text-align: center; }
        h2 { color: #333; }
        table { width: 90%; margin: 0 auto; border-collapse: collapse; background: white; box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
        th, td { padding: 15px; border-bottom: 1px solid #ddd; text-align: center; }
        th { background-color: #28a745; color: white; } /* Green header for Returns */
        tr:hover { background-color: #f1f1f1; }
        img { width: 80px; height: 80px; cursor: pointer; border: 2px solid transparent; border-radius: 5px; }
        img:hover { border-color: #28a745; transform: scale(1.1); transition: 0.2s; }
        .back-btn { display: inline-block; margin-bottom: 20px; padding: 10px 20px; background: #6c757d; color: white; text-decoration: none; border-radius: 5px; }
        .scan-hint { color: #28a745; font-size: 0.85em; font-weight: bold; }
    </style>
</head>
<body>

    <a href="admin_dashboard.jsp" class="back-btn">⬅ Back to Dashboard</a>
    
    <h2>↩️ Return Book Scanner</h2>
    <p>Click on a QR Code to simulate "Scanning" and <b>Return</b> the book.</p>

    <table>
        <tr>
            <th>ID</th>
            <th>Title</th>
            <th>Author</th>
            <th>Qty</th>
            <th>Action</th>
        </tr>

        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_system", "root", "3001");
                
                Statement stmt = con.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT * FROM books");

                while(rs.next()) {
        %>
            <tr>
                <td><%= rs.getInt("book_id") %></td>
                <td><%= rs.getString("title") %></td>
                <td><%= rs.getString("author") %></td>
                <td><%= rs.getInt("quantity") %></td>
                <td>
                    <a href="return_confirm.jsp?id=<%= rs.getInt("book_id") %>&title=<%= rs.getString("title") %>">
                        <img src="<%= rs.getString("qr_code") %>" alt="Scan to Return">
                    </a>
                    <br><span class="scan-hint">🖱 Click to Return</span>
                </td>
            </tr>
        <%
                }
                con.close();
            } catch (Exception e) {
                out.println("<tr><td colspan='5'>Error: " + e.getMessage() + "</td></tr>");
            }
        %>
    </table>

</body>
</html>