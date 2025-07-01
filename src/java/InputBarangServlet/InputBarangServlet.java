package InputBarangServlet; // Sesuaikan package Anda

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.UUID;

@WebServlet("/InputBarangServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
                 maxFileSize = 1024 * 1024 * 10,      // 10MB
                 maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class InputBarangServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    // Ganti dengan path absolut ke folder uploads di server Anda
    private static final String UPLOAD_DIR = "uploads"; 

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String applicationPath = request.getServletContext().getRealPath("");
        String uploadFilePath = applicationPath + File.separator + UPLOAD_DIR;
        
        File uploadDir = new File(uploadFilePath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        String namaBarang = request.getParameter("namaBarang");
        String deskripsiBarang = request.getParameter("deskripsiBarang"); // Ambil deskripsi
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        int harga = Integer.parseInt(request.getParameter("harga"));
        
        Part filePart = request.getPart("gambarBarang");
        String fileName = null;
        String dbFileName = null;

        if (filePart != null && filePart.getSize() > 0) {
            fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            // Buat nama file unik untuk menghindari konflik
            String uniqueID = UUID.randomUUID().toString();
            String extension = "";
            int i = fileName.lastIndexOf('.');
            if (i > 0) {
                extension = fileName.substring(i);
            }
            dbFileName = uniqueID + extension; // Nama file yang disimpan di DB
            
            try (InputStream fileContent = filePart.getInputStream()) {
                Files.copy(fileContent, Paths.get(uploadFilePath + File.separator + dbFileName), StandardCopyOption.REPLACE_EXISTING);
            } catch (Exception e) {
                request.setAttribute("error", "File upload failed: " + e.getMessage());
                RequestDispatcher dispatcher = request.getRequestDispatcher("masterBarang.jsp");
                dispatcher.forward(request, response);
                return;
            }
        }

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/barang", "root", "");
            
            // Modifikasi SQL untuk menyertakan deskripsi
            String sql = "INSERT INTO barang (nama_barang, gambar, quantity, harga, deskripsi) VALUES (?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, namaBarang);
            pstmt.setString(2, dbFileName); // Simpan nama file unik
            pstmt.setInt(3, quantity);
            pstmt.setInt(4, harga);
            pstmt.setString(5, deskripsiBarang); // Tambahkan deskripsi

            int row = pstmt.executeUpdate();
            if (row > 0) {
                request.setAttribute("message", "Barang berhasil ditambahkan!");
            } else {
                request.setAttribute("error", "Gagal menambahkan barang.");
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