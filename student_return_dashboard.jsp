<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    // 1. KILLS BROWSER CACHE
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); 
    response.setHeader("Pragma", "no-cache"); 
    response.setDateHeader("Expires", 0); 

    // Optional: If Admin is not logged in, kick them out completely 
    // Uncomment this and change "admin_email" to your actual admin session variable
    // if(session.getAttribute("admin_email") == null) { response.sendRedirect("admin_login.jsp"); return; }

    // 2. CHECK IF ADMIN CLICKED "CLOSE PROFILE"
    if ("close".equals(request.getParameter("action"))) {
        session.removeAttribute("active_student_id"); // Erase student from server memory
        response.sendRedirect("issue_book.jsp"); // Send back to scanner
        return;
    }

    // 3. CAPTURE NEW SCAN & CLEAN THE URL (The Magic Fix)
    String urlId = request.getParameter("id");
    if (urlId != null && !urlId.trim().isEmpty()) {
        session.setAttribute("active_student_id", urlId); // Save ID to invisible server memory
        response.sendRedirect("student_issue_dashboard.jsp"); // Reload page to erase "?id=" from the URL
        return;
    }

    // 4. GET STUDENT ID FROM SECURE MEMORY
    String studentId = (String) session.getAttribute("active_student_id");
    
    // If memory is empty (because they clicked Close or hit Back), force back to scanner
    if(studentId == null || studentId.trim().isEmpty()) {
        response.sendRedirect("issue_book.jsp"); 
        return;
    }
    
    String name = "Unknown", photo = "images/default.png", dept = "N/A", officialId = studentId; 
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_system", "root", "3001");
        
        // Fetch Student Details
        PreparedStatement ps = con.prepareStatement("SELECT * FROM lib_students WHERE library_id = ? OR roll_no = ?");
        ps.setString(1, studentId);
        ps.setString(2, studentId);
        ResultSet rs = ps.executeQuery();
        
        if(rs.next()) {
            name = rs.getString("name");
            photo = rs.getString("photo_url");
            dept = rs.getString("class_name");
            officialId = rs.getString("library_id");
        } else {
            response.sendRedirect("issue_book.jsp?error=StudentNotFound");
            return;
        }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Returning: <%= name %></title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <script src="https://unpkg.com/html5-qrcode" type="text/javascript"></script>
    
    <style>
        /* --- PURPLE THEME --- */
        body { font-family: 'Poppins', sans-serif; background: #f4f6f9; padding: 20px; }
        .container { max-width: 1100px; margin: 0 auto; display: flex; gap: 20px; }
        
        /* Left: Student Profile */
        .profile-card { flex: 0.8; background: white; padding: 30px; border-radius: 15px; text-align: center; box-shadow: 0 4px 15px rgba(0,0,0,0.1); height: fit-content; }
        .profile-img { width: 120px; height: 120px; border-radius: 50%; object-fit: cover; border: 4px solid #764ba2; margin-bottom: 15px; }
        
        /* Right: Action Area */
        .action-area { flex: 2.2; display: flex; flex-direction: column; gap: 20px; }
        
        .scan-book-box { background: white; padding: 20px; border-radius: 15px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); text-align: center; }
        .scan-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; }
        
        /* Camera Box */
        #book-reader { width: 100%; border-radius: 10px; overflow: hidden; border: 2px dashed #764ba2; background: #eee; display: none; margin-bottom: 15px; }
        
        .btn-start { background: #667eea; color: white; padding: 8px 20px; border: none; border-radius: 50px; font-weight: bold; cursor: pointer; transition: 0.2s; font-size: 13px; }
        .btn-start:hover { background: #764ba2; }
        .btn-stop { background: #d9534f; display: none; }

        /* History Table */
        .history-box { background: white; padding: 25px; border-radius: 15px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); text-align: left; }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th { background: #f8f9fa; padding: 12px; text-align: left; font-size: 12px; color: #666; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; }
        td { padding: 15px 12px; border-bottom: 1px solid #eee; font-size: 13px; vertical-align: middle; }
        
        .book-title { font-weight: 600; color: #333; display: block; font-size: 14px; }
        .book-author { font-size: 11px; color: #888; }
        .unique-badge { background: #eef2ff; color: #667eea; padding: 4px 8px; border-radius: 6px; font-size: 11px; font-weight: 600; }
        
        .status-issued { color: #d35400; font-weight: bold; background: #fff3e0; padding: 5px 10px; border-radius: 20px; font-size: 11px; }
        .status-returned { color: #28a745; font-weight: bold; background: #e8f5e9; padding: 5px 10px; border-radius: 20px; font-size: 11px; }
    </style>
</head>
<body>

<div class="container">
    <div class="profile-card">
        <img src="<%= photo %>" class="profile-img" onerror="this.src='images/default.png'">
        
        <h2 style="margin: 10px 0;"><%= name %></h2>
        <p style="color: #666; font-size: 13px; margin: 0;"><%= officialId %></p>
        <div style="margin-top: 15px;">
            <span style="background: #f3e8ff; color: #764ba2; padding: 5px 12px; border-radius: 20px; font-size: 12px; font-weight: bold;"><%= dept %></span>
        </div>
        <br>
        <a href="student_issue_dashboard.jsp?action=close" style="color: #d9534f; text-decoration: none; font-size: 12px; border: 1px solid #d9534f; padding: 8px 20px; border-radius: 5px; display: inline-block; margin-top: 10px;">❌ Close Student</a>
    </div>

    <div class="action-area">
        
        <div class="scan-book-box">
            <div class="scan-header">
                <h3 style="margin:0;">♻️ Return Book</h3>
                
                <%-- MESSAGES --%>
                <% if("Returned".equals(request.getParameter("msg"))) { %>
                    <span style="color: #28a745; font-weight: bold; background: #e8f5e9; padding: 5px 10px; border-radius: 5px; font-size: 13px;">✅ Book Returned!</span>
                <% } else if("NotIssued".equals(request.getParameter("msg"))) { %>
                    <span style="color: #c62828; font-weight: bold; background: #ffebee; padding: 5px 10px; border-radius: 5px; font-size: 13px;">⚠️ Student didn't borrow this</span>
                <% } else if("InvalidBook".equals(request.getParameter("msg"))) { %>
                    <span style="color: #c62828; font-weight: bold; background: #ffebee; padding: 5px 10px; border-radius: 5px; font-size: 13px;">⚠️ Invalid Book QR</span>
                <% } %>
            </div>

            <button id="startBtn" class="btn-start" onclick="startCamera()">📷 Scan Return QR</button>
            <button id="stopBtn" class="btn-start btn-stop" onclick="stopCamera()">🛑 Stop</button>

            <div id="book-reader" style="margin-top: 15px;"></div>
            
            <form id="bookForm" action="ProcessReturnServlet" method="post" style="margin-top: 15px;">
                <input type="hidden" name="student_id" value="<%= officialId %>">
                <input type="text" id="bookIdInput" name="book_unique_id" placeholder="Scan Book to Return..." style="width: 100%; padding: 12px; border: 1px solid #ccc; border-radius: 8px; font-size: 14px;" autocomplete="off">
                <button type="submit" style="display:none;"></button>
            </form>
        </div>

        <div class="history-box">
            <h3 style="margin-top: 0; margin-bottom: 5px;">📂 Borrow History</h3>
            <table>
                <thead>
                    <tr>
                        <th style="width: 35%;">Book Details</th>
                        <th style="width: 20%;">Book ID</th>
                        <th>Issue Date</th>
                        <th>Return Date</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        String query = "SELECT t.issue_date, t.return_date, t.status, b.title, b.author, b.unique_id " +
                                       "FROM book_transactions t " +
                                       "JOIN books b ON t.book_id = b.book_id " +
                                       "WHERE t.student_id = ? " +
                                       "ORDER BY t.issue_date DESC";
                                       
                        PreparedStatement histPs = con.prepareStatement(query);
                        histPs.setString(1, officialId);
                        ResultSet histRs = histPs.executeQuery();
                        boolean hasData = false;
                        
                        while(histRs.next()) { 
                            hasData = true;
                            String status = histRs.getString("status");
                            Date retDate = histRs.getDate("return_date");
                    %>
                    <tr>
                        <td>
                            <span class="book-title"><%= histRs.getString("title") %></span>
                            <span class="book-author">by <%= histRs.getString("author") %></span>
                        </td>
                        <td>
                            <span class="unique-badge"><%= histRs.getString("unique_id") %></span>
                        </td>
                        <td style="color: #555;"><%= histRs.getDate("issue_date") %></td>
                        <td style="color: #555;"><%= (retDate != null) ? retDate : "-" %></td>
                        <td>
                            <% if("ISSUED".equals(status)) { %>
                                <span class="status-issued">On Loan</span>
                            <% } else { %>
                                <span class="status-returned">Returned</span>
                            <% } %>
                        </td>
                    </tr>
                    <% } if(!hasData) { %> 
                        <tr><td colspan="5" style="text-align:center; color:#999; padding: 30px;">No books borrowed yet.</td></tr> 
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
    const currentStudentId = "<%= officialId %>";
    let html5QrcodeScanner = null;
    let isProcessing = false;

    function startCamera() {
        isProcessing = false;
        document.getElementById("book-reader").style.display = "block";
        document.getElementById("startBtn").style.display = "none";
        document.getElementById("stopBtn").style.display = "inline-block";

        html5QrcodeScanner = new Html5QrcodeScanner("book-reader", { fps: 10, qrbox: {width: 250, height: 250} }, false);
        html5QrcodeScanner.render(onBookScanSuccess);
    }

    function stopCamera() {
        if(html5QrcodeScanner) { html5QrcodeScanner.clear(); }
        document.getElementById("book-reader").style.display = "none";
        document.getElementById("startBtn").style.display = "inline-block";
        document.getElementById("stopBtn").style.display = "none";
    }

    function onBookScanSuccess(decodedText) {
        if (isProcessing) return;
        
        if(decodedText === currentStudentId) {
            alert("⚠️ You scanned the Student Card again!\nPlease scan a Book to RETURN.");
            return;
        }

        isProcessing = true;
        
        document.getElementById("book-reader").innerHTML = '<p style="padding:20px; font-weight:bold; color:#28a745;">✅ Scanned! Returning...</p>';
        document.getElementById("stopBtn").style.display = "none";

        let beep = new Audio('https://actions.google.com/sounds/v1/alarms/beep_short.ogg');
        beep.play();

        if(html5QrcodeScanner) {
            html5QrcodeScanner.clear().then(() => {
                submitForm(decodedText);
            }).catch(err => {
                submitForm(decodedText);
            });
        } else {
            submitForm(decodedText);
        }
    }

    function submitForm(bookId) {
        document.getElementById('bookIdInput').value = bookId;
        document.getElementById('bookForm').submit();
    }
</script>

</body>
</html>
<%
        con.close();
    } catch(Exception e) { out.println("Error: " + e.getMessage()); }
%>