package controller.assistant.trip;

import dto.TripDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.Account;
import service.TripService;

public class MyTripServlet extends HttpServlet {
    private TripService tripService;

    @Override
    public void init() throws ServletException {
        tripService = new TripService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Account user = (Account) session.getAttribute("USER");
        int assistantID = user.getAccountID();

        List<TripDTO> assignedTrips = tripService.getTripsByAssistant(assistantID);
        request.setAttribute("assignedTrips", assignedTrips);

        request.getRequestDispatcher("/view/assistant/my-trip.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
