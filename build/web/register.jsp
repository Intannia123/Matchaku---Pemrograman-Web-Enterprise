<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String nama = request.getParameter("nama");
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    String role = "user"; // role default

    String responseMessage = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/registrasi", "root", "");

        // Simpan data ke database, termasuk role
        PreparedStatement ps = conn.prepareStatement("INSERT INTO registrasi_db (nama, email, password, role) VALUES (?, ?, ?, ?)");
        ps.setString(1, nama);
        ps.setString(2, email);
        ps.setString(3, password);
        ps.setString(4, role);
        ps.executeUpdate();

        // Simpan sesi login
        session.setAttribute("nama", nama);
        session.setAttribute("role", role);

        // Redirect ke halaman produk.jsp jika role adalah user
        if ("user".equals(role)) {
            response.sendRedirect("login.jsp");
        } else if ("admin".equals(role)) {
            response.sendRedirect("dashboard.jsp");
        }
        return;

    } catch (Exception e) {
        responseMessage = "Terjadi kesalahan!";
%>
        <html>
            <head>
                <style>
                    body {
                        font-family: 'Arial', sans-serif;
                        background: url('https://www.matakanasuperfoods.com/cdn/shop/files/Matcha_About.png?v=1727149914') no-repeat center center fixed;
                        background-size: cover;
                        display: flex;
                        justify-content: center;
                        align-items: center;
                        height: 100vh;
                        margin: 0;
                        color: white;
                    }
                    .error-container {
                        background-color: rgba(220, 53, 69, 0.8);
                        color: white;
                        padding: 30px;
                        border-radius: 12px;
                        text-align: center;
                        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
                        width: 90%;
                        max-width: 450px;
                        font-size: 18px;
                    }
                    .btn {
                        background-color: #007bff;
                        color: white;
                        padding: 12px 25px;
                        border: none;
                        border-radius: 5px;
                        font-size: 18px;
                        text-decoration: none;
                        transition: background-color 0.3s ease;
                    }
                    .btn:hover {
                        background-color: #0056b3;
                    }
                </style>
            </head>
            <body>
                <div class="error-container">
                    <h2><%= responseMessage %></h2>
                    <p><%= e.getMessage() %></p>
                    <a href="formRegist.html" class="btn">Kembali ke Form Registrasi</a>
                </div>
            </body>
        </html>
<%
    }
%>
