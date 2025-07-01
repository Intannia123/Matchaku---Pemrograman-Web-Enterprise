<%@ page import="java.sql.*" %>
<jsp:include page="koneksi.jsp" />

<%
    // Ambil semua data dari form yang baru
    String customerName = request.getParameter("customer_name");
    String namaBarang = request.getParameter("nama_barang");
    String jumlahStr = request.getParameter("jumlah");
    String hargaStr = request.getParameter("harga");
    String paymentMethod = request.getParameter("payment_method");

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        // Validasi dasar, pastikan tidak ada yang null atau kosong
        if (customerName == null || customerName.trim().isEmpty() ||
            namaBarang == null || namaBarang.trim().isEmpty() ||
            jumlahStr == null || jumlahStr.trim().isEmpty() ||
            hargaStr == null || hargaStr.trim().isEmpty() ||
            paymentMethod == null || paymentMethod.trim().isEmpty()) {
            
            throw new Exception("Semua field wajib diisi.");
        }

        int jumlah = Integer.parseInt(jumlahStr);
        double harga = Double.parseDouble(hargaStr);
        double total = jumlah * harga;

        conn = (Connection) application.getAttribute("koneksi");
        if (conn == null || conn.isClosed()) {
            throw new SQLException("Koneksi ke database gagal.");
        }

        // Query INSERT yang sudah disesuaikan dengan semua kolom
        String sql = "INSERT INTO db_transaksi (customer_name, nama, jumlah, harga, total, payment_method) VALUES (?, ?, ?, ?, ?, ?)";
        pstmt = conn.prepareStatement(sql);

        pstmt.setString(1, customerName);
        pstmt.setString(2, namaBarang);
        pstmt.setInt(3, jumlah);
        pstmt.setDouble(4, harga);
        pstmt.setDouble(5, total);
        pstmt.setString(6, paymentMethod);

        int rowsAffected = pstmt.executeUpdate();

        if (rowsAffected > 0) {
            session.setAttribute("transactionMessage", "Transaksi baru untuk '" + customerName + "' berhasil disimpan!");
        } else {
            throw new SQLException("Gagal menyimpan transaksi, tidak ada baris yang terpengaruh di database.");
        }

    } catch (NumberFormatException nfe) {
        session.setAttribute("transactionError", "Input jumlah dan harga harus berupa angka yang valid.");
        nfe.printStackTrace();
    } catch (Exception e) {
        session.setAttribute("transactionError", "Terjadi kesalahan: " + e.getMessage());
        e.printStackTrace();
    } finally {
        if (pstmt != null) {
            try {
                pstmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        // Jangan tutup koneksi dari application scope
    }

    // Arahkan kembali ke halaman transaksi untuk melihat hasilnya
    response.sendRedirect("tampilTransaksi.jsp");
%>