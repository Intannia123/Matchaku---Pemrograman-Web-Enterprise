<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<jsp:include page="koneksi.jsp" />
<%
    // Ambil semua data dari form
    int id = Integer.parseInt(request.getParameter("id"));
    String nama = request.getParameter("nama_pelanggan");
    String email = request.getParameter("customer_email");
    String alamat = request.getParameter("alamat");
    String telepon = request.getParameter("telepon");
    String status = request.getParameter("status_pesanan");

    Connection conn = (Connection) application.getAttribute("koneksi");
    PreparedStatement pstmt = null;

    try {
        // Gunakan PreparedStatement untuk keamanan
        String sql = "UPDATE pesanan SET nama_pelanggan=?, customer_email=?, alamat=?, telepon=?, status_pesanan=? WHERE id=?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, nama);
        pstmt.setString(2, email);
        pstmt.setString(3, alamat);
        pstmt.setString(4, telepon);
        pstmt.setString(5, status);
        pstmt.setInt(6, id);

        pstmt.executeUpdate();

        session.setAttribute("statusUpdateMessage", "Pesanan #" + id + " berhasil diperbarui.");
    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("statusUpdateMessage", "Gagal memperbarui pesanan: " + e.getMessage());
    } finally {
        if (pstmt != null) pstmt.close();
    }

    // Redirect kembali ke halaman admin
    response.sendRedirect("admin_pesanan.jsp");
%>