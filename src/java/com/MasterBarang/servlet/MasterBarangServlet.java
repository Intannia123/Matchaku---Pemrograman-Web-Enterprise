package com.MasterBarang.servlet;

import java.io.InputStream;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/inputBarang")
@MultipartConfig(maxFileSize = 16177215) // 16MB max file
public class MasterBarangServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8"); // penting untuk mencegah error karakter
        String nama = request.getParameter("namaBarang");
        int qty = Integer.parseInt(request.getParameter("quantity"));
        double harga = Double.parseDouble(request.getParameter("harga"));
        Part filePart = request.getPart("gambarBarang");

        InputStream inputStream = null;
        if (filePart != null && filePart.getSize() > 0) {
            inputStream = filePart.getInputStream();
        }

        String message;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/barang", "root", "");
                 PreparedStatement stmt = conn.prepareStatement(
                     "INSERT INTO barang (nama_barang, gambar, quantity, harga) VALUES (?, ?, ?, ?)")) {

                stmt.setString(1, nama);
                if (inputStream != null) {
                    stmt.setBlob(2, inputStream);
                } else {
                    stmt.setNull(2, Types.BLOB);
                }
                stmt.setInt(3, qty);
                stmt.setDouble(4, harga);

                int row = stmt.executeUpdate();
                message = (row > 0) ? "Data berhasil disimpan ke database!" : "Gagal menyimpan data.";
            }
        } catch (Exception e) {
            message = "Gagal menyimpan: " + e.getMessage();
        }

        request.setAttribute("message", message);
        request.getRequestDispatcher("masterBarang.jsp").forward(request, response);
    }
}
