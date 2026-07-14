package service;

import dal.TripDAO;
import dal.RouteDAO;
import dal.BusDAO;
import dal.AccountDAO;
import dal.BusLocationHistoryDAO;
import dal.RouteStopDAO;
import dto.RouteStopDTO;
import dto.TripDTO;
import enums.TripStatus;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import model.BusLocationHistory;
import model.Trip;

public class TripService {

    private TripDAO tripDAO;
    private RouteDAO routeDAO;
    private BusDAO busDAO;
    private AccountDAO accountDAO;
    private RouteStopDAO routeStopDAO;
    private BusLocationHistoryDAO locationDAO;

    public TripService() {
        tripDAO = new TripDAO();
        routeDAO = new RouteDAO();
        busDAO = new BusDAO();
        accountDAO = new AccountDAO();
        routeStopDAO = new RouteStopDAO();
        locationDAO = new BusLocationHistoryDAO();
    }

    public List<TripDTO> getAllTrips() throws Exception {
        return tripDAO.searchTrips(null, -1, null, null);
    }

    public List<TripDTO> searchTrips(String date, int routeID, String plate, String status) {
        return tripDAO.searchTrips(date, routeID, plate, status);
    }

    public Trip getTripById(int tripID) {
        return tripDAO.getById(tripID);
    }

    /**
     * Lấy TripDTO (đã JOIN route name, bus plate, driver name) theo TripID.
     * Dùng để hiển thị thông tin có ý nghĩa (không dùng raw ID) trong trang chi
     * tiết chuyến xe.
     */
    public TripDTO getTripDTOById(int tripID) {
        return tripDAO.getTripDTOById(tripID);
    }

    public int countTripsToday() {
        return tripDAO.countTripsToday();
    }

    // CREATE TRIP
    public void createTrip(int routeID, int busID, int driverID, Integer assistantID,
            LocalDate tripDate, LocalTime startTime, LocalTime endTime, int direction) throws Exception {

        // Thực hiện quét toàn bộ lỗi bảo mật và trùng lịch (excludeTripID = null khi tạo mới)
        validateTripBusinessRules(routeID, busID, driverID, assistantID, tripDate, startTime, endTime, direction, null);

        Trip trip = new Trip();
        trip.setRouteID(routeID);
        trip.setBusID(busID);
        trip.setDriverID(driverID);
        trip.setAssistantID(assistantID);
        trip.setTripDate(tripDate);
        trip.setStartTime(startTime);
        trip.setEndTime(endTime);
        trip.setDirection(direction);
        trip.setStatus(TripStatus.SCHEDULED);

        if (!tripDAO.insert(trip)) {
            throw new Exception("Lỗi hệ thống: Không thể lưu chuyến xe vào cơ sở dữ liệu.");
        }
    }

