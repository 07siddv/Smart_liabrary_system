<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 1. KILL BROWSER CACHE (Stops the back/forward button ghosting)
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // 2. THE SECURITY BOUNCER: Check if the session is actually valid!
    // NOTE: Change "admin_email" if your login servlet uses a different session variable name
    if (session.getAttribute("user") == null) {
        response.sendRedirect("admin_login.jsp?error=Please Login First");
        return; // Stops loading the rest of the dashboard
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        /* --- GLOBAL THEME --- */
        body { 
            font-family: 'Poppins', sans-serif; 
            margin: 0; 
            padding: 0; 
            min-height: 100vh;
            /* THEME: The Purple/Blue Gradient */
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #333;
        }
        
        a { text-decoration: none; color: inherit; transition: 0.3s; } 

        /* --- GLASS HEADER --- */
        .header { 
            /* Glass Effect */
            background: rgba(255, 255, 255, 0.1); 
            backdrop-filter: blur(10px); 
            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
            
            padding: 15px 40px; 
            display: flex;            
            justify-content: space-between; 
            align-items: center;  
            color: white;     
        }

        /* --- LOGO SECTION --- */
        .header-left { 
            display: flex; 
            align-items: center; 
            gap: 15px; 
        }

        .logo { 
            height: 55px; 
            width: 55px; 
            background: white; 
            border-radius: 50%; 
            padding: 3px; 
            object-fit: contain;
            box-shadow: 0 4px 10px rgba(0,0,0,0.2);
        }

        .college-info h2 { 
            margin: 0; 
            font-size: 20px; 
            font-weight: 600;
            letter-spacing: 0.5px;
            text-shadow: 0 2px 4px rgba(0,0,0,0.2);
        }

        .college-info p { 
            margin: 0; 
            font-size: 13px; 
            opacity: 0.9; 
            font-weight: 300; 
        }

        /* --- USER SECTION --- */
        .header-right { 
            text-align: right; 
        }
        .header-right h2 { 
            margin: 0; 
            font-weight: 500; 
            font-size: 18px;
            text-shadow: 0 2px 4px rgba(0,0,0,0.2);
        }
        .header-right p { 
            margin: 2px 0 0; 
            font-size: 0.85em; 
            opacity: 0.9; 
        }
        .logout-btn {
            color: #ffcc00; 
            font-weight: 600;
            margin-left: 5px;
        }
        .logout-btn:hover {
            color: #fff;
            text-shadow: 0 0 5px #ffcc00;
        }

        /* --- DASHBOARD GRID --- */
        .container { 
            display: flex;            
            flex-wrap: wrap;           
            justify-content: center;   
            gap: 30px;                 
            padding: 60px 20px;
            max-width: 1200px;
            margin: 0 auto;
        }

        /* --- MODERN CARDS --- */
        .card { 
            background: rgba(255, 255, 255, 0.95); /* Slightly transparent white */
            width: 260px; 
            padding: 40px 25px; 
            border-radius: 20px; /* Rounded Corners */
            box-shadow: 0 10px 25px rgba(0,0,0,0.2); /* Soft Shadow */
            text-align: center; 
            transition: transform 0.3s, box-shadow 0.3s; 
            cursor: pointer;
            position: relative;
            overflow: hidden;
        }

        .card:hover { 
            transform: translateY(-10px); 
            box-shadow: 0 20px 40px rgba(0,0,0,0.3); 
        }

        /* Icon Container Circle */
        .icon-box {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #e0c3fc 0%, #8ec5fc 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
        }
        
        .icon { 
            font-size: 40px; 
            display: block; 
            line-height: 1;
        }

        .card h3 { 
            margin: 10px 0 5px; 
            color: #4a4a4a; 
            font-size: 1.4em; 
            font-weight: 600;
        }
        
        .card p { 
            color: #777; 
            font-size: 0.9em; 
            line-height: 1.5; 
            margin: 0;
        }

    </style>
</head>
<body>

    <div class="header">
        
        <div class="header-left">
            <img src="images/logo.png" alt="Logo" class="logo">
            <div class="college-info">
                <h2>Shri Shankaracharya Mahavidyalaya</h2>
                <p>Junwani, Bhilai</p>
            </div>
        </div>

        <div class="header-right">
            <h2>Library Admin Dashboard</h2>
            <p>Welcome, Admin | <a href="logout.jsp" class="logout-btn">Logout</a></p>
        </div>

    </div>

    <div class="container">
        
        <a href="add_book.jsp">
            <div class="card">
                <div class="icon-box"><span class="icon">➕</span></div>
                <h3>Add Book</h3>
                <p>Register new books to the library inventory.</p>
            </div>
        </a>

        <a href="issue_book.jsp">
            <div class="card">
                <div class="icon-box"><span class="icon">📲</span></div>
                <h3>Issue Book</h3>
                <p>Scan a QR code to assign a book to a student.</p>
            </div>
        </a>

        <a href="return_process.jsp"> 
            <div class="card">
                <div class="icon-box"><span class="icon">↩️</span></div>
                <h3>Return Book</h3>
                <p>Scan a QR code to accept a returned book.</p>
            </div>
        </a>

        <a href="view_books.jsp">
            <div class="card">
                <div class="icon-box"><span class="icon">👀</span></div>
                <h3>View All Books</h3>
                <p>Browse the complete list of available books.</p>
            </div>
        </a>

        <a href="book_management.jsp">
            <div class="card">
                <div class="icon-box"><span class="icon">📋</span></div>
                <h3>Book Management</h3>
                <p>Track all issued books, due dates, and return history.</p>
            </div>
        </a>
        <a href="view_students.jsp">
            <div class="card">
                <div class="icon-box"><span class="icon">🪪</span></div>
                <h3>Student Cards</h3>
                <p>Manage students and print Library ID Cards.</p>
            </div>
        </a>

    </div>

</body>
</html>