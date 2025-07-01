// Pastikan nama package sesuai dengan proyek Anda
package ProcessOrderServlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.Serializable;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;

// Pastikan import class CartItem Anda sudah benar
import AddToCartServlet.CartItem;

@WebServlet("/ProcessOrderServlet")
public class ProcessOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // --- Detail koneksi Anda ---
    private String dbURL = "jdbc:mysql://localhost:3306/transaksi";
    private String dbUser = "root";
    private String dbPass = "";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Connection conn = null;

        // Ambil data dari form dan keranjang belanja
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address") + ", " + request.getParameter("city") + ", " + request.getParameter("postalCode");
        String shippingMethod = request.getParameter("shippingMethod");
        String paymentMethod = request.getParameter("paymentMethod");
        
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect("cart.jsp");
            return;
        }

        try {
            DriverManager.registerDriver(new com.mysql.cj.jdbc.Driver());
            conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
            conn.setAutoCommit(false); // Mulai transaction

            // Hitung total harga
            double itemsSubtotal = 0;
            for (CartItem item : cart) {
                itemsSubtotal += item.getSubtotal();
            }

            // --- REKOMENDASI: Logika perhitungan ongkos kirim dibuat lebih jelas ---
            double shippingCost = 0;
            if ("Sameday".equals(shippingMethod)) {
                shippingCost = 20000;
            } else if ("Instant".equals(shippingMethod)) {
                shippingCost = 30000;
            }
            
            double grandTotal = itemsSubtotal + shippingCost;

            // --- PERBAIKAN 1: Memperbarui Query INSERT agar mencakup SEMUA kolom yang relevan ---
            String sqlInsertPesanan = "INSERT INTO pesanan " +
                                      "(nama_pelanggan, customer_email, alamat, telepon, total_harga, payment_method, status_pesanan, tanggal_pesanan, subtotal_produk, ongkos_kirim, metode_pengiriman) " +
                                      "VALUES (?, ?, ?, ?, ?, ?, 'Pending', NOW(), ?, ?, ?)";
                                      
            PreparedStatement pstmtPesanan = conn.prepareStatement(sqlInsertPesanan, Statement.RETURN_GENERATED_KEYS);
            
            // --- PERBAIKAN 2: Menambahkan dan menyesuaikan parameter untuk query baru ---
            pstmtPesanan.setString(1, fullName);
            pstmtPesanan.setString(2, email);
            pstmtPesanan.setString(3, address);
            pstmtPesanan.setString(4, phone);
            pstmtPesanan.setDouble(5, grandTotal);        // total_harga
            pstmtPesanan.setString(6, paymentMethod);     // payment_method
            // Kolom-kolom BARU yang ditambahkan:
            pstmtPesanan.setDouble(7, itemsSubtotal);     // subtotal_produk
            pstmtPesanan.setDouble(8, shippingCost);      // ongkos_kirim
            pstmtPesanan.setString(9, shippingMethod);    // metode_pengiriman
            
            pstmtPesanan.executeUpdate();

            // Ambil ID pesanan baru (sudah benar)
            ResultSet generatedKeys = pstmtPesanan.getGeneratedKeys();
            int orderId = -1;
            if (generatedKeys.next()) {
                orderId = generatedKeys.getInt(1);
            } else {
                throw new SQLException("Gagal membuat pesanan, ID tidak didapatkan.");
            }
            pstmtPesanan.close();

            // 2. Simpan setiap item ke tabel 'detail_pesanan' (sudah benar)
            String sqlInsertDetail = "INSERT INTO detail_pesanan (id_pesanan, nama_produk, jumlah, harga_satuan, subtotal) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement pstmtDetail = conn.prepareStatement(sqlInsertDetail);
            for (CartItem item : cart) {
                pstmtDetail.setInt(1, orderId);
                pstmtDetail.setString(2, item.getName());
                pstmtDetail.setInt(3, item.getQuantity());
                pstmtDetail.setDouble(4, item.getPrice());
                pstmtDetail.setDouble(5, item.getSubtotal());
                pstmtDetail.addBatch();
            }
            pstmtDetail.executeBatch();
            pstmtDetail.close();
            
            // 3. Jika semua berhasil, commit dan arahkan ke halaman sukses (sudah benar)
            conn.commit();
            
            session.removeAttribute("cart");
            session.setAttribute("orderSuccessMessage", "Pesanan Anda dengan ID #" + orderId + " telah kami terima!");
            response.sendRedirect("order-confirmation.jsp?id=" + orderId);

        } catch (Exception e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
            session.setAttribute("checkoutError", "Terjadi kesalahan sistem: " + e.getMessage());
            response.sendRedirect("checkout.jsp");
        } finally {
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
}