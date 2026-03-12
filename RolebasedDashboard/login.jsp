<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@300;400;500;600&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            --cream: #F5F0E8;
            --warm-white: #FDFAF5;
            --ink: #1A1610;
            --brown: #6B4F3A;
            --gold: #C8963E;
            --gold-light: #E8B96A;
            --muted: #9A8F84;
            --border: #DDD5C8;
            --error: #C0392B;
            --success: #2D6A4F;
        }

        html, body {
            height: 100%;
            font-family: 'DM Sans', sans-serif;
            background-color: var(--cream);
            color: var(--ink);
        }

        body {
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            overflow: hidden;
            position: relative;
        }

        /* Decorative background */
        body::before {
            content: '';
            position: fixed;
            top: -30%;
            right: -20%;
            width: 700px;
            height: 700px;
            background: radial-gradient(circle, rgba(200, 150, 62, 0.12) 0%, transparent 70%);
            pointer-events: none;
            z-index: 0;
        }

        body::after {
            content: '';
            position: fixed;
            bottom: -20%;
            left: -15%;
            width: 600px;
            height: 600px;
            background: radial-gradient(circle, rgba(107, 79, 58, 0.08) 0%, transparent 70%);
            pointer-events: none;
            z-index: 0;
        }

        /* Floating geometric decorations */
        .bg-decoration {
            position: fixed;
            top: 0; left: 0;
            width: 100%; height: 100%;
            pointer-events: none;
            z-index: 0;
            overflow: hidden;
        }

        .bg-decoration span {
            position: absolute;
            border: 1px solid rgba(200, 150, 62, 0.15);
            border-radius: 50%;
            animation: floatOrb 12s ease-in-out infinite;
        }

        .bg-decoration span:nth-child(1) {
            width: 300px; height: 300px;
            top: 10%; left: 5%;
            animation-delay: 0s;
        }

        .bg-decoration span:nth-child(2) {
            width: 180px; height: 180px;
            top: 60%; right: 8%;
            animation-delay: -4s;
        }

        .bg-decoration span:nth-child(3) {
            width: 80px; height: 80px;
            bottom: 15%; left: 20%;
            animation-delay: -8s;
        }

        @keyframes floatOrb {
            0%, 100% { transform: translateY(0px) rotate(0deg); opacity: 0.5; }
            33% { transform: translateY(-20px) rotate(5deg); opacity: 1; }
            66% { transform: translateY(10px) rotate(-3deg); opacity: 0.7; }
        }

        /* Main wrapper */
        .page-wrapper {
            position: relative;
            z-index: 1;
            display: flex;
            width: 100%;
            max-width: 400px;
            min-height: 560px;
            margin: 2rem;
            border-radius: 4px;
            overflow: hidden;
            box-shadow:
                0 2px 4px rgba(26, 22, 16, 0.04),
                0 8px 24px rgba(26, 22, 16, 0.08),
                0 32px 80px rgba(26, 22, 16, 0.12);
            animation: pageReveal 0.8s cubic-bezier(0.16, 1, 0.3, 1) forwards;
        }

        @keyframes pageReveal {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Left panel */
        .panel-left {
            flex: 1;
            background: linear-gradient(145deg, var(--brown) 0%, #3D2B1F 60%, #2A1D14 100%);
            padding: 3.5rem;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            position: relative;
            overflow: hidden;
            min-width: 300px;
        }

        .panel-left::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            background:
                radial-gradient(ellipse at 20% 20%, rgba(200, 150, 62, 0.2) 0%, transparent 50%),
                radial-gradient(ellipse at 80% 80%, rgba(200, 150, 62, 0.1) 0%, transparent 40%);
            pointer-events: none;
        }

        .panel-left::after {
            content: '';
            position: absolute;
            bottom: -60px; right: -60px;
            width: 280px; height: 280px;
            border: 1px solid rgba(200, 150, 62, 0.2);
            border-radius: 50%;
            pointer-events: none;
        }

        .brand {
            position: relative;
            z-index: 1;
            animation: fadeUp 0.8s 0.2s cubic-bezier(0.16, 1, 0.3, 1) both;
        }

        .brand-icon {
            width: 48px;
            height: 48px;
            border: 1.5px solid var(--gold);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 1.5rem;
        }

        .brand-icon svg {
            width: 22px;
            height: 22px;
            fill: none;
            stroke: var(--gold);
            stroke-width: 1.5;
        }

        .brand-name {
            font-family: 'Cormorant Garamond', serif;
            font-size: 1.6rem;
            font-weight: 500;
            color: var(--cream);
            letter-spacing: 0.04em;
            line-height: 1;
        }

        .brand-tagline {
            font-size: 0.72rem;
            color: var(--gold-light);
            letter-spacing: 0.18em;
            text-transform: uppercase;
            margin-top: 0.4rem;
            opacity: 0.8;
        }

        .panel-quote {
            position: relative;
            z-index: 1;
            animation: fadeUp 0.8s 0.4s cubic-bezier(0.16, 1, 0.3, 1) both;
        }

        .quote-mark {
            font-family: 'Cormorant Garamond', serif;
            font-size: 5rem;
            line-height: 0.5;
            color: var(--gold);
            opacity: 0.4;
            margin-bottom: 1rem;
            display: block;
        }

        .quote-text {
            font-family: 'Cormorant Garamond', serif;
            font-size: 1.45rem;
            font-weight: 300;
            color: var(--cream);
            line-height: 1.6;
            opacity: 0.9;
        }

        .quote-author {
            font-size: 0.72rem;
            letter-spacing: 0.16em;
            text-transform: uppercase;
            color: var(--gold-light);
            margin-top: 1.2rem;
            opacity: 0.6;
        }

        .panel-footer {
            position: relative;
            z-index: 1;
            animation: fadeUp 0.8s 0.5s cubic-bezier(0.16, 1, 0.3, 1) both;
        }

        .panel-footer p {
            font-size: 0.7rem;
            color: rgba(245, 240, 232, 0.35);
            letter-spacing: 0.06em;
        }

        /* Right panel */
        .panel-right {
            width: 440px;
            background: var(--warm-white);
            padding: 3.5rem;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .login-header {
            margin-bottom: 2.5rem;
            animation: fadeUp 0.8s 0.3s cubic-bezier(0.16, 1, 0.3, 1) both;
        }

        .login-label {
            font-size: 0.68rem;
            letter-spacing: 0.2em;
            text-transform: uppercase;
            color: var(--gold);
            font-weight: 500;
            margin-bottom: 0.6rem;
        }

        .login-title {
            font-family: 'Cormorant Garamond', serif;
            font-size: 2.4rem;
            font-weight: 500;
            color: var(--ink);
            line-height: 1.1;
        }

        .login-subtitle {
            font-size: 0.85rem;
            color: var(--muted);
            margin-top: 0.5rem;
            line-height: 1.5;
        }

        /* Alert messages */
        .alert {
            display: none;
            padding: 0.8rem 1rem;
            border-radius: 3px;
            font-size: 0.82rem;
            margin-bottom: 1.5rem;
            animation: slideDown 0.3s ease;
        }

        .alert.show { display: flex; align-items: center; gap: 0.6rem; }

        .alert-error {
            background: rgba(192, 57, 43, 0.07);
            border-left: 3px solid var(--error);
            color: var(--error);
        }

        .alert-success {
            background: rgba(45, 106, 79, 0.07);
            border-left: 3px solid var(--success);
            color: var(--success);
        }

        @keyframes slideDown {
            from { opacity: 0; transform: translateY(-8px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Form */
        .login-form {
            animation: fadeUp 0.8s 0.45s cubic-bezier(0.16, 1, 0.3, 1) both;
        }

        .form-field {
            margin-bottom: 1.4rem;
            position: relative;
        }

        .form-field label {
            display: block;
            font-size: 0.72rem;
            font-weight: 500;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            color: var(--brown);
            margin-bottom: 0.5rem;
        }

        .input-wrapper {
            position: relative;
        }

        .input-wrapper svg {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            width: 16px;
            height: 16px;
            stroke: var(--muted);
            fill: none;
            stroke-width: 1.5;
            pointer-events: none;
            transition: stroke 0.2s;
        }

        .form-field input {
            width: 100%;
            padding: 0.85rem 1rem 0.85rem 2.8rem;
            background: var(--cream);
            border: 1.5px solid var(--border);
            border-radius: 3px;
            font-family: 'DM Sans', sans-serif;
            font-size: 0.9rem;
            color: var(--ink);
            transition: all 0.25s ease;
            outline: none;
            -webkit-appearance: none;
        }

        .form-field input::placeholder {
            color: rgba(154, 143, 132, 0.6);
        }

        .form-field input:focus {
            border-color: var(--gold);
            background: var(--warm-white);
            box-shadow: 0 0 0 3px rgba(200, 150, 62, 0.1);
        }

        .form-field input:focus + svg,
        .input-wrapper:focus-within svg {
            stroke: var(--gold);
        }

        .form-field input:focus ~ svg {
            stroke: var(--gold);
        }

        /* Fix icon inside wrapper */
        .form-field .input-wrapper input:focus ~ svg { stroke: var(--gold); }
        .input-wrapper:focus-within svg { stroke: var(--gold); }

        /* Remember row */
        .form-options {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 2rem;
        }

        .remember-label {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            cursor: pointer;
            font-size: 0.82rem;
            color: var(--muted);
            user-select: none;
        }

        .remember-label input[type="checkbox"] {
            width: 15px;
            height: 15px;
            border: 1.5px solid var(--border);
            border-radius: 2px;
            background: var(--cream);
            cursor: pointer;
            accent-color: var(--gold);
        }

        .forgot-link {
            font-size: 0.8rem;
            color: var(--gold);
            text-decoration: none;
            letter-spacing: 0.02em;
            transition: opacity 0.2s;
        }

        .forgot-link:hover { opacity: 0.7; }

        /* Submit button */
        .btn-login {
            width: 100%;
            padding: 0.95rem;
            background: var(--brown);
            color: var(--cream);
            border: none;
            border-radius: 3px;
            font-family: 'DM Sans', sans-serif;
            font-size: 0.82rem;
            font-weight: 500;
            letter-spacing: 0.18em;
            text-transform: uppercase;
            cursor: pointer;
            position: relative;
            overflow: hidden;
            transition: all 0.3s ease;
        }

        .btn-login::before {
            content: '';
            position: absolute;
            top: 0; left: -100%;
            width: 100%; height: 100%;
            background: linear-gradient(90deg, transparent, rgba(200, 150, 62, 0.25), transparent);
            transition: left 0.5s ease;
        }

        .btn-login:hover {
            background: #3D2B1F;
            transform: translateY(-1px);
            box-shadow: 0 6px 20px rgba(107, 79, 58, 0.3);
        }

        .btn-login:hover::before { left: 100%; }
        .btn-login:active { transform: translateY(0); }

        /* Divider */
        .divider {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin: 1.8rem 0;
            color: var(--border);
            font-size: 0.72rem;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            color: var(--muted);
        }

        .divider::before, .divider::after {
            content: '';
            flex: 1;
            height: 1px;
            background: var(--border);
        }

        /* Sign up */
        .signup-row {
            text-align: center;
            font-size: 0.82rem;
            color: var(--muted);
            animation: fadeUp 0.8s 0.55s cubic-bezier(0.16, 1, 0.3, 1) both;
        }

        .signup-row a {
            color: var(--gold);
            text-decoration: none;
            font-weight: 500;
            transition: opacity 0.2s;
        }

        .signup-row a:hover { opacity: 0.7; }

        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(16px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Responsive */
        @media (max-width: 700px) {
            .panel-left { display: none; }
            .panel-right { width: 100%; padding: 2.5rem 2rem; }
            .page-wrapper { margin: 1rem; min-height: unset; }
        }
    </style>
</head>
<body>

    <div class="bg-decoration">
        <span></span><span></span><span></span>
    </div>

    <%
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String errorMessage = "";
        String successMessage = "";

        if (request.getMethod().equals("POST")) {
            if (username != null && !username.trim().isEmpty() &&
                password != null && !password.trim().isEmpty()) {
                if (username.equals("admin") && password.equals("password")) {
                    successMessage = "Welcome back, " + username + ". Redirecting…";
                    session.setAttribute("username", username);
                    response.sendRedirect("dashboard.jsp");
                } else {
                    errorMessage = "Invalid credentials. Please try again.";
                }
            } else {
                errorMessage = "Both fields are required.";
            }
        }
    %>

    <div class="page-wrapper">

      
        <!-- RIGHT PANEL -->
        <div class="panel-right">
            <div class="login-header">
                <p class="login-label">Welcome back</p>
                <h1 class="login-title">Sign in to<br>your account</h1>
                <p class="login-subtitle">Enter your credentials to access the dashboard.</p>
            </div>

            <div class="alert alert-error <%= !errorMessage.isEmpty() ? "show" : "" %>">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                <%= errorMessage %>
            </div>

            <div class="alert alert-success <%= !successMessage.isEmpty() ? "show" : "" %>">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="20 6 9 17 4 12"/></svg>
                <%= successMessage %>
            </div>

            <form class="login-form" method="POST" action="new.jsp" onsubmit="return validateForm()">

                <div class="form-field">
                    <label for="username">Username</label>
                    <div class="input-wrapper">
                        <input type="text" id="username" name="username"
                               placeholder="your.username"
                               value="<%= username != null ? username : "" %>" required autocomplete="username">
                        <svg viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                    </div>
                </div>

                <div class="form-field">
                    <label for="password">Password</label>
                    <div class="input-wrapper">
                        <input type="password" id="password" name="password"
                               placeholder="••••••••" required autocomplete="current-password">
                        <svg viewBox="0 0 24 24"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                    </div>
                </div>

                <div class="form-options">
                    <label class="remember-label">
                        <input type="checkbox" name="remember"> Remember me
                    </label>
                    <a href="#" class="forgot-link">Forgot password?</a>
                </div>

                <button type="submit" class="btn-login">Sign In</button>

            </form>

            <div class="divider">or</div>

            <div class="signup-row">
                Don't have an account? <a href="#">Request access</a>
            </div>
        </div>
    </div>

    <script>
        function validateForm() {
            const u = document.getElementById('username').value.trim();
            const p = document.getElementById('password').value.trim();
            if (!u || !p) {
                showError('Please fill in all fields.');
                return false;
            }
            return true;
        }

        function showError(msg) {
            const el = document.querySelector('.alert-error');
            el.querySelector('span') || (el.innerHTML += '');
            el.childNodes[el.childNodes.length - 1].textContent = msg;
            el.classList.add('show');
        }
    </script>

</body>
</html>
