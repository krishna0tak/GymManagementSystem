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
 * AdminLoginServlet — handles admin authentication.
 *
 * GET  : forwards to adminlogin.jsp
 * POST : validates username/password; creates admin session on success
 *
 * Accepts either the hardcoded fallback (admin / admin123)
 * or credentials stored in the admin table in MySQL.
 */
@WebServlet(urlPatterns = {"/AdminLogin"})
public class AdminLoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // If already admin-logged-in, go to dashboard
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("admin_user") != null) {
            response.sendRedirect(request.getContextPath() + "/AdminDashboard");
            return;
        }
        request.getRequestDispatcher("/adminlogin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        boolean authenticated = false;

        // Hardcoded fallback admin credentials
        if ("admin".equalsIgnoreCase(username) && "admin123".equals(password)) {
            authenticated = true;
        } else {
            // Check database admin table
            Connection con = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            try {
                con = dbcon.getConnection();

                // Auto-create admin table if it does not exist yet
                Statement stmt = con.createStatement();
                stmt.executeUpdate(
                        "CREATE TABLE IF NOT EXISTS admin (" +
                        "admin_id INT AUTO_INCREMENT PRIMARY KEY, " +
                        "username VARCHAR(50) UNIQUE, " +
                        "password VARCHAR(100))");
                stmt.close();

                ps = con.prepareStatement(
                        "SELECT * FROM admin WHERE username=? AND password=?");
                ps.setString(1, username);
                ps.setString(2, password);
                rs = ps.executeQuery();

                if (rs.next()) {
                    authenticated = true;
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (rs  != null) try { rs.close();  } catch (Exception e) {}
                if (ps  != null) try { ps.close();  } catch (Exception e) {}
                if (con != null) try { con.close(); } catch (Exception e) {}
            }
        }

        if (authenticated) {
            HttpSession session = request.getSession(true);
            session.setAttribute("admin_user", username);
            response.sendRedirect(request.getContextPath() + "/AdminDashboard");
        } else {
            request.setAttribute("error", "Invalid Admin Username or Password.");
            request.getRequestDispatcher("/adminlogin.jsp").forward(request, response);
        }
    }
}