    // UPDATE TRIP
    public void updateTrip(
            int tripID,
            int routeID,
            int busID,
            int driverID,
            Integer assistantID,
            LocalDate tripDate,
            LocalTime startTime,
            LocalTime endTime,
            int direction,
            String status
    ) throws Exception {

        // 1. Lấy chuyến xe gốc trước để kiểm tra trạng thái hiện tại
        Trip trip = tripDAO.getById(tripID);

        if (trip == null) {
            throw new IllegalArgumentException(
                    "Chuyến xe cần cập nhật không tồn tại."
            );
        }

        // 2. Dùng Try-Catch ép kiểu trạng thái mới để chống F12 gửi status rác
        TripStatus newStatus;

        try {
            newStatus = TripStatus.valueOf(status);
        } catch (Exception e) {
            throw new IllegalArgumentException(
                    "Trạng thái gửi lên không hợp lệ."
            );
        }

        // 3. Chuyến xe đã HOÀN THÀNH hoặc ĐÃ HỦY thì khóa hồ sơ, không cho sửa nữa
        if (trip.getStatus() == TripStatus.COMPLETED
                || trip.getStatus() == TripStatus.CANCELLED) {

            throw new IllegalArgumentException(
                    "Thao tác từ chối: Không thể chỉnh sửa chuyến xe đã Hoàn thành hoặc Đã hủy."
            );
        }

        // 4. Không cho chuyển thẳng từ SCHEDULED sang COMPLETED
        // Vì COMPLETED phải đi qua IN_PROGRESS để có ActualStartTime trước
        if (trip.getStatus() == TripStatus.SCHEDULED
                && newStatus == TripStatus.COMPLETED) {

            throw new IllegalArgumentException(
                    "Không thể chuyển trực tiếp từ SCHEDULED sang COMPLETED. Chuyến xe phải bắt đầu trước."
            );
        }

        // 5. Validate nghiệp vụ cơ bản: tuyến, xe, tài xế, phụ xe, thời gian, chiều chạy, trùng lịch
        // excludeTripID = tripID để khi update không bị check trùng với chính chuyến hiện tại
        validateTripBusinessRules(
                routeID,
                busID,
                driverID,
                assistantID,
                tripDate,
                startTime,
                endTime,
                direction,
                tripID
        );

        // 6. Nếu chuyến xe đang chạy thì chỉ cho phép kết thúc chuyến
        // Không cho đổi tuyến, xe, tài xế, phụ xe, ngày, giờ, chiều chạy
        if (trip.getStatus() == TripStatus.IN_PROGRESS) {

            // Không cho lùi trạng thái từ đang chạy về chuẩn bị hoặc hủy
            if (newStatus == TripStatus.CANCELLED
                    || newStatus == TripStatus.SCHEDULED) {

                throw new IllegalArgumentException(
                        "Lỗi logic: Xe ĐANG VẬN HÀNH trên đường, không thể chuyển về trạng thái Hủy hoặc Chuẩn bị."
                );
            }

            // Đang chạy thì không được đổi tuyến
            if (trip.getRouteID() != routeID) {
                throw new IllegalArgumentException(
                        "Cảnh báo: Không thể thay đổi Tuyến đường khi chuyến xe đang lăn bánh!"
                );
            }

            // Đang chạy thì không được đổi xe buýt
            if (trip.getBusID() != busID) {
                throw new IllegalArgumentException(
                        "Cảnh báo: Không thể thay đổi Xe buýt khi chuyến xe đang lăn bánh!"
                );
            }

            // Đang chạy thì không được đổi tài xế
            if (trip.getDriverID() != driverID) {
                throw new IllegalArgumentException(
                        "Cảnh báo: Không thể thay đổi Tài xế khi chuyến xe đang lăn bánh!"
                );
            }

            // Đang chạy thì không được đổi phụ xe
            if ((trip.getAssistantID() == null && assistantID != null)
                    || (trip.getAssistantID() != null
                    && !trip.getAssistantID().equals(assistantID))) {

                throw new IllegalArgumentException(
                        "Cảnh báo: Không thể thay đổi Phụ xe khi chuyến xe đang lăn bánh!"
                );
            }

            // Đang chạy thì không được đổi ngày chạy
            if (!trip.getTripDate().equals(tripDate)) {
                throw new IllegalArgumentException(
                        "Cảnh báo: Không thể thay đổi Ngày chạy khi chuyến xe đang lăn bánh!"
                );
            }

            // Đang chạy thì không được đổi giờ dự kiến
            if (!trip.getStartTime().equals(startTime)
                    || !trip.getEndTime().equals(endTime)) {

                throw new IllegalArgumentException(
                        "Cảnh báo: Không thể thay đổi Khung giờ khi chuyến xe đang lăn bánh!"
                );
            }

            // Đang chạy thì không được đổi chiều chạy
            if (trip.getDirection() != direction) {
                throw new IllegalArgumentException(
                        "Cảnh báo: Không thể thay đổi Chiều chạy khi chuyến xe đang lăn bánh!"
                );
            }
        }

        // 7. Xác định có phải thao tác bắt đầu chuyến hay không
        boolean isStartingTrip
                = newStatus == TripStatus.IN_PROGRESS
                && trip.getStatus() != TripStatus.IN_PROGRESS;

        // 8. Xác định có phải thao tác kết thúc chuyến hay không
        boolean isEndingTrip
                = newStatus == TripStatus.COMPLETED
                && trip.getStatus() == TripStatus.IN_PROGRESS;

        // 9. Khi bắt đầu chuyến, chỉ cho phép chuyến thuộc ngày hôm nay
        if (isStartingTrip) {

            LocalDate operationalToday = LocalDate.now();

            if (!tripDate.equals(operationalToday)) {
                throw new IllegalArgumentException(
                        "Thao tác từ chối: Chỉ có thể kích hoạt IN_PROGRESS cho các chuyến xe thuộc ngày vận hành hôm nay."
                );
            }

            // Tài xế không được đang chạy chuyến khác
            if (tripDAO.isDriverCurrentlyDriving(driverID, tripID)) {
                throw new IllegalArgumentException(
                        "Xung đột nhân sự: Tài xế này đang vận hành một chuyến xe khác chưa kết thúc!"
                );
            }

            // Xe buýt không được đang chạy chuyến khác
            if (tripDAO.isBusCurrentlyRunning(busID, tripID)) {
                throw new IllegalArgumentException(
                        "Xung đột thiết bị: Xe buýt này đang chạy một chuyến khác chưa về bến!"
                );
            }
        }

        // 10. Set lại thông tin chuyến xe sau khi đã qua toàn bộ validate
        trip.setRouteID(routeID);
        trip.setBusID(busID);
        trip.setDriverID(driverID);
        trip.setAssistantID(assistantID);
        trip.setTripDate(tripDate);
        trip.setStartTime(startTime);
        trip.setEndTime(endTime);
        trip.setDirection(direction);

        /*
     * 11. Trường hợp bắt đầu chuyến:
     * Không dùng tripDAO.update() để chuyển thẳng sang IN_PROGRESS
     * vì IN_PROGRESS phải đồng thời set ActualStartTime.
         */
        if (isStartingTrip) {

            // Giữ nguyên status cũ để update thông tin chuyến trước
            TripStatus oldStatus = trip.getStatus();
            trip.setStatus(oldStatus);

            if (!tripDAO.update(trip)) {
                throw new Exception(
                        "Lỗi hệ thống: Không thể cập nhật thông tin chuyến xe."
                );
            }

            // Sau đó mới chính thức bắt đầu chuyến và set ActualStartTime
            Timestamp actualStart
                    = new Timestamp(System.currentTimeMillis());

            boolean started = tripDAO.startTripActual(
                    tripID,
                    actualStart
            );

            if (!started) {
                throw new Exception(
                        "Lỗi hệ thống: Không thể bắt đầu chuyến xe."
                );
            }

            // Tạo GPS ban đầu theo đúng chiều chạy
            List<RouteStopDTO> stops
                    = routeStopDAO.getStopsByRoute(routeID);

            if (stops != null && !stops.isEmpty()) {

                RouteStopDTO startStop;

                if (direction == 1) {
                    // Chiều đi: lấy trạm đầu
                    startStop = stops.get(0);
                } else {
                    // Chiều về: lấy trạm cuối
                    startStop = stops.get(stops.size() - 1);
                }

                BusLocationHistory loc
                        = new BusLocationHistory();

                loc.setBusID(busID);
                loc.setTripID(tripID);
                loc.setLatitude(startStop.getLatitude());
                loc.setLongitude(startStop.getLongitude());

                locationDAO.insert(loc);
            }

            return;
        }

        /*
     * 12. Trường hợp kết thúc chuyến:
     * Không dùng tripDAO.update() đơn thuần
     * vì COMPLETED phải đồng thời set ActualEndTime.
         */
        if (isEndingTrip) {

            Timestamp actualEnd
                    = new Timestamp(System.currentTimeMillis());

            boolean ended = tripDAO.finishTripActual(
                    tripID,
                    actualEnd
            );

            if (!ended) {
                throw new Exception(
                        "Lỗi hệ thống: Không thể kết thúc chuyến xe."
                );
            }

            return;
        }

        /*
     * 13. Các trường hợp update bình thường:
     * Ví dụ sửa thông tin chuyến SCHEDULED, hoặc giữ nguyên trạng thái.
         */
        trip.setStatus(newStatus);

        if (!tripDAO.update(trip)) {
            throw new Exception(
                    "Lỗi hệ thống: Không thể cập nhật thông tin chuyến xe."
            );
        }
    }

