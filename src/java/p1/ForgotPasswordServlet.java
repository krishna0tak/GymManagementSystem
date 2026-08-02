package p1;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * ForgotPasswordServlet — generates a new random password, updates the DB,
 * and emails the new password to the registered address.
 *
 * GET  : forwards to forgotpassword.jsp
 * POST : processes the email and sends the reset password
 */
@WebServlet(urlPatterns = {"/ForgotPassword"})
public class ForgotPasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/forgotpassword.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        if (email != null) email = email.trim();

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = dbcon.getConnection();
            if (con == null) {
                request.setAttribute("errorMsg", "Database connection failed. Please check settings.");
                request.getRequestDispatcher("/forgotpassword.jsp").forward(request, response);
                return;
            }

            // 1. Check if email exists
            ps = con.prepareStatement(
                    "SELECT member_id FROM members WHERE email=?");
            ps.setString(1, email);
            rs = ps.executeQuery();

            if (rs.next()) {
                // 2. Generate new plain-text password and encrypt
                String newPassword = AESUtil.generateRandomPassword();
                String encPassword = AESUtil.encryptAES(newPassword);

                // 3. Update DB
                PreparedStatement updatePs = con.prepareStatement(
                        "UPDATE members SET password=? WHERE email=?");
                updatePs.setString(1, encPassword);
                updatePs.setString(2, email);
                int rows = updatePs.executeUpdate();
                updatePs.close();

                if (rows > 0) {
                    // 4. Send email
                    Emailclass mailer = new Emailclass();
                    boolean sent = mailer.SendMail(email, newPassword);

                    if (sent) {
                        request.setAttribute("successMsg",
                                "New password sent to <strong>" + email +
                                "</strong>. Please check your inbox (and spam folder).");
                    } else {
                        request.setAttribute("successMsg",
                                "Password updated! New password: <strong>" + newPassword + "</strong><br>" +
                                "⚠ Email delivery failed — <small>" + mailer.lastError + "</small><br>" +
                                "Please save this password and use it to login.");
                    }
                } else {
                    request.setAttribute("errorMsg", "Failed to update password. Please try again.");
                }

            } else {
                request.setAttribute("errorMsg",
                        "No account registered with email: " + email);
            }

        } catch (Exception e) {
            request.setAttribute("errorMsg", "Error: " + e.getMessage());

        } finally {
            if (rs  != null) try { rs.close();  } catch (Exception ex) {}
            if (ps  != null) try { ps.close();  } catch (Exception ex) {}
            if (con != null) try { con.close(); } catch (Exception ex) {}
        }

        request.getRequestDispatcher("/forgotpassword.jsp").forward(request, response);
    }
}
