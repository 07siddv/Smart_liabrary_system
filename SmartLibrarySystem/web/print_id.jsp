<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.io.*" %>

<%
    // 1. GLOBAL VARIABLES
    String reqId = request.getParameter("id");
    
    // Default empty values to prevent null pointer errors
    String name = "";
    String uniqueId = "";
    String className = "";
    Date dob = null;
    String photoUrl = "";
    boolean isFound = false;

    // Security Check
    if(reqId == null || reqId.trim().isEmpty()) {
        out.println("<h3 style='color:red; text-align:center; font-family:sans-serif; margin-top:50px;'>⚠️ No Student Selected!</h3>");
        return;
    }

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_system", "root", "3001");
        
        // Fetch Student Details
        String query = "SELECT * FROM lib_students WHERE library_id = ? OR roll_no = ?";
        ps = con.prepareStatement(query);
        ps.setString(1, reqId);
        ps.setString(2, reqId);
        rs = ps.executeQuery();

        // 2. POPULATE VARIABLES IF STUDENT FOUND
        if (rs.next()) {
            isFound = true;
            name = rs.getString("name");
            uniqueId = rs.getString("library_id");
            className = rs.getString("class_name");
            dob = rs.getDate("dob");
            photoUrl = rs.getString("photo_url");
        }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>ID Card: <%= (isFound ? uniqueId : "Not Found") %></title>
    
    <script src="https://cdn.jsdelivr.net/npm/jsbarcode@3.11.5/dist/JsBarcode.all.min.js"></script>

    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap');

        body {
            font-family: 'Poppins', sans-serif;
            background: #e0e0e0;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 40px;
            margin: 0;
        }

        /* --- CONTROLS --- */
        .controls {
            position: fixed; top: 20px; z-index: 100;
            background: rgba(255,255,255,0.9); padding: 10px 20px;
            border-radius: 30px; box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .btn-download {
            background: #004a99; color: white; border: none; padding: 10px 25px;
            border-radius: 30px; font-size: 15px; font-weight: 600; cursor: pointer;
            box-shadow: 0 4px 10px rgba(0,0,0,0.2); transition: 0.2s;
            display: flex; align-items: center; gap: 8px;
        }
        .btn-download:hover { background: #003366; transform: scale(1.05); }

        /* --- PREVIEW ONLY --- */
        .side-label {
            font-size: 14px; font-weight: 600; color: #666;
            margin: 30px 0 10px 0; text-transform: uppercase; letter-spacing: 1px;
            text-align: center; display: block;
        }
        .spacer { height: 60px; } 

        /* =========================================
           CARD STYLE (Common)
           ========================================= */
        .id-card-base {
            width: 600px;
            height: 378px; /* Ratio 1.58 */
            background: white;
            border-radius: 24px; /* UPDATED: Smooth rounded corners */
            box-shadow: 0 15px 40px rgba(0,0,0,0.15);
            overflow: hidden; /* Ensures header color doesn't escape the corners */
            position: relative;
            display: flex;
            flex-direction: column;
            border: 1px solid #ccc;
            margin-bottom: 30px; 
            box-sizing: border-box;
            
            -webkit-print-color-adjust: exact;
            print-color-adjust: exact; 
        }

        /* FRONT SIDE CONTENT */
        .header { background: #004499; color: white; height: 68px; padding: 2px 0; display: flex; justify-content: center; align-items: center; gap: 15px; border-bottom: 4px solid #ff6600; }
        .logo-img { width: 52px; height: 52px; background: white; border-radius: 50%; padding: 2px; object-fit: contain; flex-shrink: 0; }
        .header-text { text-align: center; line-height: 1.2; }
        .header-text h2 { margin: 0; font-size: 18px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; }
        .header-text p { margin: 0; font-size: 12px; font-weight: 400; opacity: 0.9; margin-top: 2px; }
        .card-body { flex: 1; padding: 10px 30px 0 30px; display: flex; justify-content: space-between; position: relative; }
        .info-section { flex: 1.5; display: flex; flex-direction: column; justify-content: flex-start; padding-top: 5px; }
        .info-row { margin-bottom: 6px; font-size: 15px; color: #000; text-align: left; }
        .label { font-weight: 700; color: #004499; display: inline-block; width: 90px; }
        .label.orange { color: #d35400; }
        .value { font-weight: 600; color: #000; }
        .photo-section { flex: 0.8; display: flex; justify-content: flex-end; align-items: flex-start; }
        .photo-box { width: 120px; height: 145px; border: 4px solid #ff6600; border-radius: 10px; overflow: hidden; }
        .student-photo { width: 100%; height: 100%; object-fit: cover; }
        .footer-area { padding: 0 30px 8px 30px; display: flex; justify-content: space-between; align-items: flex-end; }
        .qr-section img { width: 70px; height: 70px; border: 1px solid #ddd; padding: 2px; }
        .sign-section { text-align: center; }
        .sign-line { width: 120px; height: 2px; background: #000; margin-bottom: 5px; }
        .sign-text { font-size: 13px; font-weight: 700; color: #000; margin: 0; }

        /* BACK SIDE CONTENT */
        .back-header { background: #004499; color: white; height: 45px; display: flex; justify-content: center; align-items: center; font-size: 16px; font-weight: 700; letter-spacing: 1px; text-transform: uppercase; border-bottom: 4px solid #ff6600; }
        .back-body { flex: 1; padding: 15px 30px; display: flex; flex-direction: column; color: #333; text-align: left; }
        .rules-list { list-style: none; padding: 0; margin: 0 0 10px 0; }
        .rules-list li { margin-bottom: 6px; font-size: 13px; display: flex; align-items: flex-start; line-height: 1.3; }
        .rules-list li::before { content: "🔹"; color: #ff6600; font-size: 10px; margin-right: 8px; margin-top: 3px; }
        .barcode-area { display: flex; flex-direction: column; align-items: center; margin-top: auto; margin-bottom: 5px; }
        .barcode-img { height: 45px; width: auto; max-width: 90%; }
        .barcode-text { font-size: 11px; color: #555; letter-spacing: 1px; font-family: monospace; }
        .return-info { font-size: 12px; font-weight: 600; color: #004499; text-align: center; margin-top: 5px; }
        .bottom-banner { background: #004499; color: white; text-align: center; font-size: 12px; font-weight: 600; letter-spacing: 1px; padding: 6px 0; width: 100%; margin-top: 5px; position: relative; bottom: 0; }
        .back-footer { background: #004499; color: rgba(255,255,255,0.9); text-align: center; font-size: 10px; padding: 6px 0; width: 100%; line-height: 1.4; }


        /* =========================================
           🖨️ THE MAGIC PRINT CSS 
           This ONLY runs when you click Print
           ========================================= */
        @media print {
            body {
                background: white; 
                padding: 0; 
                margin: 0;
            }

            .controls, .side-label, .spacer {
                display: none !important;
            }

            .id-card-base {
                box-shadow: none !important;
                border: 1px dashed #999 !important; 
                border-radius: 24px !important; /* UPDATED: Keep rounded corners when printing */
                overflow: hidden !important; /* UPDATED: Prevent header colors from bleeding out */
                
                transform: scale(0.54);
                transform-origin: top left;
                
                margin-bottom: -160px !important;
                margin-right: -260px !important;
                margin-left: 10px !important; 
                
                page-break-inside: avoid; 
            }

            #preview-container {
                display: block; 
                padding: 10px;
            }
        }

    </style>
</head>
<body>

    <div class="controls">
        <button class="btn-download" onclick="window.print()">🖨️ Print / Save as PDF</button>
    </div>
    <div class="spacer"></div>

    <% if (isFound) { %>

    <div id="preview-container">
        
        <div class="side-label">Front Side</div>
        <div class="id-card-base" id="front-source">
            <div class="header">
                <img src="images/logo.png" alt="Logo" class="logo-img">
                <div class="header-text">
                    <h2>SHRI SHANKARACHARYA<br>MAHAVIDYALAYA</h2>
                    <p>Bhilai, Chhattisgarh</p>
                </div>
            </div>
            <div class="card-body">
                <div class="info-section">
                    <div class="info-row"><span class="label">Name:</span> <span class="value"><%= name %></span></div>
                    <div class="info-row"><span class="label orange">ID No:</span> <span class="value"><%= uniqueId %></span></div>
                    <div class="info-row"><span class="label">Class:</span> <span class="value"><%= className %></span></div>
                    <div class="info-row"><span class="label">DOB:</span> <span class="value"><%= dob %></span></div>
                    <div class="info-row"><span class="label">Valid Upto:</span> <span class="value">2026-2027</span></div>
                </div>
                <div class="photo-section">
                    <div class="photo-box">
                        <img src="ImageLoader?img=<%= photoUrl %>" crossorigin="anonymous" class="student-photo" onerror="this.src='images/default.png'">
                    </div>
                </div>
            </div>
            <div class="footer-area">
                <div class="qr-section">
                    <img src="https://api.qrserver.com/v1/create-qr-code/?size=100x100&data=<%= uniqueId %>" crossorigin="anonymous" alt="QR">
                </div>
                <div class="sign-section">
                    <div class="sign-line"></div>
                    <p class="sign-text">Principal</p>
                </div>
            </div>
            <div class="bottom-banner">ssmv.ac.in</div>
        </div>

        <div class="side-label">Back Side</div>
        <div class="id-card-base" id="back-source">
            <div class="back-header">Terms & Conditions</div>
            <div class="back-body">
                <ul class="rules-list">
                    <li>This card is the property of Shri Shankaracharya Mahavidyalaya.</li>
                    <li>This card is non-transferable and must be carried at all times.</li>
                    <li>Lost cards must be reported immediately.</li>
                </ul>
                <div class="barcode-area">
                    <img id="barcode-img" class="barcode-img" />
                </div>
                <div class="return-info">If found, please return to the College Office.</div>
            </div>
            <div class="back-footer">
                Junwani, Bhilai, Chhattisgarh - 490020<br>
                Phone: 0788-2284826 | Website: www.ssmv.ac.in
            </div>
        </div>

    </div>

    <script>
        // Initialize Barcode on Load
        window.onload = function() {
            try {
                JsBarcode("#barcode-img", "<%= uniqueId %>", {
                    format: "CODE128",
                    lineColor: "#333",
                    width: 1.5,
                    height: 40,
                    displayValue: true,
                    fontSize: 12,
                    font: "Poppins"
                });
            } catch (e) { console.error("Barcode Error", e); }
        };
    </script>

    <% } else { out.println("<h3 style='color:red;'>Student Not Found</h3>"); } %>

</body>
</html>
<%
    } catch (Exception e) { e.printStackTrace(); } 
    finally { if(con != null) try { con.close(); } catch(SQLException e) {} }
%>