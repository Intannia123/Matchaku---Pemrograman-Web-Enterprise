<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<jsp:include page="koneksi.jsp" />
<%
    // Mengambil ID pesanan terakhir yang diketahui oleh klien/admin
    String lastOrderIdStr = request.getParameter("latestOrderId");
    int latestOrderId = 0;
    if (lastOrderIdStr != null && !lastOrderIdStr.equals("NaN")) {
        try {
            latestOrderId = Integer.parseInt(lastOrderIdStr);
        } catch (NumberFormatException e) {
            // Abaikan jika format salah, tetap 0
        }
    }

    Connection conn = (Connection) application.getAttribute("koneksi");
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    boolean hasNewOrder = false;
    
    try {
        // Query untuk menghitung pesanan dengan ID yang lebih besar dari yang terakhir dilihat
        String sql = "SELECT COUNT(*) as new_count FROM pesanan WHERE id > ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, latestOrderId);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            if (rs.getInt("new_count") > 0) {
                hasNewOrder = true;
            }
        }
    } catch (Exception e) {
        // Jika ada error, anggap tidak ada pesanan baru untuk menghindari notifikasi palsu
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
    }

    // Mengirimkan respons dalam format JSON
    // Ini akan dibaca oleh JavaScript di halaman admin
    out.clear();
    out.print("{ \"new_order\": " + hasNewOrder + " }");
    out.flush();
%>