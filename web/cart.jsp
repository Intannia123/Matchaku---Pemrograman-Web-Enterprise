<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, AddToCartServlet.CartItem, java.text.NumberFormat, java.util.Locale" %>
<%
    List<AddToCartServlet.CartItem> cart = (List<AddToCartServlet.CartItem>) session.getAttribute("cart");
    double totalAmount = 0;
    
    NumberFormat rupiahCurrencyFormat = NumberFormat.getCurrencyInstance(new Locale("id", "ID"));
    rupiahCurrencyFormat.setMaximumFractionDigits(0); 

    String cartMessage = (String) session.getAttribute("cartMessage");
    String cartError = (String) session.getAttribute("cartError");
    session.removeAttribute("cartMessage"); 
    session.removeAttribute("cartError");   
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Shopping Cart - Matchaku</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        /* Semua CSS Anda tetap sama, tidak ada perubahan di sini */
        :root {
            --matcha-green: #a6c48a; --dark-matcha: #678d58; --light-matcha: #f0f7e6;
            --cream: #f9f9f5; --japan-red: #c82525;
        }
        body { font-family: 'Poppins', sans-serif; background-color: var(--cream); color: #333; margin:0; padding:0; line-height:1.6; }
        .container { max-width: 1200px; margin: 0 auto; padding: 20px; }
        header { background: linear-gradient(135deg, var(--dark-matcha), var(--matcha-green)); padding: 25px 0; text-align: center; box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
        .logo { font-size: 2.8rem; color: white; text-shadow: 2px 2px 4px rgba(0,0,0,0.3); letter-spacing: 1px; font-weight: 600; }
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
        footer { background: linear-gradient(135deg, var(--dark-matcha), #5a7a4e); color: white; text-align: center; padding: 40px 0 20px; margin-top: 60px; }
        .footer-logo { font-size: 2rem; margin-bottom: 15px; font-weight: 600; }
        .footer-info { max-width: 600px; margin: 0 auto 25px; line-height: 1.8; }
        .social-icons { margin: 25px 0; }
        .social-icons a { color: white; margin: 0 15px; font-size: 1.5rem; transition: all 0.3s; display: inline-block; }
        .social-icons a:hover { transform: translateY(-3px); color: #fff8e1; }
        .copyright { margin-top: 30px; font-size: 0.9rem; opacity: 0.8; }
        .page-title { text-align: center; margin: 40px 0; color: var(--dark-matcha); font-size: 2.5rem; }
        .cart-table { width: 100%; border-collapse: collapse; margin-bottom: 30px; background-color: #fff; box-shadow: 0 2px 8px rgba(0,0,0,0.1); border-radius: 8px; overflow:hidden; }
        .cart-table th, .cart-table td { padding: 12px 15px; text-align: left; border-bottom: 1px solid var(--light-matcha); vertical-align: middle; }
        .cart-table thead { background-color: var(--dark-matcha); color: white; }
        .cart-table img { max-width: 60px; height: auto; border-radius: 4px; }
        .cart-table .product-name-cart { font-weight: 500; color: var(--dark-matcha); }
        .cart-table .btn-remove-item { background-color: transparent; border: 1px solid var(--japan-red); color: var(--japan-red); padding: 5px 10px; border-radius: 5px; cursor: pointer; transition: all 0.3s; }
        .cart-table .btn-remove-item:hover { background-color: var(--japan-red); color: white; }
        .cart-table .btn-remove-item i { margin-right: 3px; }
        .cart-summary { text-align: right; margin-bottom: 30px; }
        .cart-summary h3 { color: var(--dark-matcha); font-size: 1.8rem; }
        .cart-actions { display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 10px;}
        .btn-matcha-cart { background: linear-gradient(to right, var(--matcha-green), var(--dark-matcha)); color: white; border: none; padding: 12px 25px; border-radius: 8px; font-weight: 600; text-decoration: none; display: inline-block; transition: all 0.3s; font-size: 0.95rem; }
        .btn-matcha-cart:hover { color:white; transform: translateY(-2px); box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
        .btn-checkout { background: var(--japan-red); }
        .btn-checkout:hover { background: #a71d1d; }
        .alert-cart { padding: 15px; margin-bottom: 20px; border-radius: 8px; font-size: 1rem; }
        .alert-cart-success { background-color: var(--light-matcha); color: var(--dark-matcha); border: 1px solid var(--matcha-green); }
        .alert-cart-error { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb;}
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

            <%
                String loggedInUserName = (String) session.getAttribute("userName");

                if (loggedInUserName != null && !loggedInUserName.isEmpty()) {
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
            %>
                <li><a href="login.jsp">Login <i class="fas fa-sign-in-alt"></i></a></li>
            <%
                }
            %>

            <li>
                <%-- Menambahkan class="active" ke link Cart --%>
                <a href="cart.jsp" class="active">Cart <i class="fas fa-shopping-cart"></i> 
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
                </a>
            </li>
        </ul>
    </nav>

    <div class="container">
        <h1 class="page-title">Your Shopping Cart</h1>

        <% if (cartMessage != null) { %>
            <div class="alert-cart alert-cart-success"><i class="fas fa-check-circle"></i> <%= cartMessage %></div>
        <% } %>
        <% if (cartError != null) { %>
            <div class="alert-cart alert-cart-error"><i class="fas fa-exclamation-triangle"></i> <%= cartError %></div>
        <% } %>

        <% if (cart == null || cart.isEmpty()) { %>
            <p style="text-align:center; font-size:1.2rem; margin: 40px 0;">Your shopping cart is empty. Let's go shopping!</p>
        <% } else { %>
            <div class="table-responsive">
            <table class="cart-table">
                <thead>
                    <tr>
                        <th style="width:10%;">Image</th>
                        <th style="width:30%;">Product Name</th>
                        <th style="width:15%;">Unit Price</th>
                        <th style="width:10%; text-align:center;">Quantity</th>
                        <th style="width:15%; text-align:right;">Subtotal</th>
                        <th style="width:10%; text-align:center;">Action</th>
                    </tr>
                </thead>
                <tbody>
                <% for (AddToCartServlet.CartItem item : cart) {
                    double subtotal = item.getSubtotal();
                    totalAmount += subtotal;
                %>
                    <tr>
                        <td><img src="uploads/<%= (item.getImage() != null && !item.getImage().isEmpty() ? item.getImage() : "placeholder.png") %>" alt="<%= item.getName() %>"></td>
                        <td class="product-name-cart"><%= item.getName() %></td>
                        <td><%= rupiahCurrencyFormat.format(item.getPrice()) %></td>
                        <td style="text-align:center;"><%= item.getQuantity() %></td>
                        <td style="text-align:right;"><%= rupiahCurrencyFormat.format(subtotal) %></td>
                        <td style="text-align:center;">
                            <form action="RemoveFromCartServlet" method="post" style="display:inline;">
                                <input type="hidden" name="productId" value="<%= item.getId() %>">
                                <button type="submit" class="btn-remove-item" title="Remove item">
                                    <i class="fas fa-trash-alt"></i>
                                </button>
                            </form>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
            </div>
            <div class="cart-summary">
                <h3>Total: <%= rupiahCurrencyFormat.format(totalAmount) %></h3>
            </div>
        <% } %>
        <div class="cart-actions">
            <a href="home.jsp#products" class="btn-matcha-cart"><i class="fas fa-arrow-left"></i> Continue Shopping</a>
            <% if (cart != null && !cart.isEmpty()) { %>
                <a href="checkout.jsp" class="btn-matcha-cart btn-checkout">Proceed to Checkout <i class="fas fa-arrow-right"></i></a> 
            <% } %>
        </div>
    </div>

    <footer id="contact">
        </footer>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const dropdownToggle = document.querySelector('.dropdown-toggle');
            const dropdownMenu = document.querySelector('.dropdown-menu');
    
            if (dropdownToggle) {
                dropdownToggle.addEventListener('click', function(event) {
                    event.preventDefault();
                    dropdownMenu.classList.toggle('show');
                });
            }
    
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