<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="p1.AdminDashboardServlet.MemberItem"%>
<%@page import="p1.AdminDashboardServlet.PlanItem"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - PowerFit Gym</title>
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>

<%
    String adminUser = (String) session.getAttribute("admin_user");

    // Flash messages from PRG redirect
    String msgParam = request.getParameter("msg");
    String errParam = request.getParameter("err");
    String flashMsg = "";
    String flashErr = "";
    if ("deleted".equals(msgParam))    flashMsg = "Member deleted successfully!";
    if ("plan_added".equals(msgParam)) flashMsg = "New membership plan added successfully!";
    if ("1".equals(errParam))          flashErr = "An error occurred. Please try again.";

    // Cast lists from servlet
    @SuppressWarnings("unchecked")
    List<MemberItem> memberList = (List<MemberItem>) request.getAttribute("memberList");
    @SuppressWarnings("unchecked")
    List<PlanItem> planList = (List<PlanItem>) request.getAttribute("planList");

    int totalMembers   = (Integer) (request.getAttribute("totalMembers")   != null ? request.getAttribute("totalMembers")   : 0);
    int activeMembers  = (Integer) (request.getAttribute("activeMembers")  != null ? request.getAttribute("activeMembers")  : 0);
    int expiredMembers = (Integer) (request.getAttribute("expiredMembers") != null ? request.getAttribute("expiredMembers") : 0);
    int totalPlans     = (Integer) (request.getAttribute("totalPlans")     != null ? request.getAttribute("totalPlans")     : 0);
%>

<div class="navbar">
    <div class="logo">
        POWERFIT GYM <span style="font-size:14px;color:#fff;font-weight:normal;background:#E63946;padding:2px 8px;border-radius:4px;margin-left:10px;">ADMIN</span>
    </div>
    <ul>
        <li><a href="${pageContext.request.contextPath}/AdminDashboard"><i class="fas fa-chart-line"></i> Dashboard</a></li>
        <li><a href="${pageContext.request.contextPath}/index.jsp" target="_blank"><i class="fas fa-globe"></i> Visit Site</a></li>
        <li><a href="${pageContext.request.contextPath}/AdminLogout" style="color:#ff4d4d;"><i class="fas fa-sign-out-alt"></i> Logout (<%=adminUser%>)</a></li>
    </ul>
</div>

