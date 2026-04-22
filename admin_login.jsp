<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 1. KILL BROWSER CACHE FOR THE LOGIN PAGE
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // 2. IF ALREADY LOGGED IN, BOUNCE THEM BACK TO DASHBOARD
    // Note: Make sure the word in quotes matches exactly what you used in admin_dashboard.jsp!
    if (session.getAttribute("admin_email") != null) {
        response.sendRedirect("admin_dashboard.jsp");
        return;
    }
%>
<!DOCTYPE html> 
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Library Admin Login</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        /* --- ANIMATIONS --- */
        @keyframes fadeInDown {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes float {
            0% { transform: translateY(0px); }
            50% { transform: translateY(-10px); }
            100% { transform: translateY(0px); }
        }

        /* --- BASE STYLES --- */
        body {
            font-family: 'Poppins', sans-serif;
            margin: 0;
            padding: 0;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            /* Modern Gradient Background */
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            overflow: hidden;
        }

        /* --- DECORATIVE CIRCLES (Background Graphics) --- */
        .circle {
            position: absolute;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            backdrop-filter: blur(5px);
            z-index: 0;
            animation: float 6s infinite ease-in-out;
        }
        .c1 { width: 200px; height: 200px; top: 10%; left: 20%; animation-delay: 0s; }
        .c2 { width: 300px; height: 300px; bottom: 10%; right: 10%; animation-delay: 1s; }
        .c3 { width: 100px; height: 100px; top: 20%; right: 30%; animation-delay: 2s; }

        /* --- LOGIN CARD --- */
        .login-card {
            background: rgba(255, 255, 255, 0.95);
            padding: 50px 40px;
            width: 350px;
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.2);
            text-align: center;
            position: relative;
            z-index: 1;
            animation: fadeInDown 0.8s ease-out;
        }

        /* --- TYPOGRAPHY --- */
        .login-card h2 {
            margin: 0 0 10px;
            color: #333;
            font-weight: 600;
            font-size: 28px;
        }
        
        .subtitle {
            margin-bottom: 30px;
            color: #666;
            font-size: 14px;
        }

        /* --- FORM ELEMENTS --- */
        .input-group {
            margin-bottom: 20px;
            text-align: left;
        }

        label {
            display: block;
            margin-bottom: 8px;
            color: #444;
            font-size: 13px;
            font-weight: 600;
        }

        input {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #eee;
            border-radius: 10px;
            font-size: 15px;
            box-sizing: border-box; /* Fixes padding issues */
            transition: all 0.3s;
            font-family: 'Poppins', sans-serif;
        }

        input:focus {
            border-color: #764ba2;
            outline: none;
            box-shadow: 0 0 0 4px rgba(118, 75, 162, 0.1);
        }

        /* --- BUTTON --- */
        button {
            width: 100%;
            padding: 14px;
            background: linear-gradient(to right, #667eea, #764ba2);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s, box-shadow 0.2s;
            margin-top: 10px;
        }

        button:hover {
            transform: translateY(-3px); /* Lifts button up */
            box-shadow: 0 5px 15px rgba(118, 75, 162, 0.4);
        }

        button:active {
            transform: translateY(0);
        }

        /* --- FOOTER LINK --- */
        .footer-link {
            margin-top: 20px;
            display: block;
            font-size: 13px;
            color: #888;
            text-decoration: none;
        }
        .footer-link:hover {
            color: #764ba2;
            text-decoration: underline;
        }
    </style>
</head>
<body>

    <div class="circle c1"></div>
    <div class="circle c2"></div>
    <div class="circle c3"></div>

    <div class="login-card">
        <h2>📚 Admin Login</h2>
        <p class="subtitle">Secure Library Management System</p>

        <form action="AdminLoginServlet" method="post">
            <div class="input-group">
                <label>Username</label>
                <input type="text" name="username" placeholder="Enter username (admin)" required autocomplete="off">
            </div>

            <div class="input-group">
                <label>Password</label>
                <input type="password" name="password" placeholder="Enter password" required>
            </div>

            <button type="submit">🔐 Login to Dashboard</button>
        </form>

        <a href="#" class="footer-link">Forgot Password? Contact IT Dept.</a>
    </div>

</body>
</html>