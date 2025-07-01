package GambarServlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.*;
import java.nio.file.*;
import java.sql.*;

@WebServlet("/gambar")
public class GambarServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));

        try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/barang", "root", "");
             PreparedStatement stmt = conn.prepareStatement("SELECT gambar FROM barang WHERE id = ?")) {

            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Blob blob = rs.getBlob("gambar");
                byte[] bytes = blob.getBytes(1, (int) blob.length());
                response.setContentType("image/jpeg");
                response.getOutputStream().write(bytes);
            }
        } catch (Exception e) {
            response.sendError(500, "Gagal menampilkan gambar");
        }
    }
}
