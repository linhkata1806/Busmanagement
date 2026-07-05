package service;

import dal.BusDAO;
import dal.NotificationDAO;
import dal.RouteDAO;
import dal.TripDAO;
import dto.TripDTO;
import model.Bus;
import model.Route;
import java.util.HashMap;
import java.util.Map;

public class DriverDashboardService {
    private final TripDAO tripDAO;
    private final BusDAO busDAO;
    private final RouteDAO routeDAO;
    private final NotificationDAO notificationDAO;

    public DriverDashboardService() {
        this.tripDAO = new TripDAO();
        this.busDAO = new BusDAO();
        this.routeDAO = new RouteDAO();
        this.notificationDAO = new NotificationDAO();
    }

    public Map<String, Object> getDashboardStats(int driverID) {
        Map<String, Object> stats = new HashMap<>();

        // 1. Get current active or upcoming trip for driver
        // (getCurrentTripByDriver already prioritizes IN_PROGRESS trips first)
        TripDTO currentTrip = tripDAO.getCurrentTripByDriver(driverID);
        stats.put("currentTrip", currentTrip);

        if (currentTrip != null) {
            try {
                model.Trip tripObj = tripDAO.getById(currentTrip.getTripID());
                if (tripObj != null) {
                    Route route = routeDAO.getRouteById(tripObj.getRouteID());
                    stats.put("currentRoute", route);

                    Bus bus = busDAO.getBusById(tripObj.getBusID());
                    stats.put("currentBus", bus);
                }
            } catch (Exception e) {
                System.out.println("Error fetching route/bus details for dashboard: " + e.getMessage());
            }
        }

        // 2. Count today's trips
        int todaysTrips = tripDAO.countDriverTripsToday(driverID);
        stats.put("todaysTrips", todaysTrips);

        // 3. Count pending (unread) notifications
        int pendingNotifications = notificationDAO.countUnreadNotifications(driverID);
        stats.put("pendingNotifications", pendingNotifications);

        return stats;
    }
}
