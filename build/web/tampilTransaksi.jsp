<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.util.*, java.text.NumberFormat, java.net.URLEncoder" %>
<%
    NumberFormat rupiahFormat = NumberFormat.getCurrencyInstance(new Locale("id", "ID"));
    rupiahFormat.setMaximumFractionDigits(0);
    String transactionMessage = (String) session.getAttribute("transactionMessage");
    String transactionError = (String) session.getAttribute("transactionError");
    session.removeAttribute("transactionMessage");
    session.removeAttribute("transactionError");

    List<Map<String, String>> produkList = new ArrayList<>();
    Connection conn_produk = null; Statement stmt_produk = null; ResultSet rs_produk = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn_produk = DriverManager.getConnection("jdbc:mysql://localhost:3306/barang", "root", "");
        stmt_produk = conn_produk.createStatement();
        rs_produk = stmt_produk.executeQuery("SELECT nama_barang, harga FROM barang ORDER BY nama_barang ASC");
        while(rs_produk.next()){
            Map<String, String> produk = new HashMap<>();
            produk.put("nama", rs_produk.getString("nama_barang"));
            produk.put("harga", String.valueOf(rs_produk.getInt("harga")));
            produkList.add(produk);
        }
    } catch (Exception e) { e.printStackTrace(); } 
    finally {
        try { if(rs_produk != null) rs_produk.close(); } catch (Exception e) {}
        try { if(stmt_produk != null) stmt_produk.close(); } catch (Exception e) {}
        try { if(conn_produk != null) conn_produk.close(); } catch (Exception e) {}
    }
