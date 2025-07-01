<%@ page import="java.sql.*" %>
<jsp:include page="koneksi.jsp" />
<%
    String idPesananStr = request.getParameter("id_pesanan");
    String statusBaru = request.getParameter("status_baru");
    if (idPesananStr != null && statusBaru != null) {
        Connection conn = (Connection) application.getAttribute("koneksi");
        PreparedStatement pstmt = null;
        try {
            String sql = "UPDATE pesanan SET status_pesanan = ? WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, statusBaru);
            pstmt.setInt(2, Integer.parseInt(idPesananStr));
            pstmt.executeUpdate();
            session.setAttribute("statusUpdateMessage", "Status pesanan #" + idPesananStr + " diubah.");
        } catch (Exception e) { e.printStackTrace(); } 
        finally { if (pstmt != null) pstmt.close(); }
    }
    response.sendRedirect("admin_pesanan.jsp");
%>