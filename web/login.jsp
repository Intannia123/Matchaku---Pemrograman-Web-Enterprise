<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.net.URLEncoder" %>
<%
    // Google OAuth2 settings
    String clientId = "180021249265-3m1iuib9orvj4hlhoaevd6eho2ut3mvp.apps.googleusercontent.com";
    String redirectUri = "http://localhost:8080/WebPertemuan6/googleLogin.jsp";

    String googleAuthUrl = "https://accounts.google.com/o/oauth2/v2/auth"
        + "?client_id=" + URLEncoder.encode(clientId, "UTF-8")
        + "&redirect_uri=" + URLEncoder.encode(redirectUri, "UTF-8")
        + "&response_type=code"
        + "&scope=" + URLEncoder.encode("openid email profile", "UTF-8")
        + "&access_type=offline"
        + "&include_granted_scopes=true"
        + "&prompt=consent";
%>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="google-signin-client_id" content="180021249265-3m1iuib9orvj4hlhoaevd6eho2ut3mvp.apps.googleusercontent.com">
    <title>Login Pengguna | Matchaku</title>
    <script src="https://accounts.google.com/gsi/client" async defer></script>



    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">

    <style>
        :root {
            --matcha-green: #6bbf59;
            --dark-matcha: #5aa64b;
            --light-matcha: #e8f5e9;
            --japan-red: #c82525;
        }
        
        body {
            font-family: 'Poppins', sans-serif;
            background: url('https://www.matakanasuperfoods.com/cdn/shop/files/Matcha_About.png?v=1727149914') no-repeat center center fixed;
            background-size: cover;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .navbar-brand {
            font-weight: 600;
            font-size: 1.5rem;
            color: var(--matcha-green);
        }

        .form-container {
            background: rgba(255, 255, 255, 0.92);
            padding: 2.5rem;
            border-radius: 1rem;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(0, 0, 0, 0.05);
            margin: 2rem auto;
        }

        .form-title {
            font-weight: 600;
            color: var(--dark-matcha);
            text-align: center;
            margin-bottom: 1.5rem;
            position: relative;
        }

        .form-title:after {
            content: '';
            display: block;
            width: 60px;
            height: 3px;
            background: var(--matcha-green);
            margin: 0.5rem auto 0;
        }

        .form-floating .bi {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            color: var(--dark-matcha);
            font-size: 1.2rem;
            z-index: 4;
        }

        .form-floating .form-control {
            padding-left: 3rem;
            background: rgba(255, 255, 255, 0.95);
            border: 1px solid #ced4da;
            border-radius: 0.5rem;
        }

        .form-floating .form-control:focus {
            border-color: var(--matcha-green);
            box-shadow: 0 0 0 0.25rem rgba(107, 191, 89, 0.25);
        }

        .form-floating label {
            padding-left: 2.5rem;
            color: #5a5a5a;
        }

        .icon-left {
            left: 1rem;
        }

        .icon-right {
            right: 1rem;
            cursor: pointer;
            pointer-events: auto;
            color: #6c757d;
            z-index: 5;
        }

        .btn-matcha {
            background-color: var(--matcha-green);
            border: none;
            font-weight: 500;
            transition: all 0.3s ease;
            padding: 0.75rem;
            border-radius: 0.5rem;
            width: 100%;
            color: white;
        }

        .btn-matcha:hover {
            background-color: var(--dark-matcha);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .register-link {
            color: var(--dark-matcha);
            font-weight: 500;
            text-decoration: none;
            transition: all 0.3s;
        }
        
         a.google-button { display:block; background:#db4437; color:#fff; font-weight:bold; padding:10px; text-align:center; border-radius:6px; text-decoration:none; margin-top:10px; }
         a.google-button:hover { background:#c23321; }


        .register-link:hover {
            color: var(--matcha-green);
            text-decoration: underline;
        }

        footer {
            background-color: rgba(0, 0, 0, 0.85);
            color: white;
            padding: 1.5rem 0;
            margin-top: auto;
        }

        .footer-logo {
            font-weight: 600;
            color: var(--matcha-green);
        }

        @media (max-width: 768px) {
            .form-container {
                padding: 1.5rem;
                margin: 1rem;
            }
        }
    </style>
</head>
<body>
    
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm">
        <div class="container">
            <a class="navbar-brand" href="index.jsp">
                <i class="bi bi-cup-hot-fill me-2"></i>Matchaku
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="index.jsp">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="produk.jsp">Produk</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="about.jsp">Tentang</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="formRegist.html">Daftar</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="login.jsp">Login</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Form Login -->
    <div class="container my-5">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-6">
                <div class="form-container">
                    <h2 class="form-title">Login ke Matchaku</h2>

                    <!-- Login Manual -->
                    <form action="proses_login.jsp" method="post">
                        <!-- Email -->
                        <div class="form-floating mb-3 position-relative">
                            <input type="email" class="form-control" id="email" name="email" placeholder="Email" required>
                            <label for="email">Email</label>
                            <i class="bi bi-envelope icon-left"></i>
                        </div>

                        <!-- Password -->
                        <div class="form-floating mb-4 position-relative">
                            <input type="password" class="form-control" id="password" name="password" placeholder="Password" required>
                            <label for="password">Password</label>
                            <i class="bi bi-lock icon-left"></i>
                            <i class="bi bi-eye-slash icon-right" id="togglePassword"></i>
                        </div>

                        <!-- Tombol Login Manual -->
                        <button type="submit" class="btn btn-matcha mb-3">
                            <i class="bi bi-box-arrow-in-right me-2"></i>Login Manual
                        </button>
                    </form>

                    <!-- Pembatas -->
                    <div class="text-center my-3">
                        <span>atau</span>
                    </div>

                    <!-- Login dengan Google -->
                    <a href="<%= googleAuthUrl %>" class="google-button">Login dengan Google</a>

                    <!-- Link ke registrasi -->
                    <div class="text-center mt-4">
                        Belum punya akun? <a href="formRegist.html" class="register-link">Daftar Sekarang</a>
                    </div>                                                      
                </div>
            </div>
        </div>
    </div>
    

    <!-- Script Google Sign-In -->
    <script src="https://accounts.google.com/gsi/client" async defer></script>

    
    <!-- Footer -->
    <footer class="text-center">
        <div class="container">
            <div class="footer-logo mb-3">
                <i class="bi bi-cup-hot-fill me-2"></i>Matchaku
            </div>
            <p class="mb-3">Premium Matcha Products from Japan</p>
            <div class="social-icons mb-3">
                <a href="#" class="text-white mx-2"><i class="bi bi-instagram"></i></a>
                <a href="#" class="text-white mx-2"><i class="bi bi-facebook"></i></a>
                <a href="#" class="text-white mx-2"><i class="bi bi-twitter"></i></a>
            </div>
            <p class="small">&copy; 2023 Matchaku. All rights reserved.</p>
        </div>
    </footer>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Script toggle password -->
    <script>
        const toggle = document.getElementById('togglePassword');
        const password = document.getElementById('password');

        toggle.addEventListener('click', function () {
            const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
            password.setAttribute('type', type);
            this.classList.toggle('bi-eye');
            this.classList.toggle('bi-eye-slash');
        });
    </script>
</body>
</html>