<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String username = (String) session.getAttribute("username");
    String role     = (String) session.getAttribute("role");
    if (username == null || !"admin".equals(role)) {
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
<title>Admin Dashboard — EduPortal</title>
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;500;600;700;800&family=Mulish:wght@300;400;500;600&display=swap" rel="stylesheet">
<style>
*,*::before,*::after{margin:0;padding:0;box-sizing:border-box}
:root{
  --bg:#0B0F1A;
  --surface:#111827;
  --card:#161D2E;
  --card2:#1A2235;
  --border:#1E2A40;
  --accent:#F97316;
  --accent2:#FB923C;
  --blue:#4F8EF7;
  --green:#38D9A9;
  --red:#FF6B6B;
  --yellow:#F6C90E;
  --text:#EDF2FF;
  --muted:#6B7A9A;
  --sidebar-w:240px;
}
html,body{height:100%;font-family:'Mulish',sans-serif;background:var(--bg);color:var(--text);overflow-x:hidden}

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
  background:linear-gradient(135deg,var(--accent),#C2570A);
  display:flex;align-items:center;justify-content:center;flex-shrink:0;
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
.nav-item:hover{background:rgba(249,115,22,.08);color:var(--text)}
.nav-item.active{background:rgba(249,115,22,.12);color:var(--accent);font-weight:600}
.nav-item.active svg{stroke:var(--accent)}

.sidebar-user{
  padding:1rem 1.2rem;border-top:1px solid var(--border);
  display:flex;align-items:center;gap:.8rem;
}
.user-avatar{
  width:36px;height:36px;border-radius:50%;flex-shrink:0;
  background:linear-gradient(135deg,var(--accent),#C2570A);
  display:flex;align-items:center;justify-content:center;
  font-family:'Syne',sans-serif;font-weight:800;font-size:.85rem;color:#fff;
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
.main{margin-left:var(--sidebar-w);min-height:100vh;display:flex;flex-direction:column}

.topbar{
  padding:1.4rem 2rem;border-bottom:1px solid var(--border);
  background:rgba(11,15,26,.8);backdrop-filter:blur(12px);
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
.icon-btn:hover{border-color:var(--accent);background:rgba(249,115,22,.08)}
.icon-btn:hover svg{stroke:var(--accent)}
.notif-dot{
  position:absolute;top:6px;right:6px;width:7px;height:7px;
  border-radius:50%;background:var(--red);border:2px solid var(--bg);
}

.content{padding:2rem;flex:1}

/* Stats grid */
.stats-grid{
  display:grid;grid-template-columns:repeat(4,1fr);gap:1rem;
  margin-bottom:2rem;animation:fadeUp .5s .2s both;
}
.stat-card{
  background:var(--card);border:1px solid var(--border);border-radius:12px;
  padding:1.4rem;position:relative;overflow:hidden;transition:transform .2s,border-color .2s;
}
.stat-card:hover{transform:translateY(-2px);border-color:rgba(249,115,22,.3)}
.stat-card::before{
  content:'';position:absolute;top:0;right:0;width:80px;height:80px;
  border-radius:0 12px 0 80px;opacity:.06;
}
.stat-card.orange::before{background:var(--accent)}
.stat-card.blue::before{background:var(--blue)}
.stat-card.green::before{background:var(--green)}
.stat-card.yellow::before{background:var(--yellow)}

.stat-icon{
  width:40px;height:40px;border-radius:10px;
  display:flex;align-items:center;justify-content:center;margin-bottom:1rem;
}
.stat-icon svg{width:18px;height:18px;fill:none;stroke:currentColor;stroke-width:2}
.stat-card.orange .stat-icon{background:rgba(249,115,22,.12);color:var(--accent)}
.stat-card.blue .stat-icon{background:rgba(79,142,247,.12);color:var(--blue)}
.stat-card.green .stat-icon{background:rgba(56,217,169,.12);color:var(--green)}
.stat-card.yellow .stat-icon{background:rgba(246,201,14,.12);color:var(--yellow)}

.stat-val{font-family:'Syne',sans-serif;font-size:1.9rem;font-weight:800;line-height:1;margin-bottom:.3rem}
.stat-card.orange .stat-val{color:var(--accent)}
.stat-card.blue .stat-val{color:var(--blue)}
.stat-card.green .stat-val{color:var(--green)}
.stat-card.yellow .stat-val{color:var(--yellow)}
.stat-label{font-size:.75rem;color:var(--muted);font-weight:500}
.stat-change{
  display:inline-flex;align-items:center;gap:.25rem;
  font-size:.68rem;font-weight:600;margin-top:.5rem;padding:.15rem .5rem;border-radius:20px;
}
.stat-change.up{background:rgba(56,217,169,.1);color:var(--green)}
.stat-change.down{background:rgba(255,107,107,.1);color:var(--red)}

/* Two-column row */
.row-2{display:grid;grid-template-columns:1.6fr 1fr;gap:1rem;margin-bottom:2rem;animation:fadeUp .5s .3s both}

/* Table */
.section-card{background:var(--card);border:1px solid var(--border);border-radius:12px;overflow:hidden}
.section-header{
  padding:1.2rem 1.4rem;border-bottom:1px solid var(--border);
  display:flex;align-items:center;justify-content:space-between;
}
.section-title{font-family:'Syne',sans-serif;font-size:.9rem;font-weight:700}
.section-action{
  font-size:.72rem;color:var(--accent);font-weight:600;letter-spacing:.06em;
  text-transform:uppercase;cursor:pointer;text-decoration:none;
  border:1px solid rgba(249,115,22,.3);padding:.25rem .7rem;border-radius:5px;
  transition:all .2s;
}
.section-action:hover{background:rgba(249,115,22,.1)}

table{width:100%;border-collapse:collapse}
thead th{
  padding:.75rem 1.4rem;text-align:left;
  font-size:.67rem;text-transform:uppercase;letter-spacing:.12em;
  color:var(--muted);font-weight:700;border-bottom:1px solid var(--border);
}
tbody tr{transition:background .15s;cursor:default}
tbody tr:hover{background:rgba(249,115,22,.04)}
tbody td{padding:.85rem 1.4rem;font-size:.82rem;border-bottom:1px solid rgba(30,42,64,.6)}
tbody tr:last-child td{border-bottom:none}
.avatar-cell{display:flex;align-items:center;gap:.7rem}
.t-avatar{
  width:30px;height:30px;border-radius:50%;flex-shrink:0;
  display:flex;align-items:center;justify-content:center;
  font-family:'Syne',sans-serif;font-weight:800;font-size:.7rem;
}
.t-name{font-weight:600;font-size:.82rem}
.t-sub{font-size:.7rem;color:var(--muted)}
.badge-status{
  display:inline-flex;padding:.2rem .7rem;border-radius:20px;
  font-size:.67rem;font-weight:700;letter-spacing:.06em;text-transform:uppercase;
}
.badge-status.active{background:rgba(56,217,169,.1);color:var(--green)}
.badge-status.pending{background:rgba(246,201,14,.1);color:var(--yellow)}
.badge-status.inactive{background:rgba(107,122,154,.1);color:var(--muted)}

/* Activity feed */
.activity-list{padding:.6rem 0}
.activity-item{
  display:flex;align-items:flex-start;gap:.9rem;
  padding:.75rem 1.4rem;border-bottom:1px solid rgba(30,42,64,.5);
  transition:background .15s;
}
.activity-item:last-child{border-bottom:none}
.activity-item:hover{background:rgba(249,115,22,.04)}
.act-dot{
  width:32px;height:32px;border-radius:8px;flex-shrink:0;
  display:flex;align-items:center;justify-content:center;margin-top:.1rem;
}
.act-dot svg{width:14px;height:14px;fill:none;stroke:currentColor;stroke-width:2}
.act-dot.blue{background:rgba(79,142,247,.1);color:var(--blue)}
.act-dot.green{background:rgba(56,217,169,.1);color:var(--green)}
.act-dot.orange{background:rgba(249,115,22,.1);color:var(--accent)}
.act-dot.red{background:rgba(255,107,107,.1);color:var(--red)}
.act-text{font-size:.8rem;color:var(--text);line-height:1.4}
.act-time{font-size:.68rem;color:var(--muted);margin-top:.2rem}

/* Bottom row */
.row-3{display:grid;grid-template-columns:1fr 1fr 1fr;gap:1rem;animation:fadeUp .5s .4s both}

/* Course progress bars */
.course-item{padding:.9rem 1.4rem;border-bottom:1px solid rgba(30,42,64,.5)}
.course-item:last-child{border-bottom:none}
.course-row{display:flex;justify-content:space-between;align-items:center;margin-bottom:.5rem}
.course-name{font-size:.82rem;font-weight:600}
.course-pct{font-size:.75rem;color:var(--muted)}
.progress-bar{height:5px;background:var(--border);border-radius:3px;overflow:hidden}
.progress-fill{height:100%;border-radius:3px;transition:width 1s ease}

/* Quick actions */
.qa-grid{display:grid;grid-template-columns:1fr 1fr;gap:.6rem;padding:1rem}
.qa-btn{
  display:flex;flex-direction:column;align-items:center;gap:.5rem;
  padding:1rem .6rem;background:var(--card2);border:1px solid var(--border);
  border-radius:10px;cursor:pointer;transition:all .2s;text-decoration:none;color:var(--text);
}
.qa-btn svg{width:20px;height:20px;fill:none;stroke:currentColor;stroke-width:2}
.qa-btn span{font-size:.7rem;font-weight:600;text-align:center;letter-spacing:.03em}
.qa-btn:hover{border-color:var(--accent);background:rgba(249,115,22,.08);color:var(--accent)}

@keyframes fadeUp{from{opacity:0;transform:translateY(16px)}to{opacity:1;transform:none}}
@media(max-width:900px){
  .stats-grid{grid-template-columns:1fr 1fr}
  .row-2,.row-3{grid-template-columns:1fr}
  .sidebar{transform:translateX(-100%)}
  .main{margin-left:0}
}
</style>
</head>
<body>

<!-- Sidebar -->
<aside class="sidebar">
  <div class="sidebar-logo">
    <div class="sidebar-logo-mark">
      <svg viewBox="0 0 24 24"><path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"/></svg>
    </div>
    <div>
      <div class="sidebar-logo-text">EduPortal</div>
      <div class="sidebar-logo-sub">Admin Panel</div>
    </div>
  </div>

  <nav class="sidebar-nav">
    <div class="nav-section-label">Main</div>
    <a class="nav-item active" href="#">
      <svg viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/></svg>
      Dashboard
    </a>
    <a class="nav-item" href="#">
      <svg viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
      Students
    </a>
    <a class="nav-item" href="#">
      <svg viewBox="0 0 24 24"><path d="M22 10v6M2 10l10-5 10 5-10 5z"/><path d="M6 12v5c3 3 9 3 12 0v-5"/></svg>
      Courses
    </a>
    <a class="nav-item" href="#">
      <svg viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
      Reports
    </a>
    <div class="nav-section-label">Management</div>
    <a class="nav-item" href="#">
      <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="3"/><path d="M19.07 4.93a10 10 0 0 1 0 14.14"/><path d="M4.93 4.93a10 10 0 0 0 0 14.14"/></svg>
      Settings
    </a>
    <a class="nav-item" href="#">
      <svg viewBox="0 0 24 24"><path d="M18 20V10M12 20V4M6 20v-6"/></svg>
      Analytics
    </a>
  </nav>

  <div class="sidebar-user">
    <div class="user-avatar"><%= username.substring(0,1).toUpperCase() %></div>
    <div>
      <div class="user-name"><%= username %></div>
      <div class="user-role">Administrator</div>
    </div>
    <a class="logout-btn" href="adminDashboard.jsp?action=logout" title="Logout">
      <svg viewBox="0 0 24 24"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
    </a>
  </div>
</aside>

<!-- Main -->
<main class="main">
  <div class="topbar">
    <div>
      <div class="topbar-title">Admin Dashboard</div>
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

    <!-- Stats -->
    <div class="stats-grid">
      <div class="stat-card orange">
        <div class="stat-icon"><svg viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg></div>
        <div class="stat-val">2,418</div>
        <div class="stat-label">Total Students</div>
        <span class="stat-change up">▲ 12% this month</span>
      </div>
      <div class="stat-card blue">
        <div class="stat-icon"><svg viewBox="0 0 24 24"><path d="M22 10v6M2 10l10-5 10 5-10 5z"/><path d="M6 12v5c3 3 9 3 12 0v-5"/></svg></div>
        <div class="stat-val">184</div>
        <div class="stat-label">Active Courses</div>
        <span class="stat-change up">▲ 5% this month</span>
      </div>
      <div class="stat-card green">
        <div class="stat-icon"><svg viewBox="0 0 24 24"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg></div>
        <div class="stat-val">91%</div>
        <div class="stat-label">Pass Rate</div>
        <span class="stat-change up">▲ 3% vs last term</span>
      </div>
      <div class="stat-card yellow">
        <div class="stat-icon"><svg viewBox="0 0 24 24"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg></div>
        <div class="stat-val">48</div>
        <div class="stat-label">Faculty Members</div>
        <span class="stat-change down">▼ 2 on leave</span>
      </div>
    </div>

    <!-- Table + Activity -->
    <div class="row-2">
      <div class="section-card">
        <div class="section-header">
          <span class="section-title">Recent Enrollments</span>
          <a class="section-action" href="#">View All</a>
        </div>
        <table>
          <thead><tr>
            <th>Student</th><th>Course</th><th>Date</th><th>Status</th>
          </tr></thead>
          <tbody>
            <tr>
              <td><div class="avatar-cell"><div class="t-avatar" style="background:rgba(79,142,247,.15);color:#4F8EF7">PR</div><div><div class="t-name">Priya Rajan</div><div class="t-sub">ID #2401</div></div></div></td>
              <td>Data Structures</td><td>Mar 08</td>
              <td><span class="badge-status active">Active</span></td>
            </tr>
            <tr>
              <td><div class="avatar-cell"><div class="t-avatar" style="background:rgba(56,217,169,.15);color:#38D9A9">AM</div><div><div class="t-name">Arjun Mehta</div><div class="t-sub">ID #2402</div></div></div></td>
              <td>Web Development</td><td>Mar 07</td>
              <td><span class="badge-status pending">Pending</span></td>
            </tr>
            <tr>
              <td><div class="avatar-cell"><div class="t-avatar" style="background:rgba(249,115,22,.15);color:#F97316">SK</div><div><div class="t-name">Sneha Kumar</div><div class="t-sub">ID #2403</div></div></div></td>
              <td>Machine Learning</td><td>Mar 06</td>
              <td><span class="badge-status active">Active</span></td>
            </tr>
            <tr>
              <td><div class="avatar-cell"><div class="t-avatar" style="background:rgba(246,201,14,.15);color:#F6C90E">RD</div><div><div class="t-name">Rohit Das</div><div class="t-sub">ID #2404</div></div></div></td>
              <td>Database Systems</td><td>Mar 05</td>
              <td><span class="badge-status inactive">Inactive</span></td>
            </tr>
            <tr>
              <td><div class="avatar-cell"><div class="t-avatar" style="background:rgba(79,142,247,.15);color:#4F8EF7">NP</div><div><div class="t-name">Nisha Patel</div><div class="t-sub">ID #2405</div></div></div></td>
              <td>Cloud Computing</td><td>Mar 04</td>
              <td><span class="badge-status active">Active</span></td>
            </tr>
          </tbody>
        </table>
      </div>

      <div class="section-card">
        <div class="section-header"><span class="section-title">Recent Activity</span></div>
        <div class="activity-list">
          <div class="activity-item">
            <div class="act-dot blue"><svg viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg></div>
            <div><div class="act-text">New student <b>Priya Rajan</b> enrolled in Data Structures</div><div class="act-time">2 hours ago</div></div>
          </div>
          <div class="activity-item">
            <div class="act-dot green"><svg viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg></div>
            <div><div class="act-text">Assignment submitted for <b>Web Dev</b> by 24 students</div><div class="act-time">4 hours ago</div></div>
          </div>
          <div class="activity-item">
            <div class="act-dot orange"><svg viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg></div>
            <div><div class="act-text">Course <b>ML Fundamentals</b> updated with new module</div><div class="act-time">Yesterday</div></div>
          </div>
          <div class="activity-item">
            <div class="act-dot red"><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><circle cx="12" cy="16" r=".5" fill="currentColor"/></svg></div>
            <div><div class="act-text">Exam scheduled for <b>Database Systems</b> on Mar 15</div><div class="act-time">Yesterday</div></div>
          </div>
          <div class="activity-item">
            <div class="act-dot blue"><svg viewBox="0 0 24 24"><path d="M18 20V10M12 20V4M6 20v-6"/></svg></div>
            <div><div class="act-text">Monthly analytics report generated successfully</div><div class="act-time">2 days ago</div></div>
          </div>
        </div>
      </div>
    </div>

    <!-- Courses + Quick Actions -->
    <div class="row-3">
      <div class="section-card">
        <div class="section-header"><span class="section-title">Course Completion</span></div>
        <div class="course-item">
          <div class="course-row"><span class="course-name">Data Structures</span><span class="course-pct">78%</span></div>
          <div class="progress-bar"><div class="progress-fill" style="width:78%;background:var(--blue)"></div></div>
        </div>
        <div class="course-item">
          <div class="course-row"><span class="course-name">Web Development</span><span class="course-pct">65%</span></div>
          <div class="progress-bar"><div class="progress-fill" style="width:65%;background:var(--green)"></div></div>
        </div>
        <div class="course-item">
          <div class="course-row"><span class="course-name">Machine Learning</span><span class="course-pct">45%</span></div>
          <div class="progress-bar"><div class="progress-fill" style="width:45%;background:var(--accent)"></div></div>
        </div>
        <div class="course-item">
          <div class="course-row"><span class="course-name">Cloud Computing</span><span class="course-pct">88%</span></div>
          <div class="progress-bar"><div class="progress-fill" style="width:88%;background:var(--yellow)"></div></div>
        </div>
      </div>

      <div class="section-card">
        <div class="section-header"><span class="section-title">Quick Actions</span></div>
        <div class="qa-grid">
          <a class="qa-btn" href="#">
            <svg viewBox="0 0 24 24"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><line x1="19" y1="8" x2="19" y2="14"/><line x1="22" y1="11" x2="16" y2="11"/></svg>
            <span>Add Student</span>
          </a>
          <a class="qa-btn" href="#">
            <svg viewBox="0 0 24 24"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
            <span>New Course</span>
          </a>
          <a class="qa-btn" href="#">
            <svg viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
            <span>Generate Report</span>
          </a>
          <a class="qa-btn" href="#">
            <svg viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
            <span>Schedule Exam</span>
          </a>
        </div>
      </div>

      <div class="section-card">
        <div class="section-header"><span class="section-title">Department Stats</span></div>
        <table>
          <thead><tr><th>Dept</th><th>Students</th><th>Rate</th></tr></thead>
          <tbody>
            <tr><td>Computer Sci.</td><td>680</td><td><span style="color:var(--green)">94%</span></td></tr>
            <tr><td>Electronics</td><td>540</td><td><span style="color:var(--green)">89%</span></td></tr>
            <tr><td>Mathematics</td><td>310</td><td><span style="color:var(--yellow)">76%</span></td></tr>
            <tr><td>Physics</td><td>275</td><td><span style="color:var(--yellow)">81%</span></td></tr>
            <tr><td>Civil Engg.</td><td>420</td><td><span style="color:var(--red)">68%</span></td></tr>
          </tbody>
        </table>
      </div>
    </div>

  </div>
</main>

<script>
const d=new Date();
document.getElementById('dateStr').textContent=d.toLocaleDateString('en-US',{weekday:'long',year:'numeric',month:'long',day:'numeric'});
</script>
</body>
</html>
