<%@ page import="java.sql.*" %>
<%
    Connection conn = null;
    // Check if connection already exists and is valid to avoid re-creating it unnecessarily on every include
    // This is a basic check; a robust solution would involve a connection pool.
    Object connObj = application.getAttribute("koneksi");
    if (connObj instanceof Connection) {
        conn = (Connection) connObj;
        try {
            if (conn != null && !conn.isClosed()) {
                // Connection is valid, do nothing
            } else {
                conn = null; // Mark as null to re-initialize
            }
        } catch (SQLException e) {
            conn = null; // Mark as null on error
            e.printStackTrace();
        }
    }

    if (conn == null) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            // Ensure your database name is 'transaksi' for this specific connection
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/transaksi", "root", "");
            application.setAttribute("koneksi", conn);
            System.out.println("Koneksi.jsp: New database connection established and set in application scope.");
        } catch(Exception e) {
            out.println("Koneksi Gagal: " + e.getMessage());
            e.printStackTrace(); // Print stack trace for debugging
        }
    } else {
        // System.out.println("Koneksi.jsp: Using existing database connection from application scope.");
    }
%>