%>
<jsp:include page="koneksi.jsp" />
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Transaksi - Dashboard Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <style>
        :root { --matcha-green: #a6c48a; --dark-matcha: #678d58; --light-matcha: #f0f7e6; --cream: #f9f9f5; --japan-red: #c82525; --sidebar-green: #5aa64b; }
        body { font-family: 'Poppins', sans-serif; background-color: var(--cream); }
        .sidebar { height: 100vh; width: 220px; position: fixed; top: 0; left: 0; background-color: var(--sidebar-green); padding-top: 2rem; color: white; z-index: 100; }
        .sidebar h4 { font-weight: 600; text-align: center; margin-bottom: 2rem; }
        .sidebar a { display: block; color: white; padding: 0.75rem 1.5rem; text-decoration: none; }
        .sidebar a:hover, .sidebar a.active { background-color: #495057; }
        .main-content { margin-left: 220px; padding: 2rem; }
        .card { box-shadow: 0 6px 15px rgba(0,0,0,0.08); border: none; }
        .card-header { background: linear-gradient(135deg, var(--dark-matcha), var(--matcha-green)); color: white; font-weight: 600; display: flex; justify-content: space-between; align-items: center; }
        .table thead { background-color: var(--dark-matcha); color: white; }
        .table td, .table th { vertical-align: middle; }
        .btn-add-tx { background-color: var(--japan-red); color: white; border: none; border-radius: 50%; width: 44px; height: 44px; display: flex; align-items: center; justify-content: center; font-size: 1.8rem; transition: all 0.3s ease; box-shadow: 0 4px 8px rgba(0,0,0,0.2); }
        .btn-add-tx:hover { transform: scale(1.1) translateY(-2px); background-color: #a71d1d; box-shadow: 0 6px 12px rgba(0,0,0,0.3); }
        .modal-header { background: linear-gradient(135deg, var(--dark-matcha), var(--matcha-green)); color: white; }
        .modal-header.bg-danger { background: linear-gradient(135deg, #c82525, #a71d1d) !important; }
        .btn-close-white { filter: brightness(0) invert(1); }
        .action-buttons { display: flex; gap: 5px; justify-content: center; }
        .alert-fixed-top { position: fixed; top: 20px; left: 50%; transform: translateX(-50%); z-index: 1055; width: auto; max-width: 90%;}
    </style>
</head>
<body>
    <div class="sidebar">
        <h4>Dashboard</h4>
        <a href="dashboard.jsp">Home</a>
        <a href="dataRegister.jsp">Data Register</a>
        <a href="masterBarang.jsp">Master Barang</a>
        <a href="tampilTransaksi.jsp" class="active">Transaksi</a>
        <a href="admin_pesanan.jsp">Online Transaksi</a>
    </div>

    <div class="main-content">
        <% if (transactionMessage != null) { %><div class="alert alert-success alert-dismissible fade show alert-fixed-top" role="alert"><%= transactionMessage %><button type="button" class="btn-close" data-bs-dismiss="alert"></button></div><% } %>
        <% if (transactionError != null) { %><div class="alert alert-danger alert-dismissible fade show alert-fixed-top" role="alert"><%= transactionError %><button type="button" class="btn-close" data-bs-dismiss="alert"></button></div><% } %>
        <h3 class="mb-4"><i class="bi bi-receipt-cutoff"></i> Detail Transaksi</h3>
        <div class="card">
            <div class="card-header">
                <span><i class="bi bi-list-ul"></i> Riwayat Transaksi</span>
                <button type="button" class="btn-add-tx" data-bs-toggle="modal" data-bs-target="#addTransaksiModal"><i class="bi bi-plus-lg"></i></button>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover table-striped">
                        <thead>
                            <tr>
                                <th>ID</th><th>Tgl Transaksi</th><th>Customer</th><th>Barang</th><th class="text-center">Jumlah</th><th class="text-end">Total</th><th>Pembayaran</th><th class="text-center">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            Connection conn = null; Statement stmt = null; ResultSet rs = null;
                            try {
                                conn = (Connection) application.getAttribute("koneksi");
                                stmt = conn.createStatement();
                                String sql = "SELECT *, DATE_FORMAT(transaction_date, '%d-%m-%Y %H:%i') as formatted_date FROM db_transaksi ORDER BY id DESC";
                                rs = stmt.executeQuery(sql);
                                while(rs.next()) {
                        %>
                                <tr>
                                    <td><%= rs.getInt("id") %></td>
                                    <td><%= rs.getString("formatted_date") %></td>
                                    <td><%= rs.getString("customer_name") %></td>
                                    <td><%= rs.getString("nama") %></td>
                                    <td class="text-center"><%= rs.getInt("jumlah") %></td>
                                    <td class="text-end"><%= rupiahFormat.format(rs.getDouble("total")) %></td>
                                    <td><%= rs.getString("payment_method") %></td>
                                    <td class="text-center">
                                        <div class="action-buttons">
                                            <button class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#editTransaksiModal"
                                                data-id="<%= rs.getInt("id") %>" data-customer="<%= rs.getString("customer_name") %>" data-nama-barang="<%= rs.getString("nama") %>"
                                                data-jumlah="<%= rs.getInt("jumlah") %>" data-payment="<%= rs.getString("payment_method") %>">
                                                <i class="bi bi-pencil-fill"></i>
                                            </button>
                                            <button class="btn btn-sm btn-outline-danger" data-bs-toggle="modal" data-bs-target="#hapusTransaksiModal"
                                                data-id="<%= rs.getInt("id") %>" data-customer="<%= rs.getString("customer_name") %>">
                                                <i class="bi bi-trash-fill"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                        <%      }
                            } catch (Exception e) { out.println("<td colspan='8'>Error: "+e.getMessage()+"</td>"); } 
                            finally { try{if(rs!=null)rs.close();}catch(Exception e){} try{if(stmt!=null)stmt.close();}catch(Exception e){} }
                        %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="addTransaksiModal" tabindex="-1" aria-labelledby="addModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <form action="simpan_transaksi.jsp" method="post" id="addForm">
                    <div class="modal-header"><h5 class="modal-title" id="addModalLabel">Form Transaksi Baru</h5><button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button></div>
                    <div class="modal-body">
                        <div class="mb-3"><label class="form-label">Nama Customer:</label><input type="text" class="form-control" name="customer_name" required></div>
                        <div class="mb-3">
                            <label class="form-label">Nama Barang:</label>
                            <select class="form-select" name="nama_barang" id="add_nama_barang" required><option value="" data-harga="0" selected disabled>-- Pilih Produk --</option><% for(Map<String, String> p : produkList) { %><option value="<%= p.get("nama") %>" data-harga="<%= p.get("harga") %>"><%= p.get("nama") %></option><% } %></select>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3"><label class="form-label">Jumlah:</label><input type="number" class="form-control" name="jumlah" min="1" required></div>
                            <div class="col-md-6 mb-3"><label class="form-label">Harga Satuan (Rp):</label><input type="number" class="form-control" id="add_harga" name="harga" readonly required></div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Metode Pembayaran:</label>
                            <select class="form-select" name="payment_method" required><option>Cash</option><option>QRIS</option><option>Debit</option><option>Credit</option></select>
                        </div>
                    </div>
                    <div class="modal-footer"><button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button><button type="submit" class="btn btn-primary">Simpan</button></div>
                </form>
            </div>
        </div>
    </div>
    
    <div class="modal fade" id="editTransaksiModal" tabindex="-1" aria-labelledby="editModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <form action="update_transaksi.jsp" method="post">
                    <div class="modal-header"><h5 class="modal-title" id="editModalLabel">Edit Transaksi</h5><button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button></div>
                    <div class="modal-body">
                        <input type="hidden" name="id" id="edit_id">
                        <div class="mb-3"><label class="form-label">Nama Customer:</label><input type="text" class="form-control" id="edit_customer_name" name="customer_name" required></div>
                        <div class="mb-3">
                            <label class="form-label">Nama Barang:</label>
                            <select class="form-select" id="edit_nama_barang" name="nama_barang" required><option value="" data-harga="0" disabled>-- Pilih --</option><% for(Map<String, String> p : produkList) { %><option value="<%= p.get("nama") %>" data-harga="<%= p.get("harga") %>"><%= p.get("nama") %></option><% } %></select>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3"><label class="form-label">Jumlah:</label><input type="number" class="form-control" id="edit_jumlah" name="jumlah" min="1" required></div>
                            <div class="col-md-6 mb-3"><label class="form-label">Harga Satuan:</label><input type="number" class="form-control" id="edit_harga" name="harga" readonly required></div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Metode Pembayaran:</label>
                            <select class="form-select" id="edit_payment_method" name="payment_method" required><option>Cash</option><option>QRIS</option><option>Debit</option><option>Credit</option></select>
                        </div>
                    </div>
                    <div class="modal-footer"><button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button><button type="submit" class="btn btn-primary">Simpan Perubahan</button></div>
                </form>
            </div>
        </div>
    </div>

    <div class="modal fade" id="hapusTransaksiModal" tabindex="-1" aria-labelledby="hapusModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white"><h5 class="modal-title" id="hapusModalLabel">Konfirmasi Hapus</h5><button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button></div>
                <div class="modal-body"><p>Yakin hapus transaksi untuk <strong id="delete_customer_name_modal"></strong>?</p></div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                    <form action="hapus_transaksi.jsp" method="POST" class="m-0">
                        <input type="hidden" name="id" id="delete_id_input">
                        <button type="submit" class="btn btn-danger">Ya, Hapus</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            // Logika untuk Modal Tambah
            const addModal = document.getElementById('addTransaksiModal');
            addModal.querySelector('#add_nama_barang').addEventListener('change', function() {
                const selectedOption = this.options[this.selectedIndex];
                addModal.querySelector('#add_harga').value = selectedOption.getAttribute('data-harga');
            });
            addModal.addEventListener('hidden.bs.modal', function () {
                addModal.querySelector('form').reset();
                addModal.querySelector('#add_harga').value = '';
            });

            // Logika untuk Modal Edit
            const editModal = document.getElementById('editTransaksiModal');
            const editNamaBarangSelect = editModal.querySelector('#edit_nama_barang');
            editNamaBarangSelect.addEventListener('change', function() {
                const selectedOption = this.options[this.selectedIndex];
                editModal.querySelector('#edit_harga').value = selectedOption.getAttribute('data-harga');
            });
            editModal.addEventListener('show.bs.modal', function (event) {
                const button = event.relatedTarget;
                editModal.querySelector('#edit_id').value = button.getAttribute('data-id');
                editModal.querySelector('#edit_customer_name').value = button.getAttribute('data-customer');
                editModal.querySelector('#edit_jumlah').value = button.getAttribute('data-jumlah');
                editModal.querySelector('#edit_nama_barang').value = button.getAttribute('data-nama-barang');
                editModal.querySelector('#edit_payment_method').value = button.getAttribute('data-payment');
                editNamaBarangSelect.dispatchEvent(new Event('change'));
            });

            // Logika untuk Modal Hapus
            const hapusModal = document.getElementById('hapusTransaksiModal');
            hapusModal.addEventListener('show.bs.modal', function (event) {
                const button = event.relatedTarget;
                hapusModal.querySelector('#delete_customer_name_modal').textContent = button.getAttribute('data-customer');
                hapusModal.querySelector('#delete_id_input').value = button.getAttribute('data-id');
            });

            // Logika untuk Notifikasi
            const alert = document.querySelector('.alert-fixed-top');
            if(alert) { setTimeout(() => { new bootstrap.Alert(alert).close(); }, 5000); }
        });
    </script>
</body>
</html>