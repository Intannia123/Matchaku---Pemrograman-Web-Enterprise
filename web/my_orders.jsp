<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, java.text.NumberFormat, java.text.SimpleDateFormat, java.util.Locale" %>
<%
    // Security Check
    String loggedInUserName = (String) session.getAttribute("userName");
    if (loggedInUserName == null || loggedInUserName.isEmpty()) {
        response.sendRedirect("login.jsp?error=Please+login+to+view+your+orders.");
        return;
    }

    // Formatters
    NumberFormat rupiahCurrencyFormat = NumberFormat.getCurrencyInstance(new Locale("id", "ID"));
    rupiahCurrencyFormat.setMaximumFractionDigits(0);
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yy, HH:mm", new Locale("id", "ID"));
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Orders - Matchaku</title>
    <style>
        /* CSS Lengkap dari sebelumnya */
        :root {
            --matcha-green: #a6c48a;
            --dark-matcha: #678d58;
            --light-matcha: #f0f7e6;
            --cream: #f9f9f5;
            --japan-red: #c82525;
            --grey-text: #555;
        }
        body { font-family: 'Poppins', 'Helvetica Neue', Arial, sans-serif; background-color: var(--cream); color: #333; margin: 0; padding: 0; line-height: 1.6; }
        .container { max-width: 1200px; margin: 0 auto; padding: 20px; }
        header { background: linear-gradient(135deg, var(--dark-matcha), var(--matcha-green)); padding: 25px 0; text-align: center; box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
        .logo { font-size: 2.8rem; color: white; text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3); letter-spacing: 1px; font-weight: 600; }
        nav { background-color: var(--dark-matcha); padding: 12px 0; position: sticky; top: 0; z-index: 100; }
        .dropdown { position: relative; }
        .dropdown-menu { display: none; position: absolute; top: 100%; right: 0; background-color: var(--cream); min-width: 200px; box-shadow: 0 8px 16px rgba(0,0,0,0.2); z-index: 101; border-radius: 8px; padding: 10px 0; margin-top: 10px; border: 1px solid var(--light-matcha); }
        .dropdown-menu a, .dropdown-header { color: var(--dark-matcha); padding: 12px 20px; text-decoration: none; display: block; text-align: left; font-size: 1rem; }
        .dropdown-menu a:hover { background-color: var(--light-matcha); }
        .dropdown-header { font-size: 0.9rem; color: #666; border-bottom: 1px solid var(--light-matcha); margin-bottom: 5px; padding-bottom: 15px; }
        .dropdown-header strong { color: var(--dark-matcha); font-size: 1.1rem; }
        .dropdown-menu.show { display: block; }
        nav ul { display: flex; justify-content: center; list-style: none; padding: 0; margin: 0; }
        nav li { margin: 0 20px; }
        nav a { color: white; text-decoration: none; font-weight: 500; padding: 8px 15px; border-radius: 20px; transition: all 0.3s; font-size: 1.1rem; }
        .page-title { text-align: center; margin: 40px 0 30px; color: var(--dark-matcha); font-size: 2.5rem; position: relative; display: inline-block; padding-bottom: 10px; left: 50%; transform: translateX(-50%); }
        .page-title:after { content: ''; position: absolute; bottom: 0; left: 50%; transform: translateX(-50%); width: 80px; height: 4px; background: var(--matcha-green); border-radius: 2px; }
        .order-history-container { max-width: 900px; margin: 0 auto; }
        .order-card { background-color: #fff; border-radius: 12px; box-shadow: 0 6px 15px rgba(0,0,0,0.08); margin-bottom: 30px; overflow: hidden; border: 1px solid var(--light-matcha); transition: box-shadow 0.3s ease; }
        .order-card:hover { box-shadow: 0 10px 25px rgba(0,0,0,0.1); }
        .order-header { background-color: var(--light-matcha); padding: 15px 25px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #e9e9e9; flex-wrap: wrap; gap: 15px; }
        .order-header-info { font-size: 0.95rem; color: var(--grey-text); }
        .order-header-info strong { color: var(--dark-matcha); font-weight: 600; }
        .order-status { font-weight: 600; padding: 6px 15px; border-radius: 20px; font-size: 0.9rem; text-transform: capitalize; }
        .order-status[data-status="Pending"], .order-status[data-status="pending"] { background-color: #ffc107; color: #333; }
        .order-status[data-status="Diproses"], .order-status[data-status="diproses"] { background-color: #0dcaf0; color: #333; }
        .order-status[data-status="Dikirim"], .order-status[data-status="dikirim"] { background-color: #6c757d; color: white; }
        .order-status[data-status="Selesai"], .order-status[data-status="selesai"] { background-color: #198754; color: white; }
        .order-status[data-status="Dibatalkan"], .order-status[data-status="dibatalkan"] { background-color: #dc3545; color: white; }
        .order-body { padding: 15px 25px 25px 25px; }
        .order-item { display: flex; align-items: center; gap: 20px; padding: 12px 0; }
        .order-item:not(:last-child) { border-bottom: 1px solid #f0f0f0; }
        .order-item-details { flex-grow: 1; }
        .order-item-name { font-weight: 600; color: var(--dark-matcha); }
        .order-item-qty-price { font-size: 0.9rem; color: #666; }
        .order-item-total { font-weight: 700; font-size: 1rem; margin-left: auto; color: #333; }
        .no-orders { text-align: center; padding: 50px 20px; background-color: #fff; border-radius: 12px; }

        /* --- CSS BARU UNTUK DETAIL PESANAN --- */
        .toggle-details-btn {
            background-color: transparent; border: 1px solid var(--dark-matcha); color: var(--dark-matcha);
            padding: 5px 15px; border-radius: 20px; font-size: 0.85rem; cursor: pointer; transition: all 0.3s ease;
        }
        .toggle-details-btn:hover { background-color: var(--dark-matcha); color: white; }
        .toggle-details-btn i { margin-right: 5px; }
        .order-footer-details {
            display: none; /* Sembunyi secara default */
            background-color: #fdfdfd;
            padding: 25px;
            border-top: 1px solid #e9e9e9;
        }
        .order-footer-details.details-visible { display: grid; } /* Tampilkan saat class ditambahkan */
        .details-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 25px;
        }
        .detail-section h6 {
            font-weight: 600; color: var(--dark-matcha); margin-bottom: 8px;
            border-bottom: 2px solid var(--matcha-green); padding-bottom: 5px;
        }
        .detail-section p { margin-bottom: 5px; font-size: 0.95rem; color: var(--grey-text); }
        .rincian-biaya p { display: flex; justify-content: space-between; }
        .rincian-biaya p span:last-child { font-weight: 600; color: #333; }
        .rincian-biaya .total { font-size: 1.05rem; border-top: 1px solid #ddd; padding-top: 8px; margin-top: 5px; }
    </style>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <header><div class="container"><div class="logo">Matcha<span>ku</span> - 抹茶の逸品</div></div></header>
    <nav>
        </nav>
    
    <section class="container" id="my-orders">
        <h1 class="page-title">My Order History</h1>
        
        <div class="order-history-container">
        <%
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            
            Map<Integer, List<Map<String, Object>>> ordersMap = new LinkedHashMap<>();
            Map<Integer, Map<String, Object>> orderDetailsMap = new LinkedHashMap<>();

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/transaksi", "root", "");
                
                // QUERY DIPERBARUI: Menambahkan kolom detail
                String sql = "SELECT p.id, p.tanggal_pesanan, p.total_harga, p.status_pesanan, " +
                             "p.alamat, p.telepon, p.payment_method, p.metode_pengiriman, p.subtotal_produk, p.ongkos_kirim, " +
                             "dp.nama_produk, dp.jumlah, dp.harga_satuan " +
                             "FROM pesanan p " +
                             "JOIN detail_pesanan dp ON p.id = dp.id_pesanan " +
                             "WHERE p.nama_pelanggan = ? " +
                             "ORDER BY p.tanggal_pesanan DESC, p.id DESC";
                             
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, loggedInUserName);
                rs = pstmt.executeQuery();
                
                while(rs.next()) {
                    int orderId = rs.getInt("id");
                    
                    if (!orderDetailsMap.containsKey(orderId)) {
                        Map<String, Object> orderMeta = new HashMap<>();
                        orderMeta.put("tanggal_pesanan", rs.getTimestamp("tanggal_pesanan"));
                        orderMeta.put("total_harga", rs.getDouble("total_harga"));
                        orderMeta.put("status_pesanan", rs.getString("status_pesanan"));
                        // Menyimpan detail tambahan
                        orderMeta.put("alamat", rs.getString("alamat"));
                        orderMeta.put("telepon", rs.getString("telepon"));
                        orderMeta.put("payment_method", rs.getString("payment_method"));
                        orderMeta.put("metode_pengiriman", rs.getString("metode_pengiriman"));
                        orderMeta.put("subtotal_produk", rs.getDouble("subtotal_produk"));
                        orderMeta.put("ongkos_kirim", rs.getDouble("ongkos_kirim"));
                        
                        orderDetailsMap.put(orderId, orderMeta);
                        ordersMap.put(orderId, new ArrayList<>());
                    }
                    
                    Map<String, Object> item = new HashMap<>();
                    item.put("nama_produk", rs.getString("nama_produk"));
                    item.put("jumlah", rs.getInt("jumlah"));
                    item.put("harga_satuan", rs.getDouble("harga_satuan"));
                    ordersMap.get(orderId).add(item);
                }

                if (ordersMap.isEmpty()) {
        %>
            <div class="no-orders"></div>
        <%
                } else {
                    for (Map.Entry<Integer, List<Map<String, Object>>> entry : ordersMap.entrySet()) {
                        int orderId = entry.getKey();
                        Map<String, Object> orderDetails = orderDetailsMap.get(orderId);
                        List<Map<String, Object>> items = entry.getValue();
                        
                        String formattedDate = dateFormat.format((java.util.Date) orderDetails.get("tanggal_pesanan"));
                        String status = (String) orderDetails.get("status_pesanan");
        %>
            <div class="order-card">
                <div class="order-header">
                    <div class="order-header-info">
                        <strong>Order #<%= orderId %></strong><br>
                        Tanggal: <%= formattedDate %>
                    </div>
                    <div class="order-header-info">
                        <strong>Total: <%= rupiahCurrencyFormat.format(orderDetails.get("total_harga")) %></strong>
                    </div>
                    <div>
                         <span class="order-status" data-status="<%= status %>"><%= status %></span>
                    </div>
                    <button class="toggle-details-btn">
                        <i class="fas fa-chevron-down"></i> Lihat Detail
                    </button>
                </div>

                <div class="order-body">
                <%
                    for (Map<String, Object> item : items) {
                        double hargaSatuan = (double) item.get("harga_satuan");
                        int jumlah = (int) item.get("jumlah");
                %>
                    <div class="order-item">
                        <div class="order-item-details">
                            <div class="order-item-name"><%= item.get("nama_produk") %></div>
                            <div class="order-item-qty-price"><%= jumlah %> x <%= rupiahCurrencyFormat.format(hargaSatuan) %></div>
                        </div>
                        <div class="order-item-total"><%= rupiahCurrencyFormat.format(hargaSatuan * jumlah) %></div>
                    </div>
                <%
                    } // End loop item
                %>
                </div>
                
                <div class="order-footer-details">
                    <div class="details-grid">
                        <div class="detail-section">
                            <h6>Alamat Pengiriman</h6>
                            <p><%= orderDetails.get("alamat") %></p>
                            <p><strong>Telp:</strong> <%= orderDetails.get("telepon") %></p>
                        </div>
                        <div class="detail-section">
                            <h6>Info Pembayaran & Pengiriman</h6>
                            <p><strong>Pembayaran:</strong> <%= orderDetails.get("payment_method") %></p>
                            <p><strong>Pengiriman:</strong> <%= orderDetails.get("metode_pengiriman") %></p>
                        </div>
                        <div class="detail-section rincian-biaya">
                             <h6>Rincian Pembayaran</h6>
                             <p><span>Subtotal Produk:</span> <span><%= rupiahCurrencyFormat.format(orderDetails.get("subtotal_produk")) %></span></p>
                             <p><span>Ongkos Kirim:</span> <span><%= rupiahCurrencyFormat.format(orderDetails.get("ongkos_kirim")) %></span></p>
                             <p class="total"><span>Total:</span> <span><%= rupiahCurrencyFormat.format(orderDetails.get("total_harga")) %></span></p>
                        </div>
                    </div>
                </div>

            </div>
        <%
                    } // End loop pesanan
                } // End else
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<p style='color:red; text-align:center;'>Error: " + e.getMessage() + "</p>");
            } finally {
                // Close resources
            }
        %>
        </div>
    </section>

    <script>
    document.addEventListener('DOMContentLoaded', function() {
        // --- SCRIPT UNTUK DROPDOWN NAVIGASI ---
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

        // --- SCRIPT BARU UNTUK MENAMPILKAN/SEMBUNYIKAN DETAIL PESANAN ---
        document.querySelectorAll('.toggle-details-btn').forEach(button => {
            button.addEventListener('click', function() {
                const card = this.closest('.order-card');
                const detailsSection = card.querySelector('.order-footer-details');
                const icon = this.querySelector('i');

                // Toggle class untuk menampilkan/menyembunyikan
                detailsSection.classList.toggle('details-visible');

                // Mengubah teks dan ikon tombol
                if (detailsSection.classList.contains('details-visible')) {
                    this.innerHTML = '<i class="fas fa-chevron-up"></i> Sembunyikan Detail';
                } else {
                    this.innerHTML = '<i class="fas fa-chevron-down"></i> Lihat Detail';
                }
            });
        });
    });
    </script>
</body>
</html>