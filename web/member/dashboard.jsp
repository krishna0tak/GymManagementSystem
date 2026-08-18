<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Member Dashboard - PowerFit Gym</title>
    <link rel="stylesheet" href="../style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>

<%@ include file="../header.jsp" %>

<section class="dashboard-section">
    <div class="dashboard-container">

        <!-- Welcome -->
        <div class="welcome-box">
            <h1>Welcome, <span>${name}</span></h1>
            <p>Stay consistent. Stay Strong.</p>
        </div>

        <!-- Statistics Grid -->
        <div class="stats-grid">
            <div class="stat-card">
                <i class="fa-solid fa-dumbbell"></i>
                <h3>${planName}</h3>
                <p>Membership Plan</p>
            </div>

            <div class="stat-card">
                <i class="fa-solid fa-calendar-days"></i>
                <h3>${membershipStatus}</h3>
                <p>Status</p>
            </div>

            <div class="stat-card">
                <i class="fa-solid fa-weight-scale"></i>
                <h3>${bmiValue}</h3>
                <p>BMI</p>
            </div>

            <div class="stat-card">
                <i class="fa-solid fa-heart-pulse"></i>
                <h3>${bmiStatus}</h3>
                <p>Health</p>
            </div>
        </div>

        <!-- Membership Summary -->
        <div class="member-summary">
            <h2>Membership Details</h2>
            <table>
                <tr>
                    <th>Name</th>
                    <td>${name}</td>
                </tr>
                <tr>
                    <th>Email</th>
                    <td>${email}</td>
                </tr>
                <tr>
                    <th>Mobile</th>
                    <td>${mobile}</td>
                </tr>
                <tr>
                    <th>Gender</th>
                    <td>${gender}</td>
                </tr>
                <tr>
                    <th>Address</th>
                    <td>${address}</td>
                </tr>
                <tr>
                    <th>Membership</th>
                    <td>${planName}</td>
                </tr>
                <tr>
                    <th>Duration</th>
                    <td>${duration} Month(s)</td>
                </tr>
                <tr>
                    <th>Fees</th>
                    <td>&#8377;${fees}</td>
                </tr>
                <tr>
                    <th>Join Date</th>
                    <td>${joinDate}</td>
                </tr>
                <tr>
                    <th>Expiry Date</th>
                    <td>${expiryDate}</td>
                </tr>
                <tr>
                    <th>Status</th>
                    <td>
                        <% if ("Active".equals(request.getAttribute("membershipStatus"))) { %>
                            <span class="active-status">Active</span>
                        <% } else { %>
                            <span class="expired-status">${membershipStatus}</span>
                        <% } %>
                    </td>
                </tr>
            </table>
        </div>

        <!-- Dashboard Navigation Menu -->
        <div class="dashboard-menu">
            <a href="${pageContext.request.contextPath}/member/Profile" class="menu-card">
                <i class="fas fa-user"></i>
                <h3>My Profile</h3>
                <p>View your personal details.</p>
            </a>
            <a href="${pageContext.request.contextPath}/member/BMI" class="menu-card">
                <i class="fas fa-heartbeat"></i>
                <h3>BMI Calculator</h3>
                <p>Check &amp; record your BMI.</p>
            </a>

            <a href="${pageContext.request.contextPath}/member/Workout" class="menu-card">
                <i class="fas fa-dumbbell"></i>
                <h3>Workout Plans</h3>
                <p>Browse training routines.</p>
            </a>

            <a href="${pageContext.request.contextPath}/member/Logout" class="menu-card logout">
                <i class="fas fa-sign-out-alt"></i>
                <h3>Logout</h3>
                <p>Securely sign out.</p>
            </a>
        </div>

        <div class="dashboard-footer">
            <h3>Fitness Tip</h3>
            <p>Stay hydrated, eat enough protein, train consistently, and sleep at least 7&#8211;8 hours every day for maximum recovery.</p>
        </div>

    </div>
</section>

<%@ include file="../footer.jsp" %>

</body>
</html>