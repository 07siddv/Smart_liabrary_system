<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    // 🔥 SECURITY FIX: Prevent Browser Caching (Kills the Back Button Issue)
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); 
    response.setHeader("Pragma", "no-cache"); 
    response.setDateHeader("Expires", 0); 
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Student List & ID Cards</title>
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
        .btn { padding: 12px 25px; text-decoration: none; border-radius: 50px; font-weight: 600; font-size: 14px; transition: transform 0.2s, box-shadow 0.2s; box-shadow: 0 4px 10px rgba(0,0,0,0.2); display: inline-flex; align-items: center; gap: 8px; }
        .btn-back { background: rgba(255, 255, 255, 0.9); color: #764ba2; }
        .btn-back:hover { background: #fff; transform: translateY(-2px); }
        .btn-add { background: linear-gradient(to right, #11998e, #38ef7d); color: white; }
        .btn-add:hover { transform: translateY(-2px); box-shadow: 0 6px 15px rgba(56, 239, 125, 0.4); }
        
        .table-container { max-width: 1200px; margin: 0 auto; background: rgba(255, 255, 255, 0.95); border-radius: 20px; box-shadow: 0 15px 35px rgba(0,0,0,0.2); overflow: hidden; padding: 20px; animation: fadeIn 0.8s ease-out; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        
        h2.page-title { text-align: center; color: white; margin-bottom: 5px; font-weight: 600; text-shadow: 0 2px 4px rgba(0,0,0,0.2); }
        p.subtitle { text-align: center; color: rgba(255,255,255,0.8); margin-bottom: 25px; font-size: 13px; }
        
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        thead { background: linear-gradient(to right, #667eea, #764ba2); color: white; }
        th { padding: 18px 15px; font-weight: 500; font-size: 13px; letter-spacing: 0.5px; text-transform: uppercase; text-align: center; }
        th:first-child { border-top-left-radius: 10px; }
        th:last-child { border-top-right-radius: 10px; }
        td { padding: 15px; border-bottom: 1px solid #eee; text-align: center; vertical-align: middle; font-size: 14px; color: #555; }
        tr:last-child td { border-bottom: none; }
        tbody tr:hover { background-color: #f8f9fa; }
        
        .photo-thumb { width: 50px; height: 50px; border-radius: 50%; object-fit: cover; border: 2px solid #ddd; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        .unique-id-badge { font-weight: 700; color: #d35400; background: #fff3e0; padding: 5px 10px; border-radius: 8px; font-size: 13px; letter-spacing: 0.5px; border: 1px solid #ffe0b2; }
        
        .action-btns { display: flex; justify-content: center; gap: 8px; }
        
        /* Updated Print Button Style for Link */
        .btn-print { 
            background: #6c757d; 
            color: white; 
            text-decoration: none; 
            padding: 6px 12px; 
            border-radius: 6px; 
            font-size: 12px; 
            cursor: pointer; 
            transition: 0.2s; 
            display: inline-block;
        }
        .btn-print:hover { background: #5a6268; transform: scale(1.05); }
        
        .btn-delete { background-color: #ff4d4d; color: white; text-decoration: none; padding: 6px 12px; border-radius: 6px; font-size: 12px; transition: 0.2s; }
        .btn-delete:hover { background-color: #d63030; transform: scale(1.05); }

    </style>
    
    <script>
        function confirmDelete(name) { return confirm("⚠️ Are you sure you want to delete student: " + name + "?"); }
    </script>
</head>
<body>

    <div class="nav-bar">
        <a href="admin_dashboard.jsp" class="btn btn-back">⬅ Dashboard</a>
        <a href="add_student.jsp" class="btn btn-add">➕ Add Student</a>
    </div>

    <h2 class="page-title">🎓 Student Library Cards</h2>
    <p class="subtitle">Manage students and print Identity Cards</p>

    <div class="table-container">
        <table>
            <thead>
                <tr><th>Photo</th><th>Unique ID</th><th>Roll No</th><th>Name</th><th>Class</th><th>Contact</th><th>Action</th></tr>
            </thead>
            <tbody>
            <%
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_system", "root", "3001");
                    Statement stmt = con.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT * FROM lib_students ORDER BY class_name ASC");
                    
                    while(rs.next()) {
                        String roll = rs.getString("roll_no");
                        String name = rs.getString("name");
                        String dept = rs.getString("class_name");
                        
                        // --- IMAGE LOADER ---
                        String photoFilename = rs.getString("photo_url");
                        String photoUrl = "ImageLoader?img=" + photoFilename;
                        // --------------------
                        
                        String libId = rs.getString("library_id");
                        String displayLibId = (libId == null) ? "<span style='color:#ccc; font-size:10px;'>(Re-add Student)</span>" : libId;
                        
                        // Determine ID to pass to print page
                        String qrData = (libId == null) ? roll : libId;
            %>
                <tr>
                    <td><img src="<%= photoUrl %>" class="photo-thumb" onerror="this.src='images/default.png'"></td>
                    
                    <td><span class="unique-id-badge"><%= displayLibId %></span></td>
                    <td style="font-weight: 600; font-size: 13px; color: #666;"><%= roll %></td>
                    <td><%= name %></td>
                    <td><span style="background:#eef2ff; color:#667eea; padding:4px 10px; border-radius:10px; font-size:12px; font-weight:600;"><%= dept %></span></td>
                    <td><%= rs.getString("contact") %></td>
                    <td>
                        <div class="action-btns">
                            <a href="print_id.jsp?id=<%= qrData %>" target="_blank" class="btn-print">🖨️ Print</a>
                            
                            <a href="${pageContext.request.contextPath}/DeleteStudentServlet?roll_no=<%= roll %>" class="btn-delete" onclick="return confirmDelete('<%= name %>')">✕</a>
                        </div>
                    </td>
                </tr>
            <%
                    }
                    con.close();
                } catch (Exception e) { out.println("<tr><td colspan='7' style='color:red;'>Error: " + e.getMessage() + "</td></tr>"); }
            %>
            </tbody>
        </table>
    </div>
</body>
</html>