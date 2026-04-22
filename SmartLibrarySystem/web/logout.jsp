<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 🔥 SECURITY FIX: Prevent Browser from Caching the Logout Process
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // 1. Find out who is trying to log out (Admin or Student?)
    String userRole = request.getParameter("role");
    
    // 2. Safely Destroy the session memory
    HttpSession currentSession = request.getSession(false); // Gets existing session, doesn't create a new one
    if (currentSession != null) {
        currentSession.invalidate(); // Destroys all server-side session data securely
    }
    
    // 3. Send them to the correct login page
    if ("student".equals(userRole)) {
        response.sendRedirect("student_login.jsp?error=Logged Out Successfully");
    } else {
        // Default fallback goes to Admin
        response.sendRedirect("admin_login.jsp"); 
    }
%>