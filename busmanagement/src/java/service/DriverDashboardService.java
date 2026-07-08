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

        // 1. Lấy chuyến đi hiện tại hoặc sắp tới của tài xế
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

        // 2. Đếm số chuyến xe trong ngày hôm nay
        int todaysTrips = tripDAO.countDriverTripsToday(driverID);
        stats.put("todaysTrips", todaysTrips);

        // 3. Đếm số thông báo chưa đọc
        int pendingNotifications = notificationDAO.countUnreadNotifications(driverID);
        stats.put("pendingNotifications", pendingNotifications);

        return stats;
    }
}
