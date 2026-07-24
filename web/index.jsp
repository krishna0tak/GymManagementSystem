<%@ page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>PowerFit Gym</title>

<link rel="stylesheet" href="style.css">

</head>

<body>

<%@ include file="header.jsp" %>

<section class="hero">

    <div class="hero-content">

        <h1>TRANSFORM YOUR BODY</h1>

        <p>Train Hard • Stay Strong • Stay Healthy</p>

        <a href="register.jsp" class="btn">Join Now</a>

        <a href="about.jsp" class="btn btn2">Learn More</a>

    </div>

</section>

<section class="about-home">

    <h2>About PowerFit Gym</h2>

    <p>

        PowerFit Gym provides modern fitness equipment, experienced trainers,
        flexible membership plans and a motivating environment to help you
        achieve your fitness goals.

    </p>

</section>

<section class="features">

    <h2>Why Choose Us</h2>

    <div class="feature-container">

        <div class="feature-card">

            <h3>🏋 Modern Equipment</h3>

            <p>Latest machines for every workout.</p>

        </div>

        <div class="feature-card">

            <h3>👨‍🏫 Certified Trainers</h3>

            <p>Professional guidance and support.</p>

        </div>

        <div class="feature-card">

            <h3>🥗 Diet Plans</h3>

            <p>Customized nutrition guidance.</p>

        </div>

        <div class="feature-card">

            <h3>⏰ Flexible Timings</h3>

            <p>Morning and evening batches.</p>

        </div>

    </div>

</section>

<section class="plans">

<h2>Membership Plans</h2>

<div class="plan-container">

<div class="plan-card">

<h3>Basic</h3>

<p>₹999 / Month</p>

<p>Gym Access</p>

<a href="register.jsp" class="btn">Join</a>

</div>

<div class="plan-card">

<h3>Standard</h3>

<p>₹1499 / Month</p>

<p>Gym + Cardio</p>

<a href="register.jsp" class="btn">Join</a>

</div>

<div class="plan-card">

<h3>Premium</h3>

<p>₹2499 / Month</p>

<p>All Facilities</p>

<a href="register.jsp" class="btn">Join</a>

</div>

</div>

</section>

<%@ include file="footer.jsp" %>

</body>

</html>