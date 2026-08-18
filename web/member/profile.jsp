<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Profile - PowerFit Gym</title>
    <link rel="stylesheet" href="../style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>

<%@ include file="../header.jsp" %>

<section class="profile-section">
    <div class="profile-container">

        <% if ("1".equals(request.getParameter("updated"))) { %>
            <div class="alert-success">
                <i class="fas fa-check-circle"></i> Profile updated successfully!
            </div>
        <% } %>

        <div class="profile-header">
            <div class="profile-avatar">
                <i class="fas fa-user-circle"></i>
            </div>
            <div class="profile-title">
                <h2>${name}</h2>
                <p><i class="fas fa-envelope"></i> ${email} &nbsp;|&nbsp; <i class="fas fa-phone"></i> ${mobile}</p>
                <span class="badge ${'Active'.equals(membershipStatus) ? 'badge-active' : 'badge-expired'}">
                    ${membershipStatus} Member
                </span>
            </div>

        </div>

        <div class="profile-grid">
            <!-- Personal Information -->
            <div class="profile-card">
                <h3><i class="fas fa-id-card"></i> Personal Information</h3>
                <table class="info-table">
                    <tr><th>Full Name:</th><td>${name}</td></tr>
                    <tr><th>Gender:</th><td>${gender}</td></tr>
                    <tr><th>Date of Birth:</th><td>${dob}</td></tr>
                    <tr><th>Age:</th><td>${age} Years</td></tr>
                    <tr><th>Address:</th><td>${address}</td></tr>
                </table>
            </div>

            <!-- Health & Fitness -->
            <div class="profile-card">
                <h3><i class="fas fa-heartbeat"></i> Health &amp; Physical Stats</h3>
                <table class="info-table">
                    <tr><th>Height:</th><td>${height} cm</td></tr>
                    <tr><th>Weight:</th><td>${weight} kg</td></tr>
                    <tr><th>BMI Score:</th><td><strong>${bmiValue}</strong></td></tr>
                </table>
                <div class="profile-sub-actions">
                    <a href="${pageContext.request.contextPath}/member/BMI" class="btn-link">
                        <i class="fas fa-calculator"></i> Calculate / Update BMI
                    </a>
                </div>
            </div>

            <!-- Membership Details -->
            <div class="profile-card full-width">
                <h3><i class="fas fa-dumbbell"></i> Current Membership Plan</h3>
                <div class="plan-details-box">
                    <div class="plan-info">
                        <h4>${planName} Plan</h4>
                        <p>Duration: ${duration} Months | Price: &#8377;${fees}</p>
                    </div>
                    <div class="plan-dates">
                        <p><strong>Joined:</strong> ${joinDate}</p>
                        <p><strong>Expires:</strong> ${expiryDate}</p>
                    </div>
                </div>
            </div>
        </div>

        <div class="back-nav">
            <a href="${pageContext.request.contextPath}/member/Dashboard" class="btn btn2">
                <i class="fas fa-arrow-left"></i> Back to Dashboard
            </a>
        </div>

    </div>
</section>

<%@ include file="../footer.jsp" %>

</body>
</html>
