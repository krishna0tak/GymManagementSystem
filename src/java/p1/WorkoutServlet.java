package p1;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * WorkoutServlet — session-guarded entry point for the workout plans page.
 * No DB access needed; all workout content is static HTML in workout.jsp.
 *
 * GET : verify member session → forward to member/workout.jsp
 */
@WebServlet(urlPatterns = {"/member/Workout"})
public class WorkoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("member_id") == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        request.getRequestDispatcher("/member/workout.jsp").forward(request, response);
    }
}
