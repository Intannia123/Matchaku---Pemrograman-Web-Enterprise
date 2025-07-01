<%@ page import="java.sql.*" %>
<jsp:include page="koneksi.jsp" />
<%
    String idStr = request.getParameter("id");
    String customerName = request.getParameter("customer_name");
    String namaBarang = request.getParameter("nama_barang");
    String jumlahStr = request.getParameter("jumlah");
    String hargaStr = request.getParameter("harga");
    String paymentMethod = request.getParameter("payment_method");

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        int id = Integer.parseInt(idStr);
        int jumlah = Integer.parseInt(jumlahStr);
        double harga = Double.parseDouble(hargaStr);
        double total = jumlah * harga;

        conn = (Connection) application.getAttribute("koneksi");
        String sql = "UPDATE db_transaksi SET customer_name=?, nama=?, jumlah=?, harga=?, total=?, payment_method=? WHERE id=?";
        pstmt = conn.prepareStatement(sql);

        pstmt.setString(1, customerName);
        pstmt.setString(2, namaBarang);
        pstmt.setInt(3, jumlah);
        pstmt.setDouble(4, harga);
        pstmt.setDouble(5, total);
        pstmt.setString(6, paymentMethod);
        pstmt.setInt(7, id);

        int rowsAffected = pstmt.executeUpdate();

        if (rowsAffected > 0) {
            session.setAttribute("transactionMessage", "Transaksi #" + id + " berhasil diperbarui!");
        } else {
            session.setAttribute("transactionError", "Gagal memperbarui, transaksi tidak ditemukan.");
        }
    } catch (Exception e) {
        session.setAttribute("transactionError", "Error: " + e.getMessage());
        e.printStackTrace();
    } finally {
        if (pstmt != null) pstmt.close();
    }

    response.sendRedirect("tampilTransaksi.jsp");
%>