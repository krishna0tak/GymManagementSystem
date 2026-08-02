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
 * BMIServlet — handles BMI calculation and saving height/weight to the member profile.
 *
 * GET  : fetch current height & weight from DB → forward to member/bmi.jsp
 * POST : update height & weight in DB → redirect back (PRG) with flash param
 */
@WebServlet(urlPatterns = {"/member/BMI"})
public class BMIServlet extends HttpServlet {

    /** Load current height & weight and forward to the BMI view */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("member_id") == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        int memberId = (Integer) session.getAttribute("member_id");

        double height = 0, weight = 0;
        String bmiFormatted = "0.0";

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = dbcon.getConnection();
            ps  = con.prepareStatement(
                    "SELECT height, weight FROM members WHERE member_id=?");
            ps.setInt(1, memberId);
            rs = ps.executeQuery();

            if (rs.next()) {
                height = rs.getDouble("height");
                weight = rs.getDouble("weight");
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs  != null) try { rs.close();  } catch (Exception e) {}
            if (ps  != null) try { ps.close();  } catch (Exception e) {}
            if (con != null) try { con.close(); } catch (Exception e) {}
        }

        // Pre-calculate server-side BMI for the initial page load
        if (height > 0) {
            double meter = height / 100.0;
            double bmi   = weight / (meter * meter);
            bmiFormatted = new DecimalFormat("#.0").format(bmi);
        }

        request.setAttribute("height",       height);
        request.setAttribute("weight",       weight);
        request.setAttribute("bmiFormatted", bmiFormatted);

        request.getRequestDispatcher("/member/bmi.jsp").forward(request, response);
    }

    /** Save updated height & weight, then redirect (PRG pattern) */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("member_id") == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        int    memberId = (Integer) session.getAttribute("member_id");
        String redirect = request.getContextPath() + "/member/BMI";

        try {
            double height = Double.parseDouble(request.getParameter("height"));
            double weight = Double.parseDouble(request.getParameter("weight"));

            Connection con = dbcon.getConnection();
            PreparedStatement ps = con.prepareStatement(
                    "UPDATE members SET height=?, weight=? WHERE member_id=?");
            ps.setDouble(1, height);
            ps.setDouble(2, weight);
            ps.setInt(3, memberId);

            int rows = ps.executeUpdate();
            ps.close();
            con.close();

            redirect += (rows > 0) ? "?saved=1" : "?saved=0";

        } catch (Exception e) {
            e.printStackTrace();
            redirect += "?saved=0";
        }

        // PRG — redirect so browser refresh doesn't resubmit
        response.sendRedirect(redirect);
    }
}
