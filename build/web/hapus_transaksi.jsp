<%@ page import="java.sql.*" %>
<jsp:include page="koneksi.jsp" />

<%
    String idStr = request.getParameter("id");
    Connection conn = null;
    PreparedStatement pstmt = null;

    // === PERBAIKAN DIMULAI DI SINI ===
    // 1. Cek dulu apakah idStr benar-benar ada isinya (tidak null dan tidak kosong)
    if (idStr != null && !idStr.trim().isEmpty()) {
        try {
            int id = Integer.parseInt(idStr);
            conn = (Connection) application.getAttribute("koneksi");

            if (conn == null || conn.isClosed()) {
                throw new SQLException("Koneksi ke database gagal.");
            }
            
            String sql = "DELETE FROM db_transaksi WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);

            int rowsAffected = pstmt.executeUpdate();
            
            if (rowsAffected > 0) {
                session.setAttribute("transactionMessage", "Transaksi #" + id + " berhasil dihapus.");
            } else {
                session.setAttribute("transactionError", "Gagal menghapus, transaksi dengan ID #" + id + " tidak ditemukan.");
            }

        } catch (NumberFormatException nfe) {
            // Ini akan menangani jika ID yang dikirim bukan angka (misal: "abc")
            session.setAttribute("transactionError", "Gagal menghapus: Format ID tidak valid.");
            nfe.printStackTrace();
        } catch (Exception e) {
            session.setAttribute("transactionError", "Terjadi kesalahan saat menghapus data: " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (pstmt != null) {
                try { pstmt.close(); } catch (SQLException e) {}
            }
        }
    } else {
        // 2. Jika idStr kosong atau null, langsung buat pesan error.
        session.setAttribute("transactionError", "Gagal menghapus: ID transaksi tidak dipilih atau tidak valid.");
    }
    // === PERBAIKAN SELESAI ===

    response.sendRedirect("tampilTransaksi.jsp");
%>