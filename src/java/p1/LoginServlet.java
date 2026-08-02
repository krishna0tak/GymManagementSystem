package p1;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * LoginServlet — handles member authentication.
 * GET  : forwards to login.jsp (render the login form)
 * POST : validates credentials, creates session, redirects to Dashboard
 */
@WebServlet(urlPatterns = {"/Login"})
public class LoginServlet extends HttpServlet {

    /** Show the login form */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // If already logged in, go straight to dashboard
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("member_id") != null) {
            response.sendRedirect(request.getContextPath() + "/member/Dashboard");
            return;
        }
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    /** Process login form submission */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email    = request.getParameter("email");
        String password = request.getParameter("password");

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            String encPassword = AESUtil.encryptAES(password);

            con = dbcon.getConnection();
            ps  = con.prepareStatement(
                    "SELECT * FROM members WHERE email=? AND password=?");
            ps.setString(1, email);
            ps.setString(2, encPassword);
            rs = ps.executeQuery();

            if (rs.next()) {
                // Credentials valid — create session
                HttpSession session = request.getSession(true);
                session.setAttribute("member_id",   rs.getInt("member_id"));
                session.setAttribute("name",        rs.getString("name"));
                session.setAttribute("email",       rs.getString("email"));
                session.setAttribute("mobile",      rs.getString("mobile"));
                session.setAttribute("plan_id",     rs.getInt("plan_id"));
                session.setAttribute("join_date",   rs.getDate("join_date"));
                session.setAttribute("expiry_date", rs.getDate("expiry_date"));

                response.sendRedirect(request.getContextPath() + "/member/Dashboard");

            } else {
                request.setAttribute("error", "Invalid Email or Password.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }

        } catch (Exception e) {
            request.setAttribute("error", "Login error: " + e.getMessage());
            request.getRequestDispatcher("/login.jsp").forward(request, response);

        } finally {
            if (rs  != null) try { rs.close();  } catch (Exception e) {}
            if (ps  != null) try { ps.close();  } catch (Exception e) {}
            if (con != null) try { con.close(); } catch (Exception e) {}
        }
    }
}
