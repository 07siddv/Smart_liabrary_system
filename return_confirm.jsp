<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Get details from URL
    String bookId = request.getParameter("id");
    String title = request.getParameter("title");
    String author = request.getParameter("author");
    String qty = request.getParameter("qty");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Confirm Return</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background-color: #f4f6f9; padding: 40px; text-align: center; }
        .container { background: white; max-width: 400px; margin: 0 auto; padding: 30px; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); text-align: left; }
        h2 { text-align: center; color: #28a745; margin-top: 0; }
        
        .book-info { background: #e9ecef; padding: 15px; border-radius: 5px; margin-bottom: 20px; }
        .book-info p { margin: 5px 0; color: #555; font-size: 14px; }
        .book-info b { color: #333; }
        
        label { display: block; margin-top: 15px; font-weight: bold; color: #333; }
        input { width: 100%; padding: 10px; margin-top: 5px; border: 1px solid #ccc; border-radius: 5px; box-sizing: border-box; }
        
        button { width: 100%; padding: 12px; background-color: #28a745; color: white; border: none; border-radius: 5px; cursor: pointer; font-size: 16px; margin-top: 20px; transition: 0.3s; }
        button:hover { background-color: #218838; }
        .cancel { display: block; text-align: center; margin-top: 15px; color: #666; text-decoration: none; }
    </style>
</head>
<body>

    <div class="container">
        <h2>↩️ Confirm Return</h2>
        
        <div class="book-info">
            <p><b>Book ID:</b> <%= bookId %></p>
            <p><b>Title:</b> <%= title %></p>
            <p><b>Author:</b> <%= author %></p>
            <p><b>Current Qty:</b> <%= qty %></p>
        </div>

        <form action="${pageContext.request.contextPath}/ReturnBookServlet" method="post">
            <input type="hidden" name="book_id" value="<%= bookId %>">

            <label>Student Name (Optional):</label>
            <input type="text" name="student_name" placeholder="Who is returning this?">

            <button type="submit">✅ Accept Return (+1 Qty)</button>
        </form>

        <a href="return_list.jsp" class="cancel">Cancel</a>
    </div>

</body>
</html>