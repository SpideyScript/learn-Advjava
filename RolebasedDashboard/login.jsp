<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // If already logged in, redirect
    String loggedUser = (String) session.getAttribute("username");
    String loggedRole = (String) session.getAttribute("role");
    if (loggedUser != null && loggedRole != null) {
        if (loggedRole.equals("admin")) {
            response.sendRedirect("adminDashboard.jsp");
        } else {
            response.sendRedirect("studentDashboard.jsp");
        }
        return;
    }

    String errorMessage = "";

    if (request.getMethod().equals("POST")) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role     = request.getParameter("role");

        if (username != null && !username.trim().isEmpty()
            && password != null && !password.trim().isEmpty()
            && role != null && !role.trim().isEmpty()) {

            // Demo credentials — replace with DB logic
            boolean validAdmin   = role.equals("admin")   && username.equals("admin")   && password.equals("admin123");
            boolean validStudent = role.equals("student")  && username.equals("student") && password.equals("stu123");

            if (validAdmin || validStudent) {
                session.setAttribute("username", username);
                session.setAttribute("role", role);
                if (role.equals("admin")) {
                    response.sendRedirect("adminDashboard.jsp");
                } else {
                    response.sendRedirect("studentDashboard.jsp");
                }
                return;
            } else {
                errorMessage = "Invalid credentials for selected role.";
            }
        } else {
            errorMessage = "All fields are required.";
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>EduPortal — Sign In</title>
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;500;600;700;800&family=Mulish:wght@300;400;500;600&display=swap" rel="stylesheet">
<style>
*,*::before,*::after{margin:0;padding:0;box-sizing:border-box}
:root{
  --bg:#0B0F1A;
  --surface:#111827;
  --card:#161D2E;
  --border:#1E2A40;
  --accent:#4F8EF7;
  --accent2:#38D9A9;
  --gold:#F6C90E;
  --text:#EDF2FF;
  --muted:#6B7A9A;
  --error:#FF6B6B;
  --admin-accent:#F97316;
  --student-accent:#4F8EF7;
}
html,body{height:100%;font-family:'Mulish',sans-serif;background:var(--bg);color:var(--text)}
body{display:flex;align-items:center;justify-content:center;min-height:100vh;overflow:hidden}

/* Animated grid background */
.grid-bg{
  position:fixed;inset:0;
  background-image:
    linear-gradient(rgba(79,142,247,0.04) 1px, transparent 1px),
    linear-gradient(90deg, rgba(79,142,247,0.04) 1px, transparent 1px);
  background-size:60px 60px;
  animation:gridShift 20s linear infinite;
  z-index:0;
}
@keyframes gridShift{from{background-position:0 0}to{background-position:60px 60px}}

.glow-orb{
  position:fixed;border-radius:50%;filter:blur(80px);pointer-events:none;z-index:0;
}
.glow-orb.one{width:400px;height:400px;background:rgba(79,142,247,0.12);top:-100px;left:-100px;animation:drift1 15s ease-in-out infinite}
.glow-orb.two{width:350px;height:350px;background:rgba(56,217,169,0.08);bottom:-80px;right:-80px;animation:drift2 18s ease-in-out infinite}
@keyframes drift1{0%,100%{transform:translate(0,0)}50%{transform:translate(60px,40px)}}
@keyframes drift2{0%,100%{transform:translate(0,0)}50%{transform:translate(-50px,-30px)}}

.wrapper{
  position:relative;z-index:1;
  display:flex;width:100%;max-width:900px;min-height:540px;
  margin:1.5rem;border-radius:16px;overflow:hidden;
  border:1px solid var(--border);
  box-shadow:0 0 0 1px rgba(79,142,247,0.06),0 40px 100px rgba(0,0,0,0.5);
  animation:wrapIn .7s cubic-bezier(.16,1,.3,1) both;
}
@keyframes wrapIn{from{opacity:0;transform:translateY(24px) scale(.98)}to{opacity:1;transform:none}}

/* Left decorative panel */
.panel-deco{
  flex:1;background:linear-gradient(135deg,#0D1B35 0%,#091428 50%,#060D1F 100%);
  padding:3rem;display:flex;flex-direction:column;justify-content:space-between;
  position:relative;overflow:hidden;min-width:280px;
}
.panel-deco::before{
  content:'';position:absolute;inset:0;
  background:repeating-linear-gradient(
    -45deg,
    transparent,transparent 40px,
    rgba(79,142,247,0.025) 40px,rgba(79,142,247,0.025) 41px
  );
}
.deco-circle{
  position:absolute;border:1px solid rgba(79,142,247,0.15);border-radius:50%;
}
.deco-circle.c1{width:280px;height:280px;bottom:-80px;right:-80px;}
.deco-circle.c2{width:160px;height:160px;bottom:20px;right:20px;}
.deco-circle.c3{width:60px;height:60px;top:80px;right:60px;}

.logo{position:relative;z-index:1;animation:fadeUp .7s .2s both}
.logo-mark{
  width:52px;height:52px;border-radius:12px;
  background:linear-gradient(135deg,var(--accent),var(--accent2));
  display:flex;align-items:center;justify-content:center;margin-bottom:1.2rem;
  box-shadow:0 8px 24px rgba(79,142,247,0.3);
}
.logo-mark svg{width:26px;height:26px;fill:none;stroke:#fff;stroke-width:2}
.logo-name{font-family:'Syne',sans-serif;font-size:1.5rem;font-weight:800;color:var(--text)}
.logo-sub{font-size:.7rem;letter-spacing:.18em;text-transform:uppercase;color:var(--muted);margin-top:.25rem}

.deco-stats{position:relative;z-index:1;animation:fadeUp .7s .35s both}
.stat-item{margin-bottom:1.6rem}
.stat-num{font-family:'Syne',sans-serif;font-size:2.2rem;font-weight:800;
  background:linear-gradient(90deg,var(--accent),var(--accent2));
  -webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text}
.stat-label{font-size:.75rem;color:var(--muted);letter-spacing:.06em}

.deco-badges{display:flex;gap:.6rem;flex-wrap:wrap;position:relative;z-index:1;animation:fadeUp .7s .45s both}
.badge{
  padding:.3rem .8rem;border-radius:20px;font-size:.68rem;font-weight:600;letter-spacing:.08em;text-transform:uppercase;
  border:1px solid;
}
.badge.admin{border-color:var(--admin-accent);color:var(--admin-accent);background:rgba(249,115,22,.08)}
.badge.student{border-color:var(--student-accent);color:var(--student-accent);background:rgba(79,142,247,.08)}
.badge.staff{border-color:var(--accent2);color:var(--accent2);background:rgba(56,217,169,.08)}

/* Right form panel */
.panel-form{
  width:420px;background:var(--card);
  padding:3rem 2.8rem;display:flex;flex-direction:column;justify-content:center;
}
.form-header{margin-bottom:2rem;animation:fadeUp .7s .3s both}
.form-eyebrow{font-size:.68rem;letter-spacing:.2em;text-transform:uppercase;color:var(--accent);font-weight:600;margin-bottom:.5rem}
.form-title{font-family:'Syne',sans-serif;font-size:2rem;font-weight:800;line-height:1.1}
.form-title span{background:linear-gradient(90deg,var(--accent),var(--accent2));-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text}
.form-desc{font-size:.82rem;color:var(--muted);margin-top:.5rem;line-height:1.5}

.alert{
  display:none;align-items:center;gap:.6rem;
  padding:.75rem 1rem;border-radius:8px;font-size:.8rem;margin-bottom:1.4rem;
  background:rgba(255,107,107,.08);border:1px solid rgba(255,107,107,.2);color:var(--error);
  animation:slideIn .25s ease;
}
.alert.show{display:flex}
@keyframes slideIn{from{opacity:0;transform:translateY(-6px)}to{opacity:1;transform:none}}

/* Role selector */
.role-selector{display:grid;grid-template-columns:1fr 1fr;gap:.6rem;margin-bottom:1.4rem;animation:fadeUp .7s .4s both}
.role-btn{
  padding:.8rem;border-radius:8px;border:1.5px solid var(--border);
  background:transparent;color:var(--muted);font-family:'Mulish',sans-serif;
  font-size:.8rem;font-weight:600;letter-spacing:.06em;text-transform:uppercase;
  cursor:pointer;transition:all .2s;display:flex;flex-direction:column;align-items:center;gap:.4rem;
}
.role-btn svg{width:18px;height:18px;fill:none;stroke:currentColor;stroke-width:2}
.role-btn:hover{border-color:var(--accent);color:var(--accent);background:rgba(79,142,247,.06)}
.role-btn.active-admin{border-color:var(--admin-accent);color:var(--admin-accent);background:rgba(249,115,22,.08)}
.role-btn.active-student{border-color:var(--student-accent);color:var(--student-accent);background:rgba(79,142,247,.1)}

.login-form{animation:fadeUp .7s .45s both}
.field{margin-bottom:1.1rem}
.field label{display:block;font-size:.7rem;font-weight:600;letter-spacing:.12em;text-transform:uppercase;color:var(--muted);margin-bottom:.45rem}
.field-wrap{position:relative}
.field-wrap svg{position:absolute;left:.9rem;top:50%;transform:translateY(-50%);width:15px;height:15px;stroke:var(--muted);fill:none;stroke-width:2;pointer-events:none;transition:stroke .2s}
.field-wrap:focus-within svg{stroke:var(--accent)}
.field input{
  width:100%;padding:.8rem .9rem .8rem 2.6rem;
  background:var(--surface);border:1.5px solid var(--border);border-radius:8px;
  font-family:'Mulish',sans-serif;font-size:.88rem;color:var(--text);outline:none;
  transition:all .2s;
}
.field input::placeholder{color:var(--muted)}
.field input:focus{border-color:var(--accent);background:#0F1828;box-shadow:0 0 0 3px rgba(79,142,247,.12)}
input[name="role"]{display:none}

.btn-submit{
  width:100%;padding:.9rem;margin-top:.4rem;
  background:linear-gradient(135deg,var(--accent),#3B6FD4);
  border:none;border-radius:8px;color:#fff;
  font-family:'Syne',sans-serif;font-size:.82rem;font-weight:700;
  letter-spacing:.15em;text-transform:uppercase;cursor:pointer;
  position:relative;overflow:hidden;transition:all .25s;
  box-shadow:0 4px 20px rgba(79,142,247,.25);
}
.btn-submit::after{
  content:'';position:absolute;inset:0;
  background:linear-gradient(135deg,rgba(255,255,255,.1),transparent);
  opacity:0;transition:opacity .2s;
}
.btn-submit:hover{transform:translateY(-2px);box-shadow:0 8px 28px rgba(79,142,247,.35)}
.btn-submit:hover::after{opacity:1}
.btn-submit:active{transform:none}

.demo-hint{margin-top:1.4rem;padding:.8rem;background:var(--surface);border-radius:8px;border:1px solid var(--border)}
.demo-hint p{font-size:.72rem;color:var(--muted);margin-bottom:.3rem}
.demo-hint code{font-size:.7rem;color:var(--accent2);background:rgba(56,217,169,.08);padding:.1rem .4rem;border-radius:3px}

@keyframes fadeUp{from{opacity:0;transform:translateY(14px)}to{opacity:1;transform:none}}
@media(max-width:680px){.panel-deco{display:none}.panel-form{width:100%;padding:2rem 1.5rem}.wrapper{margin:.8rem;min-height:auto}}
</style>
</head>
<body>
<div class="grid-bg"></div>
<div class="glow-orb one"></div>
<div class="glow-orb two"></div>

<div class="wrapper">
  <!-- Left decorative panel -->
  <div class="panel-deco">
    <div class="deco-circle c1"></div>
    <div class="deco-circle c2"></div>
    <div class="deco-circle c3"></div>
    <div class="logo">
      <div class="logo-mark">
        <svg viewBox="0 0 24 24"><path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"/></svg>
      </div>
      <div class="logo-name">EduPortal</div>
      <div class="logo-sub">Learning Management System</div>
    </div>
    <div class="deco-stats">
      <div class="stat-item"><div class="stat-num">2,400+</div><div class="stat-label">Active Students</div></div>
      <div class="stat-item"><div class="stat-num">180+</div><div class="stat-label">Courses Available</div></div>
      <div class="stat-item"><div class="stat-num">98%</div><div class="stat-label">Satisfaction Rate</div></div>
    </div>
    <div class="deco-badges">
      <span class="badge admin">Admin</span>
      <span class="badge student">Student</span>
      <span class="badge staff">Staff</span>
    </div>
  </div>

  <!-- Right form panel -->
  <div class="panel-form">
    <div class="form-header">
      <p class="form-eyebrow">Welcome back</p>
      <h1 class="form-title">Sign in to <span>EduPortal</span></h1>
      <p class="form-desc">Select your role and enter your credentials to continue.</p>
    </div>

    <% if (!errorMessage.isEmpty()) { %>
    <div class="alert show">
      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><circle cx="12" cy="16" r=".5" fill="currentColor"/></svg>
      <%= errorMessage %>
    </div>
    <% } %>

    <!-- Role selector (visual, drives hidden input) -->
    <div class="role-selector" id="roleSelector">
      <button type="button" class="role-btn" id="btnAdmin" onclick="selectRole('admin')">
        <svg viewBox="0 0 24 24"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
        Admin
      </button>
      <button type="button" class="role-btn" id="btnStudent" onclick="selectRole('student')">
        <svg viewBox="0 0 24 24"><path d="M22 10v6M2 10l10-5 10 5-10 5z"/><path d="M6 12v5c3 3 9 3 12 0v-5"/></svg>
        Student
      </button>
    </div>

    <form class="login-form" method="POST" action="login.jsp" onsubmit="return validateForm()">
      <input type="hidden" name="role" id="roleInput" value="">

      <div class="field">
        <label>Username</label>
        <div class="field-wrap">
          <svg viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
          <input type="text" name="username" placeholder="Enter username" required autocomplete="username"
                 value="<%= request.getParameter("username") != null ? request.getParameter("username") : "" %>">
        </div>
      </div>

      <div class="field">
        <label>Password</label>
        <div class="field-wrap">
          <svg viewBox="0 0 24 24"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
          <input type="password" name="password" placeholder="••••••••" required autocomplete="current-password">
        </div>
      </div>

      <button type="submit" class="btn-submit" id="submitBtn">Sign In</button>
    </form>

    <div class="demo-hint">
      <p>Demo credentials:</p>
      <p>Admin → <code>admin</code> / <code>admin123</code></p>
      <p>Student → <code>student</code> / <code>stu123</code></p>
    </div>
  </div>
</div>

<script>
  let selectedRole = '';

  function selectRole(role) {
    selectedRole = role;
    document.getElementById('roleInput').value = role;
    document.getElementById('btnAdmin').className = 'role-btn' + (role === 'admin' ? ' active-admin' : '');
    document.getElementById('btnStudent').className = 'role-btn' + (role === 'student' ? ' active-student' : '');
    // Update button color based on role
    const btn = document.getElementById('submitBtn');
    if (role === 'admin') {
      btn.style.background = 'linear-gradient(135deg,#F97316,#C2570A)';
      btn.style.boxShadow = '0 4px 20px rgba(249,115,22,.3)';
    } else {
      btn.style.background = 'linear-gradient(135deg,#4F8EF7,#3B6FD4)';
      btn.style.boxShadow = '0 4px 20px rgba(79,142,247,.25)';
    }
  }

  function validateForm() {
    if (!selectedRole) {
      const a = document.createElement('div');
      // show inline alert
      alert('Please select a role first (Admin or Student).');
      return false;
    }
    return true;
  }

  // Pre-select role if returning after error
  <% if (request.getParameter("role") != null) { %>
    selectRole('<%= request.getParameter("role") %>');
  <% } %>
</script>
</body>
</html>
