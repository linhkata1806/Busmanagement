package service;

import dal.NotificationDAO;
import dal.TicketDAO;
import dal.TripDAO;
import dto.TripDTO;
import java.util.HashMap;
import java.util.Map;

public class AssistantDashboardService {
    private final TripDAO tripDAO;
    private final TicketDAO ticketDAO;
    private final NotificationDAO notificationDAO;

    public AssistantDashboardService() {
        this.tripDAO = new TripDAO();
        this.ticketDAO = new TicketDAO();
        this.notificationDAO = new NotificationDAO();
    }

    public Map<String, Object> getDashboardStats(int assistantID) {
        Map<String, Object> stats = new HashMap<>();

        // Get current active or upcoming trip for assistant
        TripDTO currentTrip = tripDAO.getCurrentTripByAssistant(assistantID);
        stats.put("currentTrip", currentTrip);

        if (currentTrip != null) {
            // Count checked-in passengers for this trip
            int totalChecked = ticketDAO.countTicketsByTripAndStatus(currentTrip.getTripID(), "CHECKED_IN");
            stats.put("totalChecked", totalChecked);

            // Count remaining unused tickets for this route (potential passengers)
            int passengersRemaining = ticketDAO.countUnusedTicketsForRoute(tripDAO.getById(currentTrip.getTripID()).getRouteID());
            stats.put("passengersRemaining", passengersRemaining);
        } else {
            stats.put("totalChecked", 0);
            stats.put("passengersRemaining", 0);
        }

        // Count pending notifications
        int pendingNotifications = notificationDAO.countUnreadNotifications(assistantID);
        stats.put("pendingNotifications", pendingNotifications);

        return stats;
    }
}
