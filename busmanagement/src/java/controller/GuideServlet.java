package controller;

import dal.RouteDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Route;

public class GuideServlet extends HttpServlet {
    private RouteDAO routeDAO;

    @Override
    public void init() throws ServletException {
        routeDAO = new RouteDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Route> suspendedRoutes = routeDAO.getSuspendedRoutes();
            request.setAttribute("suspendedRoutes", suspendedRoutes);
            request.getRequestDispatcher("/view/guide.jsp").forward(request, response);
        } catch (Exception e) {
            response.setContentType("text/plain;charset=UTF-8");
            response.getWriter().println("Error executing GuideServlet: " + e.getMessage());
            e.printStackTrace(response.getWriter());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
