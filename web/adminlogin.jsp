<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Login - PowerFit Gym</title>
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>

<%@ include file="header.jsp" %>

<section class="login-section">
    <div class="login-container">

        <div class="login-image">
            <img src="images/login.jpg" alt="Admin Access">
        </div>

        <div class="login-form">
            <h2><i class="fas fa-user-shield"></i> Admin Portal</h2>
            <p>Authorized administration access only.</p>

            <%-- Show logout confirmation --%>
            <% if ("1".equals(request.getParameter("logout"))) { %>
                <div class="alert-success">
                    <i class="fas fa-sign-out-alt"></i>
                    Admin logged out successfully.
                </div>
            <% } %>

            <form action="${pageContext.request.contextPath}/AdminLogin"
                  method="post"
                  onsubmit="return validateAdmin();">

                <div class="input-box">
                    <i class="fa-solid fa-user-gear"></i>
                    <input type="text" id="username" name="username"
                           placeholder="Admin Username" required>
                </div>

                <div class="input-box password-box">
                    <i class="fa-solid fa-lock"></i>
                    <input type="password" id="password" name="password"
                           placeholder="Password" required>
                    <i class="fa-solid fa-eye" id="eye" onclick="togglePassword()"></i>
                </div>

                <button type="submit" name="admin_login" class="btn btn-admin">
                    <i class="fa-solid fa-right-to-bracket"></i> Login to Admin Console
                </button>

            </form>

            <% if (request.getAttribute("error") != null) { %>
                <div class="message error-msg">
                    ${error}
                </div>
            <% } %>
        </div>

    </div>
</section>

<script>
function togglePassword(){
    var pass = document.getElementById("password");
    var eye  = document.getElementById("eye");
    if(pass.type === "password"){
        pass.type = "text";
        eye.classList.remove("fa-eye");
        eye.classList.add("fa-eye-slash");
    } else {
        pass.type = "password";
        eye.classList.remove("fa-eye-slash");
        eye.classList.add("fa-eye");
    }
}
function validateAdmin(){
    var u = document.getElementById("username").value.trim();
    var p = document.getElementById("password").value.trim();
    if(u === "" || p === ""){
        alert("Please fill in both Username and Password.");
        return false;
    }
    return true;
}
</script>

<%@ include file="footer.jsp" %>

</body>
</html>
