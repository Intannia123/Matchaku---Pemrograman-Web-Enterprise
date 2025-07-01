<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- PERUBAHAN 1: Menambahkan impor yang diperlukan untuk logika navbar --%>
<%@ page import="java.util.List, AddToCartServlet.CartItem" %> 

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>About Matcha - Matchaku</title>
    <style>
        /* Semua CSS Anda tetap sama, tidak ada perubahan di sini */
        :root {
            --matcha-green: #a6c48a;
            --dark-matcha: #678d58;
            --light-matcha: #f0f7e6;
            --cream: #f9f9f5;
            --japan-red: #c82525;
        }
        body { font-family: 'Poppins', 'Helvetica Neue', Arial, sans-serif; background-color: var(--cream); color: #333; margin: 0; padding: 0; line-height: 1.7; }
        .container { max-width: 1100px; margin: 0 auto; padding: 20px; }
        header { background: linear-gradient(135deg, var(--dark-matcha), var(--matcha-green)); padding: 25px 0; text-align: center; box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
        .logo { font-size: 2.8rem; color: white; text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3); letter-spacing: 1px; font-weight: 600; }
        .logo span { color: #fff8e1; }
        nav { background-color: var(--dark-matcha); padding: 12px 0; position: sticky; top: 0; z-index: 100; }
        .dropdown { position: relative; }
        .dropdown-menu { display: none; position: absolute; top: 100%; right: 0; background-color: var(--cream); min-width: 200px; box-shadow: 0 8px 16px rgba(0,0,0,0.2); z-index: 101; border-radius: 8px; padding: 10px 0; margin-top: 10px; border: 1px solid var(--light-matcha); }
        .dropdown-menu a, .dropdown-header { color: var(--dark-matcha); padding: 12px 20px; text-decoration: none; display: block; text-align: left; font-size: 1rem; }
        .dropdown-menu a:hover { background-color: var(--light-matcha); color: var(--dark-matcha); }
        .dropdown-header { font-size: 0.9rem; color: #666; border-bottom: 1px solid var(--light-matcha); margin-bottom: 5px; padding-bottom: 15px; }
        .dropdown-header strong { color: var(--dark-matcha); font-size: 1.1rem; }
        .dropdown-menu.show { display: block; }
        nav ul { display: flex; justify-content: center; list-style: none; padding: 0; margin: 0; }
        nav li { margin: 0 20px; }
        nav a { color: white; text-decoration: none; font-weight: 500; padding: 8px 15px; border-radius: 20px; transition: all 0.3s; font-size: 1.1rem; }
        nav a:hover, nav a.active { background-color: rgba(255,255,255,0.2); transform: translateY(-2px); }
        .seasonal-banner { background: linear-gradient(135deg, var(--japan-red), #e74c3c); color: white; padding: 15px; text-align: center; font-weight: 600; font-size: 1.1rem; letter-spacing: 0.5px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
        .page-header { background: var(--light-matcha); padding: 60px 20px; text-align: center; margin-bottom: 40px; border-bottom: 3px solid var(--matcha-green); }
        .page-header h1 { color: var(--dark-matcha); font-size: 2.8rem; margin: 0; font-weight: 600; }
        .page-header p { color: #555; font-size: 1.1rem; max-width: 700px; margin: 15px auto 0; }
        .content-section { padding: 30px 0; margin-bottom: 30px; background-color: #fff; border-radius: 12px; box-shadow: 0 6px 15px rgba(0,0,0,0.05); }
        .content-section .container { padding-top: 0; padding-bottom: 0; }
        .content-section h2 { color: var(--dark-matcha); font-size: 2rem; margin-bottom: 25px; padding-bottom: 10px; border-bottom: 2px solid var(--matcha-green); display: inline-block; }
        .content-section p, .content-section ul { font-size: 1.05rem; color: #444; margin-bottom: 20px; }
        .content-section ul { list-style: none; padding-left: 0; }
        .content-section ul li { padding-left: 25px; position: relative; margin-bottom: 12px; }
        .content-section ul li:before { content: "\f14a"; font-family: "Font Awesome 6 Free"; font-weight: 900; color: var(--matcha-green); position: absolute; left: 0; top: 2px; font-size: 1.1em; }
        .content-image { width: 100%; max-width: 450px; height: auto; border-radius: 10px; margin: 20px auto; display: block; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
        .flex-container { display: flex; align-items: center; gap: 30px; margin-bottom: 30px; }
        .flex-container .text-content { flex: 1; }
        .flex-container .image-content { flex-basis: 300px; text-align: center; }
        .flex-container .image-content img { max-width: 100%; height: auto; border-radius: 8px; }
        footer { background: linear-gradient(135deg, var(--dark-matcha), #5a7a4e); color: white; text-align: center; padding: 40px 0 20px; margin-top: 60px; }
        .footer-logo { font-size: 2rem; margin-bottom: 15px; font-weight: 600; }
        .footer-info { max-width: 600px; margin: 0 auto 25px; line-height: 1.8; }
        .social-icons { margin: 25px 0; }
        .social-icons a { color: white; margin: 0 15px; font-size: 1.5rem; transition: all 0.3s; display: inline-block; }
        .social-icons a:hover { transform: translateY(-3px); color: #fff8e1; }
        .copyright { margin-top: 30px; font-size: 0.9rem; opacity: 0.8; }
        @media (max-width: 768px) {
            .page-header h1 { font-size: 2.2rem; }
            .page-header p { font-size: 1rem; }
            nav li { margin: 0 10px; }
            nav a { font-size: 1rem; padding: 6px 12px; }
            .content-section h2 { font-size: 1.7rem; }
            .flex-container { flex-direction: column; }
            .flex-container .image-content { margin-bottom: 20px; flex-basis: auto; }
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
            <li><a href="home.jsp">Home</a></li>
            <li><a href="home.jsp#products">Products</a></li>
            <li><a href="aboutMatchaku.jsp" class="active">About Matcha</a></li>
            <li><a href="home.jsp#contact">Contact</a></li>

            <%
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
                        <a href="LogoutServlet">Logout</a>
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
                    List<CartItem> cartForCount = (List<CartItem>) session.getAttribute("cart");
                    int itemCount = 0;
                    if (cartForCount != null) {
                        for (CartItem item : cartForCount) {
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
        <i class="fas fa-leaf"></i> Discover the Essence of True Matcha!
    </div>

    <section class="page-header">
        <h1>Kisah Matchaku & Seni Matcha</h1>
        <p>Selami kekayaan sejarah, budidaya yang teliti, dan manfaat luar biasa dari teh hijau terbaik dunia.</p>
    </section>
    
    <div class="container">
        <section class="content-section">
            <h2>Filosofi Kami: Janji Matchaku</h2>
            <div class="row align-items-center">
                <div class="col-md-7">
                    <p>Di Matchaku, kami percaya bahwa matcha lebih dari sekadar teh; ini adalah sebuah pengalaman, momen ketenangan, dan perayaan kehidupan. Perjalanan kami dimulai dengan penghormatan mendalam terhadap budaya teh Jepang untuk menghadirkan esensi otentiknya ke cangkir Anda.</p>
                    <p>Janji kami sederhana: menyediakan pengalaman matcha yang tak tertandingi, memastikan setiap tegukan mencerminkan kemurnian, semangat, dan warisan budaya yang kaya dari teh hijau yang luar biasa ini.</p>
                </div>
                <div class="col-md-5">
                    <img src="https://assets-pergikuliner.com/uploads/bootsy/image/17061/Matcha__matchamu.com_.jpg" class="img-fluid rounded shadow">
                </div>
            </div>
        </section>

        <section class="content-section bg-white">
            <div class="container">
                <h2>Proses Kami: Dari Daun hingga Cangkir</h2>
                <p>Kami bekerja secara langsung dengan para perajin teh terampil di Uji, Kyoto, yang telah mengasah keahlian mereka selama beberapa generasi. Setiap daun teh dipilih secara manual, dikukus dengan lembut, dikeringkan, dan digiling dengan batu granit secara perlahan untuk menjaga nutrisi dan warnanya yang cerah.</p>
                <img src="https://titipjepang.com/wp-content/uploads/2023/11/BLOG-Daerah-Penghasil-Teh-Di-Jepang-2.jpg" class="img-fluid rounded shadow mb-3">
            </div>
        </section>

        <section class="content-section">
            <h2>Nilai-Nilai Kami</h2>
            <div class="row">
                <div class="col-md-4">
                    <div class="value-item">
                        <i class="fas fa-check-circle"></i>
                        <div><strong>Kualitas Terbaik</strong><br>Hanya menggunakan daun teh dari panen pertama (first harvest) untuk rasa dan aroma terbaik.</div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="value-item">
                        <i class="fas fa-leaf"></i>
                        <div><strong>100% Alami & Organik</strong><br>Bebas dari pestisida dan bahan tambahan, menjaga kemurnian matcha seutuhnya.</div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="value-item">
                        <i class="fas fa-hand-holding-heart"></i>
                        <div><strong>Kemitraan yang Adil</strong><br>Mendukung petani lokal di Uji dengan praktik perdagangan yang etis dan berkelanjutan.</div>
                    </div>
                </div>
            </div>
        </section>
    </div>
    
    <footer>
        <section class="container" id="contact">
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
        
        src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
    </script>
    
</body>
</html>