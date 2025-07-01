<%--
    Document   : dashboard
    Created on : May 11, 2025, 12:34:14 PM
    Author     : LENOVO
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat, java.util.Locale" %> <%-- Tambahkan untuk format harga --%>
<%@ page session="true" %>

<%
    NumberFormat rupiahDashboardFormat = NumberFormat.getCurrencyInstance(new Locale("id", "ID"));
    rupiahDashboardFormat.setMaximumFractionDigits(0);
%>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Poppins', sans-serif;
            margin: 0;
            background-color: #e8f5e9;
        }
        .sidebar {
            height: 100vh;
            width: 220px;
            position: fixed;
            top: 0;
            left: 0;
            background-color: #5aa64b;
            padding-top: 2rem;
            color: white;
        }
        .sidebar h4 {
            font-weight: 600;
            text-align: center;
            margin-bottom: 2rem;
        }
        .sidebar a {
            display: block;
            color: white;
            padding: 0.75rem 1.5rem;
            text-decoration: none;
        }
        .sidebar a:hover, .sidebar a.active {
            background-color: #495057;
        }
        .main-content {
            margin-left: 220px;
            padding: 1.5rem;
        }
        /* Style untuk Header dan User Menu */
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
        }
        .user-dropdown .dropdown-toggle {
            color: #333;
            text-decoration: none;
        }
        .user-dropdown .dropdown-menu {
            border-radius: 0.5rem;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .welcome-box {
            background: white;
            border-radius: 1rem;
            padding: 2rem;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
        }
        
        /* Katalog Barang */
        .catalog-title {
            color: #2e7d32;
            margin-bottom: 1.5rem;
            font-weight: 600;
        }
        .catalog-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 1.5rem;
        }
        .catalog-card {
            background: white;
            border-radius: 0.75rem;
            overflow: hidden;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
            display: flex; 
            flex-direction: column; 
        }
        .catalog-card:hover {
            transform: translateY(-5px);
        }
        .catalog-img {
            width: 100%;
            height: 180px;
            object-fit: cover;
        }
        .catalog-body {
            padding: 1rem;
        }
        .catalog-name {
            font-weight: 600;
            color: #333;
            margin-bottom: 1.05rem;
        }
        .catalog-description {
            font-size: 0.9rem;
            color: #555;
            margin-bottom: 0.75rem;
            line-height: 1.4;
            height: 4.2em; 
            overflow: hidden;
            text-overflow: ellipsis;
            display: -webkit-box;
            -webkit-line-clamp: 3; 
            -webkit-box-orient: vertical;
        }
        .catalog-price {
            color: #2e7d32;
            font-weight: 600;
            font-size: 1.1rem;
        }
        .catalog-stock {
            color: #666;
            font-size: 0.9rem;
        }
        .no-image {
            background: #f5f5f5;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 180px;
            color: #999;
        }
    </style>
</head>
<body>

<div class="sidebar">
    <h4>Dashboard</h4>
    <a href="#" class="active">Home</a>
    <a href="dataRegister.jsp">Data Register</a>
    <a href="masterBarang.jsp">Master Barang</a>
    <a href="tampilTransaksi.jsp">Transaksi</a>
    <a href="admin_pesanan.jsp">Online Transaksi</a> 
</div>

<div class="main-content">
    <div class="header">
        <h3 class="mb-0">Selamat Datang!</h3>
        <div class="user-dropdown dropdown">
            <a href="#" class="dropdown-toggle d-flex align-items-center" data-bs-toggle="dropdown" aria-expanded="false">
                <i class="bi bi-person-circle fs-4 me-2"></i>
                <span class="fw-semibold"><%= session.getAttribute("userName") != null ? session.getAttribute("userName") : "[Nama User]" %></span>
            </a>
            <ul class="dropdown-menu dropdown-menu-end">
                <li><a class="dropdown-item" href="logout.jsp"><i class="bi bi-box-arrow-right me-2"></i>Logout</a></li>
            </ul>
        </div>
    </div>
    
    <div class="welcome-box">
        <h5 class="fw-semibold">Menu Master</h5>
        <p>Gunakan menu di sebelah kiri untuk mengakses data register pengguna.</p>
    </div>
    
    <div class="welcome-box">
        <h4 class="catalog-title"><i class="bi bi-box-seam"></i> Daftar Produk</h4>
        
        <div class="catalog-container">
            <% 
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/barang", "root", "");
                pstmt = conn.prepareStatement("SELECT * FROM barang ORDER BY id DESC LIMIT 8");
                rs = pstmt.executeQuery();
                
                while(rs.next()) {
                    String id = rs.getString("id");
                    String nama = rs.getString("nama_barang");
                    String gambar = rs.getString("gambar");
                    String deskripsi = rs.getString("deskripsi");
                    int quantity = rs.getInt("quantity");
                    int harga = rs.getInt("harga");
            %>
            <div class="catalog-card">
                <% if(gambar != null && !gambar.isEmpty()) { %>
                    <img src="uploads/<%= gambar %>" class="catalog-img" alt="<%= nama %>">
                <% } else { %>
                    <div class="no-image">
                        <i class="bi bi-image" style="font-size: 2rem;"></i>
                    </div>
                <% } %>
                <div class="catalog-body">
                    <h5 class="catalog-name"><%= nama %></h5>
                    <p class="catalog-description" title="<%= (deskripsi != null ? deskripsi.replace("\"", "&quot;") : "") %>">
                        <%= (deskripsi != null && !deskripsi.trim().isEmpty() ? deskripsi : "Deskripsi tidak tersedia.") %>
                    </p>
                     <div class="d-flex justify-content-between align-items-center mt-auto">
                         <div class="catalog-price"><%= rupiahDashboardFormat.format(harga) %></div>
                         <div class="catalog-stock">Stok: <%= quantity %></div>
                    </div>
                </div>
            </div>
            <% 
                }
            } catch(Exception e) {
                out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
            } finally {
                try { if(rs != null) rs.close(); } catch(Exception e) {}
                try { if(pstmt != null) pstmt.close(); } catch(Exception e) {}
                try { if(conn != null) conn.close(); } catch(Exception e) {}
            }
            %>
        </div>
    </div>
</div>
        
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>