<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    // 🔥 SECURITY FIX: Prevent Browser Caching (Kills the Back Button Issue)
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); 
    response.setHeader("Pragma", "no-cache"); 
    response.setDateHeader("Expires", 0); 
%>

<%
    if(session.getAttribute("user") == null) {
        response.sendRedirect("admin_login.jsp");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Book</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        /* --- ANIMATIONS --- */
        @keyframes fadeInDown {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* --- BASE STYLES (Matches Login Theme) --- */
        body {
            font-family: 'Poppins', sans-serif;
            margin: 0;
            padding: 0;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            /* THEME: Purple/Blue Gradient */
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }

        /* --- GLASS CARD --- */
        .form-card {
            background: rgba(255, 255, 255, 0.95);
            padding: 40px 50px;
            width: 400px;
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.2);
            text-align: center;
            position: relative;
            animation: fadeInDown 0.8s ease-out;
        }

        h2 {
            margin: 0 0 5px;
            color: #333;
            font-weight: 600;
            font-size: 26px;
        }
        p.subtitle {
            color: #666;
            font-size: 14px;
            margin-bottom: 25px;
        }

        /* --- INPUTS --- */
        .input-group { margin-bottom: 15px; text-align: left; }
        
        label {
            display: block;
            margin-bottom: 5px;
            color: #444;
            font-size: 13px;
            font-weight: 600;
        }

        input, select {
            width: 100%;
            padding: 12px 15px;
            background: #f0f2f5; /* Light gray background */
            
            /* 🔥 UPDATE: Added Thin Black Border */
            border: 1px solid #000; 
            
            border-radius: 8px;
            font-size: 14px;
            box-sizing: border-box;
            transition: all 0.3s;
            font-family: 'Poppins', sans-serif;
            color: #333;
        }

        input:focus, select:focus {
            background: #fff;
            outline: none;
            /* Changed glow to match black border, or keep purple glow */
            border-color: #764ba2; 
            box-shadow: 0 0 0 3px rgba(118, 75, 162, 0.1); 
        }

        /* --- ROW FOR SMALLER INPUTS --- */
        .row { display: flex; gap: 15px; }
        .col { flex: 1; }

        /* --- BUTTONS --- */
        button {
            width: 100%;
            padding: 14px;
            /* THEME: Purple Gradient Button */
            background: linear-gradient(to right, #667eea, #764ba2);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s, box-shadow 0.2s;
            margin-top: 20px;
        }
        button:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(118, 75, 162, 0.4);
        }

        .cancel-btn {
            display: block;
            margin-top: 15px;
            color: #888;
            text-decoration: none;
            font-size: 13px;
        }
        .cancel-btn:hover { color: #764ba2; text-decoration: underline; }
    </style>
</head>
<body>

    <div class="form-card">
        <h2>📖 Add New Book</h2>
        <p class="subtitle">Enter book details below</p>

        <form action="AddBookServlet" method="post" autocomplete="off">
            
            <div class="input-group">
                <label>Book Title</label>
                <input type="text" name="title" placeholder="" required>
            </div>

            <div class="input-group">
                <label>Author Name</label>
                <input type="text" name="author" placeholder="" required>
            </div>

            <div class="input-group">
                <label>Department</label>
                <select name="department" required>
                    <option value="" disabled selected>Select Department</option>
                    <option value="Computer (BCA/CS)">Computer (BCA/CS)</option>
                    <option value="Management (BBA/MBA)">Management (BBA/MBA)</option>
                    <option value="Science (B.Sc/M.Sc)">Science (B.Sc/M.Sc)</option>
                    <option value="Arts & Humanity">Arts & Humanity</option>
                    <option value="Education (B.Ed/D.El.Ed)">Education (B.Ed/D.El.Ed)</option>
                    <option value="Commerce (B.Com/M.Com)">Commerce (B.Com/M.Com)</option>
                    <option value="General Library">General Library</option>
                </select>
            </div>

            <div class="row">
                <div class="col">
                    <div class="input-group">
                        <label>Publication Year</label>
                        <input type="number" name="publication Year" placeholder="" min="1900" max="2100" required>
                    </div>
                </div>
                <div class="col">
                    <div class="input-group">
                        <label>Quantity</label>
                        <input type="number" name="quantity" value="1" min="1" required>
                    </div>
                </div>
            </div>

            <button type="submit">💾 Save Book</button>
            <a href="admin_dashboard.jsp" class="cancel-btn">Back to Dashboard</a>
        </form>
    </div>

</body>
</html>