<%@page import="java.sql.*"%>
<jsp:include page="koneksi.jsp" />
<html>
<head>
    <title>Input Transaksi</title>
</head>
<body>
    <h2>Form Transaksi</h2>
    <form action="simpan_transaksi.jsp" method="post">
        Nama Barang: <input type="text" name="nama" required><br><br>
        Jumlah: <input type="number" name="jumlah" required><br><br>
        Harga: <input type="number" name="harga" step="any" required><br><br>
        <input type="submit" value="Simpan Transaksi">
    </form>
    <br>
    <a href="tampilTransaksi.jsp">Lihat Riwayat Transaksi</a>
</body>
</html>