<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Workout Plans - PowerFit Gym</title>
    <link rel="stylesheet" href="../style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>

<%@ include file="../header.jsp" %>

<section class="workout-section">
    <div class="workout-container">

        <div class="workout-header">
            <h2><i class="fas fa-dumbbell"></i> Custom Workout Plans</h2>
            <p>Tailored training routines to achieve your fitness targets efficiently.</p>
        </div>

        <!-- Filter / Tabs -->
        <div class="workout-tabs">
            <button class="tab-btn active" onclick="switchTab('beginner', this)">
                <i class="fas fa-running"></i> Beginner / Toning
            </button>
            <button class="tab-btn" onclick="switchTab('muscle', this)">
                <i class="fas fa-dumbbell"></i> Muscle Building
            </button>
            <button class="tab-btn" onclick="switchTab('fatloss', this)">
                <i class="fas fa-fire"></i> Weight &amp; Fat Loss
            </button>
        </div>

        <!-- TAB 1: BEGINNER -->
        <div id="tab-beginner" class="tab-content active">
            <h3><i class="fas fa-calendar-alt"></i> 3-Day Beginner Full Body Split</h3>
            <div class="workout-grid">

                <div class="workout-card">
                    <div class="card-header">
                        <h4>Day 1: Upper Body Focus</h4>
                        <span>Duration: 45 Mins</span>
                    </div>
                    <ul>
                        <li><strong>Push-Ups:</strong> 3 Sets x 10-12 Reps</li>
                        <li><strong>Dumbbell Chest Press:</strong> 3 Sets x 12 Reps</li>
                        <li><strong>Lat Pulldown:</strong> 3 Sets x 12 Reps</li>
                        <li><strong>Seated Cable Row:</strong> 3 Sets x 12 Reps</li>
                        <li><strong>Overhead Shoulder Press:</strong> 3 Sets x 10 Reps</li>
                        <li><strong>Plank Hold:</strong> 3 Sets x 45 Secs</li>
                    </ul>
                </div>

                <div class="workout-card">
                    <div class="card-header">
                        <h4>Day 2: Lower Body &amp; Core</h4>
                        <span>Duration: 45 Mins</span>
                    </div>
                    <ul>
                        <li><strong>Bodyweight Squats:</strong> 3 Sets x 15 Reps</li>
                        <li><strong>Leg Press Machine:</strong> 3 Sets x 12 Reps</li>
                        <li><strong>Walking Lunges:</strong> 3 Sets x 10 Reps/leg</li>
                        <li><strong>Leg Curls:</strong> 3 Sets x 12 Reps</li>
                        <li><strong>Calf Raises:</strong> 3 Sets x 20 Reps</li>
                        <li><strong>Crunches:</strong> 3 Sets x 15 Reps</li>
                    </ul>
                </div>

                <div class="workout-card">
                    <div class="card-header">
                        <h4>Day 3: Full Body &amp; Cardio</h4>
                        <span>Duration: 50 Mins</span>
                    </div>
                    <ul>
                        <li><strong>Treadmill Incline Walk:</strong> 15 Minutes</li>
                        <li><strong>Dumbbell Deadlifts:</strong> 3 Sets x 10 Reps</li>
                        <li><strong>Dumbbell Bicep Curls:</strong> 3 Sets x 12 Reps</li>
                        <li><strong>Triceps Pushdown:</strong> 3 Sets x 12 Reps</li>
                        <li><strong>Bicycle Crunches:</strong> 3 Sets x 20 Reps</li>
                        <li><strong>Stretching Routine:</strong> 10 Minutes</li>
                    </ul>
                </div>

            </div>
        </div>

        <!-- TAB 2: MUSCLE BUILDING -->
        <div id="tab-muscle" class="tab-content">
            <h3><i class="fas fa-calendar-alt"></i> 5-Day Hypertrophy &amp; Strength Split</h3>
            <div class="workout-grid">

                <div class="workout-card">
                    <div class="card-header">
                        <h4>Day 1: Chest &amp; Triceps</h4>
                        <span>Intensity: High</span>
                    </div>
                    <ul>
                        <li><strong>Barbell Bench Press:</strong> 4 Sets x 8-10 Reps</li>
                        <li><strong>Incline Dumbbell Press:</strong> 3 Sets x 10 Reps</li>
                        <li><strong>Cable Chest Flyes:</strong> 3 Sets x 12 Reps</li>
                        <li><strong>Skull Crushers:</strong> 3 Sets x 10 Reps</li>
                        <li><strong>Rope Triceps Pushdowns:</strong> 3 Sets x 12 Reps</li>
                    </ul>
                </div>

                <div class="workout-card">
                    <div class="card-header">
                        <h4>Day 2: Back &amp; Biceps</h4>
                        <span>Intensity: High</span>
                    </div>
                    <ul>
                        <li><strong>Deadlifts / Barbell Rows:</strong> 4 Sets x 8 Reps</li>
                        <li><strong>Lat Pulldown (Wide Grip):</strong> 3 Sets x 10 Reps</li>
                        <li><strong>Single Arm DB Row:</strong> 3 Sets x 10 Reps/arm</li>
                        <li><strong>Barbell Bicep Curls:</strong> 3 Sets x 10 Reps</li>
                        <li><strong>Hammer Curls:</strong> 3 Sets x 12 Reps</li>
                    </ul>
                </div>

                <div class="workout-card">
                    <div class="card-header">
                        <h4>Day 3: Legs &amp; Abs</h4>
                        <span>Intensity: Max</span>
                    </div>
                    <ul>
                        <li><strong>Barbell Back Squats:</strong> 4 Sets x 8-10 Reps</li>
                        <li><strong>Romanian Deadlifts:</strong> 3 Sets x 10 Reps</li>
                        <li><strong>Leg Extension &amp; Curl:</strong> 3 Sets x 12 Reps</li>
                        <li><strong>Standing Calf Raise:</strong> 4 Sets x 15 Reps</li>
                        <li><strong>Hanging Leg Raises:</strong> 3 Sets x 12 Reps</li>
                    </ul>
                </div>

            </div>
        </div>

        <!-- TAB 3: FAT LOSS -->
        <div id="tab-fatloss" class="tab-content">
            <h3><i class="fas fa-fire"></i> High-Intensity Calorie Burn Circuit</h3>
            <div class="workout-grid">

                <div class="workout-card">
                    <div class="card-header">
                        <h4>Day 1: HIIT Cardio &amp; Core</h4>
                        <span>Burn: ~500 kcal</span>
                    </div>
                    <ul>
                        <li><strong>Treadmill Sprints (30s sprint/30s walk):</strong> 15 Mins</li>
                        <li><strong>Kettlebell Swings:</strong> 4 Sets x 15 Reps</li>
                        <li><strong>Burpees:</strong> 3 Sets x 12 Reps</li>
                        <li><strong>Mountain Climbers:</strong> 3 Sets x 40 Secs</li>
                        <li><strong>Russian Twists:</strong> 3 Sets x 20 Reps</li>
                    </ul>
                </div>

                <div class="workout-card">
                    <div class="card-header">
                        <h4>Day 2: Functional Circuit</h4>
                        <span>Burn: ~450 kcal</span>
                    </div>
                    <ul>
                        <li><strong>Jump Squats:</strong> 4 Sets x 15 Reps</li>
                        <li><strong>Dumbbell Thrusters:</strong> 3 Sets x 12 Reps</li>
                        <li><strong>Battle Ropes:</strong> 4 Sets x 30 Secs</li>
                        <li><strong>Box Jumps / Step-Ups:</strong> 3 Sets x 12 Reps</li>
                        <li><strong>Plank to Push-up:</strong> 3 Sets x 10 Reps</li>
                    </ul>
                </div>

                <div class="workout-card">
                    <div class="card-header">
                        <h4>Day 3: Endurance &amp; Rowing</h4>
                        <span>Burn: ~550 kcal</span>
                    </div>
                    <ul>
                        <li><strong>Rowing Machine:</strong> 20 Minutes (Continuous)</li>
                        <li><strong>Bodyweight Lunge Matrix:</strong> 3 Sets x 12 Reps</li>
                        <li><strong>Jumping Jacks:</strong> 3 Sets x 60 Secs</li>
                        <li><strong>High Knees:</strong> 3 Sets x 45 Secs</li>
                        <li><strong>Cool Down &amp; Foam Rolling:</strong> 10 Mins</li>
                    </ul>
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
function switchTab(tabName, element) {
    document.querySelectorAll('.tab-content').forEach(el => el.classList.remove('active'));
    document.querySelectorAll('.tab-btn').forEach(el => el.classList.remove('active'));
    document.getElementById('tab-' + tabName).classList.add('active');
    element.classList.add('active');
}
</script>

<%@ include file="../footer.jsp" %>

</body>
</html>
