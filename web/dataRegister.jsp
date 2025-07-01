<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Data Register</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
  <style>
    body {
      background: #e8f5e9;
      font-family: 'Poppins', sans-serif;
    }
    .sidebar {
      height: 100vh;
      width: 220px;
      position: fixed;
      top: 0;
      left: 0;
      background-color: #5aa64b;
      padding-top: 2rem;
      color: white;
    }
    .sidebar h4 {
      font-weight: 600;
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
    .table thead {
      background-color: #28a745;
      color: white;
    }
    .table tbody tr:hover {
      background-color: #d4edda;
    }
    .btn-edit {
      background-color: #28a745;
      color: white;
    }
    .btn-edit:hover {
      background-color: #218838;
    }
    .btn-delete {
      background-color: #dc3545;
      color: white;
    }
    .btn-delete:hover {
      background-color: #c82333;
    }
    .modal-header.bg-success, .modal-footer .btn-success {
      background-color: #28a745 !important;
    }
    .modal-header.bg-success .modal-title,
    .modal-footer .btn-success {
      color: white;
    }
    h3 {
      color: #155724;
    }
  </style>
</head>
<body>
<div class="sidebar">
  <h4>Dashboard</h4>
  <a href="dashboard.jsp">Home</a>
  <a href="dataRegister.jsp" class="active">Data Register</a>
   <a href="masterBarang.jsp">Master Barang</a>
   <a href="tampilTransaksi.jsp">Transaksi</a>
   <a href="admin_pesanan.jsp">Online Transaksi</a>
   
</div>
<div class="main-content">
  <h3 class="mb-4 text-center">📋 Data Register</h3>
  <div class="table-responsive">
    <table class="table table-bordered table-hover shadow-sm">
      <thead class="text-center">
        <tr>
          <th>No</th>
          <th>Nama</th>
          <th>Email</th>
          <th>Aksi</th>
        </tr>
      </thead>
      <tbody>
<%
  Connection conn = null;
  PreparedStatement stmt = null;
  ResultSet rs = null;
  int no = 1;
  try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/registrasi", "root", "");
    stmt = conn.prepareStatement("SELECT * FROM registrasi_db");
    rs = stmt.executeQuery();
    while(rs.next()) {
      String id = rs.getString("id");
      String nama = rs.getString("nama");
      String email = rs.getString("email");
%>
        <tr>
          <td class="text-center"><%= no++ %></td>
          <td><%= nama %></td>
          <td><%= email %></td>
          <td class="text-center">
            <button class="btn btn-edit btn-sm" data-bs-toggle="modal" data-bs-target="#editModal" data-id="<%= id %>" data-nama="<%= nama %>" data-email="<%= email %>">✏️ Edit</button>
            <button class="btn btn-delete btn-sm" data-bs-toggle="modal" data-bs-target="#deleteModal" data-id="<%= id %>">🗑️</button>
          </td>
        </tr>
<%
    }
  } catch(Exception e) {
    out.println("<tr><td colspan='4'>Error: " + e.getMessage() + "</td></tr>");
  } finally {
    if (rs != null) rs.close();
    if (stmt != null) stmt.close();
    if (conn != null) conn.close();
  }
%>
      </tbody>
    </table>
  </div>
</div>

<!-- Modal Edit -->
<div class="modal fade" id="editModal" tabindex="-1" aria-labelledby="editModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post">
        <div class="modal-header bg-success">
          <h5 class="modal-title" id="editModalLabel">Edit Data</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <input type="hidden" name="edit_id" id="edit-id">
          <div class="mb-3">
            <label for="edit-nama" class="form-label">Nama</label>
            <input type="text" class="form-control" id="edit-nama" name="edit_nama" required>
          </div>
          <div class="mb-3">
            <label for="edit-email" class="form-label">Email</label>
            <input type="email" class="form-control" id="edit-email" name="edit_email" required>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
          <button type="submit" class="btn btn-success">Simpan</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- Modal Delete -->
<div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post">
        <div class="modal-header bg-danger text-white">
          <h5 class="modal-title" id="deleteModalLabel">Konfirmasi Hapus</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <input type="hidden" name="delete_id" id="delete-id">
          <p>Apakah Anda yakin ingin menghapus data ini?</p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
          <button type="submit" class="btn btn-danger">Ya, Hapus</button>
        </div>
      </form>
    </div>
  </div>
</div>

<%-- Proses Update & Delete --%>
<%
  String editId = request.getParameter("edit_id");
  String editNama = request.getParameter("edit_nama");
  String editEmail = request.getParameter("edit_email");

  if (editId != null && editNama != null && editEmail != null) {
    try {
      Class.forName("com.mysql.cj.jdbc.Driver");
      conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/registrasi", "root", "");
      stmt = conn.prepareStatement("UPDATE registrasi_db SET nama=?, email=? WHERE id=?");
      stmt.setString(1, editNama);
      stmt.setString(2, editEmail);
      stmt.setString(3, editId);
      stmt.executeUpdate();
      response.sendRedirect("dataRegister.jsp");
    } catch(Exception e) {
      out.println("<script>alert('Gagal update: " + e.getMessage() + "');</script>");
    } finally {
      if (stmt != null) stmt.close();
      if (conn != null) conn.close();
    }
  }

  String deleteId = request.getParameter("delete_id");
  if (deleteId != null) {
    try {
      Class.forName("com.mysql.cj.jdbc.Driver");
      conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/registrasi", "root", "");
      stmt = conn.prepareStatement("DELETE FROM registrasi_db WHERE id=?");
      stmt.setString(1, deleteId);
      stmt.executeUpdate();
      response.sendRedirect("dataRegister.jsp");
    } catch(Exception e) {
      out.println("<script>alert('Gagal hapus: " + e.getMessage() + "');</script>");
    } finally {
      if (stmt != null) stmt.close();
      if (conn != null) conn.close();
    }
  }
%>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
  var editModal = document.getElementById('editModal');
  editModal.addEventListener('show.bs.modal', function (event) {
    var button = event.relatedTarget;
    document.getElementById('edit-id').value = button.getAttribute('data-id');
    document.getElementById('edit-nama').value = button.getAttribute('data-nama');
    document.getElementById('edit-email').value = button.getAttribute('data-email');
  });

  var deleteModal = document.getElementById('deleteModal');
  deleteModal.addEventListener('show.bs.modal', function (event) {
    var button = event.relatedTarget;
    var id = button.getAttribute('data-id');
    document.getElementById('delete-id').value = id;
  });
</script>
</body>
</html>
