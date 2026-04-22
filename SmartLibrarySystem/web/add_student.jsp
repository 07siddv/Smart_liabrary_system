<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Student</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        /* --- GLOBAL THEME --- */
        body { 
            font-family: 'Poppins', sans-serif; 
            margin: 0; 
            padding: 20px; 
            min-height: 100vh;
            /* THEME: Purple/Blue Gradient */
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        /* --- NAVIGATION --- */
        .nav-bar { 
            width: 100%;
            max-width: 500px;
            margin-bottom: 20px;
            display: flex;
            justify-content: flex-start;
        }
        
        .btn-back { 
            background: rgba(255, 255, 255, 0.9); 
            color: #764ba2; 
            padding: 10px 20px; 
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
        .btn-back:hover { background: #fff; transform: translateY(-2px); }

        /* --- GLASS FORM CARD --- */
        .glass-card {
            background: rgba(255, 255, 255, 0.95);
            padding: 40px 50px;
            width: 100%;
            max-width: 500px;
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.2);
            position: relative;
            animation: fadeInDown 0.8s ease-out;
            box-sizing: border-box;
        }

        @keyframes fadeInDown {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        h2 { margin: 0 0 5px; color: #333; font-weight: 600; font-size: 26px; text-align: center; }
        p.subtitle { color: #666; font-size: 14px; margin-bottom: 25px; text-align: center; }

        /* --- INPUTS --- */
        .input-group { margin-bottom: 15px; }
        
        label { display: block; margin-bottom: 6px; color: #555; font-size: 13px; font-weight: 600; }

        input[type="text"], input[type="file"], input[type="date"] {
            width: 100%;
            padding: 12px 15px;
            
            /* 🔥 UPDATE: Added Thin Black Border */
            border: 1px solid #000;
            
            border-radius: 10px;
            font-size: 14px;
            box-sizing: border-box;
            transition: all 0.3s;
            font-family: 'Poppins', sans-serif;
            background: #fff;
            color: #333;
        }

        input:focus {
            /* Active/Focus state remains purple for better UX */
            border-color: #764ba2;
            outline: none;
            box-shadow: 0 0 0 4px rgba(118, 75, 162, 0.1);
        }

        /* --- ROW LAYOUT --- */
        .row { display: flex; gap: 15px; }
        .col { flex: 1; }

        /* --- BUTTONS --- */
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
            margin-top: 20px;
        }
        button:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(118, 75, 162, 0.4);
        }

        .error-msg {
            color: #d9534f;
            background: #fbe1e1;
            padding: 10px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 13px;
            text-align: center;
            font-weight: 600;
            border: 1px solid #eba5a3;
        }
    </style>
</head>
<body>

    <div class="nav-bar">
        <a href="view_students.jsp" class="btn-back">⬅ Student List</a>
    </div>

    <div class="glass-card">
        <h2>🎓 Register Student</h2>
        <p class="subtitle">Enter student details including DOB</p>

        <% 
            String errorMsg = request.getParameter("error");
            if(errorMsg != null && !errorMsg.trim().isEmpty()) { 
                try { errorMsg = java.net.URLDecoder.decode(errorMsg, "UTF-8"); } catch(Exception e) {}
        %>
            <div class="error-msg">⚠️ <%= errorMsg %></div>
        <% } %>

        <form action="${pageContext.request.contextPath}/AddStudentServlet" method="post" enctype="multipart/form-data" autocomplete="off">
            
            <div class="input-group">
                <label>Full Name</label>
                <input type="text" name="name" placeholder="" required>
            </div>

            <div class="input-group">
                <label>Roll Number (Unique ID)</label>
                <input type="text" name="roll_no" placeholder="" required autocomplete="off">
            </div>
            
            <div class="row">
                <div class="col">
                    <div class="input-group">
                        <label>Class</label>
                        <input type="text" name="class_name" placeholder="" required>
                    </div>
                </div>
                <div class="col">
                    <div class="input-group">
                        <label>Section</label>
                        <input type="text" name="section" placeholder="" required>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col">
                    <div class="input-group">
                        <label>Date of Birth</label>
                        <input type="date" name="dob" required>
                    </div>
                </div>
                <div class="col">
                    <div class="input-group">
                        <label>Contact Number</label>
                        <input type="text" name="contact" placeholder="" required>
                    </div>
                </div>
            </div>
            
            <div class="input-group">
                <label>Upload Photo</label>
                <input type="file" name="photo" required accept="image/*" style="padding: 10px; background: #f8f9fa;">
            </div>

            <button type="submit">✅ Save Student</button>
        </form>
    </div>

</body>
</html>