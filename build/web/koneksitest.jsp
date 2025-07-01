<%-- 
    Document   : koneksitest
    Created on : Apr 23, 2025, 11:14:48 AM
    Author     : LENOVO
--%>

<%-- 
    Document   : koneksitest
    Created on : Apr 23, 2025, 11:14:48 AM
    Author     : LENOVO
--%>

<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<html>
<head>
    <title>Test Koneksi DB</title>
</head>
<body>
<%
    String url = "jdbc:mysql://localhost:3306/registrasi"; // nama DB
    String user = "root"; // user DB
    String password = ""; // password DB (kosong jika default)

    try {
        Class.forName("com.mysql.cj.jdbc.Driver"); // gunakan driver MySQL terbaru
        Connection conn = DriverManager.getConnection(url, user, password);
        
        if (conn != null) {
            out.println("Koneksi ke database berhasil<br><br>");
            conn.close();
        }
    } catch (Exception e) {
        out.println("Koneksi gagal: " + e.getMessage());
    }
%>
</body>
</html>
