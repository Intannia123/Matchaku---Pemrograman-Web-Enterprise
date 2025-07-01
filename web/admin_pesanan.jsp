<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.text.NumberFormat, java.util.Locale, java.net.URLEncoder" %>
<jsp:include page="koneksi.jsp" />
<%
    NumberFormat rupiahFormat = NumberFormat.getCurrencyInstance(new Locale("id", "ID"));
    rupiahFormat.setMaximumFractionDigits(0);
    String message = (String) session.getAttribute("statusUpdateMessage");
    session.removeAttribute("statusUpdateMessage");
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Manajemen Pesanan - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <style>
        :root { --dark-matcha: #678d58; --matcha-green: #a6c48a; --cream: #f9f9f5; --sidebar-green: #5aa64b; --japan-red: #c82525;}
        body { font-family: 'Poppins', sans-serif; background-color: var(--cream); }
        .sidebar { height: 100vh; width: 220px; position: fixed; top: 0; left: 0; background-color: var(--sidebar-green); padding-top: 2rem; color: white; z-index: 100; }
        .sidebar h4 { font-weight: 600; text-align: center; margin-bottom: 2rem; }
        .sidebar a { display: block; color: white; padding: 0.75rem 1.5rem; text-decoration: none; }
        .sidebar a:hover, .sidebar a.active { background-color: #495057; }
        .main-content { margin-left: 220px; padding: 2rem; }
        .table thead { background-color: var(--dark-matcha); color: white; }
        .table td, .table th { vertical-align: middle; }
        .modal-header { background: linear-gradient(135deg, var(--dark-matcha), var(--matcha-green)); color: white; }
        .modal-header.bg-danger { background: linear-gradient(135deg, var(--japan-red), #a71d1d) !important; }
        .btn-close-white { filter: brightness(0) invert(1); }
        .order-notification {
            position: fixed; bottom: 20px; right: 20px;
            background-color: var(--dark-matcha); color: white;
            padding: 15px 25px; border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
            z-index: 1050; display: none; cursor: pointer;
            transition: transform 0.3s ease-in-out;
        }
        .order-notification:hover { transform: scale(1.05); }
        .order-notification .icon { font-size: 1.5rem; margin-right: 15px; }
    </style>
</head>
<body>
    <div class="sidebar">
        <h4>Dashboard</h4>
        <a href="dashboard.jsp">Home</a>
        <a href="dataRegister.jsp">Data Register</a>
        <a href="masterBarang.jsp">Master Barang</a>
        <a href="tampilTransaksi.jsp">Transaksi</a>
        <a href="admin_pesanan.jsp" class="active">Online Transaksi</a>
    </div>

    <div class="main-content">
        <h3>Manajemen Pesanan Pelanggan</h3>
        <% if (message != null) { %><div class="alert alert-success alert-dismissible fade show"><%= message %><button type="button" class="btn-close" data-bs-dismiss="alert"></button></div><% } %>

        <div class="card shadow-sm mt-4">
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>ID</th><th>Tanggal</th><th>Customer</th><th class="text-end">Total</th><th class="text-center">Status</th><th>Ubah Status & Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            Connection conn = (Connection) application.getAttribute("koneksi");
                            Statement stmt = null; ResultSet rs = null;
                            String[] statuses = {"Pending", "Diproses", "Dikirim", "Selesai", "Dibatalkan"};
                            try {
                                stmt = conn.createStatement();
                                rs = stmt.executeQuery("SELECT * FROM pesanan ORDER BY id DESC");
                                while(rs.next()) {
                                    String currentStatus = rs.getString("status_pesanan");
                                    String badgeColor = "Pending".equals(currentStatus) ? "warning" : "Selesai".equals(currentStatus) ? "success" : "Diproses".equals(currentStatus) ? "info" : "Dibatalkan".equals(currentStatus) ? "danger" : "secondary";
                        %>
                            <tr>
                                <td>#<%= rs.getInt("id") %></td>
                                <td><%= new java.text.SimpleDateFormat("dd MMM yyyy, HH:mm").format(rs.getTimestamp("tanggal_pesanan")) %></td>
                                <td><%= rs.getString("nama_pelanggan") %><small class="d-block text-muted"><%= rs.getString("customer_email") %></small></td>
                                <td class="text-end"><%= rupiahFormat.format(rs.getDouble("total_harga")) %></td>
                                <td class="text-center"><span class="badge rounded-pill text-bg-<%= badgeColor %>"><%= currentStatus %></span></td>
                                <td>
                                    <div class="d-flex justify-content-center align-items-center gap-2">
                                        <form action="update_status.jsp" method="post" class="d-flex flex-grow-1">
                                            <input type="hidden" name="id_pesanan" value="<%= rs.getInt("id") %>">
                                            <select name="status_baru" class="form-select form-select-sm" onchange="this.form.submit()" title="Langsung ubah status">
                                                <% for(String s : statuses) { %><option value="<%= s %>" <%= s.equals(currentStatus) ? "selected" : "" %>><%= s %></option><% } %>
                                            </select>
                                        </form>
                                        <div class="btn-group">
                                            <button class="btn btn-sm btn-outline-secondary" data-bs-toggle="modal" data-bs-target="#editPesananModal" 
                                                data-id="<%= rs.getInt("id") %>" data-nama="<%= rs.getString("nama_pelanggan") %>" data-email="<%= rs.getString("customer_email") %>" data-alamat="<%= rs.getString("alamat") %>"
                                                data-telepon="<%= rs.getString("telepon") %>" data-status="<%= currentStatus %>" title="Edit Detail Pesanan">
                                                <i class="bi bi-pencil-fill"></i>
                                            </button>
                                            <button class="btn btn-sm btn-outline-danger" data-bs-toggle="modal" data-bs-target="#hapusPesananModal" 
                                                data-id="<%= rs.getInt("id") %>" data-nama="<%= rs.getString("nama_pelanggan") %>" title="Hapus Pesanan">
                                                <i class="bi bi-trash-fill"></i>
                                            </button>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        <%
                                }
                            } catch (Exception e) { e.printStackTrace(); }
                            finally { if(rs!=null)rs.close(); if(stmt!=null)stmt.close(); }
                        %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div id="newOrderNotification" class="order-notification" onclick="location.reload();">
        <i class="bi bi-bell-fill icon"></i>
        <span><strong>Pesanan Baru Masuk!</strong> Klik untuk memuat ulang.</span>
    </div>

    <div class="modal fade" id="editPesananModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <form action="proses_edit_pesanan.jsp" method="post">
                    <div class="modal-header"><h5 class="modal-title">Edit Pesanan</h5><button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button></div>
                    <div class="modal-body">
                        <input type="hidden" name="id" id="edit_id">
                        <div class="mb-3"><label class="form-label">Nama Customer</label><input type="text" class="form-control" name="nama_pelanggan" id="edit_nama"></div>
                        <div class="mb-3"><label class="form-label">Email</label><input type="email" class="form-control" name="customer_email" id="edit_email"></div>
                        <div class="mb-3"><label class="form-label">Alamat Lengkap</label><textarea class="form-control" name="alamat" rows="3" id="edit_alamat"></textarea></div>
                        <div class="mb-3"><label class="form-label">Nomor Telepon</label><input type="text" class="form-control" name="telepon" id="edit_telepon"></div>
                        <div class="mb-3"><label class="form-label">Status Pesanan</label>
                            <select name="status_pesanan" id="edit_status" class="form-select">
                                <% for(String s : statuses) { %><option value="<%= s %>"><%= s %></option><% } %>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer"><button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button><button type="submit" class="btn btn-primary">Simpan Perubahan</button></div>
                </form>
            </div>
        </div>
    </div>

    <div class="modal fade" id="hapusPesananModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white"><h5 class="modal-title">Konfirmasi Hapus</h5><button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button></div>
                <div class="modal-body"><p>Anda yakin ingin menghapus pesanan untuk <strong id="hapus_nama"></strong>? Tindakan ini tidak dapat diurungkan.</p></div>
                <div class="modal-footer">
                    <form action="proses_hapus_pesanan.jsp" method="post" style="display:inline;">
                        <input type="hidden" name="id" id="hapus_id">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                        <button type="submit" class="btn btn-danger">Ya, Hapus</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
    // --- SEMUA JAVASCRIPT DIGABUNG DI SINI ---
    document.addEventListener('DOMContentLoaded', function () {

        // --- Logika untuk Modal Edit ---
        const editPesananModal = document.getElementById('editPesananModal');
        if (editPesananModal) {
            editPesananModal.addEventListener('show.bs.modal', event => {
                const button = event.relatedTarget; // Tombol yang diklik
                // Ambil data dari atribut data-*
                const id = button.getAttribute('data-id');
                const nama = button.getAttribute('data-nama');
                const email = button.getAttribute('data-email');
                const alamat = button.getAttribute('data-alamat');
                const telepon = button.getAttribute('data-telepon');
                const status = button.getAttribute('data-status');

                // Masukkan data ke dalam form di modal
                editPesananModal.querySelector('#edit_id').value = id;
                editPesananModal.querySelector('#edit_nama').value = nama;
                editPesananModal.querySelector('#edit_email').value = email;
                editPesananModal.querySelector('#edit_alamat').value = alamat;
                editPesananModal.querySelector('#edit_telepon').value = telepon;
                editPesananModal.querySelector('#edit_status').value = status;
            });
        }

        // --- Logika untuk Modal Hapus ---
        const hapusPesananModal = document.getElementById('hapusPesananModal');
        if (hapusPesananModal) {
            hapusPesananModal.addEventListener('show.bs.modal', event => {
                const button = event.relatedTarget;
                const id = button.getAttribute('data-id');
                const nama = button.getAttribute('data-nama');
                
                // Masukkan data ke dalam modal hapus
                hapusPesananModal.querySelector('#hapus_id').value = id;
                hapusPesananModal.querySelector('#hapus_nama').textContent = nama;
            });
        }

        // --- Logika untuk Notifikasi Pesanan Baru (Polling) ---
        function getLatestOrderId() {
            const firstRow = document.querySelector('tbody tr');
            if (firstRow) {
                const idText = firstRow.cells[0].innerText;
                return parseInt(idText.replace('#', ''), 10);
            }
            return 0;
        }

        function checkNewOrders() {
            const latestId = getLatestOrderId();
            fetch(`check_new_orders.jsp?latestOrderId=${latestId}`)
                .then(response => response.json())
                .then(data => {
                    if (data.new_order) {
                        const notification = document.getElementById('newOrderNotification');
                        notification.style.display = 'flex';
                    }
                })
                .catch(error => console.error('Error checking for new orders:', error));
        }

        // Jalankan pengecekan setiap 15 detik
        setInterval(checkNewOrders, 15000);
    });
    </script>
</body>
</html>