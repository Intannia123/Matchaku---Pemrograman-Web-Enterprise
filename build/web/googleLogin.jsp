<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.OutputStream"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.net.URL"%>
<%@ page import="javax.net.ssl.*, java.security.cert.X509Certificate, java.security.SecureRandom" %>
<%@ page import="com.google.gson.JsonObject, com.google.gson.JsonParser" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" session="true" %>

<%
    // Bypass SSL verification (kalau di localhost, hati-hati kalau nanti di production)
    TrustManager[] trustAllCerts = new TrustManager[]{
        new X509TrustManager() {
            public java.security.cert.X509Certificate[] getAcceptedIssuers() { return null; }
            public void checkClientTrusted(X509Certificate[] certs, String authType) { }
            public void checkServerTrusted(X509Certificate[] certs, String authType) { }
        }
    };

    SSLContext sc = SSLContext.getInstance("SSL");
    sc.init(null, trustAllCerts, new SecureRandom());
    HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());

    HostnameVerifier allHostsValid = new HostnameVerifier() {
    public boolean verify(String hostname, SSLSession session) {
        return true;
    }
};

    HttpsURLConnection.setDefaultHostnameVerifier(allHostsValid);

    String code = request.getParameter("code");
    if (code == null || code.isEmpty()) {
        out.println("Gagal mendapatkan kode otorisasi dari Google.");
        return;
    }

    String clientId = "180021249265-3m1iuib9orvj4hlhoaevd6eho2ut3mvp.apps.googleusercontent.com";
    String clientSecret = "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";
    String redirectUri = "http://localhost:8080/WebPertemuan6/googleLogin.jsp";

    try {
        // Step 1: Exchange code for token
        URL url = new URL("https://oauth2.googleapis.com/token");
        HttpsURLConnection conn = (HttpsURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setDoOutput(true);
        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");

        String params = "code=" + URLEncoder.encode(code, "UTF-8")
                      + "&client_id=" + URLEncoder.encode(clientId, "UTF-8")
                      + "&client_secret=" + URLEncoder.encode(clientSecret, "UTF-8")
                      + "&redirect_uri=" + URLEncoder.encode(redirectUri, "UTF-8")
                      + "&grant_type=authorization_code";

        try (OutputStream os = conn.getOutputStream()) {
            os.write(params.getBytes());
            os.flush();
        }

        int responseCode = conn.getResponseCode();
        InputStream is = (responseCode == 200) ? conn.getInputStream() : conn.getErrorStream();
        BufferedReader reader = new BufferedReader(new InputStreamReader(is));
        StringBuilder responseStr = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            responseStr.append(line);
        }
        reader.close();

        if (responseCode == 200) {
            JsonObject jsonResponse = JsonParser.parseString(responseStr.toString()).getAsJsonObject();
            String idToken = jsonResponse.get("id_token").getAsString();

            // Step 2: Decode ID token (optional: verify with Google if needed)
            String[] jwtParts = idToken.split("\\.");
            if (jwtParts.length == 3) {
                String payloadJson = new String(java.util.Base64.getUrlDecoder().decode(jwtParts[1]), "UTF-8");
                JsonObject payload = JsonParser.parseString(payloadJson).getAsJsonObject();

                String email = payload.get("email").getAsString();
                String name = payload.get("name").getAsString();

                session.setAttribute("userEmail", email);
                session.setAttribute("userName", name);
                session.setAttribute("userRole", "pengguna");

                response.sendRedirect("home.jsp");
            } else {
                out.println("Format ID Token tidak valid.");
            }
        } else {
            out.println("Response error dari Google: " + responseStr.toString());
        }
    } catch (Exception e) {
        out.println("Terjadi kesalahan: " + e.getMessage());
        e.printStackTrace(new java.io.PrintWriter(out));
    }
%>