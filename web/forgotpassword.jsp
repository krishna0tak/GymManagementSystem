<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Forgot Password - PowerFit Gym</title>
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>

<%@ include file="header.jsp" %>

<section class="login-section">
    <div class="login-container">

        <!-- Left Image -->
        <div class="login-image">
            <img src="images/login.jpg" alt="Forgot Password">
        </div>

        <!-- Right Form -->
        <div class="login-form">
            <h2><i class="fas fa-key"></i> Forgot Password</h2>
            <p>Enter your registered email address and we'll send you a new password.</p>

            <form action="${pageContext.request.contextPath}/ForgotPassword" method="post" onsubmit="return validateEmailForm();">

                <!-- EMAIL -->
                <div class="input-box">
                    <i class="fa-solid fa-envelope"></i>
                    <input type="email" id="email" name="email" placeholder="Registered Email Address" required>
                </div>

                <!-- BUTTON -->
                <button type="submit" name="forgot">
                    <i class="fa-solid fa-paper-plane"></i> Send New Password
                </button>

            </form>

            <!-- SUCCESS MESSAGE -->
            <% if (request.getAttribute("successMsg") != null) { %>
                <div class="alert-success" style="margin-top: 20px;">
                    <i class="fas fa-check-circle"></i> ${successMsg}
                </div>
            <% } %>

            <!-- ERROR MESSAGE -->
            <% if (request.getAttribute("errorMsg") != null) { %>
                <div class="message error-msg">
                    ${errorMsg}
                </div>
            <% } %>

            <!-- BACK TO LOGIN -->
            <p class="register-link">
                Remembered your password?
                <a href="${pageContext.request.contextPath}/Login">Login Here</a>
            </p>

        </div>

    </div>
</section>

<script>
function validateEmailForm() {
    var email = document.getElementById("email").value.trim();
    var emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[A-Za-z]{2,}$/;
    if (email === "") {
        alert("Please enter your registered email address.");
        return false;
    }
    if (!emailPattern.test(email)) {
        alert("Please enter a valid email address.");
        return false;
    }
    return true;
}
</script>

<%@ include file="footer.jsp" %>

</body>
</html>
