package service;

import dal.BusDAO;
import dal.BusLocationHistoryDAO;
import dal.RouteStopDAO;
import dal.TicketDAO;
import dal.TripDAO;
import dto.BusLocationDTO;
import dto.TripDTO;
import dto.RouteStopDTO;
import model.BusLocationHistory;
import model.Bus;
import model.Trip;
import java.util.ArrayList;
import java.util.List;

public class BusTrackingService {

    private TripDAO tripDAO = new TripDAO();
    private BusLocationHistoryDAO locationDAO = new BusLocationHistoryDAO();
    private TicketDAO ticketDAO = new TicketDAO();
    private BusDAO busDAO = new BusDAO();
    private RouteStopDAO routeStopDAO = new RouteStopDAO();

    public List<BusLocationDTO> getRunningBusesLocations() {
        List<BusLocationDTO> result = new ArrayList<>();

        List<TripDTO> runningTrips = tripDAO.getRunningTripsForTracking();

        for (TripDTO tripDTO : runningTrips) {
            try {
                BusLocationHistory latestLoc = locationDAO.getLatestByTrip(tripDTO.getTripID());

                if (latestLoc == null) {
                    continue;
                }
                Trip tripEntity = tripDAO.getById(tripDTO.getTripID());
                int routeID = (tripEntity != null) ? tripEntity.getRouteID() : 0;
                List<RouteStopDTO> stops = routeStopDAO.getStopsByRoute(routeID);
                if (stops != null && !stops.isEmpty()) {
                    // Lấy trạm dừng cuối cùng của tuyến
                    RouteStopDTO lastStop = stops.get(stops.size() - 1);

                    // Tính khoảng cách từ xe đến bến cuối
                    double distanceToLastStop = calculateHaversineDistance(
                            latestLoc.getLatitude(), latestLoc.getLongitude(),
                            lastStop.getLatitude(), lastStop.getLongitude()
                    );

                    // Nếu khoảng cách <= 0.15 km (150 mét), coi như đã tới bến cuối
                    if (distanceToLastStop <= 0.15) {
                        // Tự động Update Status thành 'COMPLETED' và lưu thời gian thực tế
                        tripDAO.finishTripActual(tripDTO.getTripID(), new java.sql.Timestamp(System.currentTimeMillis()));

                        // Bỏ qua xe này, không đẩy vào danh sách trả về cho Client nữa
                        continue;
                    }
                }
                int passenger = ticketDAO.countTicketsByTripAndStatus(tripDTO.getTripID(), "CHECKED_IN");


                // Tính toán ETA dựa trên GPS thực tế và tọa độ các trạm
                int eta = calculateETA(latestLoc.getLatitude(), latestLoc.getLongitude(), routeID);

                int capacity = 60;
                List<Bus> foundBuses = busDAO.searchAndFilter(tripDTO.getBusPlate(), "ALL", 0, 1);
                if (foundBuses != null && !foundBuses.isEmpty()) {
                    capacity = foundBuses.get(0).getCapacity();
                }

                result.add(
                        new BusLocationDTO(
                                tripDTO.getTripID(),
                                tripDTO.getRouteNumber(),
                                tripDTO.getBusPlate(),
                                latestLoc.getLatitude(),
                                latestLoc.getLongitude(),
                                passenger,
                                capacity,
                                eta
                        )
                );

            } catch (Exception e) {
                System.out.println("Lỗi xử lý tracking cho TripID: " + tripDTO.getTripID());
                e.printStackTrace();
            }
        }
        return result;
    }

    /**
     * Thuật toán tính ETA (Thời gian dự kiến đến trạm tiếp theo)
     */
    private int calculateETA(double currentLat, double currentLng, int routeID) {
        if (routeID == 0) {
            return 0;
        }

        // Lấy danh sách tọa độ các trạm dừng của tuyến xe này
        List<RouteStopDTO> stops = routeStopDAO.getStopsByRoute(routeID);

        if (stops == null || stops.isEmpty()) {
            return 0;
        }

        double minDistance = Double.MAX_VALUE;

        // Tìm trạm dừng gần nhất so với vị trí hiện tại của xe buýt
        for (RouteStopDTO stop : stops) {
            double distance = calculateHaversineDistance(currentLat, currentLng, stop.getLatitude(), stop.getLongitude());
            if (distance < minDistance) {
                minDistance = distance;
            }
        }

        // Vận tốc trung bình giả định: 30 km/h
        double averageSpeedKmH = 30.0;

        // Thời gian (Giờ) = Quãng đường (km) / Vận tốc (km/h)
        double timeInHours = minDistance / averageSpeedKmH;

        // Chuyển đổi sang phút
        int etaMinutes = (int) Math.round(timeInHours * 60);

        // Đảm bảo trả về ít nhất 1 phút nếu khoảng cách quá gần, 
        // vì xe cần thời gian hãm phanh và đón/trả khách.
        return Math.max(1, etaMinutes);
    }

    /**
     * Công thức toán học Haversine để tính khoảng cách đường chim bay giữa 2
     * điểm GPS (trên mặt cầu) Trả về kết quả theo đơn vị Kilometers (km).
     */
    private double calculateHaversineDistance(double lat1, double lon1, double lat2, double lon2) {
        final int R = 6371; // Bán kính Trái Đất (km)

        double latDistance = Math.toRadians(lat2 - lat1);
        double lonDistance = Math.toRadians(lon2 - lon1);

        double a = Math.sin(latDistance / 2) * Math.sin(latDistance / 2)
                + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2))
                * Math.sin(lonDistance / 2) * Math.sin(lonDistance / 2);

        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

        return R * c;
    }
}
