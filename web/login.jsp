<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>

<link rel="stylesheet" href="style.css">
<link rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<section class="login-section">

<div class="login-container">

    <!-- Left Image -->

    <div class="login-image">

        <img src="images/login.jpg" alt="Gym Login">

    </div>

    <!-- Right Form -->

    <div class="login-form">

        <h2>Member Login</h2>

        <p>Welcome back! Continue your fitness journey.</p>

        <%-- Show success message after registration --%>
        <% if ("1".equals(request.getParameter("success"))) { %>
            <div class="alert-success">
                <i class="fas fa-check-circle"></i>
                Registration successful! Please login.
            </div>
        <% } %>

        <%-- Show logout confirmation --%>
        <% if ("1".equals(request.getParameter("logout"))) { %>
            <div class="alert-success">
                <i class="fas fa-sign-out-alt"></i>
                You have been logged out successfully.
            </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/Login"
              method="post"
              onsubmit="return validateLogin();">

            <!-- EMAIL -->

            <div class="input-box">

                <i class="fa-solid fa-envelope"></i>

                <input
                    type="email"
                    id="email"
                    name="email"
                    placeholder="Email Address"
                    required>

            </div>

            <!-- PASSWORD -->

            <div class="input-box password-box">

                <i class="fa-solid fa-lock"></i>

                <input
                    type="password"
                    id="password"
                    name="password"
                    placeholder="Password"
                    required>

                <i class="fa-solid fa-eye"
                   id="eye"
                   onclick="togglePassword()"></i>

            </div>

            <!-- REMEMBER -->

            <div class="login-options">

                <label>

                    <input
                        type="checkbox"
                        name="remember">

                    Remember Me

                </label>

                <a href="${pageContext.request.contextPath}/ForgotPassword">

                    Forgot Password?

                </a>

            </div>

            <!-- BUTTON -->

            <button
                type="submit"
                name="login">

                <i class="fa-solid fa-right-to-bracket"></i>

                Login

            </button>

        </form>

        <!-- ERROR MESSAGE -->

        <% if (request.getAttribute("error") != null) { %>

        <div class="message">

            ${error}

        </div>

        <% } %>

        <!-- REGISTER -->

        <p class="register-link">

            New Member?

            <a href="${pageContext.request.contextPath}/register.jsp">

                Register Here

            </a>

        </p>

    </div>

</div>

</section>

<script>

// ==============================
// Show / Hide Password
// ==============================

function togglePassword(){

    var pass=document.getElementById("password");

    var eye=document.getElementById("eye");

    if(pass.type==="password"){

        pass.type="text";

        eye.classList.remove("fa-eye");

        eye.classList.add("fa-eye-slash");

    }

    else{

        pass.type="password";

        eye.classList.remove("fa-eye-slash");

        eye.classList.add("fa-eye");

    }

}

// ==============================
// Login Validation
// ==============================

function validateLogin(){

    var email=document.getElementById("email").value.trim();

    var password=document.getElementById("password").value;

    // Email

    var emailPattern=/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[A-Za-z]{2,}$/;

    if(email===""){

        alert("Please enter Email.");

        return false;

    }

    if(!emailPattern.test(email)){

        alert("Enter a valid Email Address.");

        return false;

    }

    // Password

    if(password===""){

        alert("Please enter Password.");

        return false;

    }

    if(password.length<8){

        alert("Password should be at least 8 characters.");

        return false;

    }

    return true;

}

// ==============================
// Enter Key Support
// ==============================

document.addEventListener("keypress",function(e){

    if(e.key==="Enter"){

        var form=document.querySelector("form");

        if(form){

            form.requestSubmit();

        }

    }

});

// ==============================
// Focus on Email
// ==============================

window.onload=function(){

    document.getElementById("email").focus();

};

</script>
<%@ include file="footer.jsp" %>