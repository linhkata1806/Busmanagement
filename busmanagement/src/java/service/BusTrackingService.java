package service;

import dal.BusDAO;
import dal.BusLocationHistoryDAO;
import dal.RouteStopDAO;
import dal.TicketDAO;
import dal.TripDAO;
import dto.BusLocationDTO;
import dto.RouteStopDTO;
import dto.TripDTO;
import model.Bus;
import model.BusLocationHistory;
import model.Trip;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class BusTrackingService {

    private static final double SPEED_METERS_PER_SECOND = 5.0;
    private static final double FINISH_DISTANCE_KM = 0.15;

    private final TripDAO tripDAO = new TripDAO();
    private final BusLocationHistoryDAO locationDAO = new BusLocationHistoryDAO();
    private final TicketDAO ticketDAO = new TicketDAO();
    private final BusDAO busDAO = new BusDAO();
    private final RouteStopDAO routeStopDAO = new RouteStopDAO();

    public List<BusLocationDTO> getRunningBusesLocations() {
        List<BusLocationDTO> result = new ArrayList<>();

        List<TripDTO> runningTrips
                = tripDAO.searchTrips(null, 0, null, "IN_PROGRESS");

        if (runningTrips == null || runningTrips.isEmpty()) {
            return result;
        }

        // Tránh query lại danh sách trạm nhiều lần nếu nhiều xe cùng route.
        Map<Integer, List<RouteStopDTO>> routeStopsCache = new HashMap<>();

        for (TripDTO tripDTO : runningTrips) {
            try {
                processRunningTrip(tripDTO, result, routeStopsCache);
            } catch (Exception e) {
                System.err.println(
                        "Lỗi xử lý tracking cho TripID: "
                        + tripDTO.getTripID()
                );
                e.printStackTrace();
            }
        }

        return result;
    }

    private void processRunningTrip(
            TripDTO tripDTO,
            List<BusLocationDTO> result,
            Map<Integer, List<RouteStopDTO>> routeStopsCache
    ) {
        BusLocationHistory latestLoc
                = locationDAO.getLatestByTrip(tripDTO.getTripID());

        if (latestLoc == null) {
            System.out.println(
                    "Không có GPS cho Trip " + tripDTO.getTripID()
            );
            return;
        }

        Trip tripEntity = tripDAO.getById(tripDTO.getTripID());

        if (tripEntity == null) {
            System.out.println(
                    "Không tìm thấy TripEntity cho Trip "
                    + tripDTO.getTripID()
            );
            return;
        }

        int routeID = tripEntity.getRouteID();

        List<RouteStopDTO> stops = routeStopsCache.computeIfAbsent(
                routeID,
                routeStopDAO::getStopsByRoute
        );

        double displayLat = latestLoc.getLatitude();
        double displayLng = latestLoc.getLongitude();

        long elapsedSeconds = 0;
        double distanceTraveled = 0.0;
        double totalRouteDistance = 0.0;
        System.out.println("========== CHECK MOVE CONDITION ==========");
        System.out.println("TripID = " + tripDTO.getTripID());
        System.out.println("ActualStartTime = " + tripEntity.getActualStartTime());
        System.out.println("Stops null = " + (stops == null));
        System.out.println("Stops size = " + (stops == null ? -1 : stops.size()));
        if (tripEntity.getActualStartTime() != null
                && stops != null
                && stops.size() >= 2) {

            elapsedSeconds = Math.max(
                    0,
                    (System.currentTimeMillis()
                    - tripEntity.getActualStartTime().getTime()) / 1000
            );

            distanceTraveled
                    = elapsedSeconds * SPEED_METERS_PER_SECOND;

            PositionResult positionResult
                    = calculateSimulatedPosition(stops, distanceTraveled);

            displayLat = positionResult.latitude;
            displayLng = positionResult.longitude;
            totalRouteDistance = positionResult.totalRouteDistanceMeters;

            System.out.println("====== MOVE BUS ======");
            System.out.println("Trip = " + tripDTO.getTripID());
            System.out.println(
                    "Start = " + tripEntity.getActualStartTime()
            );
            System.out.println("Elapsed = " + elapsedSeconds);
            System.out.println(
                    "Distance traveled = " + distanceTraveled
            );
            System.out.println(
                    "Total route distance = " + totalRouteDistance
            );
            System.out.println("DISPLAY LAT = " + displayLat);
            System.out.println("DISPLAY LNG = " + displayLng);
        }

        /*
         * Kiểm tra kết thúc chuyến bằng TỌA ĐỘ HIỂN THỊ,
         * không dùng latestLoc vì latestLoc là GPS cũ trong database.
         */
        if (stops != null && !stops.isEmpty()) {
            RouteStopDTO lastStop = stops.get(stops.size() - 1);

            double distanceToLastStop = calculateHaversineDistance(
                    displayLat,
                    displayLng,
                    lastStop.getLatitude(),
                    lastStop.getLongitude()
            );

            boolean traveledWholeRoute
                    = totalRouteDistance > 0
                    && distanceTraveled >= totalRouteDistance;

            if (traveledWholeRoute
                    && distanceToLastStop <= FINISH_DISTANCE_KM) {

                tripDAO.finishTripActual(
                        tripDTO.getTripID(),
                        new Timestamp(System.currentTimeMillis())
                );

                System.out.println(
                        "Trip " + tripDTO.getTripID()
                        + " đã đến bến. Chuyển trạng thái COMPLETED."
                );

                return;
            }
        }

        int passenger = ticketDAO.countTicketsByTripAndStatus(
                tripDTO.getTripID(),
                "CHECKED_IN"
        );

        // ETA phải dùng tọa độ đang trả về cho frontend.
        int eta = calculateETA(displayLat, displayLng, stops);

        int capacity = 60;

        List<Bus> foundBuses = busDAO.searchAndFilter(
                tripDTO.getBusPlate(),
                "ALL"
        );

        if (foundBuses != null && !foundBuses.isEmpty()) {
            capacity = foundBuses.get(0).getCapacity();
        }

        System.out.println("========== BEFORE DTO ==========");
        System.out.println("TripID = " + tripDTO.getTripID());
        System.out.println("LAT = " + displayLat);
        System.out.println("LNG = " + displayLng);

        result.add(
                new BusLocationDTO(
                        tripDTO.getTripID(),
                        tripDTO.getRouteNumber(),
                        tripDTO.getBusPlate(),
                        displayLat,
                        displayLng,
                        passenger,
                        capacity,
                        eta
                )
        );
    }

    /**
     * Tính vị trí mô phỏng của xe trên các đoạn nối giữa các trạm.
     *
     * Lưu ý: đây vẫn là nội suy đường thẳng giữa các stop. Muốn marker bám đúng
     * đường giao thông cần route shape/polyline.
     */
    private PositionResult calculateSimulatedPosition(
            List<RouteStopDTO> stops,
            double distanceTraveledMeters
    ) {
        double totalRouteDistance = calculateTotalRouteDistance(stops);

        RouteStopDTO firstStop = stops.get(0);

        if (distanceTraveledMeters <= 0) {
            return new PositionResult(
                    firstStop.getLatitude(),
                    firstStop.getLongitude(),
                    totalRouteDistance
            );
        }

        double accumulatedDistance = 0.0;

        for (int i = 0; i < stops.size() - 1; i++) {
            RouteStopDTO stop1 = stops.get(i);
            RouteStopDTO stop2 = stops.get(i + 1);

            double distSegment = calculateHaversineDistance(
                    stop1.getLatitude(),
                    stop1.getLongitude(),
                    stop2.getLatitude(),
                    stop2.getLongitude()
            ) * 1000.0;

            if (distSegment <= 0.001) {
                continue;
            }

            double segmentEndDistance
                    = accumulatedDistance + distSegment;

            if (distanceTraveledMeters <= segmentEndDistance) {
                double remainingDistance
                        = distanceTraveledMeters - accumulatedDistance;

                double ratio = remainingDistance / distSegment;
                ratio = Math.max(0.0, Math.min(1.0, ratio));

                double latitude
                        = stop1.getLatitude()
                        + (stop2.getLatitude()
                        - stop1.getLatitude()) * ratio;

                double longitude
                        = stop1.getLongitude()
                        + (stop2.getLongitude()
                        - stop1.getLongitude()) * ratio;

                return new PositionResult(
                        latitude,
                        longitude,
                        totalRouteDistance
                );
            }

            accumulatedDistance = segmentEndDistance;
        }

        RouteStopDTO lastStop = stops.get(stops.size() - 1);

        return new PositionResult(
                lastStop.getLatitude(),
                lastStop.getLongitude(),
                totalRouteDistance
        );
    }

    private double calculateTotalRouteDistance(
            List<RouteStopDTO> stops
    ) {
        if (stops == null || stops.size() < 2) {
            return 0.0;
        }

        double totalDistanceMeters = 0.0;

        for (int i = 0; i < stops.size() - 1; i++) {
            RouteStopDTO stop1 = stops.get(i);
            RouteStopDTO stop2 = stops.get(i + 1);

            double segmentDistanceMeters
                    = calculateHaversineDistance(
                            stop1.getLatitude(),
                            stop1.getLongitude(),
                            stop2.getLatitude(),
                            stop2.getLongitude()
                    ) * 1000.0;

            if (segmentDistanceMeters > 0.001) {
                totalDistanceMeters += segmentDistanceMeters;
            }
        }

        return totalDistanceMeters;
    }

    /**
     * ETA tới trạm gần nhất.
     */
    private int calculateETA(
            double currentLat,
            double currentLng,
            List<RouteStopDTO> stops
    ) {
        if (stops == null || stops.isEmpty()) {
            return 0;
        }

        double minDistance = Double.MAX_VALUE;

        for (RouteStopDTO stop : stops) {
            double distance = calculateHaversineDistance(
                    currentLat,
                    currentLng,
                    stop.getLatitude(),
                    stop.getLongitude()
            );

            if (distance < minDistance) {
                minDistance = distance;
            }
        }

        double averageSpeedKmH = 30.0;
        double timeInHours = minDistance / averageSpeedKmH;
        int etaMinutes = (int) Math.round(timeInHours * 60);

        return Math.max(1, etaMinutes);
    }

    /**
     * Khoảng cách Haversine, đơn vị km.
     */
    private double calculateHaversineDistance(
            double lat1,
            double lon1,
            double lat2,
            double lon2
    ) {
        final int EARTH_RADIUS_KM = 6371;

        double latDistance = Math.toRadians(lat2 - lat1);
        double lonDistance = Math.toRadians(lon2 - lon1);

        double a
                = Math.sin(latDistance / 2)
                * Math.sin(latDistance / 2)
                + Math.cos(Math.toRadians(lat1))
                * Math.cos(Math.toRadians(lat2))
                * Math.sin(lonDistance / 2)
                * Math.sin(lonDistance / 2);

        double c = 2 * Math.atan2(
                Math.sqrt(a),
                Math.sqrt(1 - a)
        );

        return EARTH_RADIUS_KM * c;
    }

    private static class PositionResult {

        private final double latitude;
        private final double longitude;
        private final double totalRouteDistanceMeters;

        private PositionResult(
                double latitude,
                double longitude,
                double totalRouteDistanceMeters
        ) {
            this.latitude = latitude;
            this.longitude = longitude;
            this.totalRouteDistanceMeters
                    = totalRouteDistanceMeters;
        }
    }
}
