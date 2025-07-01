<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, AddToCartServlet.CartItem, java.text.NumberFormat, java.util.Locale" %>
<%
    List<AddToCartServlet.CartItem> cart = (List<AddToCartServlet.CartItem>) session.getAttribute("cart");

    if (cart == null || cart.isEmpty()) {
        response.sendRedirect("cart.jsp");
        return;
    }

    double itemsSubtotal = 0;
    for (AddToCartServlet.CartItem item : cart) {
        itemsSubtotal += item.getSubtotal();
    }
    
    NumberFormat rupiahCurrencyFormat = NumberFormat.getCurrencyInstance(new Locale("id", "ID"));
    rupiahCurrencyFormat.setMaximumFractionDigits(0);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Checkout - Matchaku</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --matcha-green: #a6c48a;
            --dark-matcha: #678d58;
            --light-matcha: #f0f7e6;
            --cream: #f9f9f5;
            --japan-red: #c82525;
        }
        body { font-family: 'Poppins', sans-serif; background-color: var(--cream); color: #333; margin:0; padding:0; line-height:1.6; }
        .container { max-width: 1200px; margin: 0 auto; padding: 20px; }
        header { background: linear-gradient(135deg, var(--dark-matcha), var(--matcha-green)); padding: 25px 0; text-align: center; box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
        .logo { font-size: 2.8rem; color: white; text-shadow: 2px 2px 4px rgba(0,0,0,0.3); letter-spacing: 1px; font-weight: 600; }
        .logo span { color: #fff8e1; }
        nav { background-color: var(--dark-matcha); padding: 12px 0; position: sticky; top: 0; z-index: 100; }
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
        
        /* CSS Spesifik untuk Halaman Checkout */
        .checkout-layout {
            display: grid;
            grid-template-columns: 1.2fr 0.8fr; /* Kolom form lebih besar */
            gap: 40px;
            align-items: flex-start;
        }

        .checkout-form, .order-summary {
            background-color: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }

        .form-section-title {
            font-size: 1.5rem;
            color: var(--dark-matcha);
            margin-bottom: 20px;
            border-bottom: 2px solid var(--light-matcha);
            padding-bottom: 10px;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: 500;
        }

        .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            transition: border-color 0.3s;
        }

        .form-control:focus {
            border-color: var(--dark-matcha);
            outline: none;
            box-shadow: 0 0 5px rgba(103, 141, 88, 0.3);
        }

        .order-summary-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid #eee;
            font-size: 0.9rem;
        }
        .order-summary-item:last-child {
            border-bottom: none;
        }
        .order-summary-item .item-name {
            color: #555;
        }
        .order-summary-item .item-name span {
            color: var(--dark-matcha);
            font-weight: 500;
        }

        .order-summary-total {
            margin-top: 20px;
            padding-top: 20px;
            border-top: 2px solid var(--dark-matcha);
            display: flex;
            justify-content: space-between;
            font-size: 1.4rem;
            font-weight: 600;
            color: var(--dark-matcha);
        }

        .payment-options .form-check {
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            margin-bottom: 10px;
            cursor: pointer;
            transition: all 0.3s;
        }
        .payment-options .form-check:hover {
            background-color: var(--light-matcha);
            border-color: var(--matcha-green);
        }
        .payment-options .form-check-input:checked + .form-check-label {
            font-weight: 600;
            color: var(--dark-matcha);
        }

        .btn-place-order {
            background: linear-gradient(to right, var(--japan-red), #a71d1d);
            color: white; border: none; padding: 15px 30px; border-radius: 8px;
            font-weight: 600; text-decoration: none; display: block; width:100%;
            transition: all 0.3s; font-size: 1.1rem; text-align:center;
            margin-top:20px;
        }
        .btn-place-order:hover {
            color:white; transform: translateY(-2px); box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        }

        /* Responsiveness */
        @media (max-width: 992px) {
            .checkout-layout {
                grid-template-columns: 1fr;
            }
            .order-summary {
                margin-top: 30px;
            }
        }
        
        
        :root { --matcha-green: #a6c48a; --dark-matcha: #678d58; --light-matcha: #f0f7e6; --cream: #f9f9f5; --japan-red: #c82525; }
        body { font-family: 'Poppins', sans-serif; background-color: var(--cream); color: #333; margin:0; padding:0; line-height:1.6; }
        .container { max-width: 1200px; margin: 0 auto; padding: 20px; }
        .checkout-layout { display: grid; grid-template-columns: 1.2fr 0.8fr; gap: 40px; align-items: flex-start; }
        .checkout-form, .order-summary { background-color: #fff; padding: 30px; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.08); }
        .form-section-title { font-size: 1.5rem; color: var(--dark-matcha); margin-bottom: 20px; border-bottom: 2px solid var(--light-matcha); padding-bottom: 10px; }
        .order-summary-item, .order-summary-fee { display: flex; justify-content: space-between; align-items: center; padding: 10px 0; font-size: 0.95rem; }
        .order-summary-total { margin-top: 15px; padding-top: 15px; border-top: 2px solid var(--dark-matcha); display: flex; justify-content: space-between; font-size: 1.4rem; font-weight: 600; color: var(--dark-matcha); }
        .payment-options .form-check { padding: 12px; border: 1px solid #ddd; border-radius: 5px; margin-bottom: 10px; cursor: pointer; }
        .btn-place-order { background: linear-gradient(to right, var(--japan-red), #a71d1d); color: white; border: none; padding: 15px 30px; border-radius: 8px; font-weight: 600; text-decoration: none; display: block; width:100%; font-size: 1.1rem; text-align:center; margin-top:20px; }
    </style>
</head>
<body>
    <header>
        <div class="container"><div class="logo">Matcha<span>ku</span> - 抹茶の逸品</div></div>
    </header>
    <nav>
        <ul>
            <li><a href="home.jsp">Home</a></li>
            <li><a href="home.jsp#products">Products</a></li>
            <li><a href="aboutMatchaku.jsp">About Matcha</a></li>
            <li><a href="home.jsp#contact">Contact</a></li>
            <li><a href="cart.jsp" class="active">Cart</a></li>
        </ul>
    </nav>
    
    <%
        String checkoutError = (String) session.getAttribute("checkoutError");
        if (checkoutError != null) {
    %>
        <div class="container mt-3">
            <div class="alert alert-danger">
                <strong>Terjadi Masalah:</strong><br>
                <%= checkoutError %>
            </div>
        </div>
    <%
            session.removeAttribute("checkoutError"); // Hapus pesan setelah ditampilkan
        }
    %>

    <div class="container">
        <h1 class="page-title">Checkout</h1>
        <form action="ProcessOrderServlet" method="post">
            <div class="checkout-layout">
                <div class="checkout-form">
                    <h3 class="form-section-title">Shipping Details</h3>
                    <%-- Form Shipping Details --%>
                    <div class="row"><div class="col-md-12 form-group"><label for="fullName">Full Name</label><input type="text" id="fullName" name="fullName" class="form-control" required></div></div>
                    <div class="row"><div class="col-md-6 form-group"><label for="email">Email Address</label><input type="email" id="email" name="email" class="form-control" required></div><div class="col-md-6 form-group"><label for="phone">Phone Number</label><input type="tel" id="phone" name="phone" class="form-control" required></div></div>
                    <div class="form-group"><label for="address">Shipping Address</label><textarea id="address" name="address" rows="3" class="form-control" required></textarea></div>
                    <div class="row"><div class="col-md-8 form-group"><label for="city">City</label><input type="text" id="city" name="city" class="form-control" required></div><div class="col-md-4 form-group"><label for="postalCode">Postal Code</label><input type="text" id="postalCode" name="postalCode" class="form-control" required></div></div>

                    <h3 class="form-section-title" style="margin-top: 30px;">Metode Pengiriman</h3>
                    <div class="payment-options">
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="shippingMethod" id="sameday" value="Sameday" data-price="20000" checked required>
                            <label class="form-check-label d-flex justify-content-between" for="sameday">
                                <span><i class="fas fa-shipping-fast"></i> Sameday (6-8 Jam)</span>
                                <span>Rp 20.000</span>
                            </label>
                        </div>
                         <div class="form-check">
                            <input class="form-check-input" type="radio" name="shippingMethod" id="instant" value="Instant" data-price="30000" required>
                            <label class="form-check-label d-flex justify-content-between" for="instant">
                                <span><i class="fas fa-motorcycle"></i> Instant (1-2 Jam)</span>
                                <span>Rp 30.000</span>
                            </label>
                        </div>
                    </div>
                    <h3 class="form-section-title" style="margin-top: 30px;">Payment Method</h3>
                    <div class="payment-options">
                        <div class="form-check"><input class="form-check-input" type="radio" name="paymentMethod" id="bankTransfer" value="Bank Transfer" checked required><label class="form-check-label" for="bankTransfer"><i class="fas fa-university"></i> Bank Transfer</label></div>
                        <div class="form-check"><input class="form-check-input" type="radio" name="paymentMethod" id="eWallet" value="E-Wallet" required><label class="form-check-label" for="eWallet"><i class="fas fa-wallet"></i> E-Wallet</label></div>
                    </div>
                </div>
                
                <div class="order-summary">
                    <h3 class="form-section-title">Your Order Summary</h3>
                    <div class="order-summary-items">
                    <% for (AddToCartServlet.CartItem item : cart) { %>
                        <div class="order-summary-item">
                            <span><%= item.getName() %> <span>x <%= item.getQuantity() %></span></span>
                            <span><%= rupiahCurrencyFormat.format(item.getSubtotal()) %></span>
                        </div>
                    <% } %>
                    </div>
                    <hr class="my-3">
                    <div class="order-summary-fee">
                        <span>Subtotal</span>
                        <span><%= rupiahCurrencyFormat.format(itemsSubtotal) %></span>
                    </div>
                    <div class="order-summary-fee">
                        <span>Ongkos Kirim</span>
                        <span id="shipping-cost-display"></span>
                    </div>
                    <div class="order-summary-total">
                        <span>TOTAL</span>
                        <span id="grand-total-display"></span>
                    </div>
                    <button type="submit" class="btn-place-order">Place Order <i class="fas fa-check-circle"></i></button>
                </div>
            </div>
        </form>
    </div>
    
    <script>
        // JavaScript tidak perlu diubah sama sekali
        document.addEventListener('DOMContentLoaded', function() {
            const shippingOptions = document.querySelectorAll('input[name="shippingMethod"]');
            const shippingCostDisplay = document.getElementById('shipping-cost-display');
            const grandTotalDisplay = document.getElementById('grand-total-display');
            const itemsSubtotal = <%= itemsSubtotal %>;
            const rupiah = (number) => new Intl.NumberFormat('id-ID', { style: 'currency', currency: 'IDR', minimumFractionDigits: 0, maximumFractionDigits: 0 }).format(number);
            function updateTotals() {
                const selectedShipping = document.querySelector('input[name="shippingMethod"]:checked');
                if (!selectedShipping) return;
                const shippingCost = parseFloat(selectedShipping.getAttribute('data-price'));
                const grandTotal = itemsSubtotal + shippingCost;
                shippingCostDisplay.innerText = rupiah(shippingCost);
                grandTotalDisplay.innerText = rupiah(grandTotal);
            }
            shippingOptions.forEach(option => option.addEventListener('change', updateTotals));
            updateTotals();
        });
    </script>
</body>
</html>