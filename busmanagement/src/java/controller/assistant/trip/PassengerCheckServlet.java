package controller.assistant.trip;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.Account;
import model.Ticket;
import model.Trip;
import service.PassengerCheckService;
import service.TicketService;
import service.TripService;

public class PassengerCheckServlet extends HttpServlet {
    private TripService tripService;
    private TicketService ticketService;
    private PassengerCheckService passengerCheckService;

    @Override
    public void init() throws ServletException {
        tripService = new TripService();
        ticketService = new TicketService();
        passengerCheckService = new PassengerCheckService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Account user = (Account) session.getAttribute("USER");
        int assistantID = user.getAccountID();

        String tripIDStr = request.getParameter("tripID");
        if (tripIDStr == null || tripIDStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/assistant/trip");
            return;
        }

        try {
            int tripID = Integer.parseInt(tripIDStr);
            Trip trip = tripService.getTripById(tripID);

            if (trip == null) {
                request.setAttribute("error", "Chuyến xe không tồn tại.");
                request.getRequestDispatcher("/view/assistant/passenger-check.jsp").forward(request, response);
                return;
            }

            // Verify authorization
            if (trip.getAssistantID() == null || trip.getAssistantID() != assistantID) {
                request.setAttribute("error", "Bạn không có quyền thực hiện soát vé trên chuyến đi này.");
                request.getRequestDispatcher("/view/assistant/passenger-check.jsp").forward(request, response);
                return;
            }

            int page = 1;
            int limit = 10;
            String pageStr = request.getParameter("page");
            if (pageStr != null && !pageStr.trim().isEmpty()) {
                try {
                    page = Integer.parseInt(pageStr);
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }
            int offset = (page - 1) * limit;

            int totalTickets = ticketService.countTicketsByTrip(tripID);
            int totalPages = (int) Math.ceil((double) totalTickets / limit);

            // Retrieve checked-in tickets list
            List<Ticket> checkedTickets = ticketService.getTicketsByTrip(tripID, offset, limit);

            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("queryString", "tripID=" + tripID);

            // Pop messages from session if any
            String successMsg = (String) session.getAttribute("successMessage");
            if (successMsg != null) {
                request.setAttribute("successMessage", successMsg);
                session.removeAttribute("successMessage");
            }
            String errorMsg = (String) session.getAttribute("errorMessage");
            if (errorMsg != null) {
                request.setAttribute("errorMessage", errorMsg);
                session.removeAttribute("errorMessage");
            }

            request.setAttribute("trip", trip);
            request.setAttribute("checkedTickets", checkedTickets);
            request.getRequestDispatcher("/view/assistant/passenger-check.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi hệ thống.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String tripIDStr = request.getParameter("tripID");
        String ticketCode = request.getParameter("ticketCode");

        if (tripIDStr == null || tripIDStr.trim().isEmpty() || ticketCode == null || ticketCode.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Vui lòng nhập đầy đủ thông tin.");
            response.sendRedirect("passenger-check?tripID=" + tripIDStr);
            return;
        }

        try {
            int tripID = Integer.parseInt(tripIDStr);

            // Perform check-in business logic
            passengerCheckService.checkInPassenger(ticketCode, tripID);

            session.setAttribute("successMessage", "Soát vé & Check-In thành công vé mã: " + ticketCode);
        } catch (IllegalArgumentException e) {
            session.setAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Hệ thống gặp lỗi: " + e.getMessage());
        }

        response.sendRedirect("passenger-check?tripID=" + tripIDStr);
    }
}
