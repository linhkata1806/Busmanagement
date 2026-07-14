/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.BusDAO;
import dal.BusLocationHistoryDAO;
import dal.RouteDAO;
import dal.RouteStopDAO;
import dal.TicketDAO;
import dal.TripDAO;
import dto.BusTrackingDTO;
import dto.RouteStopDTO;
import dto.TripDTO;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import model.Bus;
import model.BusLocationHistory;
import model.Route;
import model.Stop;
import model.Trip;

/**
 *
 * @author Administrator
 */
public class GuestTrackingService {

    private TripDAO tripDAO = new TripDAO();
    private BusDAO busDAO = new BusDAO();
    private BusLocationHistoryDAO locationDAO = new BusLocationHistoryDAO();
    private TicketDAO ticketDAO = new TicketDAO();
    private RouteStopDAO routeStopDAO = new RouteStopDAO();
    private RouteDAO routeDAO = new RouteDAO();

    public List<BusTrackingDTO> getRunningBusLocations() {
        List<BusTrackingDTO> result = new ArrayList<>();

        // 1. Tái sử dụng hàm getRunningTripsForTracking() có sẵn trong TripDAO của cậu
        List<dto.TripDTO> runningTrips = tripDAO.getRunningTripsForTracking();

        if (runningTrips == null || runningTrips.isEmpty()) {
            return result;
        }

        Random random = new Random();

        for (dto.TripDTO tripDTO : runningTrips) {
            try {
                // 2. Tái sử dụng hàm lấy GPS mới nhất từ BusLocationHistoryDAO
                BusLocationHistory latestLoc = locationDAO.getLatestByTrip(tripDTO.getTripID());
                if (latestLoc == null) {
                    continue;
                }
                Trip tripEntity = tripDAO.getById(tripDTO.getTripID());

                if (tripEntity == null) {
                    continue;
                }
                if (tripEntity.getActualStartTime() != null) {

                    long seconds
                            = (System.currentTimeMillis()
                            - latestLoc.getRecordedAt().getTime()) / 1000;

                    double moveSpeed = 0.00002;

                    latestLoc.setLatitude(
                            latestLoc.getLatitude() + seconds * moveSpeed);

                    latestLoc.setLongitude(
                            latestLoc.getLongitude() + seconds * moveSpeed);
                }

                // 4. Lấy thông tin Bus từ BusDAO có sẵn của cậu
                Bus bus = busDAO.getBusById(tripEntity.getBusID());
                String licensePlate = (bus != null) ? bus.getLicensePlate() : tripDTO.getBusPlate();
                int busID = (bus != null) ? bus.getBusID() : tripEntity.getBusID();

                // 5. Sinh vận tốc ngẫu nhiên mô phỏng từ 25 đến 45 km/h theo yêu cầu mục VI
                int speed = 25 + random.nextInt(21);

                // 6. Tái sử dụng hàm đếm vé CHECKED_IN từ TicketDAO của cậu
                int passengerCount = ticketDAO.countTicketsByTripAndStatus(tripDTO.getTripID(), "CHECKED_IN");

                // 7. Lấy danh sách Stop theo Route từ RouteStopDAO có sẵn
                List<RouteStopDTO> stops = routeStopDAO.getStopsByRoute(tripEntity.getRouteID());
                String currentStopName = "Đang cập nhật";
                String nextStopName = "Đang cập nhật";

                if (stops != null && !stops.isEmpty()) {
                    // Thuật toán xác định trạm gần nhất theo tọa độ hiện tại (GPS giả lập hoặc thực tế)
                    int closestIndex = 0;
                    double minDst = Double.MAX_VALUE;
                    for (int i = 0; i < stops.size(); i++) {
                        RouteStopDTO s = stops.get(i);
                        double dst = Math.hypot(latestLoc.getLatitude() - s.getLatitude(), latestLoc.getLongitude() - s.getLongitude());
                        if (dst < minDst) {
                            minDst = dst;
                            closestIndex = i;
                        }
                    }
                    currentStopName = stops.get(closestIndex).getStopName();

                    // Xác định điểm dừng kế tiếp (Next Stop) theo logic tài liệu mục VII
                    int nextIndex = Math.min(closestIndex + 1, stops.size() - 1);
                    nextStopName = stops.get(nextIndex).getStopName();

                    // Logic Kiểm tra tới bến cuối để tự động chuyển trạng thái (Auto-Complete)
                    RouteStopDTO lastStop = stops.get(stops.size() - 1);

// Khoảng cách từ xe tới bến cuối (km)
                    double distanceToLastStop = calculateHaversineDistance(
                            latestLoc.getLatitude(),
                            latestLoc.getLongitude(),
                            lastStop.getLatitude(),
                            lastStop.getLongitude()
                    );

// Nếu còn cách bến cuối <=150m thì tự kết thúc chuyến
                    if (distanceToLastStop <= 0.15) {

                        ticketDAO.updateTicketStatusByTrip(tripDTO.getTripID(), "COMPLETED");

                        tripDAO.finishTripActual(
                                tripDTO.getTripID(),
                                new Timestamp(System.currentTimeMillis())
                        );

                        continue;
                    }
                }

                // 8. Lấy thông tin tuyến (Route) để fill vào DTO
                Route route = routeDAO.getRouteById(tripEntity.getRouteID());
                String routeNumber = (route != null) ? route.getRouteNumber() : tripDTO.getRouteNumber();
                String routeName = (route != null) ? route.getRouteName() : tripDTO.getRouteName();

                // 9. Map dữ liệu vào BusTrackingDTO chuẩn theo mục IX của tài liệu
                BusTrackingDTO dto = new BusTrackingDTO();
                dto.setBusID(busID);
                dto.setLicensePlate(licensePlate);
                dto.setLatitude(latestLoc.getLatitude());
                dto.setLongitude(latestLoc.getLongitude());
                dto.setRouteNumber(routeNumber);
                dto.setRouteName(routeName);
                dto.setTripStatus("RUNNING");
                dto.setCurrentStop(currentStopName);
                dto.setNextStop(nextStopName);
                dto.setPassengerCount(passengerCount);
                dto.setSpeed(speed);

                result.add(dto);

            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return result;
    }

    private double calculateHaversineDistance(double lat1, double lon1,
            double lat2, double lon2) {

        final int R = 6371; // km

        double dLat = Math.toRadians(lat2 - lat1);
        double dLon = Math.toRadians(lon2 - lon1);

        double a = Math.sin(dLat / 2) * Math.sin(dLat / 2)
                + Math.cos(Math.toRadians(lat1))
                * Math.cos(Math.toRadians(lat2))
                * Math.sin(dLon / 2)
                * Math.sin(dLon / 2);

        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

        return R * c;
    }
}
