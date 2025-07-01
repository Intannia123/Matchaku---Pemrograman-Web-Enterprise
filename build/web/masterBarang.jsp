<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat, java.util.Locale" %> <%-- Tambahkan untuk format harga --%>
<%
    // Currency formatter (opsional, jika ingin format harga di tabel admin)
    NumberFormat rupiahAdminFormat = NumberFormat.getCurrencyInstance(new Locale("id", "ID"));
    rupiahAdminFormat.setMaximumFractionDigits(0);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Master Barang - Dashboard Admin Matchaku</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <style>
        /* ... CSS Anda yang sudah ada ... */
        :root {
            --matcha-green: #a6c48a;
            --dark-matcha: #678d58;
            --light-matcha: #f0f7e6;
            --cream: #f9f9f5;
            --japan-red: #c82525;
            --sidebar-green: #5aa64b;
        }
        
        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--cream);
            margin: 0;
            padding: 0;
        }

        .sidebar {
            height: 100vh;
            width: 220px;
            position: fixed;
            top: 0;
            left: 0;
            background-color: #5aa64b; /* Sesuai dengan --sidebar-green */
            padding-top: 2rem;
            color: white;
        }
        .sidebar h4 {
            font-weight: 600; /* Sesuai kode Anda */
            text-align: center;
            margin-bottom: 2rem;
        }
        .sidebar a {
            display: block;
            color: white;
            padding: 0.75rem 1.5rem;
            text-decoration: none;
        }
        .sidebar a:hover, .sidebar a.active {
            background-color: #495057;
        }

        .main-content {
            margin-left: 220px;
            padding: 2rem;
        }
        .admin-header {
            background: linear-gradient(135deg, var(--dark-matcha), var(--matcha-green));
            padding: 20px 0;
            color: white;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
        }
        .admin-logo {
            text-align: center;
            font-size: 2rem;
            font-weight: 600;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
        }
        .admin-logo span { color: #fff8e1; }
        .card {
            border-radius: 12px;
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.08);
            border: none;
            margin-bottom: 2rem;
        }
        .card-header {
            background: linear-gradient(135deg, var(--dark-matcha), var(--matcha-green));
            color: white;
            border-radius: 12px 12px 0 0 !important;
            font-weight: 600;
            padding: 1rem 1.5rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .form-label { font-weight: 500; color: var(--dark-matcha); margin-bottom: 8px; }
        .form-control {
            border: 1px solid #ced4da; border-radius: 8px;
            padding: 10px 15px; transition: all 0.3s;
        }
        .form-control:focus {
            border-color: var(--matcha-green);
            box-shadow: 0 0 0 0.25rem rgba(107, 191, 89, 0.25);
        }
        .btn-matcha {
            background: linear-gradient(to right, var(--matcha-green), var(--dark-matcha));
            color: white; border: none; padding: 12px 25px; border-radius: 8px;
            font-weight: 600; transition: all 0.3s;
        }
        .btn-matcha:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(0,0,0,0.1); color: white; }
        .btn-add {
            background-color: var(--japan-red); color: white; border: none;
            border-radius: 50%; width: 40px; height: 40px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.5rem; transition: all 0.3s;
        }
        .btn-add:hover { transform: scale(1.1); background-color: #a71d1d; }
        .file-upload {
            position: relative; overflow: hidden; border: 2px dashed var(--matcha-green);
            border-radius: 8px; padding: 1.5rem; text-align: center; cursor: pointer; transition: all 0.3s;
        }
        .file-upload:hover { background-color: rgba(166, 196, 138, 0.1); }
        .file-upload-input {
            position: absolute; font-size: 100px; opacity: 0;
            right: 0; top: 0; cursor: pointer;
        }
        .file-name { margin-top: 8px; font-size: 0.9rem; color: var(--dark-matcha); }
        .alert-matcha {
            background-color: rgba(166, 196, 138, 0.2); border-left: 4px solid var(--matcha-green);
            color: var(--dark-matcha); border-radius: 4px; padding: 10px 15px; margin-bottom: 30px;
        }
         .alert-matcha-error {
            background-color: rgba(200, 37, 37, 0.1); border-left: 4px solid var(--japan-red);
            color: #721c24; border-radius: 4px; padding: 10px 15px; margin-bottom: 20px;
        }
        h3 { color: var(--dark-matcha); font-weight: 600; margin-bottom: 1.5rem; }
        .table thead { background-color: var(--dark-matcha); color: white; }
        .table tbody tr:hover { background-color: rgba(166, 196, 138, 0.1); }
        .img-thumbnail { max-width: 80px; height: auto; object-fit: cover; }
        .modal-header {
            background: linear-gradient(135deg, var(--dark-matcha), var(--matcha-green));
            color: white;
        }
         .modal-header.bg-danger {
            background: linear-gradient(135deg, #c82525, #a71d1d) !important;
         }
        .btn-close-white { filter: brightness(0) invert(1); }

        .btn-delete-action { background-color: #dc3545; color: white; }
        .btn-delete-action:hover { background-color: #bb2d3b; color: white; }
        .action-buttons { display: flex; gap: 5px; }
        .description-cell {
            max-width: 200px; /* Atur lebar maksimal untuk kolom deskripsi */
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        @media (max-width: 768px) {
            .main-content { margin-left: 0; padding: 1rem; }
            .sidebar { width: 100%; height: auto; position: relative; }
            .description-cell { white-space: normal; max-width: none; } /* Agar deskripsi tidak terpotong di mobile */
        }
    </style>
</head>
<body>
    <div class="sidebar">
        <h4>Dashboard</h4>
        <a href="dashboard.jsp">Home</a>
        <a href="dataRegister.jsp">Data Register</a>
        <a href="masterBarang.jsp" class="active">Master Barang</a>
        <a href="tampilTransaksi.jsp">Transaksi</a>
        <a href="admin_pesanan.jsp">Online Transaksi</a>
    </div>

    <div class="main-content">
        <div class="admin-header">
            <div class="container">
                <div class="admin-logo">Matcha<span>ku</span> Master Barang</div>
            </div>
        </div>

        <h3><i class="bi bi-box-seam"></i> Daftar Produk</h3>

        <% 
            String successMessage = (String) request.getAttribute("message"); 
            String errorMessage = (String) request.getAttribute("error");

            if (successMessage != null) { 
        %>
            <div class="alert alert-matcha alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle-fill"></i> <%= successMessage %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% 
            } 
            if (errorMessage != null) {
        %>
            <div class="alert alert-matcha-error alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle-fill"></i> <%= errorMessage %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <%
            }
            request.removeAttribute("message");
            request.removeAttribute("error");
        %>

        <div class="card mt-4">
            <div class="card-header">
                <span><i class="bi bi-list-ul"></i> Data Barang</span>
                <button type="button" class="btn btn-add" data-bs-toggle="modal" data-bs-target="#inputBarangModal">
                    <i class="bi bi-plus"></i>
                </button>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Nama Barang</th>
                                <th>Gambar</th>
                                <th>Deskripsi</th>
                                <th>Quantity</th>
                                <th>Harga</th>
                                <th>Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
                            try {
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/barang", "root", "");
                                pstmt = conn.prepareStatement("SELECT * FROM barang ORDER BY id DESC");
                                rs = pstmt.executeQuery();
                                // PERUBAHAN 2: Menghapus variabel 'no'
                                while(rs.next()) {
                                    String id = rs.getString("id");
                                    String nama = rs.getString("nama_barang");
                                    String gambar = rs.getString("gambar");
                                    String deskripsi = rs.getString("deskripsi");
                                    int quantity = rs.getInt("quantity");
                                    int harga = rs.getInt("harga");

                                    String jsEscapedNama = nama.replace("'", "\\'").replace("\"", "\\\"");
                                    // Escape deskripsi untuk JavaScript (termasuk newline)
                                    String jsEscapedDeskripsi = (deskripsi != null ? deskripsi : "")
                                                                    .replace("\\", "\\\\") // Escape backslashes first
                                                                    .replace("'", "\\'")
                                                                    .replace("\"", "\\\"")
                                                                    .replace("\r", "\\r")
                                                                    .replace("\n", "\\n");
                            %>
                            <tr>
                                <td><%= id %></td>
                                <td><%= nama %></td>
                                <td>
                                    <% if(gambar != null && !gambar.isEmpty()) { %>
                                        <img src="uploads/<%= gambar %>" class="img-thumbnail" alt="<%= nama %>">
                                    <% } else { %>
                                        <span class="text-muted">No image</span>
                                    <% } %>
                                </td>
                                <td class="description-cell" title="<%= (deskripsi != null ? deskripsi.replace("\"", "&quot;") : "") %>">
                                    <%= (deskripsi != null && deskripsi.length() > 50 ? deskripsi.substring(0, 50) + "..." : (deskripsi != null ? deskripsi : "-")) %>
                                </td>
                                <td><%= quantity %></td>
                                <td><%= rupiahAdminFormat.format(harga) %></td>
                                <td>
                                    <div class="action-buttons">
                                        <button type="button" class="btn btn-sm btn-outline-primary" 
                                                onclick="isiEditForm('<%= id %>', '<%= jsEscapedNama %>', '<%= quantity %>', '<%= harga %>', '<%= jsEscapedDeskripsi %>')">
                                            <i class="bi bi-pencil-square"></i> Edit
                                        </button>
                                        <button type="button" class="btn btn-sm btn-outline-danger" 
                                                onclick="openDeleteConfirmationModal('<%= id %>', '<%= jsEscapedNama %>')">
                                            <i class="bi bi-trash"></i> Hapus
                                        </button>
                                    </div>
                                </td>
                            </tr>
                            <% }} catch(Exception e) {
                                out.println("<tr><td colspan='7' class='text-danger'>Error: " + e.getMessage() + "</td></tr>"); // Colspan jadi 7
                                e.printStackTrace(); 
                            } finally {
                                try { if(rs != null) rs.close(); } catch(Exception ex) {}
                                try { if(pstmt != null) pstmt.close(); } catch(Exception ex) {}
                                try { if(conn != null) conn.close(); } catch(Exception ex) {}
                            } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="inputBarangModal" tabindex="-1" aria-labelledby="inputBarangModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <form action="InputBarangServlet" method="post" enctype="multipart/form-data" class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="inputBarangModalLabel">Tambah Barang Baru</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="inputNamaBarang" class="form-label">Nama Barang</label>
                        <input type="text" class="form-control" id="inputNamaBarang" name="namaBarang" required>
                    </div>
                    <div class="mb-3">
                        <label for="inputDeskripsiBarang" class="form-label">Deskripsi Barang</label> <textarea class="form-control" id="inputDeskripsiBarang" name="deskripsiBarang" rows="3"></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Upload Gambar</label>
                        <div class="file-upload">
                            <input type="file" class="file-upload-input" id="gambarBarang" name="gambarBarang" accept="image/*" required>
                            <label for="gambarBarang" class="d-block">
                                <i class="bi bi-cloud-arrow-up-fill" style="font-size: 1.5rem; color: var(--dark-matcha);"></i>
                                <div>Pilih file gambar</div>
                                <div class="file-name" id="fileNameDisplay">Belum ada file dipilih</div>
                            </label>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="inputQuantity" class="form-label">Quantity</label>
                            <input type="number" class="form-control" id="inputQuantity" name="quantity" min="1" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="inputHarga" class="form-label">Harga</label>
                            <input type="number" class="form-control" id="inputHarga" name="harga" min="0" required>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                    <button type="submit" class="btn btn-matcha">Simpan Barang</button>
                </div>
            </form>
        </div>
    </div>

    <div class="modal fade" id="editBarangModal" tabindex="-1" aria-labelledby="editBarangModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <form action="editBarangServlet" method="post" class="modal-content"> 
                <div class="modal-header">
                    <h5 class="modal-title" id="editBarangModalLabel">Edit Barang</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="editId" name="id">
                    <div class="mb-3">
                        <label for="editNamaBarang" class="form-label">Nama Barang</label>
                        <input type="text" class="form-control" id="editNamaBarang" name="namaBarang" required>
                    </div>
                    <div class="mb-3">
                        <label for="editDeskripsiBarang" class="form-label">Deskripsi Barang</label> <textarea class="form-control" id="editDeskripsiBarang" name="deskripsiBarang" rows="3"></textarea>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                           <label for="editQuantity" class="form-label">Quantity</label>
                           <input type="number" class="form-control" id="editQuantity" name="quantity" min="0" required>
                        </div>
                        <div class="col-md-6 mb-3">
                           <label for="editHarga" class="form-label">Harga</label>
                           <input type="number" class="form-control" id="editHarga" name="harga" min="0" required>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                    <button type="submit" class="btn btn-matcha">Simpan Perubahan</button>
                </div>
            </form>
        </div>
    </div>

    <div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-labelledby="deleteConfirmModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title" id="deleteConfirmModalLabel">Konfirmasi Hapus Barang</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Apakah Anda yakin ingin menghapus barang <strong id="itemNameToDelete"></strong>?</p>
                    <p class="text-danger"><i class="bi bi-exclamation-triangle-fill"></i> Aksi ini tidak dapat dibatalkan!</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                    <form id="deleteForm" action="DeleteBarangServlet" method="post" style="display: inline;">
                        <input type="hidden" id="deleteId" name="id">
                        <button type="submit" class="btn btn-delete-action">Ya, Hapus</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const gambarBarangInput = document.getElementById('gambarBarang');
        const fileNameDisplay = document.getElementById('fileNameDisplay');
        if (gambarBarangInput) {
            gambarBarangInput.addEventListener('change', function(e) {
                const file = e.target.files[0];
                if (fileNameDisplay) {
                     fileNameDisplay.textContent = file ? file.name : 'Belum ada file dipilih';
                }
            });
        }
        const inputBarangModalEl = document.getElementById('inputBarangModal');
        if (inputBarangModalEl) {
            inputBarangModalEl.addEventListener('hidden.bs.modal', function () {
                if (fileNameDisplay) fileNameDisplay.textContent = 'Belum ada file dipilih';
                const form = inputBarangModalEl.querySelector('form');
                if (form) form.reset();
            });
        }

        let bsEditModalInstance; 
        let bsDeleteConfirmModalInstance;

        // MODIFIKASI: Tambahkan parameter deskripsi
        function isiEditForm(id, nama, quantity, harga, deskripsi) {
            if (!bsEditModalInstance) {
                bsEditModalInstance = new bootstrap.Modal(document.getElementById('editBarangModal'));
            }
            document.getElementById('editId').value = id;
            document.getElementById('editNamaBarang').value = nama;
            document.getElementById('editDeskripsiBarang').value = deskripsi; // Isi field deskripsi
            document.getElementById('editQuantity').value = quantity;
            document.getElementById('editHarga').value = harga;
            bsEditModalInstance.show();
        }

        function openDeleteConfirmationModal(id, nama) {
            if (!bsDeleteConfirmModalInstance) {
                bsDeleteConfirmModalInstance = new bootstrap.Modal(document.getElementById('deleteConfirmModal'));
            }
            document.getElementById('itemNameToDelete').textContent = nama;
            document.getElementById('deleteId').value = id;
            document.getElementById('deleteForm').action = 'HapusBarang';
            bsDeleteConfirmModalInstance.show();
        }
    </script>
</body>
</html>
