package editBarangServlet; // Sesuaikan package Anda

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/editBarangServlet") // Pastikan nama servlet ini sesuai dengan action form di JSP
public class editBarangServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String id = request.getParameter("id");
        String namaBarang = request.getParameter("namaBarang");
        String deskripsiBarang = request.getParameter("deskripsiBarang"); // Ambil deskripsi
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        int harga = Integer.parseInt(request.getParameter("harga"));

        // Gambar tidak diupdate di sini untuk simplisitas, Anda bisa menambahkannya jika perlu

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/barang", "root", "");
            
            // Modifikasi SQL untuk update deskripsi
            String sql = "UPDATE barang SET nama_barang = ?, quantity = ?, harga = ?, deskripsi = ? WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, namaBarang);
            pstmt.setInt(2, quantity);
            pstmt.setInt(3, harga);
            pstmt.setString(4, deskripsiBarang); // Tambahkan deskripsi
            pstmt.setString(5, id);

            int row = pstmt.executeUpdate();
            if (row > 0) {
                request.setAttribute("message", "Barang berhasil diperbarui!");
            } else {
                request.setAttribute("error", "Gagal memperbarui barang atau tidak ada data yang berubah.");
            }
        } catch (ClassNotFoundException | SQLException e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("masterBarang.jsp");
        dispatcher.forward(request, response);
    }
}