<section class="admin-section">
    <div class="admin-container">

        <div class="admin-welcome">
            <h2>Welcome back, <span><%=adminUser%></span></h2>
            <p>PowerFit Gym Management &amp; Analytics Console</p>
        </div>

        <% if (!flashMsg.isEmpty()) { %>
            <div class="alert-success">
                <i class="fas fa-check-circle"></i> <%=flashMsg%>
            </div>
        <% } %>
        <% if (!flashErr.isEmpty()) { %>
            <div class="alert-warning">
                <i class="fas fa-exclamation-triangle"></i> <%=flashErr%>
            </div>
        <% } %>

        <!-- Stats Overview -->
        <div class="admin-stats-grid">
            <div class="admin-stat-card card-blue">
                <i class="fas fa-users"></i>
                <div class="stat-info">
                    <h3><%=totalMembers%></h3>
                    <p>Total Members</p>
                </div>
            </div>

            <div class="admin-stat-card card-green">
                <i class="fas fa-user-check"></i>
                <div class="stat-info">
                    <h3><%=activeMembers%></h3>
                    <p>Active Memberships</p>
                </div>
            </div>

            <div class="admin-stat-card card-red">
                <i class="fas fa-user-clock"></i>
                <div class="stat-info">
                    <h3><%=expiredMembers%></h3>
                    <p>Expired Memberships</p>
                </div>
            </div>

            <div class="admin-stat-card card-gold">
                <i class="fas fa-layer-group"></i>
                <div class="stat-info">
                    <h3><%=totalPlans%></h3>
                    <p>Membership Plans</p>
                </div>
            </div>
        </div>

        <!-- Section 1: Member Management -->
        <div class="admin-card">
            <div class="card-title-bar">
                <h3><i class="fas fa-users-cog"></i> Registered Gym Members</h3>
                <div class="search-box">
                    <i class="fas fa-search"></i>
                    <input type="text" id="memberSearch"
                           placeholder="Search members by name, email..."
                           onkeyup="filterMembers()">
                </div>
            </div>

            <% if (memberList == null || memberList.isEmpty()) { %>
                <p class="no-records">No registered members found in database.</p>
            <% } else { %>
                <div class="table-responsive">
                    <table class="admin-table" id="membersTable">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Name</th>
                                <th>Contact</th>
                                <th>Gender</th>
                                <th>Plan</th>
                                <th>Join Date</th>
                                <th>Expiry Date</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (MemberItem m : memberList) { %>
                                <tr>
                                    <td>#<%=m.id%></td>
                                    <td><strong><%=m.name%></strong></td>
                                    <td>
                                        <div><i class="fas fa-envelope"></i> <%=m.email%></div>
                                        <div><i class="fas fa-phone"></i> <%=m.mobile%></div>
                                    </td>
                                    <td><%=m.gender%></td>
                                    <td><span class="plan-tag"><%=m.planName%></span></td>
                                    <td><%=m.joinDate != null ? m.joinDate : "N/A"%></td>
                                    <td><%=m.expiryDate != null ? m.expiryDate : "N/A"%></td>
                                    <td>
                                        <% if ("Active".equals(m.status)) { %>
                                            <span class="active-status">Active</span>
                                        <% } else { %>
                                            <span class="expired-status">Expired</span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <form action="${pageContext.request.contextPath}/AdminDashboard"
                                              method="post"
                                              style="display:inline;"
                                              onsubmit="return confirm('Are you sure you want to delete member <%=m.name%>?');">
                                            <input type="hidden" name="delete_member" value="<%=m.id%>">
                                            <button type="submit" class="btn-delete">
                                                <i class="fas fa-trash-alt"></i> Delete
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } %>
        </div>

        <!-- Section 2: Membership Plans Management -->
        <div class="admin-grid-2">

            <div class="admin-card">
                <h3><i class="fas fa-list-alt"></i> Active Membership Plans</h3>
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>Plan ID</th>
                            <th>Plan Name</th>
                            <th>Duration</th>
                            <th>Fees</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (planList != null) { for (PlanItem p : planList) { %>
                            <tr>
                                <td>#<%=p.id%></td>
                                <td><strong><%=p.name%></strong></td>
                                <td><%=p.duration%> Month(s)</td>
                                <td>&#8377;<%=p.fees%></td>
                            </tr>
                        <% } } %>
                    </tbody>
                </table>
            </div>

            <div class="admin-card">
                <h3><i class="fas fa-plus-circle"></i> Add New Membership Plan</h3>
                <form action="${pageContext.request.contextPath}/AdminDashboard"
                      method="post"
                      class="admin-form">
                    <div class="form-group">
                        <label for="plan_name">Plan Name</label>
                        <input type="text" id="plan_name" name="plan_name"
                               placeholder="e.g. VIP Yearly" required>
                    </div>

                    <div class="form-group">
                        <label for="duration_months">Duration (Months)</label>
                        <input type="number" id="duration_months" name="duration_months"
                               min="1" max="60" placeholder="e.g. 6" required>
                    </div>

                    <div class="form-group">
                        <label for="fees">Fees (&#8377;)</label>
                        <input type="number" step="0.1" id="fees" name="fees"
                               min="0" placeholder="e.g. 2999" required>
                    </div>

                    <button type="submit" name="add_plan" class="btn">
                        <i class="fas fa-plus"></i> Create Membership Plan
                    </button>
                </form>
            </div>

        </div>

    </div>
</section>

<script>
function filterMembers() {
    let input = document.getElementById("memberSearch").value.toLowerCase();
    let table = document.getElementById("membersTable");
    if (!table) return;
    let rows = table.getElementsByTagName("tr");

    for (let i = 1; i < rows.length; i++) {
        let rowText = rows[i].innerText.toLowerCase();
        rows[i].style.display = rowText.includes(input) ? "" : "none";
    }
}
</script>

<%@ include file="footer.jsp" %>

</body>
</html>
