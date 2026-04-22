<%@ page import="com.itextpdf.text.*, com.itextpdf.text.pdf.*, java.io.*" %>
<%
    // 1. Reset the response to prevent blank page/corruption
    out.clear();
    out = pageContext.pushBody(); 
    response.reset();

    // 2. Set PDF headers
    response.setContentType("application/pdf");
    response.setHeader("Content-Disposition", "attachment; filename=\"Student_ID_Card.pdf\"");

    // 3. Define Standard Credit Card Size (CR-80: 85.6mm x 54mm -> approx 243 x 153 points)
    Rectangle creditCardSize = new Rectangle(243, 153);
    
    // Create Document with NO margins so the image fills it completely
    Document document = new Document(creditCardSize, 0, 0, 0, 0);

    try {
        PdfWriter.getInstance(document, response.getOutputStream());
        document.open();

        // --- FRONT SIDE ---
        // REPLACE "images/front_id.jpg" with the actual path to your generated image
        String frontPath = application.getRealPath("images/front_id.jpg"); 
        
        // Check if file exists to avoid crashing
        File f1 = new File(frontPath);
        if(f1.exists()){
            Image img1 = Image.getInstance(frontPath);
            img1.scaleToFit(243, 153); // Force fit to card size
            document.add(img1);
        } else {
            document.add(new Paragraph("Front Image Not Found"));
        }

        // --- BACK SIDE ---
        document.newPage(); // This creates the 2nd page in the same file
        
        // REPLACE "images/back_id.jpg" with your actual path
        String backPath = application.getRealPath("images/back_id.jpg");
        
        File f2 = new File(backPath);
        if(f2.exists()){
            Image img2 = Image.getInstance(backPath);
            img2.scaleToFit(243, 153); 
            document.add(img2);
        } else {
            document.add(new Paragraph("Back Image Not Found"));
        }

        document.close();
        
    } catch (Exception e) {
        e.printStackTrace();
    }
%>