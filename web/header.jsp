<%@ page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String ctx = request.getContextPath();
    boolean isMemberLoggedIn = (session != null && session.getAttribute("member_id") != null);
    boolean isAdminLoggedIn  = (session != null && session.getAttribute("admin_user") != null);
%>

<link rel="stylesheet" href="<%=ctx%>/style.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<div class="navbar">

    <div class="logo">
        <a href="<%=ctx%>/index.jsp" style="color: inherit; text-decoration: none;">POWERFIT GYM</a>
    </div>

    <ul>
        <li><a href="<%=ctx%>/index.jsp"><i class="fas fa-home"></i> Home</a></li>
        <li><a href="<%=ctx%>/about.jsp"><i class="fas fa-info-circle"></i> About</a></li>

        <% if (isMemberLoggedIn) { %>
            <li><a href="<%=ctx%>/member/Dashboard"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
            <li><a href="<%=ctx%>/member/Profile"><i class="fas fa-user"></i> My Profile</a></li>
            <li><a href="<%=ctx%>/member/Logout" style="color: #ff6b6b;"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
        <% } else if (isAdminLoggedIn) { %>
            <li><a href="<%=ctx%>/AdminDashboard"><i class="fas fa-chart-line"></i> Admin Dashboard</a></li>
            <li><a href="<%=ctx%>/AdminLogout" style="color: #ff6b6b;"><i class="fas fa-sign-out-alt"></i> Admin Logout</a></li>
        <% } else { %>
            <li><a href="<%=ctx%>/register.jsp"><i class="fas fa-user-plus"></i> Register</a></li>
            <li><a href="<%=ctx%>/Login"><i class="fas fa-sign-in-alt"></i> Member Login</a></li>
            <li><a href="<%=ctx%>/AdminLogin"><i class="fas fa-user-shield"></i> Admin Login</a></li>
        <% } %>
    </ul>

</div>