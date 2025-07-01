<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<jsp:include page="koneksi.jsp" />
<%
    int id = Integer.parseInt(request.getParameter("id"));

    Connection conn = (Connection) application.getAttribute("koneksi");
    PreparedStatement pstmt1 = null;
    PreparedStatement pstmt2 = null;

    try {
        // Matikan auto-commit untuk transaksi
        conn.setAutoCommit(false);

        // 1. Hapus dulu dari tabel detail_pesanan (asumsi nama tabelnya ini)
        String sql1 = "DELETE FROM detail_pesanan WHERE id_pesanan = ?";
        pstmt1 = conn.prepareStatement(sql1);
        pstmt1.setInt(1, id);
        pstmt1.executeUpdate();
        
        // 2. Baru hapus dari tabel pesanan utama
        String sql2 = "DELETE FROM pesanan WHERE id = ?";
        pstmt2 = conn.prepareStatement(sql2);
        pstmt2.setInt(1, id);
        int rowsAffected = pstmt2.executeUpdate();

        // Jika berhasil, commit transaksi
        conn.commit();

        if (rowsAffected > 0) {
            session.setAttribute("statusUpdateMessage", "Pesanan #" + id + " berhasil dihapus.");
        } else {
            session.setAttribute("statusUpdateMessage", "Pesanan #" + id + " tidak ditemukan.");
        }

    } catch (SQLException e) {
        // Jika terjadi error, batalkan semua perubahan
        conn.rollback();
        e.printStackTrace();
        session.setAttribute("statusUpdateMessage", "Gagal menghapus pesanan: " + e.getMessage());
    } finally {
        // Kembalikan auto-commit ke kondisi normal dan tutup statement
        conn.setAutoCommit(true);
        if (pstmt1 != null) pstmt1.close();
        if (pstmt2 != null) pstmt2.close();
    }

    response.sendRedirect("admin_pesanan.jsp");
%>