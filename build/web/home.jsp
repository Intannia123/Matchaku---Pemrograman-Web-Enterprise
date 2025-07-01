<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, java.text.NumberFormat, java.util.Locale" %>
<%
    NumberFormat rupiahCurrencyFormat = NumberFormat.getCurrencyInstance(new Locale("id", "ID"));
    rupiahCurrencyFormat.setMaximumFractionDigits(0); 
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Matchaku - Premium Matcha Products</title>
    <style>
        /* ... CSS Anda yang sudah ada ... */
        :root {
            --matcha-green: #a6c48a;
            --dark-matcha: #678d58;
            --light-matcha: #f0f7e6;
            --cream: #f9f9f5;
            --japan-red: #c82525;
        }
        
        body {
            font-family: 'Poppins', 'Helvetica Neue', Arial, sans-serif;
            background-color: var(--cream); color: #333;
            margin: 0; padding: 0; line-height: 1.6;
        }
        .container { max-width: 1200px; margin: 0 auto; padding: 20px; }
        header {
            background: linear-gradient(135deg, var(--dark-matcha), var(--matcha-green));
            padding: 25px 0; text-align: center; box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .logo {
            font-size: 2.8rem; color: white; text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
            letter-spacing: 1px; font-weight: 600;
        }
        .logo span { color: #fff8e1; }
        nav {
            background-color: var(--dark-matcha); padding: 12px 0;
            position: sticky; top: 0; z-index: 100;
        }
        
        .dropdown {
            position: relative; /* Penting untuk posisi dropdown-menu */
        }

        .dropdown-menu {
            display: none; /* Sembunyikan secara default */
            position: absolute;
            top: 100%; /* Muncul tepat di bawah tombol */
            right: 0; /* Rata kanan */
            background-color: var(--cream);
            min-width: 200px;
            box-shadow: 0 8px 16px rgba(0,0,0,0.2);
            z-index: 101; /* Pastikan di atas elemen lain */
            border-radius: 8px;
            padding: 10px 0;
            margin-top: 10px; /* Jarak dari navbar */
            border: 1px solid var(--light-matcha);
        }

        .dropdown-menu a, .dropdown-header {
            color: var(--dark-matcha);
            padding: 12px 20px;
            text-decoration: none;
            display: block; /* Agar setiap item memenuhi lebar */
            text-align: left;
            font-size: 1rem;
        }

        .dropdown-menu a:hover {
            background-color: var(--light-matcha);
            color: var(--dark-matcha);
        }

        .dropdown-header {
            font-size: 0.9rem;
            color: #666;
            border-bottom: 1px solid var(--light-matcha);
            margin-bottom: 5px;
            padding-bottom: 15px;
        }
        
        .dropdown-header strong {
            color: var(--dark-matcha);
            font-size: 1.1rem;
        }

        /* Kelas 'show' untuk menampilkan dropdown dengan JavaScript */
        .dropdown-menu.show {
            display: block;
        }
        
        nav ul { display: flex; justify-content: center; list-style: none; padding: 0; margin: 0; }
        nav li { margin: 0 20px; }
        nav a {
            color: white; text-decoration: none; font-weight: 500;
            padding: 8px 15px; border-radius: 20px; transition: all 0.3s; font-size: 1.1rem;
        }
        nav a:hover, nav a.active { background-color: rgba(255,255,255,0.2); transform: translateY(-2px); }
        .hero {
            background: linear-gradient(rgba(0,0,0,0.4), rgba(0,0,0,0.4)), 
            url('https://img.freepik.com/free-vector/preparation-process-matcha-tea_107791-32016.jpg?semt=ais_hybrid&w=740');
            background-size: cover; background-position: center; height: 500px;
            display: flex; align-items: center; justify-content: center;
            color: white; text-align: center; position: relative; margin-bottom: 40px;
        }
        .hero-content { position: relative; z-index: 1; max-width: 800px; padding: 0 20px; }
        .hero h1 {
            font-size: 3.5rem; margin-bottom: 20px;
            text-shadow: 2px 2px 8px rgba(0, 0, 0, 0.5); font-weight: 600;
        }
        .hero p {
            font-size: 1.3rem; margin: 0 auto;
            text-shadow: 1px 1px 3px rgba(0, 0, 0, 0.5); max-width: 600px;
        }
        .products-title {
            text-align: center; margin: 50px 0 30px; color: var(--dark-matcha);
            font-size: 2.5rem; position: relative; display: inline-block;
            padding-bottom: 10px; left: 50%; transform: translateX(-50%);
        }
        .products-title:after {
            content: ''; position: absolute; bottom: 0; left: 50%; transform: translateX(-50%);
            width: 80px; height: 4px; background: var(--matcha-green); border-radius: 2px;
        }
        .products-container { padding: 0 20px 50px; }
        .products-grid {
            display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 35px;
        }
        .product-card {
            background-color: white; border-radius: 12px; overflow: hidden;
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.08); transition: all 0.3s ease;
            border: none; display: flex; flex-direction: column; 
        }
        .product-card:hover { transform: translateY(-10px); box-shadow: 0 12px 25px rgba(0, 0, 0, 0.15); }
        .product-image {
            height: 250px; background-color: var(--light-matcha);
            background-size: cover; background-position: center;
            position: relative; overflow: hidden;
        }
        .product-image:after { 
            content: ''; position: absolute; top: 0; left: 0; right: 0; bottom: 0;
            background: linear-gradient(to bottom, rgba(0,0,0,0) 60%, rgba(0,0,0,0.05));
        }
        .product-info {
            padding: 20px; background: white; flex-grow: 1; 
            display: flex; flex-direction: column;
        }
        .product-name {
            font-weight: 600; font-size: 1.2rem; margin-bottom: 8px; color: var(--dark-matcha);
        }
        .product-desc { /* Style untuk deskripsi di home.jsp */
            font-size: 0.90rem; color: #555; /* Sedikit lebih gelap dari #666 */
            margin-bottom: 15px;
            min-height: 4.2em; /* Cukup untuk sekitar 3 baris */
            line-height: 1.4em; 
            overflow: hidden;
            text-overflow: ellipsis;
            display: -webkit-box;
            -webkit-line-clamp: 3; /* Batasi hingga 3 baris */
            -webkit-box-orient: vertical;
        }
        .product-price {
            color: var(--japan-red); font-weight: 700; font-size: 1.3rem;
            margin-bottom: 15px; display: flex; align-items: center; margin-top: auto; 
        }
        .add-to-cart {
            background: linear-gradient(to right, var(--matcha-green), var(--dark-matcha));
            color: white; border: none; padding: 12px 0; border-radius: 8px;
            cursor: pointer; width: 100%; font-weight: 600; font-size: 1rem;
            transition: all 0.3s; display: flex; align-items: center; justify-content: center;
            margin-top: 10px; 
        }
        .add-to-cart:hover { transform: translateY(-2px); box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); }
        .add-to-cart i { margin-right: 8px; }
        .seasonal-banner {
            background: linear-gradient(135deg, var(--japan-red), #e74c3c);
            color: white; padding: 15px; text-align: center; margin-bottom: 40px;
            font-weight: 600; font-size: 1.1rem; letter-spacing: 0.5px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .category-filter {
            display: flex; justify-content: center; margin-bottom: 40px;
            flex-wrap: wrap; gap: 10px;
        }
        .category-btn {
            background-color: var(--light-matcha); border: none; padding: 10px 20px;
            border-radius: 25px; cursor: pointer; transition: all 0.3s;
            font-weight: 500; color: var(--dark-matcha); box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }
        .category-btn:hover, .category-btn.active {
            background: linear-gradient(to right, var(--matcha-green), var(--dark-matcha));
            color: white; transform: translateY(-2px); box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        footer {
            background: linear-gradient(135deg, var(--dark-matcha), #5a7a4e);
            color: white; text-align: center; padding: 40px 0 20px; margin-top: 60px;
        }
        .footer-logo { font-size: 2rem; margin-bottom: 15px; font-weight: 600; }
        .footer-info { max-width: 600px; margin: 0 auto 25px; line-height: 1.8; }
        .social-icons { margin: 25px 0; }
        .social-icons a {
            color: white; margin: 0 15px; font-size: 1.5rem;
            transition: all 0.3s; display: inline-block;
        }
        .social-icons a:hover { transform: translateY(-3px); color: #fff8e1; }
        .copyright { margin-top: 30px; font-size: 0.9rem; opacity: 0.8; }
        
        @media (max-width: 768px) {
            .hero h1 { font-size: 2.5rem; }
            .hero p { font-size: 1.1rem; }
            nav li { margin: 0 10px; }
            nav a { font-size: 1rem; padding: 6px 12px; }
            .products-grid { grid-template-columns: repeat(auto-fill, minmax(250px, 1fr)); gap: 25px; }
            .product-desc { -webkit-line-clamp: 2; min-height: 2.8em; } /* Sesuaikan untuk mobile jika perlu */
        }
    </style>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <header>
        <div class="container">
            <div class="logo">Matcha<span>ku</span> - 抹茶の逸品</div>
        </div>
    </header>
    
    <nav>
        <ul>
            <li><a href="home.jsp" class="active">Home</a></li>
            <li><a href="home.jsp#products">Products</a></li>
            <li><a href="aboutMatchaku.jsp">About Matcha</a></li>
            <li><a href="home.jsp#contact">Contact</a></li>

            <%
                // Mengambil nama pengguna dari sesi. Nama atribut disesuaikan dengan proses_login.jsp Anda.
                String loggedInUserName = (String) session.getAttribute("userName");

                if (loggedInUserName != null && !loggedInUserName.isEmpty()) {
                    // ---- JIKA PENGGUNA SUDAH LOGIN ----
            %>
                <li class="dropdown">
                    <a href="#" class="dropdown-toggle">
                        <i class="fas fa-user"></i> <%= loggedInUserName %> <i class="fas fa-caret-down" style="font-size: 0.8em;"></i>
                    </a>
                    <div class="dropdown-menu">
                        <div class="dropdown-header">Signed in as<br><strong><%= loggedInUserName %></strong></div>
                        <a href="my_orders.jsp">My Orders</a>
                        <a href="LogoutServlet">Logout</a> <%-- Ganti LogoutServlet dengan URL logout Anda --%>
                    </div>
                </li>
            <%
                } else {
                    // ---- JIKA PENGGUNA BELUM LOGIN ----
            %>
                <li><a href="login.jsp">Login <i class="fas fa-sign-in-alt"></i></a></li>
            <%
                }
            %>

            <li><a href="cart.jsp">Cart <i class="fas fa-shopping-cart"></i> 
                <% 
                    List<AddToCartServlet.CartItem> cartForCount = (List<AddToCartServlet.CartItem>) session.getAttribute("cart");
                    int itemCount = 0;
                    if (cartForCount != null) {
                        for (AddToCartServlet.CartItem item : cartForCount) {
                            itemCount += item.getQuantity();
                        }
                    }
                    if (itemCount > 0) {
                %>
                    (<%= itemCount %>)
                <%
                    }
                %>
            </a></li>
        </ul>
    </nav>
    
    <div class="seasonal-banner">
        <i class="fas fa-leaf"></i> New Spring Matcha Desserts Available! 10% OFF All Products
    </div>
    
    <section class="hero" id="home">
        <div class="hero-content">
            <h1>Authentic Japanese Matcha Delights</h1>
            <p>Premium matcha products crafted with traditional techniques from Uji, Kyoto</p>
        </div>
    </section>
    
    <section class="container" id="products">
        <div class="category-filter">
            <button class="category-btn active">All Products</button>
            <button class="category-btn">Matcha Desserts</button>
            <button class="category-btn">Matcha Drinks</button>
            <button class="category-btn">Matcha Snacks</button>
            <button class="category-btn">Matcha Powder</button>
        </div>
        
        <h2 class="products-title">Our Premium Selection</h2>
        
        <div class="products-container">
            <div class="products-grid">
                <% 
                    Connection conn = null;
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/barang", "root", ""); 
                        String sql = "SELECT * FROM barang WHERE quantity > 0 ORDER BY id DESC"; 
                        pstmt = conn.prepareStatement(sql);
                        rs = pstmt.executeQuery();

                        if (!rs.isBeforeFirst() ) { 
                            out.println("<p class='text-center col-12'>No products currently available.</p>");
                        } else {
                            while(rs.next()){
                                String id = rs.getString("id");
                                String namaBarang = rs.getString("nama_barang");
                                String gambar = rs.getString("gambar");
                                String deskripsi = rs.getString("deskripsi"); // Ambil deskripsi
                                int harga = rs.getInt("harga");
                                
                                String namaBarangHtmlEscaped = namaBarang.replace("\"", "&quot;").replace("'", "&#39;");
                %>
                <div class="product-card">
                    <div class="product-image" style="background-image: url('uploads/<%= (gambar != null && !gambar.isEmpty() ? gambar : "placeholder.png") %>');">
                    </div>
                    <div class="product-info">
                        <div class="product-name"><%= namaBarang %></div>
                        <%-- Tampilkan deskripsi dari database --%>
                        <div class="product-desc" title="<%= (deskripsi != null ? deskripsi.replace("\"", "&quot;") : "") %>">
                           <%= (deskripsi != null && !deskripsi.trim().isEmpty() ? deskripsi : "Premium quality matcha product, crafted with the finest ingredients.") %>
                        </div>
                        <div class="product-price"><%= rupiahCurrencyFormat.format(harga) %></div> 
                        <form action="AddToCartServlet" method="post" style="width:100%;">
                            <input type="hidden" name="productId" value="<%= id %>">
                            <input type="hidden" name="productName" value="<%= namaBarangHtmlEscaped %>">
                            <input type="hidden" name="productPrice" value="<%= harga %>">
                            <input type="hidden" name="productImage" value="<%= (gambar != null && !gambar.isEmpty() ? gambar : "placeholder.png") %>">
                             <input type="hidden" name="productDescription" value="<%= (deskripsi != null ? deskripsi.replace("\"", "&quot;") : "") %>">
                            <button type="submit" class="add-to-cart"><i class="fas fa-cart-plus"></i> Add to Cart</button>
                        </form>
                    </div>
                </div>
                <% 
                            } 
                        } 
                    } catch (Exception e) {
                        e.printStackTrace(); 
                        out.println("<p class='text-center col-12' style='color:red;'>Could not load products: " + e.getMessage() + "</p>");
                    } finally {
                        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                    }
                %>
            </div>
        </div>
    </section>
    
    <footer id="contact"> 
        <section class="container">
            <div class="footer-logo">Matchaku</div>
            <div class="footer-info">
                <p>Premium Japanese Matcha Products from Uji, Kyoto</p>
                <p>Jl. Matcha No. 10, Jakarta Barat<br>Phone: (021) 1234-5678<br>Email: hello@matchaku.com</p>
            </div>
            <div class="social-icons">
                <a href="#"><i class="fab fa-instagram"></i></a>
                <a href="#"><i class="fab fa-twitter"></i></a>
                <a href="#"><i class="fab fa-facebook-f"></i></a>
                <a href="#"><i class="fab fa-tiktok"></i></a>
            </div>
            <div class="copyright">
                &copy; 2025 Matchaku. All Rights Reserved.
            </div>
        </section>
    </footer>
            
    <script>
    document.addEventListener('DOMContentLoaded', function() {
        const dropdownToggle = document.querySelector('.dropdown-toggle');
        const dropdownMenu = document.querySelector('.dropdown-menu');

        // Cek jika elemen dropdown ada (jika pengguna sudah login)
        if (dropdownToggle) {
            dropdownToggle.addEventListener('click', function(event) {
                event.preventDefault(); // Mencegah link berpindah halaman
                dropdownMenu.classList.toggle('show');
            });
        }

        // Menutup dropdown jika pengguna mengklik di luar area dropdown
        window.onclick = function(event) {
            if (dropdownMenu && !event.target.closest('.dropdown')) {
                if (dropdownMenu.classList.contains('show')) {
                    dropdownMenu.classList.remove('show');
                }
            }
        };
    });
    </script>
            
</body>
</html>