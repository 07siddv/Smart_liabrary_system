<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Kill Cache
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // Security Bouncer for scanners
    if (session.getAttribute("user") == null) {
        response.sendRedirect("admin_login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Issue Book - Step 1</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <script src="https://unpkg.com/html5-qrcode" type="text/javascript"></script>
    
    <style>
        body { 
            font-family: 'Poppins', sans-serif; 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); 
            display: flex; justify-content: center; align-items: center; min-height: 100vh; margin: 0; 
        }
        .glass-card { 
            background: rgba(255, 255, 255, 0.95); 
            padding: 30px; border-radius: 20px; text-align: center; width: 400px; 
            box-shadow: 0 15px 35px rgba(0,0,0,0.2); 
        }
        #reader { 
            width: 100%; border-radius: 10px; overflow: hidden; 
            margin-bottom: 20px; border: 2px solid #764ba2; background: #000;
        }
        input { 
            width: 80%; padding: 12px; margin: 10px 0; 
            border: 2px solid #ddd; border-radius: 8px; text-align: center; font-size: 14px;
        }
        .btn-back { display: block; margin-top: 15px; color: #666; text-decoration: none; font-size: 13px; }
        
        /* Error Alert Box */
        .alert-error {
            background: #ffebee; color: #c62828; padding: 10px; border-radius: 5px;
            font-size: 13px; font-weight: bold; border: 1px solid #ef9a9a;
            margin-bottom: 15px; display: none; /* Hidden by default */
        }
    </style>
</head>
<body>

    <div class="glass-card">
        <h2>👋 Issue Book</h2>
        <p style="color: #666; font-size: 14px; margin-bottom: 20px;">Step 1: Scan Student ID</p>
        
        <div id="errorBox" class="alert-error">
            ⚠️ Student ID Not Found! Try Again.
        </div>
        <% if(request.getParameter("error") != null) { %>
            <script>document.getElementById("errorBox").style.display = "block";</script>
        <% } %>

        <div id="reader"></div>

        <p style="font-size: 13px; color: #888;">OR Type Unique ID Manually:</p>

        <form id="scanForm" action="student_issue_dashboard.jsp" method="get">
            <input type="text" id="idInput" name="id" placeholder="Enter Student ID" autofocus autocomplete="off">
            <button type="submit" style="display:none;">Submit</button>
        </form>

        <a href="admin_dashboard.jsp" class="btn-back">⬅ Back to Dashboard</a>
    </div>

    <script>
        // Use a flag to ensure we only submit ONCE
        let isScanned = false;

        function onScanSuccess(decodedText, decodedResult) {
            if (isScanned) return; // Ignore if already processing
            isScanned = true;

            // 1. Play Beep
            let beep = new Audio('https://actions.google.com/sounds/v1/alarms/beep_short.ogg');
            beep.play().catch(e => console.log("Audio play failed"));

            // 2. FILL INPUT
            document.getElementById('idInput').value = decodedText;

            // 3. STOP CAMERA IMMEDIATELY
            html5QrcodeScanner.clear().then(() => {
                // 4. SUBMIT FORM (Move to next page)
                document.getElementById('scanForm').submit();
            }).catch(error => {
                // Even if stop fails, force submit
                document.getElementById('scanForm').submit();
            });
        }

        function onScanFailure(error) {
            // Do nothing on fail, keep scanning
        }

        let html5QrcodeScanner = new Html5QrcodeScanner(
            "reader", 
            { fps: 10, qrbox: {width: 250, height: 250} }, 
            false
        );
        html5QrcodeScanner.render(onScanSuccess, onScanFailure);
    </script>

</body>
</html>