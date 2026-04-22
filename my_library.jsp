<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.io.*" %>
<%
    // 1. GET LOGGED-IN STUDENT DETAILS FROM SESSION
    String studentId = (String) session.getAttribute("student_id");
    
    // Security check: Redirect to login if session is empty
    if(studentId == null || studentId.trim().isEmpty()) { 
        response.sendRedirect("student_login.jsp?error=Please Login First"); 
        return; 
    }
    
    // Variables to hold user data
    String studentName = "Student"; 
    String photoUrl = ""; 

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        // 2. FETCH STUDENT NAME AND PHOTO FROM DATABASE
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_system", "root", "3001");
        
        ps = con.prepareStatement("SELECT name, photo_url FROM lib_students WHERE library_id = ?");
        ps.setString(1, studentId);
        rs = ps.executeQuery();
        
        if(rs.next()) {
            studentName = rs.getString("name");
            photoUrl = rs.getString("photo_url");
            if(photoUrl == null) photoUrl = ""; 
        }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Library Dashboard</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Poppins', sans-serif; }
        
        /* --- PROFESSIONAL COLLEGE THEME BACKGROUND --- */
        body { 
            background: #f4f7f6; /* Soft, clean grey background so cards pop */
            color: #333; 
            min-height: 100vh;
        }

        /* --- Seamless College Blue Navbar --- */
        .navbar {
            background: #004499; /* College Blue */
            padding: 15px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 4px 15px rgba(0,68,153,0.2);
            position: sticky;
            top: 0;
            z-index: 100;
            border-bottom: 4px solid #ff6600; /* College Orange accent line */
        }
        
        .user-profile { display: flex; align-items: center; gap: 15px; }
        .user-profile img {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid #fff; /* Crisp white border */
            background: white;
            box-shadow: 0 2px 10px rgba(0,0,0,0.2);
        }
        .user-info h2 { font-size: 18px; color: #ffffff; margin-bottom: 2px; text-transform: capitalize; font-weight: 600; }
        .user-info p { font-size: 13px; color: #d1e3ff; letter-spacing: 0.5px; }
        
        .btn-logout {
            background: rgba(255, 255, 255, 0.1); color: #fff; padding: 10px 20px;
            border-radius: 8px; text-decoration: none; font-weight: 600;
            font-size: 14px; transition: 0.2s; display: flex; align-items: center; gap: 8px;
            border: 1px solid rgba(255,255,255,0.3);
        }
        .btn-logout:hover { background: #d32f2f; color: white; border-color: #d32f2f; }

        /* --- Main Content Area --- */
        .dashboard-container { max-width: 1200px; margin: 40px auto; padding: 0 20px; }
        
        .section-header { margin-bottom: 30px; display: flex; align-items: center; gap: 10px; color: #004499; }
        .section-header h2 { font-size: 26px; font-weight: 700; }

        /* --- Book Cards Grid --- */
        .book-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(340px, 1fr)); gap: 25px; }

        .book-card {
            background: #ffffff;
            border-radius: 16px; padding: 25px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.06);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            border-left: 6px solid #ccc; 
            display: flex; flex-direction: column; gap: 15px;
        }
        .book-card:hover { transform: translateY(-5px); box-shadow: 0 12px 35px rgba(0,0,0,0.1); }

        .status-returned { border-left-color: #2e7d32; }
        .status-issued { border-left-color: #ff6600; } /* Changed to College Orange */
        
        .card-header { display: flex; justify-content: space-between; align-items: flex-start; gap: 10px; }
        .book-title { font-size: 17px; font-weight: 700; color: #222; line-height: 1.3; }
        
        .badge { padding: 5px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; white-space: nowrap; }
        .badge-returned { background: #e8f5e9; color: #2e7d32; }
        .badge-issued { background: #fff0e6; color: #ff6600; } /* Matching orange */

        .book-author { font-size: 14px; color: #666; display: flex; align-items: center; gap: 8px; }

        .card-dates { background: #f8f9fa; padding: 15px; border-radius: 10px; display: flex; justify-content: space-between; border: 1px solid #eee; }
        .date-item { display: flex; flex-direction: column; }
        .date-item span { font-size: 11px; color: #888; text-transform: uppercase; font-weight: 600; margin-bottom: 3px; }
        .date-item strong { font-size: 14px; color: #333; }
        .date-item.due strong { color: #d32f2f; }

        .card-footer { font-size: 13px; font-weight: 500; display: flex; align-items: center; gap: 6px; }
        .text-success { color: #2e7d32; }
        .text-warning { color: #ff6600; }
        
        /* Empty State */
        .empty-state { text-align: center; color: #666; padding: 50px; font-size: 18px; grid-column: 1 / -1; background: #fff; border-radius: 15px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
    </style>
</head>
<body>

    <nav class="navbar">
        <div class="user-profile">
            <img src="ImageLoader?img=<%= photoUrl %>" alt="Profile" onerror="this.onerror=null; this.src='https://cdn-icons-png.flaticon.com/512/3135/3135715.png';">
            <div class="user-info">
                <h2><%= studentName %></h2>
                <p><%= studentId %></p>
            </div>
        </div>
        <a href="logout.jsp?role=student" class="btn-logout"><i class="fa-solid fa-power-off"></i> Logout</a>
    </nav>

    <main class="dashboard-container">
        
        <div class="section-header">
            <h2><i class="fa-solid fa-book-open"></i> My Borrowed Books</h2>
        </div>

        <div class="book-grid">

            <%
                PreparedStatement psBooks = con.prepareStatement(
                    "SELECT bt.*, b.title, b.author FROM book_transactions bt JOIN books b ON bt.book_id = b.book_id WHERE bt.student_id = ? ORDER BY bt.issue_date DESC"
                );
                psBooks.setString(1, studentId);
                ResultSet rsBooks = psBooks.executeQuery();
                
                boolean hasBooks = false;

                while(rsBooks.next()) {
                    hasBooks = true;
                    String title = rsBooks.getString("title");
                    String author = rsBooks.getString("author");
                    Date issueDate = rsBooks.getDate("issue_date");
                    Date dueDate = rsBooks.getDate("due_date");
                    String status = rsBooks.getString("status");
                    
                    boolean isReturned = "RETURNED".equalsIgnoreCase(status);
                    String cardClass = isReturned ? "status-returned" : "status-issued";
                    String badgeClass = isReturned ? "badge-returned" : "badge-issued";
                    String displayStatus = isReturned ? "Returned" : "Currently Issued";
            %>

            <div class="book-card <%= cardClass %>">
                <div class="card-header">
                    <h3 class="book-title"><%= title %></h3>
                    <span class="badge <%= badgeClass %>"><%= displayStatus %></span>
                </div>
                
                <p class="book-author"><i class="fa-solid fa-pen-nib"></i> <%= author %></p>
                
                <div class="card-dates">
                    <div class="date-item">
                        <span><i class="fa-regular fa-calendar-plus"></i> Issued On</span>
                        <strong><%= (issueDate != null) ? issueDate.toString() : "N/A" %></strong>
                    </div>
                    <div class="date-item due">
                        <span><i class="fa-regular fa-calendar-xmark"></i> Due Date</span>
                        <strong><%= (dueDate != null) ? dueDate.toString() : "N/A" %></strong>
                    </div>
                </div>

                <% if(isReturned) { %>
                    <div class="card-footer text-success">
                        <i class="fa-solid fa-circle-check"></i> Returned successfully.
                    </div>
                <% } else { %>
                    <div class="card-footer text-warning">
                        <i class="fa-solid fa-triangle-exclamation"></i> Please return by the due date.
                    </div>
                <% } %>
            </div>

            <%
                } 
                
                if(!hasBooks) {
            %>
                <div class="empty-state">
                    <i class="fa-solid fa-book-open-reader" style="font-size: 40px; margin-bottom: 15px; color: #004499;"></i><br>
                    You have not borrowed any books yet.
                </div>
            <%
                }
            %>

        </div>
    </main>

</body>
</html>
<%
    } catch(Exception e) {
        out.println("<div style='color:red; text-align:center; padding:20px; background:white;'>Error Loading Dashboard: " + e.getMessage() + "</div>");
        e.printStackTrace();
    } finally {
        if(rs != null) try { rs.close(); } catch(SQLException e) {}
        if(ps != null) try { ps.close(); } catch(SQLException e) {}
        if(con != null) try { con.close(); } catch(SQLException e) {}
    }
%>