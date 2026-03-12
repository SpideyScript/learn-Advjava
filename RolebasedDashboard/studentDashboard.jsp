<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String username = (String) session.getAttribute("username");
    String role     = (String) session.getAttribute("role");
    if (username == null || !"student".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
    if ("logout".equals(request.getParameter("action"))) {
        session.invalidate();
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Student Dashboard — EduPortal</title>
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;500;600;700;800&family=Mulish:wght@300;400;500;600&display=swap" rel="stylesheet">
<style>
*,*::before,*::after{margin:0;padding:0;box-sizing:border-box}
:root{
  --bg:#07101F;
  --surface:#0D1829;
  --card:#0F1E33;
  --card2:#132238;
  --border:#172540;
  --accent:#4F8EF7;
  --accent2:#38D9A9;
  --purple:#A78BFA;
  --red:#FF6B6B;
  --yellow:#F6C90E;
  --text:#EDF2FF;
  --muted:#5C7399;
  --sidebar-w:240px;
}
html,body{height:100%;font-family:'Mulish',sans-serif;background:var(--bg);color:var(--text);overflow-x:hidden}

/* Animated aurora bg */
.aurora{position:fixed;inset:0;pointer-events:none;z-index:0;overflow:hidden}
.aurora-blob{
  position:absolute;border-radius:50%;filter:blur(100px);mix-blend-mode:screen;
  animation:auroraMove 20s ease-in-out infinite;
}
.aurora-blob.a{width:500px;height:500px;top:-100px;left:-100px;background:rgba(79,142,247,.07);animation-delay:0s}
.aurora-blob.b{width:400px;height:400px;bottom:-80px;right:-80px;background:rgba(56,217,169,.05);animation-delay:-7s}
.aurora-blob.c{width:300px;height:300px;top:40%;left:40%;background:rgba(167,139,250,.04);animation-delay:-14s}
@keyframes auroraMove{
  0%,100%{transform:translate(0,0) scale(1)}
  33%{transform:translate(40px,-30px) scale(1.05)}
  66%{transform:translate(-30px,40px) scale(.95)}
}

/* Sidebar */
.sidebar{
  position:fixed;top:0;left:0;width:var(--sidebar-w);height:100%;
  background:var(--surface);border-right:1px solid var(--border);
  display:flex;flex-direction:column;z-index:100;
  animation:sideIn .5s cubic-bezier(.16,1,.3,1) both;
}
@keyframes sideIn{from{transform:translateX(-20px);opacity:0}to{transform:none;opacity:1}}

.sidebar-logo{
  padding:1.8rem 1.6rem 1.4rem;
  border-bottom:1px solid var(--border);
  display:flex;align-items:center;gap:.8rem;
}
.sidebar-logo-mark{
  width:36px;height:36px;border-radius:8px;
  background:linear-gradient(135deg,var(--accent),var(--accent2));
  display:flex;align-items:center;justify-content:center;flex-shrink:0;
  box-shadow:0 4px 14px rgba(79,142,247,.25);
}
.sidebar-logo-mark svg{width:18px;height:18px;fill:none;stroke:#fff;stroke-width:2}
.sidebar-logo-text{font-family:'Syne',sans-serif;font-weight:800;font-size:.95rem;line-height:1}
.sidebar-logo-sub{font-size:.6rem;text-transform:uppercase;letter-spacing:.12em;color:var(--accent);font-weight:700}

.sidebar-nav{flex:1;padding:1.2rem .8rem;overflow-y:auto}
.nav-section-label{font-size:.6rem;text-transform:uppercase;letter-spacing:.18em;color:var(--muted);font-weight:700;padding:.6rem .8rem;margin-top:.4rem}
.nav-item{
  display:flex;align-items:center;gap:.75rem;
  padding:.65rem .8rem;border-radius:8px;margin-bottom:.15rem;
  font-size:.83rem;font-weight:500;color:var(--muted);cursor:pointer;
  transition:all .2s;text-decoration:none;
}
.nav-item svg{width:16px;height:16px;fill:none;stroke:currentColor;stroke-width:2;flex-shrink:0}
.nav-item:hover{background:rgba(79,142,247,.08);color:var(--text)}
.nav-item.active{background:rgba(79,142,247,.12);color:var(--accent);font-weight:600}
.nav-item.active svg{stroke:var(--accent)}

.sidebar-user{
  padding:1rem 1.2rem;border-top:1px solid var(--border);
  display:flex;align-items:center;gap:.8rem;
}
.user-avatar{
  width:36px;height:36px;border-radius:50%;flex-shrink:0;
  background:linear-gradient(135deg,var(--accent),var(--accent2));
  display:flex;align-items:center;justify-content:center;
  font-family:'Syne',sans-serif;font-weight:800;font-size:.85rem;color:#fff;
  box-shadow:0 2px 10px rgba(79,142,247,.2);
}
.user-name{font-size:.82rem;font-weight:600;color:var(--text)}
.user-role{font-size:.68rem;text-transform:uppercase;letter-spacing:.1em;color:var(--accent);font-weight:700}
.logout-btn{
  margin-left:auto;background:none;border:none;cursor:pointer;
  color:var(--muted);transition:color .2s;padding:.2rem;
}
.logout-btn:hover{color:var(--red)}
.logout-btn svg{width:15px;height:15px;fill:none;stroke:currentColor;stroke-width:2}

/* Main */
.main{margin-left:var(--sidebar-w);min-height:100vh;display:flex;flex-direction:column;position:relative;z-index:1}

.topbar{
  padding:1.4rem 2rem;border-bottom:1px solid var(--border);
  background:rgba(7,16,31,.85);backdrop-filter:blur(14px);
  display:flex;align-items:center;justify-content:space-between;
  position:sticky;top:0;z-index:50;
  animation:fadeDown .5s .1s both;
}
@keyframes fadeDown{from{opacity:0;transform:translateY(-10px)}to{opacity:1;transform:none}}
.topbar-title{font-family:'Syne',sans-serif;font-size:1.05rem;font-weight:700}
.topbar-date{font-size:.78rem;color:var(--muted)}
.topbar-right{display:flex;align-items:center;gap:.8rem}
.icon-btn{
  width:36px;height:36px;border-radius:8px;border:1px solid var(--border);
  background:var(--card);display:flex;align-items:center;justify-content:center;
  cursor:pointer;transition:all .2s;position:relative;
}
.icon-btn svg{width:16px;height:16px;fill:none;stroke:var(--muted);stroke-width:2}
.icon-btn:hover{border-color:var(--accent);background:rgba(79,142,247,.08)}
.icon-btn:hover svg{stroke:var(--accent)}
.notif-dot{position:absolute;top:6px;right:6px;width:7px;height:7px;border-radius:50%;background:var(--red);border:2px solid var(--bg)}

.content{padding:2rem;flex:1}

/* Welcome banner */
.welcome-banner{
  background:linear-gradient(135deg,#0D1E38 0%,#091628 60%,#07101F 100%);
  border:1px solid var(--border);border-radius:14px;padding:1.8rem 2rem;
  margin-bottom:2rem;position:relative;overflow:hidden;
  animation:fadeUp .5s .15s both;
  display:flex;align-items:center;justify-content:space-between;
}
.welcome-banner::before{
  content:'';position:absolute;right:-40px;top:-40px;
  width:220px;height:220px;
  background:radial-gradient(circle,rgba(79,142,247,.12),transparent 70%);
  border-radius:50%;
}
.welcome-text h2{font-family:'Syne',sans-serif;font-size:1.4rem;font-weight:800;margin-bottom:.3rem}
.welcome-text h2 span{background:linear-gradient(90deg,var(--accent),var(--accent2));-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text}
.welcome-text p{font-size:.83rem;color:var(--muted);line-height:1.5}
.welcome-badge{
  display:flex;flex-direction:column;align-items:flex-end;gap:.4rem;flex-shrink:0;
}
.gpa-chip{
  background:rgba(56,217,169,.1);border:1px solid rgba(56,217,169,.25);
  border-radius:10px;padding:.6rem 1rem;text-align:center;
}
.gpa-val{font-family:'Syne',sans-serif;font-size:1.5rem;font-weight:800;color:var(--accent2);line-height:1}
.gpa-label{font-size:.65rem;color:var(--muted);text-transform:uppercase;letter-spacing:.1em;margin-top:.15rem}
.semester-chip{
  font-size:.7rem;letter-spacing:.1em;text-transform:uppercase;font-weight:600;
  color:var(--accent);background:rgba(79,142,247,.1);border:1px solid rgba(79,142,247,.2);
  padding:.25rem .7rem;border-radius:20px;
}

/* Stats */
.stats-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:1rem;margin-bottom:2rem;animation:fadeUp .5s .25s both}
.stat-card{
  background:var(--card);border:1px solid var(--border);border-radius:12px;
  padding:1.3rem;transition:transform .2s,border-color .2s;
}
.stat-card:hover{transform:translateY(-2px);border-color:rgba(79,142,247,.3)}
.stat-icon{width:38px;height:38px;border-radius:9px;display:flex;align-items:center;justify-content:center;margin-bottom:.9rem}
.stat-icon svg{width:17px;height:17px;fill:none;stroke:currentColor;stroke-width:2}
.stat-card.blue .stat-icon{background:rgba(79,142,247,.1);color:var(--accent)}
.stat-card.green .stat-icon{background:rgba(56,217,169,.1);color:var(--accent2)}
.stat-card.purple .stat-icon{background:rgba(167,139,250,.1);color:var(--purple)}
.stat-card.yellow .stat-icon{background:rgba(246,201,14,.1);color:var(--yellow)}
.stat-val{font-family:'Syne',sans-serif;font-size:1.7rem;font-weight:800;line-height:1;margin-bottom:.25rem}
.stat-card.blue .stat-val{color:var(--accent)}
.stat-card.green .stat-val{color:var(--accent2)}
.stat-card.purple .stat-val{color:var(--purple)}
.stat-card.yellow .stat-val{color:var(--yellow)}
.stat-label{font-size:.73rem;color:var(--muted);font-weight:500}

/* Two-col layout */
.row-2{display:grid;grid-template-columns:1.4fr 1fr;gap:1rem;margin-bottom:2rem;animation:fadeUp .5s .3s both}

.section-card{background:var(--card);border:1px solid var(--border);border-radius:12px;overflow:hidden}
.section-header{
  padding:1.1rem 1.4rem;border-bottom:1px solid var(--border);
  display:flex;align-items:center;justify-content:space-between;
}
.section-title{font-family:'Syne',sans-serif;font-size:.88rem;font-weight:700}
.section-action{
  font-size:.7rem;color:var(--accent);font-weight:600;letter-spacing:.06em;
  text-transform:uppercase;cursor:pointer;text-decoration:none;
  border:1px solid rgba(79,142,247,.3);padding:.22rem .65rem;border-radius:5px;transition:all .2s;
}
.section-action:hover{background:rgba(79,142,247,.1)}

/* Course cards */
.courses-list{padding:.8rem}
.course-card{
  background:var(--card2);border:1px solid var(--border);border-radius:10px;
  padding:1rem 1.1rem;margin-bottom:.6rem;transition:all .2s;cursor:pointer;
  display:flex;align-items:center;gap:1rem;
}
.course-card:last-child{margin-bottom:0}
.course-card:hover{border-color:rgba(79,142,247,.35);transform:translateX(3px)}
.course-color{width:4px;height:44px;border-radius:2px;flex-shrink:0}
.course-info{flex:1}
.course-name{font-size:.84rem;font-weight:600;margin-bottom:.2rem}
.course-meta{font-size:.72rem;color:var(--muted)}
.course-progress-wrap{margin-top:.5rem}
.progress-bar{height:4px;background:var(--border);border-radius:2px;overflow:hidden}
.progress-fill{height:100%;border-radius:2px}
.course-pct{font-size:.68rem;color:var(--muted);margin-top:.25rem;text-align:right}

/* Schedule */
.schedule-list{padding:.5rem 0}
.schedule-item{
  display:flex;align-items:center;gap:.9rem;
  padding:.7rem 1.4rem;border-bottom:1px solid rgba(23,37,64,.6);
  transition:background .15s;
}
.schedule-item:last-child{border-bottom:none}
.schedule-item:hover{background:rgba(79,142,247,.04)}
.sched-time{
  font-family:'Syne',sans-serif;font-size:.72rem;font-weight:700;
  color:var(--accent);text-align:center;min-width:44px;
}
.sched-dot{
  width:8px;height:8px;border-radius:50%;flex-shrink:0;
}
.sched-content .sched-name{font-size:.82rem;font-weight:600}
.sched-content .sched-room{font-size:.7rem;color:var(--muted)}
.sched-badge{
  margin-left:auto;font-size:.65rem;font-weight:700;letter-spacing:.06em;
  text-transform:uppercase;padding:.18rem .55rem;border-radius:20px;
}
.sched-badge.live{background:rgba(255,107,107,.1);color:var(--red)}
.sched-badge.next{background:rgba(79,142,247,.1);color:var(--accent)}
.sched-badge.done{background:rgba(92,115,153,.1);color:var(--muted)}

/* Bottom grid */
.row-3{display:grid;grid-template-columns:1fr 1fr 1fr;gap:1rem;animation:fadeUp .5s .4s both}

/* Assignment items */
.assignment-item{
  display:flex;align-items:center;gap:.8rem;
  padding:.8rem 1.4rem;border-bottom:1px solid rgba(23,37,64,.6);
}
.assignment-item:last-child{border-bottom:none}
.assign-icon{
  width:34px;height:34px;border-radius:8px;flex-shrink:0;
  display:flex;align-items:center;justify-content:center;
}
.assign-icon svg{width:15px;height:15px;fill:none;stroke:currentColor;stroke-width:2}
.assign-name{font-size:.8rem;font-weight:600;margin-bottom:.15rem}
.assign-meta{font-size:.7rem;color:var(--muted)}
.assign-due{margin-left:auto;font-size:.7rem;font-weight:600;padding:.15rem .5rem;border-radius:4px}
.assign-due.urgent{color:var(--red);background:rgba(255,107,107,.08)}
.assign-due.soon{color:var(--yellow);background:rgba(246,201,14,.08)}
.assign-due.ok{color:var(--accent2);background:rgba(56,217,169,.08)}

/* Grade table */
table{width:100%;border-collapse:collapse}
thead th{
  padding:.65rem 1.4rem;text-align:left;
  font-size:.64rem;text-transform:uppercase;letter-spacing:.12em;color:var(--muted);font-weight:700;
  border-bottom:1px solid var(--border);
}
tbody td{padding:.75rem 1.4rem;font-size:.8rem;border-bottom:1px solid rgba(23,37,64,.5)}
tbody tr:last-child td{border-bottom:none}
tbody tr:hover{background:rgba(79,142,247,.03)}
.grade-badge{font-family:'Syne',sans-serif;font-weight:800;font-size:.9rem}
.grade-A{color:var(--accent2)}
.grade-B{color:var(--accent)}
.grade-C{color:var(--yellow)}

/* Announcement */
.announce-item{
  padding:.85rem 1.4rem;border-bottom:1px solid rgba(23,37,64,.5);
}
.announce-item:last-child{border-bottom:none}
.announce-tag{
  display:inline-block;font-size:.62rem;font-weight:700;letter-spacing:.08em;
  text-transform:uppercase;padding:.12rem .5rem;border-radius:3px;margin-bottom:.4rem;
}
.announce-tag.exam{background:rgba(255,107,107,.1);color:var(--red)}
.announce-tag.event{background:rgba(79,142,247,.1);color:var(--accent)}
.announce-tag.holiday{background:rgba(56,217,169,.1);color:var(--accent2)}
.announce-text{font-size:.8rem;font-weight:500;margin-bottom:.2rem}
.announce-date{font-size:.68rem;color:var(--muted)}

@keyframes fadeUp{from{opacity:0;transform:translateY(16px)}to{opacity:1;transform:none}}
@media(max-width:900px){
  .stats-grid{grid-template-columns:1fr 1fr}
  .row-2,.row-3{grid-template-columns:1fr}
  .sidebar{transform:translateX(-100%)}
  .main{margin-left:0}
  .welcome-badge{display:none}
}
</style>
</head>
<body>
<div class="aurora">
  <div class="aurora-blob a"></div>
  <div class="aurora-blob b"></div>
  <div class="aurora-blob c"></div>
</div>

<!-- Sidebar -->
<aside class="sidebar">
  <div class="sidebar-logo">
    <div class="sidebar-logo-mark">
      <svg viewBox="0 0 24 24"><path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"/></svg>
    </div>
    <div>
      <div class="sidebar-logo-text">EduPortal</div>
      <div class="sidebar-logo-sub">Student Portal</div>
    </div>
  </div>

  <nav class="sidebar-nav">
    <div class="nav-section-label">Learning</div>
    <a class="nav-item active" href="#">
      <svg viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/></svg>
      Dashboard
    </a>
    <a class="nav-item" href="#">
      <svg viewBox="0 0 24 24"><path d="M22 10v6M2 10l10-5 10 5-10 5z"/><path d="M6 12v5c3 3 9 3 12 0v-5"/></svg>
      My Courses
    </a>
    <a class="nav-item" href="#">
      <svg viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
      Assignments
    </a>
    <a class="nav-item" href="#">
      <svg viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
      Schedule
    </a>
    <div class="nav-section-label">Account</div>
    <a class="nav-item" href="#">
      <svg viewBox="0 0 24 24"><path d="M18 20V10M12 20V4M6 20v-6"/></svg>
      Grades
    </a>
    <a class="nav-item" href="#">
      <svg viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
      Profile
    </a>
  </nav>

  <div class="sidebar-user">
    <div class="user-avatar"><%= username.substring(0,1).toUpperCase() %></div>
    <div>
      <div class="user-name"><%= username %></div>
      <div class="user-role">Student</div>
    </div>
    <a class="logout-btn" href="studentDashboard.jsp?action=logout" title="Logout">
      <svg viewBox="0 0 24 24"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
    </a>
  </div>
</aside>

<!-- Main Content -->
<main class="main">
  <div class="topbar">
    <div>
      <div class="topbar-title">Student Dashboard</div>
      <div class="topbar-date" id="dateStr"></div>
    </div>
    <div class="topbar-right">
      <div class="icon-btn"><svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg></div>
      <div class="icon-btn">
        <svg viewBox="0 0 24 24"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg>
        <span class="notif-dot"></span>
      </div>
    </div>
  </div>

  <div class="content">

    <!-- Welcome banner -->
    <div class="welcome-banner">
      <div class="welcome-text">
        <h2>Welcome back, <span><%= username.substring(0,1).toUpperCase() + username.substring(1) %></span> 👋</h2>
        <p>You have 3 assignments due this week and 1 upcoming exam.<br>Keep up the great work!</p>
      </div>
      <div class="welcome-badge">
        <div class="gpa-chip">
          <div class="gpa-val">3.8</div>
          <div class="gpa-label">Current GPA</div>
        </div>
        <span class="semester-chip">Semester 6 · 2025–26</span>
      </div>
    </div>

    <!-- Stats -->
    <div class="stats-grid">
      <div class="stat-card blue">
        <div class="stat-icon"><svg viewBox="0 0 24 24"><path d="M22 10v6M2 10l10-5 10 5-10 5z"/><path d="M6 12v5c3 3 9 3 12 0v-5"/></svg></div>
        <div class="stat-val">6</div>
        <div class="stat-label">Enrolled Courses</div>
      </div>
      <div class="stat-card green">
        <div class="stat-icon"><svg viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg></div>
        <div class="stat-val">84%</div>
        <div class="stat-label">Attendance Rate</div>
      </div>
      <div class="stat-card purple">
        <div class="stat-icon"><svg viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg></div>
        <div class="stat-val">3</div>
        <div class="stat-label">Pending Tasks</div>
      </div>
      <div class="stat-card yellow">
        <div class="stat-icon"><svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg></div>
        <div class="stat-val">12</div>
        <div class="stat-label">Achievements</div>
      </div>
    </div>

    <!-- Courses + Schedule -->
    <div class="row-2">
      <div class="section-card">
        <div class="section-header">
          <span class="section-title">My Courses</span>
          <a class="section-action" href="#">All Courses</a>
        </div>
        <div class="courses-list">
          <div class="course-card">
            <div class="course-color" style="background:#4F8EF7"></div>
            <div class="course-info">
              <div class="course-name">Data Structures & Algorithms</div>
              <div class="course-meta">Prof. Sharma · Mon, Wed, Fri 9:00 AM</div>
              <div class="course-progress-wrap">
                <div class="progress-bar"><div class="progress-fill" style="width:72%;background:#4F8EF7"></div></div>
                <div class="course-pct">72% complete</div>
              </div>
            </div>
          </div>
          <div class="course-card">
            <div class="course-color" style="background:#38D9A9"></div>
            <div class="course-info">
              <div class="course-name">Web Development</div>
              <div class="course-meta">Prof. Verma · Tue, Thu 11:00 AM</div>
              <div class="course-progress-wrap">
                <div class="progress-bar"><div class="progress-fill" style="width:58%;background:#38D9A9"></div></div>
                <div class="course-pct">58% complete</div>
              </div>
            </div>
          </div>
          <div class="course-card">
            <div class="course-color" style="background:#A78BFA"></div>
            <div class="course-info">
              <div class="course-name">Machine Learning</div>
              <div class="course-meta">Prof. Nair · Mon, Wed 2:00 PM</div>
              <div class="course-progress-wrap">
                <div class="progress-bar"><div class="progress-fill" style="width:40%;background:#A78BFA"></div></div>
                <div class="course-pct">40% complete</div>
              </div>
            </div>
          </div>
          <div class="course-card">
            <div class="course-color" style="background:#F6C90E"></div>
            <div class="course-info">
              <div class="course-name">Database Systems</div>
              <div class="course-meta">Prof. Singh · Fri 1:00 PM</div>
              <div class="course-progress-wrap">
                <div class="progress-bar"><div class="progress-fill" style="width:85%;background:#F6C90E"></div></div>
                <div class="course-pct">85% complete</div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="section-card">
        <div class="section-header"><span class="section-title">Today's Schedule</span></div>
        <div class="schedule-list">
          <div class="schedule-item">
            <div class="sched-time">9:00</div>
            <div class="sched-dot" style="background:#4F8EF7"></div>
            <div class="sched-content"><div class="sched-name">Data Structures</div><div class="sched-room">Room 204 · Lab</div></div>
            <span class="sched-badge done">Done</span>
          </div>
          <div class="schedule-item">
            <div class="sched-time">11:00</div>
            <div class="sched-dot" style="background:#38D9A9"></div>
            <div class="sched-content"><div class="sched-name">Web Development</div><div class="sched-room">Room 108 · Lecture</div></div>
            <span class="sched-badge live">Live</span>
          </div>
          <div class="schedule-item">
            <div class="sched-time">2:00</div>
            <div class="sched-dot" style="background:#A78BFA"></div>
            <div class="sched-content"><div class="sched-name">Machine Learning</div><div class="sched-room">Room 302 · Lecture</div></div>
            <span class="sched-badge next">Next</span>
          </div>
          <div class="schedule-item">
            <div class="sched-time">4:00</div>
            <div class="sched-dot" style="background:#F97316"></div>
            <div class="sched-content"><div class="sched-name">Study Group</div><div class="sched-room">Library · Section B</div></div>
            <span class="sched-badge next">Next</span>
          </div>
          <div class="schedule-item">
            <div class="sched-time">6:00</div>
            <div class="sched-dot" style="background:#F6C90E"></div>
            <div class="sched-content"><div class="sched-name">Database Lab</div><div class="sched-room">Computer Lab 2</div></div>
            <span class="sched-badge next">Next</span>
          </div>
        </div>
      </div>
    </div>

    <!-- Assignments + Grades + Announcements -->
    <div class="row-3">
      <div class="section-card">
        <div class="section-header"><span class="section-title">Assignments</span><a class="section-action" href="#">All</a></div>
        <div class="assignment-item">
          <div class="assign-icon" style="background:rgba(255,107,107,.1);color:var(--red)"><svg viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg></div>
          <div><div class="assign-name">DSA Assignment 4</div><div class="assign-meta">Data Structures</div></div>
          <span class="assign-due urgent">Due Today</span>
        </div>
        <div class="assignment-item">
          <div class="assign-icon" style="background:rgba(246,201,14,.1);color:var(--yellow)"><svg viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg></div>
          <div><div class="assign-name">React Project</div><div class="assign-meta">Web Development</div></div>
          <span class="assign-due soon">Mar 12</span>
        </div>
        <div class="assignment-item">
          <div class="assign-icon" style="background:rgba(56,217,169,.1);color:var(--accent2)"><svg viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg></div>
          <div><div class="assign-name">ML Lab Report</div><div class="assign-meta">Machine Learning</div></div>
          <span class="assign-due ok">Mar 18</span>
        </div>
        <div class="assignment-item">
          <div class="assign-icon" style="background:rgba(79,142,247,.1);color:var(--accent)"><svg viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg></div>
          <div><div class="assign-name">DB Schema Design</div><div class="assign-meta">Database Systems</div></div>
          <span class="assign-due ok">Mar 22</span>
        </div>
      </div>

      <div class="section-card">
        <div class="section-header"><span class="section-title">Recent Grades</span></div>
        <table>
          <thead><tr><th>Subject</th><th>Marks</th><th>Grade</th></tr></thead>
          <tbody>
            <tr><td>Data Structures</td><td>88/100</td><td><span class="grade-badge grade-A">A</span></td></tr>
            <tr><td>Web Dev</td><td>79/100</td><td><span class="grade-badge grade-B">B+</span></td></tr>
            <tr><td>ML Midterm</td><td>72/100</td><td><span class="grade-badge grade-B">B</span></td></tr>
            <tr><td>Database</td><td>91/100</td><td><span class="grade-badge grade-A">A+</span></td></tr>
            <tr><td>Cloud Comp.</td><td>65/100</td><td><span class="grade-badge grade-C">C+</span></td></tr>
          </tbody>
        </table>
      </div>

      <div class="section-card">
        <div class="section-header"><span class="section-title">Announcements</span></div>
        <div class="announce-item">
          <span class="announce-tag exam">Exam</span>
          <div class="announce-text">Mid-semester exams scheduled from March 15–20</div>
          <div class="announce-date">Posted Mar 08, 2026</div>
        </div>
        <div class="announce-item">
          <span class="announce-tag event">Event</span>
          <div class="announce-text">Tech Fest 2026 registration open — team of 3–4</div>
          <div class="announce-date">Posted Mar 06, 2026</div>
        </div>
        <div class="announce-item">
          <span class="announce-tag holiday">Holiday</span>
          <div class="announce-text">No classes on March 14 (public holiday)</div>
          <div class="announce-date">Posted Mar 05, 2026</div>
        </div>
        <div class="announce-item">
          <span class="announce-tag event">Event</span>
          <div class="announce-text">Guest lecture on AI Ethics — March 16, 3 PM, Hall A</div>
          <div class="announce-date">Posted Mar 04, 2026</div>
        </div>
      </div>
    </div>

  </div>
</main>

<script>
const d = new Date();
document.getElementById('dateStr').textContent = d.toLocaleDateString('en-US',{weekday:'long',year:'numeric',month:'long',day:'numeric'});
</script>
</body>
</html>
