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
    <meta charset="UTF-8">
    <title>Library Inventory</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        /* --- GLOBAL THEME --- */
        body { 
            font-family: 'Poppins', sans-serif; 
            margin: 0; 
            padding: 20px; 
            min-height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #333;
        }

        /* --- NAVIGATION --- */
        .nav-bar { 
            display: flex; 
            justify-content: space-between; 
            max-width: 1200px; 
            margin: 0 auto 30px; 
            padding: 0 10px;
        }
        
        .btn { 
            padding: 12px 25px; 
            text-decoration: none; 
            border-radius: 50px; 
            font-weight: 600; 
            font-size: 14px;
            transition: transform 0.2s, box-shadow 0.2s; 
            box-shadow: 0 4px 10px rgba(0,0,0,0.2);
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-back { 
            background: rgba(255, 255, 255, 0.9); 
            color: #764ba2; 
        }
        .btn-back:hover { background: #fff; transform: translateY(-2px); }

        .btn-add { 
            background: linear-gradient(to right, #00c6ff, #0072ff); 
            color: white; 
        }
        .btn-add:hover { transform: translateY(-2px); box-shadow: 0 6px 15px rgba(0, 114, 255, 0.4); }

        /* --- GLASS TABLE CARD --- */
        .table-container {
            max-width: 1200px;
            margin: 0 auto;
            background: rgba(255, 255, 255, 0.95); 
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.2);
            
            /* 🔥 FIX 1: Allow content to spill out so QR code isn't cut */
            overflow: visible !important; 
            
            padding: 20px;
        }

        h2 {
            text-align: center;
            color: white;
            margin-bottom: 25px;
            font-weight: 600;
            text-shadow: 0 2px 4px rgba(0,0,0,0.2);
        }

        /* --- TABLE STYLES --- */
        table { 
            width: 100%; 
            border-collapse: collapse; 
            margin-top: 10px;
        }
        
        thead {
            background: linear-gradient(to right, #667eea, #764ba2);
            color: white;
        }

        th { 
            padding: 18px 15px; 
            font-weight: 500; 
            font-size: 13px; 
            letter-spacing: 0.5px; 
            text-transform: uppercase;
            text-align: center;
        }

        th:first-child { border-top-left-radius: 10px; }
        th:last-child { border-top-right-radius: 10px; }

        td { 
            padding: 15px; 
            border-bottom: 1px solid #eee; 
            text-align: center; 
            vertical-align: middle; 
            font-size: 14px; 
            color: #555;
        }

        tr:last-child td { border-bottom: none; }
        tbody tr:hover { background-color: #f8f9fa; }

        /* --- ELEMENT STYLES --- */
        .dept-badge {
            background: #eef2ff; 
            color: #667eea; 
            padding: 5px 12px; 
            border-radius: 15px; 
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
        }

        .qr-wrapper {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 5px;
            position: relative; /* Anchor for stacking context */
        }

        .qr-img { 
            width: 60px; 
            height: 60px; 
            border-radius: 8px; 
            border: 1px solid #ddd; 
            padding: 2px;
            background: white;
            transition: transform 0.2s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            
            /* Ensure smooth scaling */
            position: relative;
            z-index: 1;

            /* 🔥 FIX 4: Moved transform-origin HERE so it always anchors left */
            transform-origin: left center; 
        }
        
        /* 🔥 FIX 2 & 3: Zoom to the RIGHT and stay on TOP */
        .qr-img:hover { 
            transform: scale(3.5); 
            /* transform-origin removed from here because it's now global */
            z-index: 9999; 
            box-shadow: 0 15px 40px rgba(0,0,0,0.4);
            border: 2px solid white; /* Adds contrast against text */
        }
        
        .btn-download {
            background: #28a745;
            color: white;
            border: none;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 11px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            margin-top: 5px;
        }
        .btn-download:hover { background: #218838; }

        .delete-btn { 
            background: #ff4d4d; 
            color: white; 
            text-decoration: none; 
            padding: 6px 12px; 
            border-radius: 6px; 
            font-size: 12px; 
            transition: 0.2s;
            display: inline-block;
        }
        .delete-btn:hover { background: #d63030; box-shadow: 0 3px 8px rgba(214, 48, 48, 0.3); }

    </style>
    
    <script>
        function confirmDelete(bookName) {
            return confirm("⚠️ Are you sure you want to delete '" + bookName + "'?");
        }

        async function downloadQR(imageUrl, fileName) {
            try {
                const response = await fetch(imageUrl);
                const blob = await response.blob();
                const link = document.createElement("a");
                link.href = URL.createObjectURL(blob);
                link.download = fileName + ".png"; 
                document.body.appendChild(link);
                link.click();
                document.body.removeChild(link);
            } catch (error) {
                alert("Could not download image. Try right-clicking and 'Save Image As'.");
            }
        }
    </script>
</head>
<body>

    <div class="nav-bar">
        <a href="admin_dashboard.jsp" class="btn btn-back">⬅ Dashboard</a>
        <a href="add_book.jsp" class="btn btn-add">➕ Add New Book</a>
    </div>
    
    <h2>📚 Library Inventory (Department Wise)</h2>

    <div class="table-container">
        <table>
            <thead>
                <tr>
                    <th>QR Code</th>
                    <th>Title</th>
                    <th>Author</th>
                    <th>Department</th>
                    <th>Publication Year</th>
                    <th>Added On</th>
                    <th>Qty</th>
                    <th>Action</th> 
                </tr>
            </thead>
            <tbody>

            <%
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_system", "root", "3001");
                    
                    Statement stmt = con.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT * FROM books ORDER BY department ASC, entry_date DESC");

                    while(rs.next()) {
                        String qrLink = rs.getString("qr_code");
                        String title = rs.getString("title");
                        // Clean title for filename (remove spaces/symbols)
                        String safeTitle = title.replaceAll("[^a-zA-Z0-9]", "_");
            %>
                <tr>
                    <td>
                        <div class="qr-wrapper">
                            <a href="issue_book.jsp?id=<%= rs.getInt("book_id") %>&title=<%= title %>&author=<%= rs.getString("author") %>&qty=<%= rs.getInt("quantity") %>">
                                <img src="<%= qrLink %>" alt="QR" class="qr-img">
                            </a>
                            
                            <button class="btn-download" onclick="downloadQR('<%= qrLink %>', 'QR_<%= safeTitle %>')">
                                ⬇️ Save
                            </button>
                        </div>
                    </td>

                    <td style="font-weight: 600; color: #333;"><%= title %></td>
                    <td><%= rs.getString("author") %></td>
                    <td><span class="dept-badge"><%= rs.getString("department") %></span></td>
                    <td><%= rs.getInt("publication_year") %></td>
                    
                    <td style="font-size: 12px; color: #888;">
                        <%= rs.getTimestamp("entry_date").toString().substring(0, 16) %>
                    </td>
                    
                    <td style="font-weight: bold; color: #333;"><%= rs.getInt("quantity") %></td>

                    <td>
                        <a href="${pageContext.request.contextPath}/DeleteBookServlet?id=<%= rs.getInt("book_id") %>" 
                           class="delete-btn"
                           onclick="return confirmDelete('<%= title %>')">
                           ✕ Delete
                        </a>
                    </td>
                </tr>
            <%
                    }
                    con.close();
                } catch (Exception e) {
                    out.println("<tr><td colspan='8' style='color:red;'>Error: " + e.getMessage() + "</td></tr>");
                }
            %>
            </tbody>
        </table>
    </div>

</body>
</html>