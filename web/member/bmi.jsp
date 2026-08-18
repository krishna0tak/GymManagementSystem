<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>BMI Calculator - PowerFit Gym</title>
    <link rel="stylesheet" href="../style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>

<%@ include file="../header.jsp" %>

<section class="bmi-section">
    <div class="bmi-container">

        <div class="bmi-header">
            <h2><i class="fas fa-heartbeat"></i> Body Mass Index (BMI) Calculator</h2>
            <p>Calculate your BMI to track your physical health and target ideal weight ranges.</p>
        </div>

        <%-- Flash messages from PRG redirect --%>
        <% if ("1".equals(request.getParameter("saved"))) { %>
            <div class="alert-success">
                <i class="fas fa-check-circle"></i> Height &amp; weight saved to your profile successfully!
            </div>
        <% } else if ("0".equals(request.getParameter("saved"))) { %>
            <div class="message error-msg">
                <i class="fas fa-exclamation-circle"></i> Failed to save stats. Please try again.
            </div>
        <% } %>

        <div class="bmi-grid">

            <!-- Calculator Form -->
            <div class="bmi-card">
                <h3><i class="fas fa-calculator"></i> Calculate BMI</h3>
                <form action="${pageContext.request.contextPath}/member/BMI"
                      method="post" id="bmiForm">

                    <div class="form-group">
                        <label for="height">Height (in cm)</label>
                        <input type="number" id="height" name="height"
                               step="0.1" value="${height}"
                               min="100" max="250" required
                               oninput="calculateBMI()">
                    </div>

                    <div class="form-group">
                        <label for="weight">Weight (in kg)</label>
                        <input type="number" id="weight" name="weight"
                               step="0.1" value="${weight}"
                               min="20" max="250" required
                               oninput="calculateBMI()">
                    </div>

                    <div class="form-actions">
                        <button type="submit" name="save_stats" class="btn">
                            <i class="fas fa-save"></i> Save to Profile
                        </button>
                    </div>
                </form>
            </div>

            <!-- BMI Result Card -->
            <div class="bmi-card result-card">
                <h3><i class="fas fa-chart-line"></i> Your Results</h3>
                <div class="bmi-score-box">
                    <span id="bmiScore">${bmiFormatted}</span>
                    <p id="bmiCategory">Calculating...</p>
                </div>

                <!-- Visual Category Gauge -->
                <div class="bmi-gauge">
                    <div class="gauge-bar underweight" id="barUnder">Underweight (&lt;18.5)</div>
                    <div class="gauge-bar normal"      id="barNormal">Normal (18.5-24.9)</div>
                    <div class="gauge-bar overweight"  id="barOver">Overweight (25-29.9)</div>
                    <div class="gauge-bar obese"       id="barObese">Obese (&ge;30)</div>
                </div>

                <div class="bmi-recommendation" id="recommendationText">
                    <!-- Recommendation injected via JS -->
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

<script>
function calculateBMI() {
    let h = parseFloat(document.getElementById("height").value);
    let w = parseFloat(document.getElementById("weight").value);
    let scoreEl    = document.getElementById("bmiScore");
    let categoryEl = document.getElementById("bmiCategory");
    let recEl      = document.getElementById("recommendationText");

    // Reset gauge highlights
    document.querySelectorAll(".gauge-bar").forEach(el => el.classList.remove("active"));

    if (isNaN(h) || isNaN(w) || h <= 0 || w <= 0) {
        scoreEl.innerText    = "0.0";
        categoryEl.innerText = "Enter height & weight";
        recEl.innerHTML      = "";
        return;
    }

    let meter = h / 100;
    let bmi   = w / (meter * meter);
    scoreEl.innerText = bmi.toFixed(1);

    if (bmi < 18.5) {
        categoryEl.innerText  = "Underweight";
        categoryEl.style.color = "#3b82f6";
        document.getElementById("barUnder").classList.add("active");
        recEl.innerHTML = "<p><strong>Recommendation:</strong> Focus on nutrient-dense calorie surplus, lean protein intake, and progressive strength training to gain healthy muscle mass.</p>";
    } else if (bmi < 25) {
        categoryEl.innerText  = "Normal / Healthy Weight";
        categoryEl.style.color = "#10b981";
        document.getElementById("barNormal").classList.add("active");
        recEl.innerHTML = "<p><strong>Recommendation:</strong> Excellent! Maintain a balanced diet, stay hydrated (3+ liters/day), and follow regular strength &amp; cardio workouts.</p>";
    } else if (bmi < 30) {
        categoryEl.innerText  = "Overweight";
        categoryEl.style.color = "#f59e0b";
        document.getElementById("barOver").classList.add("active");
        recEl.innerHTML = "<p><strong>Recommendation:</strong> Incorporate high-intensity interval cardio, moderate calorie deficit, and compound weight lifting 4-5 times a week.</p>";
    } else {
        categoryEl.innerText  = "Obese";
        categoryEl.style.color = "#ef4444";
        document.getElementById("barObese").classList.add("active");
        recEl.innerHTML = "<p><strong>Recommendation:</strong> Consult our head trainer for a structured fat-loss plan, focus on consistent daily walks, cardio, and calorie control.</p>";
    }
}

window.onload = function() {
    calculateBMI();
};
</script>

<%@ include file="../footer.jsp" %>

</body>
</html>
