<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String email = request.getParameter("email");
    String password = request.getParameter("password");

    String errorMessage = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/registrasi", "root", "");

        String query = "SELECT * FROM registrasi_db WHERE email = ?";
        PreparedStatement ps = conn.prepareStatement(query);
        ps.setString(1, email);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            String storedPassword = rs.getString("password");
            String role = rs.getString("role");

            if (storedPassword.equals(password)) {
                session.setAttribute("userEmail", email);
                session.setAttribute("userName", rs.getString("nama"));
                session.setAttribute("role", role); // Simpan role ke session

                if ("admin".equalsIgnoreCase(role)) {
                    response.sendRedirect("dashboard.jsp");
                } else if ("user".equalsIgnoreCase(role)) {
                    response.sendRedirect("home.jsp");
                } else {
                    errorMessage = "Peran pengguna tidak dikenali.";
                }
            } else {
                errorMessage = "Password salah!";
            }
        } else {
            errorMessage = "Email tidak terdaftar!";
        }

        rs.close();
        ps.close();
        conn.close();
    } catch (Exception e) {
        errorMessage = "Terjadi kesalahan: " + e.getMessage();
    }

    if (errorMessage != null) {
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login Gagal</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .error-container {
            background-color: #dc3545;
            color: white;
            padding: 30px;
            border-radius: 8px;
            text-align: center;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            width: 80%;
            max-width: 400px;
        }
        .error-container h2 {
            font-size: 24px;
            margin-bottom: 10px;
        }
        .error-container p {
            font-size: 16px;
            margin-bottom: 20px;
        }
        .btn {
            background-color: #007bff;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            text-decoration: none;
            font-size: 16px;
            cursor: pointer;
        }
        .btn:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <h2>Login Gagal!</h2>
        <p><%= errorMessage %></p>
        <a href="login.jsp" class="btn">Kembali ke Login</a>
    </div>
</body>
</html>
<%
    }
%>
