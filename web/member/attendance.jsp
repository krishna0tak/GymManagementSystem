<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="p1.dbcon"%>

<%
if(session.getAttribute("member_id") == null){
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
}

int memberId = (Integer)session.getAttribute("member_id");
String name = (String)session.getAttribute("name");
String msg = "";
String errorMsg = "";

Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

// Ensure attendance table exists
try {
    con = new dbcon().getConnection();
    Statement stmt = con.createStatement();
    stmt.executeUpdate(
        "CREATE TABLE IF NOT EXISTS attendance (" +
        "attendance_id INT AUTO_INCREMENT PRIMARY KEY, " +
        "member_id INT, " +
        "attendance_date DATE, " +
        "check_in_time TIME, " +
        "status VARCHAR(20), " +
        "UNIQUE KEY unique_member_date (member_id, attendance_date)" +
        ")"
    );

    // Reliably add missing columns using INFORMATION_SCHEMA (works on MySQL 5.7+)
    ResultSet colRS = con.getMetaData().getColumns(null, null, "attendance", "check_in_time");
    if (!colRS.next()) {
        stmt.executeUpdate("ALTER TABLE attendance ADD COLUMN check_in_time TIME");
    }
    colRS.close();

    ResultSet colRS2 = con.getMetaData().getColumns(null, null, "attendance", "status");
    if (!colRS2.next()) {
        stmt.executeUpdate("ALTER TABLE attendance ADD COLUMN status VARCHAR(20)");
    }
    colRS2.close();

    stmt.close();
} catch(Exception e){
    e.printStackTrace();
}

// Mark Today's Attendance
if(request.getParameter("mark_attendance") != null){
    try {
        java.sql.Date today = new java.sql.Date(System.currentTimeMillis());
        java.sql.Time curTime = new java.sql.Time(System.currentTimeMillis());
        
        ps = con.prepareStatement(
            "INSERT INTO attendance (member_id, attendance_date, check_in_time, status) VALUES (?, ?, ?, 'Present')"
        );
        ps.setInt(1, memberId);
        ps.setDate(2, today);
        ps.setTime(3, curTime);
        
        int rows = ps.executeUpdate();
        ps.close();
        if(rows > 0){
            msg = "Attendance marked successfully for today!";
        }
    } catch(SQLIntegrityConstraintViolationException ex){
        errorMsg = "You have already marked your attendance for today!";
    } catch(Exception e){
        errorMsg = "Error: " + e.getMessage();
    }
}

// Fetch Attendance History & Stats
boolean alreadyMarkedToday = false;
int totalPresent = 0;
java.sql.Date todayDate = new java.sql.Date(System.currentTimeMillis());

class AttendanceRecord {
    public java.sql.Date date;
    public java.sql.Time time;
    public String status;
    public AttendanceRecord(java.sql.Date d, java.sql.Time t, String s){
        this.date = d; this.time = t; this.status = s;
    }
}
List<AttendanceRecord> records = new ArrayList<>();

try {
    ps = con.prepareStatement("SELECT attendance_date, check_in_time, status FROM attendance WHERE member_id=? ORDER BY attendance_date DESC");
    ps.setInt(1, memberId);
    rs = ps.executeQuery();
    
    while(rs.next()){
        java.sql.Date d = rs.getDate("attendance_date");
        java.sql.Time t = rs.getTime("check_in_time");
        String st = rs.getString("status");
        
        if(d != null && d.toString().equals(todayDate.toString())){
            alreadyMarkedToday = true;
        }
        totalPresent++;
        records.add(new AttendanceRecord(d, t, st));
    }
} catch(Exception e){
    e.printStackTrace();
} finally {
    if(rs != null) try{ rs.close(); }catch(Exception e){}
    if(ps != null) try{ ps.close(); }catch(Exception e){}
    if(con != null) try{ con.close(); }catch(Exception e){}
}

// Attendance stats estimation
int currentDayOfMonth = java.util.Calendar.getInstance().get(java.util.Calendar.DAY_OF_MONTH);
double attendancePercentage = (currentDayOfMonth > 0) ? ((double)totalPresent / currentDayOfMonth) * 100 : 0;
if(attendancePercentage > 100) attendancePercentage = 100.0;
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gym Attendance - PowerFit Gym</title>
    <link rel="stylesheet" href="../style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>

<%@ include file="../header.jsp" %>

<section class="attendance-section">
    <div class="attendance-container">

        <div class="attendance-header">
            <h2><i class="fas fa-calendar-check"></i> Gym Attendance Tracker</h2>
            <p>Check-in daily to record your gym visits and track your consistency.</p>
        </div>

        <% if(!msg.equals("")) { %>
            <div class="alert-success">
                <i class="fas fa-check-circle"></i> <%=msg%>
            </div>
        <% } %>

        <% if(!errorMsg.equals("")) { %>
            <div class="alert-warning">
                <i class="fas fa-exclamation-triangle"></i> <%=errorMsg%>
            </div>
        <% } %>

        <!-- Check-in Action Box -->
        <div class="checkin-box">
            <div class="checkin-info">
                <h3>Today's Date: <span><%= new SimpleDateFormat("EEEE, MMMM dd, yyyy").format(new java.util.Date()) %></span></h3>
                <p>Status: <strong><%= alreadyMarkedToday ? "Checked In ✅" : "Not Marked Yet ⏳" %></strong></p>
            </div>
            <div class="checkin-btn-wrap">
                <% if(!alreadyMarkedToday) { %>
                    <form action="attendance.jsp" method="post">
                        <button type="submit" name="mark_attendance" class="btn btn-checkin">
                            <i class="fas fa-user-check"></i> Mark Today's Attendance
                        </button>
                    </form>
                <% } else { %>
                    <button class="btn btn-disabled" disabled>
                        <i class="fas fa-check"></i> Attendance Completed
                    </button>
                <% } %>
            </div>
        </div>

        <!-- Attendance Stats Cards -->
        <div class="stats-grid">
            <div class="stat-card">
                <i class="fas fa-calendar-alt"></i>
                <h3><%=totalPresent%></h3>
                <p>Total Days Present</p>
            </div>
            <div class="stat-card">
                <i class="fas fa-percentage"></i>
                <h3><%= String.format("%.1f", attendancePercentage) %>%</h3>
                <p>Monthly Consistency</p>
            </div>
        </div>

        <!-- History Table -->
        <div class="attendance-history-card">
            <h3><i class="fas fa-history"></i> Attendance Log History</h3>
            
            <% if(records.isEmpty()) { %>
                <p class="no-records">No attendance records found. Click "Mark Today's Attendance" to start logging!</p>
            <% } else { %>
                <table class="history-table">
                    <thead>
                        <tr>
                            <th>S.No</th>
                            <th>Date</th>
                            <th>Check-in Time</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% int idx = 1; for(AttendanceRecord rec : records) { %>
                            <tr>
                                <td><%=idx++%></td>
                                <td><%=rec.date != null ? rec.date : "N/A"%></td>
                                <td><%=rec.time != null ? rec.time : "N/A"%></td>
                                <td><span class="active-status">Present</span></td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } %>
        </div>

        <div class="back-nav">
            <a href="dashboard.jsp" class="btn btn2"><i class="fas fa-arrow-left"></i> Back to Dashboard</a>
        </div>

    </div>
</section>

<%@ include file="../footer.jsp" %>

</body>
</html>
