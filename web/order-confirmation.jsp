<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String successMessage = (String) session.getAttribute("orderSuccessMessage");
    // Hapus atribut agar tidak muncul lagi jika halaman di-refresh
    session.removeAttribute("orderSuccessMessage"); 
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Order Confirmation - Matchaku</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        /* Salin semua CSS dari checkout.jsp/home.jsp di sini */
        :root {
            --matcha-green: #a6c48a;
            --dark-matcha: #678d58;
            --light-matcha: #f0f7e6;
            --cream: #f9f9f5;
        }
        body { font-family: 'Poppins', sans-serif; background-color: var(--cream); color: #333; }
        /* ... (CSS header, nav, footer, dll) ... */
         header { background: linear-gradient(135deg, var(--dark-matcha), var(--matcha-green)); padding: 25px 0; text-align: center; box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
        .logo { font-size: 2.8rem; color: white; text-shadow: 2px 2px 4px rgba(0,0,0,0.3); letter-spacing: 1px; font-weight: 600; }
        .logo span { color: #fff8e1; }
        nav { background-color: var(--dark-matcha); padding: 12px 0; position: sticky; top: 0; z-index: 100; }
        nav ul { display: flex; justify-content: center; list-style: none; padding: 0; margin: 0; }
        nav li { margin: 0 20px; }
        nav a { color: white; text-decoration: none; font-weight: 500; padding: 8px 15px; border-radius: 20px; transition: all 0.3s; font-size: 1.1rem; }
        nav a:hover, nav a.active { background-color: rgba(255,255,255,0.2); transform: translateY(-2px); }
        .confirmation-box {
            max-width: 700px;
            margin: 50px auto;
            padding: 40px;
            background-color: #fff;
            border-radius: 12px;
            text-align: center;
            box-shadow: 0 6px 20px rgba(0,0,0,0.1);
            border-top: 5px solid var(--dark-matcha);
        }
        .confirmation-box i {
            font-size: 4rem;
            color: var(--dark-matcha);
            margin-bottom: 20px;
        }
        .confirmation-box h1 {
            color: var(--dark-matcha);
            font-weight: 600;
        }
        .btn-matcha-continue {
            background: linear-gradient(to right, var(--matcha-green), var(--dark-matcha));
            color: white; border: none; padding: 12px 30px; border-radius: 8px;
            font-weight: 600; text-decoration: none; display: inline-block; transition: all 0.3s;
            margin-top: 25px;
        }
        .btn-matcha-continue:hover { color:white; transform: translateY(-2px); box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
    </style>
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
            <li><a href="aboutMatchaku.jsp">About Matcha</a></li>
            <li><a href="home.jsp#contact">Contact</a></li>
            <li><a href="cart.jsp">Cart <i class="fas fa-shopping-cart"></i></a></li>
        </ul>
    </nav>

    <div class="container">
        <div class="confirmation-box">
            <% if (successMessage != null) { %>
                <i class="fas fa-check-circle"></i>
                <h1>Order Confirmed!</h1>
                <p class="lead mt-3"><%= successMessage %></p>
                <p>We will process your order immediately. An email confirmation has been sent to you.</p>
            <% } else { %>
                 <i class="fas fa-exclamation-triangle"></i>
                <h1>No Order Information</h1>
                <p class="lead mt-3">We could not find any recent order information.</p>
            <% } %>
            <a href="home.jsp#products" class="btn-matcha-continue">Continue Shopping</a>
        </div>
    </div>
    
    </body>
</html>