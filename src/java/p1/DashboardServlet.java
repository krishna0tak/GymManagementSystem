package p1;

import java.io.IOException;
import java.sql.*;
import java.text.DecimalFormat;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * DashboardServlet — fetches member + plan data and forwards to dashboard.jsp.
 * Requires an active member session; redirects to /Login if none found.
 *
 * GET : load data, set request attributes, forward to member/dashboard.jsp
 */
@WebServlet(urlPatterns = {"/member/Dashboard"})
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Session guard
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("member_id") == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        int memberId = (Integer) session.getAttribute("member_id");

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = dbcon.getConnection();
            ps  = con.prepareStatement(
                    "SELECT m.*, p.plan_name, p.duration_months, p.fees " +
                    "FROM members m " +
                    "LEFT JOIN membership_plan p ON m.plan_id = p.plan_id " +
                    "WHERE m.member_id = ?");
            ps.setInt(1, memberId);
            rs = ps.executeQuery();

            if (rs.next()) {
                // Member info
                request.setAttribute("name",     rs.getString("name"));
                request.setAttribute("gender",   rs.getString("gender"));
                request.setAttribute("mobile",   rs.getString("mobile"));
                request.setAttribute("email",    rs.getString("email"));
                request.setAttribute("address",  rs.getString("address"));
                request.setAttribute("height",   rs.getDouble("height"));
                request.setAttribute("weight",   rs.getDouble("weight"));

                // Plan info
                String planName = rs.getString("plan_name");
                request.setAttribute("planName",  planName != null ? planName : "N/A");
                request.setAttribute("duration",  rs.getInt("duration_months"));
                request.setAttribute("fees",      rs.getDouble("fees"));

                // Dates
                Date joinDate   = rs.getDate("join_date");
                Date expiryDate = rs.getDate("expiry_date");
                request.setAttribute("joinDate",   joinDate   != null ? joinDate.toString()   : "N/A");
                request.setAttribute("expiryDate", expiryDate != null ? expiryDate.toString() : "N/A");

                // Membership status
                String membershipStatus = "Inactive";
                if (expiryDate != null) {
                    membershipStatus = expiryDate.before(new java.util.Date()) ? "Expired" : "Active";
                }
                request.setAttribute("membershipStatus", membershipStatus);

                // BMI
                double height = rs.getDouble("height");
                double weight = rs.getDouble("weight");
                double bmi    = 0;
                if (height > 0) {
                    double meter = height / 100.0;
                    bmi = weight / (meter * meter);
                }
                DecimalFormat df = new DecimalFormat("#.0");
                request.setAttribute("bmiValue", bmi > 0 ? df.format(bmi) : "0.0");

                String bmiStatus = "N/A";
                if (bmi > 0) {
                    if      (bmi < 18.5) bmiStatus = "Underweight";
                    else if (bmi < 25)   bmiStatus = "Normal";
                    else if (bmi < 30)   bmiStatus = "Overweight";
                    else                 bmiStatus = "Obese";
                }
                request.setAttribute("bmiStatus", bmiStatus);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs  != null) try { rs.close();  } catch (Exception e) {}
            if (ps  != null) try { ps.close();  } catch (Exception e) {}
            if (con != null) try { con.close(); } catch (Exception e) {}
        }

        request.getRequestDispatcher("/member/dashboard.jsp").forward(request, response);
    }
}
