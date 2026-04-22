<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Login | Smart Library System</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        /* --- Base Setup --- */
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: 'Poppins', sans-serif;
        }

        /* --- Beautiful Background --- */
        body {
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            /* High-quality library image with a dark overlay */
            background: linear-gradient(rgba(0, 30, 60, 0.7), rgba(0, 0, 0, 0.8)), 
                        url('https://images.unsplash.com/photo-1507842217343-583bb7270b66?ixlib=rb-4.0.3&auto=format&fit=crop&w=2000&q=80') center/cover no-repeat;
        }

        /* --- Glassmorphism Login Card --- */
        .login-card {
            background: rgba(255, 255, 255, 0.95);
            padding: 40px 35px;
            border-radius: 20px;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.3);
            width: 100%;
            max-width: 420px;
            text-align: center;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        /* --- Header & Typography --- */
        .icon-header {
            font-size: 45px;
            color: #004499; /* College Blue */
            margin-bottom: 10px;
        }
        .login-card h2 {
            color: #333;
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 5px;
        }
        .login-card p {
            color: #666;
            font-size: 14px;
            margin-bottom: 25px;
        }

        /* --- Error Message Box --- */
        .error-msg {
            background: #ffe6e6;
            color: #d8000c;
            padding: 10px;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 500;
            margin-bottom: 20px;
            border: 1px solid #ffb3b3;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        /* --- Form Inputs --- */
        .input-group {
            position: relative;
            margin-bottom: 20px;
            text-align: left;
        }
        .input-group i {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            color: #999;
            font-size: 18px;
        }
        
        /* Left icon (Lock/ID) */
        .input-group i.icon-left {
            left: 15px;
            pointer-events: none;
        }
        
        /* Right icon (Eye for password) */
        .input-group i.icon-right {
            right: 15px;
            left: auto; /* Override default left */
            cursor: pointer;
            transition: 0.2s;
        }
        .input-group i.icon-right:hover {
            color: #004499;
        }

        .input-group input {
            width: 100%;
            padding: 15px 45px 15px 45px; /* Added padding on both sides to fit icons */
            border: 2px solid #eee;
            border-radius: 12px;
            font-size: 15px;
            color: #333;
            outline: none;
            transition: all 0.3s ease;
        }
        .input-group input:focus {
            border-color: #004499;
            box-shadow: 0 0 0 4px rgba(0, 68, 153, 0.1);
        }
        .input-group input::placeholder {
            color: #aaa;
        }

        /* --- Submit Button --- */
        .btn-login {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #004499, #0066cc);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(0, 68, 153, 0.3);
            margin-top: 10px;
        }
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0, 68, 153, 0.4);
            background: linear-gradient(135deg, #003377, #0055b3);
        }

        /* --- Links --- */
        .back-link {
            display: inline-block;
            margin-top: 25px;
            color: #666;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            transition: 0.2s;
        }
        .back-link:hover {
            color: #004499;
            text-decoration: underline;
        }
    </style>
</head>
<body>

    <div class="login-card">
        
        <div class="icon-header">
            <i class="fa-solid fa-user-graduate"></i>
        </div>
        <h2>Student Portal</h2>
        <p>Check Books, Due Dates & Fines</p>

        <% 
            String errorMsg = request.getParameter("error");
            if(errorMsg != null && !errorMsg.isEmpty()) {
        %>
            <div class="error-msg">
                <i class="fa-solid fa-circle-exclamation"></i>
                <%= errorMsg %>
            </div>
        <% } %>

        <script>
            if (window.location.search.includes('error=')) {
                const cleanUrl = window.location.protocol + "//" + window.location.host + window.location.pathname;
                window.history.replaceState({}, document.title, cleanUrl);
            }
        </script>

        <form action="StudentLoginServlet" method="POST">
            
            <div class="input-group">
                <i class="fa-solid fa-id-card icon-left"></i>
                <input type="text" name="library_id" placeholder="Library ID" required autocomplete="off">
            </div>

            <div class="input-group">
                <i class="fa-solid fa-lock icon-left"></i>
                <input type="password" id="pwd" name="password" placeholder="Password (Your Phone Number)" required autocomplete="new-password">
                <i class="fa-solid fa-eye icon-right" id="eye-icon" onclick="togglePassword()"></i>
            </div>

            <button type="submit" class="btn-login">Login to Dashboard</button>
        </form>

        <a href="index.jsp" class="back-link"><i class="fa-solid fa-arrow-left"></i> Back to Home</a>
    </div>

    <script>
        function togglePassword() {
            const pwdInput = document.getElementById("pwd");
            const eyeIcon = document.getElementById("eye-icon");
            
            if (pwdInput.type === "password") {
                pwdInput.type = "text";
                eyeIcon.classList.remove("fa-eye");
                eyeIcon.classList.add("fa-eye-slash"); // Changes to crossed-out eye
            } else {
                pwdInput.type = "password";
                eyeIcon.classList.remove("fa-eye-slash");
                eyeIcon.classList.add("fa-eye"); // Changes back to normal eye
            }
        }
    </script>

</body>
</html>