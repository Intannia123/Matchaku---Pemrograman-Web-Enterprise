<%--
    Document   : logout
    Created on : Jun 11, 2025, 11:15:00 AM
    Author     : LENOVO
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Hapus semua data dari sesi yang sedang aktif
    session.invalidate();

    // Arahkan (redirect) kembali ke halaman login
    response.sendRedirect("login.jsp");
%>