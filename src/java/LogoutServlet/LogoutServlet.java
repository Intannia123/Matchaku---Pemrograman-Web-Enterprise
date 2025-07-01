// Ganti 'com.matchaku.servlets' dengan nama package proyek Anda
package LogoutServlet;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet untuk menangani proses logout pengguna.
 * Anotasi @WebServlet("/LogoutServlet") secara otomatis memetakan URL ini ke servlet,
 * sehingga link <a href="LogoutServlet"> akan memanggil kelas ini.
 */
@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Metode ini dipanggil saat pengguna mengklik link logout (permintaan GET).
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // 1. Dapatkan sesi (session) yang saat ini aktif.
        // Parameter 'false' berarti "dapatkan sesi jika ada, tapi jangan buat yang baru".
        HttpSession session = request.getSession(false);
        
        // 2. Periksa apakah sesi benar-benar ada sebelum mencoba menghancurkannya.
        if (session != null) {
            // 3. Hancurkan sesi. Ini adalah perintah inti dari proses logout.
            // Perintah ini akan menghapus semua atribut yang tersimpan di sesi,
            // seperti "userName", "userEmail", "role", dan juga data "cart".
            session.invalidate();
        }
        
        // 4. Setelah sesi dihancurkan, alihkan (redirect) pengguna kembali ke halaman login.
        response.sendRedirect("login.jsp");
    }
}