<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    // 🔥 SECURITY FIX: Prevent Browser Caching (Kills the Back Button Issue)
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); 
    response.setHeader("Pragma", "no-cache"); 
    response.setDateHeader("Expires", 0); 
%>

<%
    // Security Check
    if(session.getAttribute("user") == null) {
        response.sendRedirect("admin_login.jsp");
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Book Management Log</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        /* --- GLOBAL THEME --- */
        body { 
            font-family: 'Poppins', sans-serif; 
            margin: 0; padding: 20px; min-height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #333;
        }

        .nav-bar { display: flex; justify-content: space-between; max-width: 1200px; margin: 0 auto 30px; padding: 0 10px; }
        .btn-back { 
            background: rgba(255, 255, 255, 0.9); color: #764ba2; padding: 10px 20px; 
            text-decoration: none; border-radius: 50px; font-weight: 600; font-size: 14px; 
            box-shadow: 0 4px 10px rgba(0,0,0,0.2); transition: 0.2s; display: flex; align-items: center; gap: 5px;
        }
        .btn-back:hover { background: #fff; transform: translateY(-2px); }

        .table-container { 
            max-width: 1200px; margin: 0 auto; background: rgba(255, 255, 255, 0.95); 
            border-radius: 20px; box-shadow: 0 15px 35px rgba(0,0,0,0.2); overflow: hidden; padding: 20px; 
            animation: fadeIn 0.8s ease-out; 
        }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }

        h2 { text-align: center; color: white; margin-bottom: 5px; text-shadow: 0 2px 4px rgba(0,0,0,0.2); }
        p.subtitle { text-align: center; color: rgba(255,255,255,0.8); margin-bottom: 25px; font-size: 13px; }

        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        thead { background: linear-gradient(to right, #667eea, #764ba2); color: white; }
        th { padding: 15px; font-size: 13px; text-transform: uppercase; text-align: left; }
        th:first-child { border-top-left-radius: 10px; }
        th:last-child { border-top-right-radius: 10px; }
        td { padding: 12px 15px; border-bottom: 1px solid #eee; font-size: 13px; color: #555; vertical-align: middle; }
        
        /* 🔥 FIX: ONLY HOVER ON DATA ROWS, NOT HEADER */
        tbody tr:hover { background-color: #f8f9fa; }

        .status-issued { background: #fff3e0; color: #d35400; padding: 4px 10px; border-radius: 15px; font-weight: bold; font-size: 11px; }
        .status-returned { background: #e8f5e9; color: #28a745; padding: 4px 10px; border-radius: 15px; font-weight: bold; font-size: 11px; }

        .id-badge { font-family: monospace; background: #f4f6f9; padding: 4px 6px; border-radius: 4px; border: 1px solid #e1e4e8; color: #333; font-size: 12px; }
    </style>
</head>
<body>

    <div class="nav-bar">
        <a href="admin_dashboard.jsp" class="btn-back">⬅ Dashboard</a>
    </div>

    <h2>📋 Book Management Log</h2>
    <p class="subtitle">Complete history of issued and returned books</p>

    <div class="table-container">
        <table>
            <thead>
                <tr>
                    <th>Status</th>
                    <th>Book Details</th>
                    <th>Student Details</th>
                    <th>Issue Date</th>
                    <th>Due Date</th>
                    <th>Return Date</th>
                </tr>
            </thead>
            <tbody>
            <%
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_system", "root", "3001");
                    
                    String query = "SELECT t.*, b.title, b.unique_id AS book_uid, s.name AS student_name, s.library_id " +
                                   "FROM book_transactions t " +
                                   "JOIN books b ON t.book_id = b.book_id " +
                                   "JOIN lib_students s ON t.student_id = s.library_id " +
                                   "ORDER BY t.issue_date DESC";
                                   
                    Statement stmt = con.createStatement();
                    ResultSet rs = stmt.executeQuery(query);
                    
                    while(rs.next()) {
                        String status = rs.getString("status");
                        Date retDate = rs.getDate("return_date");
            %>
                <tr>
                    <td>
                        <% if("ISSUED".equals(status)) { %>
                            <span class="status-issued">ON LOAN</span>
                        <% } else { %>
                            <span class="status-returned">RETURNED</span>
                        <% } %>
                    </td>
                    <td>
                        <span style="font-weight:600; color:#333; display:block;"><%= rs.getString("title") %></span>
                        <span class="id-badge"><%= rs.getString("book_uid") %></span>
                    </td>
                    <td>
                        <span style="font-weight:600; color:#333; display:block;"><%= rs.getString("student_name") %></span>
                        <span class="id-badge"><%= rs.getString("library_id") %></span>
                    </td>
                    <td><%= rs.getDate("issue_date") %></td>
                    <td style="color: #d9534f; font-weight:500;"><%= rs.getDate("due_date") %></td>
                    <td>
                        <% if(retDate != null) { %>
                            <%= retDate %>
                        <% } else { %>
                            <span style="color:#ccc;">-</span>
                        <% } %>
                    </td>
                </tr>
            <%
                    }
                    con.close();
                } catch (Exception e) {
                    out.println("<tr><td colspan='6' style='color:red;'>Error: " + e.getMessage() + "</td></tr>");
                }
            %>
            </tbody>
        </table>
    </div>

</body>
</html>