<%@ page import="java.sql.*" %>
<jsp:include page="koneksi.jsp" />
<%
    // Ambil ID dan status baru dari form yang disubmit
    String idTransaksiStr = request.getParameter("id");
    String statusBaru = request.getParameter("status_baru");

    if (idTransaksiStr != null && statusBaru != null) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = (Connection) application.getAttribute("koneksi");
            // Query UPDATE ke tabel db_transaksi
            String sql = "UPDATE db_transaksi SET status_pesanan = ? WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, statusBaru);
            pstmt.setInt(2, Integer.parseInt(idTransaksiStr));
            
            int rowsAffected = pstmt.executeUpdate();
            if(rowsAffected > 0){
                session.setAttribute("transactionMessage", "Status transaksi #" + idTransaksiStr + " berhasil diubah menjadi '" + statusBaru + "'.");
            } else {
                session.setAttribute("transactionError", "Gagal update, transaksi #" + idTransaksiStr + " tidak ditemukan.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("transactionError", "Error: " + e.getMessage());
        } finally {
            if (pstmt != null) pstmt.close();
            // Jangan tutup koneksi dari application scope
        }
    }
    // Arahkan kembali ke halaman transaksi
    response.sendRedirect("tampilTransaksi.jsp");
%>