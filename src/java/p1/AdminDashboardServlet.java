package p1;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * AdminDashboardServlet — controller for the admin console.
 *
 * GET  : load analytics stats, member list, plan list → forward to admindashboard.jsp
 * POST : handle actions (delete_member, add_plan) → redirect (PRG pattern)
 */
@WebServlet(urlPatterns = {"/AdminDashboard"})
public class AdminDashboardServlet extends HttpServlet {

    /* =====================================================================
       Data transfer objects (inner classes)
       ===================================================================== */

    public static class MemberItem {
        public int    id;
        public String name, email, mobile, gender, address, planName, status;
        public Date   joinDate, expiryDate;
        public double height, weight;
    }

    public static class PlanItem {
        public int    id, duration;
        public String name;
        public double fees;
    }

    /* =====================================================================
       GET — load all data and forward to the view
       ===================================================================== */

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin_user") == null) {
            response.sendRedirect(request.getContextPath() + "/AdminLogin");
            return;
        }

        Connection con = null;

        try {
            con = dbcon.getConnection();

            // Ensure required tables exist and seed default plans
            ensureTablesExist(con);

            // Analytics counters
            int totalMembers   = 0;
            int activeMembers  = 0;
            int expiredMembers = 0;
            int totalPlans     = 0;

            Statement st = con.createStatement();

            ResultSet r1 = st.executeQuery("SELECT COUNT(*) FROM members");
            if (r1.next()) totalMembers = r1.getInt(1); r1.close();

            ResultSet r2 = st.executeQuery("SELECT COUNT(*) FROM members WHERE expiry_date >= CURDATE()");
            if (r2.next()) activeMembers = r2.getInt(1); r2.close();

            ResultSet r3 = st.executeQuery("SELECT COUNT(*) FROM members WHERE expiry_date < CURDATE()");
            if (r3.next()) expiredMembers = r3.getInt(1); r3.close();

            ResultSet r4 = st.executeQuery("SELECT COUNT(*) FROM membership_plan");
            if (r4.next()) totalPlans = r4.getInt(1); r4.close();

            st.close();

            request.setAttribute("totalMembers",   totalMembers);
            request.setAttribute("activeMembers",  activeMembers);
            request.setAttribute("expiredMembers", expiredMembers);
            request.setAttribute("totalPlans",     totalPlans);

            // Member list
            List<MemberItem> memberList = new ArrayList<>();
            PreparedStatement ps = con.prepareStatement(
                    "SELECT m.*, p.plan_name " +
                    "FROM members m " +
                    "LEFT JOIN membership_plan p ON m.plan_id = p.plan_id " +
                    "ORDER BY m.member_id DESC");
            ResultSet rs = ps.executeQuery();
            java.util.Date today = new java.util.Date();

            while (rs.next()) {
                MemberItem mi  = new MemberItem();
                mi.id          = rs.getInt("member_id");
                mi.name        = rs.getString("name");
                mi.email       = rs.getString("email");
                mi.mobile      = rs.getString("mobile");
                mi.gender      = rs.getString("gender");
                mi.address     = rs.getString("address");
                mi.planName    = rs.getString("plan_name") != null ? rs.getString("plan_name") : "N/A";
                mi.joinDate    = rs.getDate("join_date");
                mi.expiryDate  = rs.getDate("expiry_date");
                mi.height      = rs.getDouble("height");
                mi.weight      = rs.getDouble("weight");
                mi.status      = (mi.expiryDate != null && mi.expiryDate.before(today))
                                 ? "Expired" : "Active";
                memberList.add(mi);
            }
            rs.close(); ps.close();
            request.setAttribute("memberList", memberList);

            // Plan list
            List<PlanItem> planList = new ArrayList<>();
            Statement pst = con.createStatement();
            ResultSet prs = pst.executeQuery("SELECT * FROM membership_plan ORDER BY plan_id ASC");
            while (prs.next()) {
                PlanItem pi  = new PlanItem();
                pi.id        = prs.getInt("plan_id");
                pi.name      = prs.getString("plan_name");
                pi.duration  = prs.getInt("duration_months");
                pi.fees      = prs.getDouble("fees");
                planList.add(pi);
            }
            prs.close(); pst.close();
            request.setAttribute("planList", planList);

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (con != null) try { con.close(); } catch (Exception e) {}
        }

        request.getRequestDispatcher("/admindashboard.jsp").forward(request, response);
    }

    /* =====================================================================
       POST — handle admin actions (delete member / add plan)
       Uses Post-Redirect-Get to prevent duplicate submissions on refresh.
       ===================================================================== */

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin_user") == null) {
            response.sendRedirect(request.getContextPath() + "/AdminLogin");
            return;
        }

        String deleteMember = request.getParameter("delete_member");
        String addPlan      = request.getParameter("add_plan");

        String redirectUrl = request.getContextPath() + "/AdminDashboard";

        Connection con = null;
        try {
            con = dbcon.getConnection();

            if (deleteMember != null) {
                int mId = Integer.parseInt(deleteMember);
                PreparedStatement ps = con.prepareStatement(
                        "DELETE FROM members WHERE member_id=?");
                ps.setInt(1, mId);
                ps.executeUpdate();
                ps.close();
                redirectUrl += "?msg=deleted";

            } else if (addPlan != null) {
                String pName   = request.getParameter("plan_name");
                int pDuration  = Integer.parseInt(request.getParameter("duration_months"));
                double pFees   = Double.parseDouble(request.getParameter("fees"));

                PreparedStatement ps = con.prepareStatement(
                        "INSERT INTO membership_plan (plan_name, duration_months, fees) VALUES (?,?,?)");
                ps.setString(1, pName);
                ps.setInt(2, pDuration);
                ps.setDouble(3, pFees);
                ps.executeUpdate();
                ps.close();
                redirectUrl += "?msg=plan_added";
            }

        } catch (Exception e) {
            e.printStackTrace();
            redirectUrl += "?err=1";
        } finally {
            if (con != null) try { con.close(); } catch (Exception e) {}
        }

        // PRG: redirect so browser refresh does not re-submit the form
        response.sendRedirect(redirectUrl);
    }

    /* =====================================================================
       Helper — ensure tables exist and seed default membership plans
       ===================================================================== */

    private void ensureTablesExist(Connection con) throws SQLException {
        Statement stmt = con.createStatement();

        stmt.executeUpdate(
                "CREATE TABLE IF NOT EXISTS membership_plan (" +
                "plan_id INT AUTO_INCREMENT PRIMARY KEY, " +
                "plan_name VARCHAR(50), " +
                "duration_months INT, " +
                "fees DOUBLE)");

        ResultSet check = stmt.executeQuery("SELECT COUNT(*) FROM membership_plan");
        if (check.next() && check.getInt(1) == 0) {
            stmt.executeUpdate("INSERT INTO membership_plan (plan_id, plan_name, duration_months, fees) VALUES (1,'Basic',1,999.0)");
            stmt.executeUpdate("INSERT INTO membership_plan (plan_id, plan_name, duration_months, fees) VALUES (2,'Standard',3,1499.0)");
            stmt.executeUpdate("INSERT INTO membership_plan (plan_id, plan_name, duration_months, fees) VALUES (3,'Premium',12,2499.0)");
        }
        check.close();
        stmt.close();
    }
}
