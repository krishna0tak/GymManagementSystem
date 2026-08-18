<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="javax.crypto.*"%>
<%@ page import="javax.crypto.spec.SecretKeySpec"%>
<%@ page import="java.util.Base64"%>
<%@ page import="java.nio.charset.StandardCharsets"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="p1.dbcon" %>

<%@ include file="header.jsp" %>








<link rel="stylesheet" href="style.css">

<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<section class="register-section">

<div class="register-container">

<div class="register-image">

<img src="images/registration.jpg" alt="Gym Registration">

</div>

<div class="register-form">

<h2>Create Your Membership</h2>

<p>Become stronger than yesterday.</p>

<form action="Register"
method="post"
onsubmit="return validateForm();">

<!-- NAME -->

<input
type="text"
id="name"
name="name"
placeholder="Full Name"
maxlength="50"
required
onkeypress="return onlyLetters(event)">

<!-- GENDER -->

<div class="gender-box">

<label>
<input type="radio"
name="gender"
value="Male" required>
Male
</label>

<label>
<input type="radio"
name="gender"
value="Female">
Female
</label>

<label>
<input type="radio"
name="gender"
value="Other">
Other
</label>

</div>

<!-- DOB -->

<input
type="date"
id="dob"
name="dob"
required>

<!-- AGE -->

<input
type="number"
id="age"
name="age"
placeholder="Age"
readonly>

<!-- MOBILE -->

<input
type="text"
id="mobile"
name="mobile"
maxlength="10"
placeholder="Mobile Number"
required
onkeypress="return onlyNumber(event)">

<!-- EMAIL -->

<input
type="email"
id="email"
name="email"
placeholder="Email Address"
required>

<!-- PASSWORD -->

<div class="password-box">

<input
type="password"
id="password"
name="password"
placeholder="Password"
required>

<i
class="fa-solid fa-eye"
id="eye"
onclick="togglePassword()">
</i>

</div>

<div id="strength"></div>

<!-- ADDRESS -->

<textarea
id="address"
name="address"
rows="3"
placeholder="Address"
required>
</textarea>

<!-- HEIGHT -->

<input
type="number"
step="0.1"
min="100"
max="250"
id="height"
name="height"
placeholder="Height (cm)"
required>

<!-- WEIGHT -->

<input
type="number"
step="0.1"
min="20"
max="250"
id="weight"
name="weight"
placeholder="Weight (kg)"
required>

<!-- PLAN -->

<select
id="plan"
name="plan"
required>

<option value="">Select Membership</option>

<option value="1">Basic</option>

<option value="2">Standard</option>

<option value="3">Premium</option>

</select>

<button
type="submit"
name="register">
Register
</button>

</form>

<p class="login-link">

Already a Member?

<a href="login.jsp">
Login Here
</a>

</p>

</div>

</div>

</section>



<script>

window.onload=function(){

// Maximum DOB = Today

document.getElementById("dob").max=
new Date().toISOString().split("T")[0];

// Calculate Age

document.getElementById("dob").addEventListener("change",function(){

let dob=new Date(this.value);

let today=new Date();

let age=today.getFullYear()-dob.getFullYear();

let m=today.getMonth()-dob.getMonth();

if(m<0 || (m==0 && today.getDate()<dob.getDate()))
age--;

document.getElementById("age").value=age;

});

// Password Strength

document.getElementById("password").onkeyup=function(){

let p=this.value;

let s=document.getElementById("strength");

if(p.length<8){

s.innerHTML="Weak";

s.style.color="red";

}

else if(/(?=.*[A-Z])(?=.*\d)/.test(p)){

s.innerHTML="Medium";

s.style.color="orange";

}

if(/(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&#])/.test(p)){

s.innerHTML="Strong";

s.style.color="green";

}

};

}

// Only Letters

function onlyLetters(e){

let ch=String.fromCharCode(e.which);

return /^[A-Za-z ]+$/.test(ch);

}

// Only Numbers

function onlyNumber(e){

let ch=e.which;

return ch>=48 && ch<=57;

}

// Show Password

function togglePassword(){

let pass=document.getElementById("password");

let eye=document.getElementById("eye");

if(pass.type=="password"){

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

function validateForm(){

let age=document.getElementById("age").value;

let mobile=document.getElementById("mobile").value;

let password=document.getElementById("password").value;

let address=document.getElementById("address").value.trim();

let height=document.getElementById("height").value;

let weight=document.getElementById("weight").value;

let plan=document.getElementById("plan").value;

if(age<16 || age>70){

alert("Age should be between 16 and 70");

return false;

}

if(!/^[6-9][0-9]{9}$/.test(mobile)){

alert("Mobile number must start with 6-9.");

return false;

}

if(password.length<8){

alert("Password must contain minimum 8 characters.");

return false;

}

if(!/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&#]).{8,}$/.test(password)){

alert("Password must contain uppercase, lowercase, number and special character.");

return false;

}

if(address.length<5){

alert("Enter valid address.");

return false;

}

if(height<100 || height>250){

alert("Enter valid height.");

return false;

}

if(weight<20 || weight>250){

alert("Enter valid weight.");

return false;

}

if(plan==""){

alert("Select Membership Plan.");

return false;

}

return true;

}

</script>

<%@ include file="footer.jsp" %>