    public void deleteTrip(int tripID) throws Exception {
        Trip trip = tripDAO.getById(tripID);

        // Validate 1: Trip không tồn tại
        if (trip == null) {
            throw new IllegalArgumentException("Thao tác bị từ chối: Chuyến xe không tồn tại trên hệ thống.");
        }

        // Validate 2: Trạng thái không hợp lệ
        if (trip.getStatus() != TripStatus.SCHEDULED) {
            throw new IllegalArgumentException("Thao tác bị từ chối: Chỉ được phép xóa các chuyến xe chưa khởi hành (SCHEDULED). Chuyến xe này đang chạy hoặc đã hoàn thành.");
        }

        // Thực thi xóa
        if (!tripDAO.delete(tripID)) {
            throw new Exception("Lỗi Database khi thực thi lệnh xóa."); // Lỗi này sẽ bị bắt bởi Exception chung và che giấu
        }
    }

    private void validateTripBusinessRules(int routeID, int busID, int driverID, Integer assistantID,
            LocalDate tripDate, LocalTime startTime, LocalTime endTime,
            int direction, Integer excludeTripID) {

        if (tripDate == null) {
            throw new IllegalArgumentException("Vui lòng chọn ngày chạy.");
        }

        if (tripDate.isBefore(LocalDate.now())) {
            throw new IllegalArgumentException(
                    "Không thể tạo chuyến xe cho ngày trong quá khứ."
            );
        }
        if (startTime == null) {
            throw new IllegalArgumentException("Vui lòng chọn giờ xuất phát.");
        }

        if (endTime == null) {
            throw new IllegalArgumentException("Vui lòng chọn giờ cập bến.");
        }
        // 1. Kiểm tra logic mốc thời gian
        if (!startTime.isBefore(endTime)) {
            throw new IllegalArgumentException("Khung giờ không hợp lệ: Giờ xuất phát phải nhỏ hơn giờ cập bến dự kiến.");
        }
        if (tripDate.equals(LocalDate.now())
                && startTime.isBefore(LocalTime.now())) {
            throw new IllegalArgumentException(
                    "Không thể tạo chuyến có giờ xuất phát đã qua."
            );
        }

        // 2. Test Driver != Assistant (Tránh trường hợp tự phân vai cho chính mình)
        if (assistantID != null && driverID == assistantID) {
            throw new IllegalArgumentException("Vi phạm phân bổ: Nhân sự tài xế và phụ xe không thể là cùng một người.");
        }

        // 3. Chiều chạy phải hợp lệ
        if (direction != 1 && direction != 2) {
            throw new IllegalArgumentException("Dữ liệu sai lệch: Chiều chạy của xe buýt bắt buộc phải là Lượt đi (1) hoặc Lượt về (2).");
        }

        // 4. Test Route Inactive (Chặn bypass qua HTML)
        model.Route route = routeDAO.getRouteById(routeID);

        if (route == null || !route.isIsActive()) {
            throw new IllegalArgumentException(
                    "Yêu cầu bị từ chối: Tuyến đường này không khả dụng hoặc đã bị ngừng hoạt động."
            );
        }

        // 5. Test Bus Maintenance / Inactive
        model.Bus bus = busDAO.getBusById(busID);
        if (bus == null) {
            throw new IllegalArgumentException("Thiết bị không tồn tại: Không tìm thấy xe buýt tương ứng trên hệ thống.");
        }
        if (bus.getStatus() != enums.BusStatus.ACTIVE) {
            throw new IllegalArgumentException("Phương tiện từ chối vận hành: Xe buýt " + bus.getLicensePlate() + " hiện đang bảo trì hoặc không ở trạng thái sẵn sàng chạy.");
        }

        // 6. Xác thực danh tính & vai trò Tài xế
        model.Account driver = accountDAO.getAccountById(driverID);
        if (driver == null || !driver.isActive()) {
            throw new IllegalArgumentException("Hồ sơ không hợp lệ: Tài xế không tồn tại hoặc tài khoản đã bị vô hiệu hóa.");
        }
        if (driver.getRoleID() != 3) { // Giả định RoleID = 3 là Driver
            throw new IllegalArgumentException("Sai lệch thẩm quyền: Tài khoản phụ trách chính không có vai trò của một Tài xế.");
        }

        // 7. Xác thực danh tính & vai trò Phụ xe (Nếu có bố trí)
        if (assistantID != null) {
            model.Account assistant = accountDAO.getAccountById(assistantID);
            if (assistant == null || !assistant.isActive()) {
                throw new IllegalArgumentException("Hồ sơ không hợp lệ: Nhân viên phụ xe được chỉ định không tồn tại hoặc tài khoản bị khóa.");
            }
            if (assistant.getRoleID() != 4) { // Giả định RoleID = 4 là Assistant
                throw new IllegalArgumentException("Sai lệch thẩm quyền: Nhân sự trợ lý không có vai trò của một Phụ xe xe buýt.");
            }
        }

        // 8. Test Trùng lịch vận hành (Kiểm tra giao thoa thời gian)
        if (tripDAO.hasDriverConflict(driverID, tripDate, startTime, endTime, excludeTripID)) {
            throw new IllegalArgumentException("Xung đột lịch trình: Tài xế đã được phân công chạy một chuyến xe khác trong khung giờ này.");
        }
        if (tripDAO.hasBusConflict(busID, tripDate, startTime, endTime, excludeTripID)) {
            throw new IllegalArgumentException("Xung đột phương tiện: Xe buýt " + bus.getLicensePlate() + " đã được đăng ký chạy một chuyến khác cùng khung giờ.");
        }
        if (assistantID != null && tripDAO.hasAssistantConflict(assistantID, tripDate, startTime, endTime, excludeTripID)) {
            throw new IllegalArgumentException("Xung đột lịch trình: Nhân viên phụ xe này đã vướng lịch công tác ở một chuyến chạy khác.");
        }
    }

    public List<TripDTO> getTripsByAssistant(int assistantID) {
        return tripDAO.getTripsByAssistant(assistantID);
    }

    public List<TripDTO> getTripsByDriver(int driverID) {
        return tripDAO.getTripsByDriver(driverID);
    }

    public TripDTO getTripDTOByIDAndDriver(int tripID, int driverID) {
        return tripDAO.getTripByIDAndDriver(tripID, driverID);
    }
}
