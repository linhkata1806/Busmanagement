package service;

import dal.TripDAO;
import dal.RouteDAO;
import dal.BusDAO;
import dal.AccountDAO;
import dto.TripDTO;
import enums.TripStatus;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import model.Trip;

public class TripService {

    private TripDAO tripDAO;
    private RouteDAO routeDAO;
    private BusDAO busDAO;
    private AccountDAO accountDAO;

    public TripService() {
        tripDAO = new TripDAO();
        routeDAO = new RouteDAO();
        busDAO = new BusDAO();
        accountDAO = new AccountDAO();
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
    public void updateTrip(int tripID, int routeID, int busID, int driverID, Integer assistantID,
            LocalDate tripDate, LocalTime startTime, LocalTime endTime,
            int direction, String status) throws Exception {

        // Thực hiện quét toàn bộ lỗi bảo mật và trùng lịch (truyền tripID hiện tại để loại trừ kiểm tra chính nó)
        validateTripBusinessRules(routeID, busID, driverID, assistantID, tripDate, startTime, endTime, direction, tripID);

        Trip trip = tripDAO.getById(tripID);
        if (trip == null) {
            throw new IllegalArgumentException("Chuyến xe cần cập nhật không tồn tại.");
        }

        // 1. Dùng Try-Catch ép kiểu trạng thái mới để chống F12 
        TripStatus newStatus;
        try {
            newStatus = TripStatus.valueOf(status);
        } catch (Exception e) {
            throw new IllegalArgumentException("Trạng thái gửi lên không hợp lệ.");
        }
        // 1. Nếu chuyến xe cũ đã HOÀN THÀNH (COMPLETED)
        if (trip.getStatus() == TripStatus.COMPLETED) {
            // Cấm tuyệt đối không cho đổi sang bất kỳ trạng thái nào khác (kể cả Admin)
            if (newStatus != TripStatus.COMPLETED) {
                throw new IllegalArgumentException("Thao tác bị từ chối: Chuyến xe đã HOÀN THÀNH, hồ sơ đã bị niêm phong và không thể thay đổi trạng thái!");
            }
            // Đã hoàn thành rồi thì cũng cấm sửa bất kỳ thông tin nào khác của chuyến xe
            if (trip.getBusID() != busID || trip.getDriverID() != driverID || trip.getRouteID() != routeID || !trip.getTripDate().equals(tripDate)) {
                throw new IllegalArgumentException("Thao tác bị từ chối: Không được phép chỉnh sửa thông tin của một chuyến xe đã hoàn thành.");
            }
        }

        // 2. Chuyến xe đã Hoàn thành hoặc Đã hủy
        if (trip.getStatus() == TripStatus.COMPLETED || trip.getStatus() == TripStatus.CANCELLED) {
            throw new IllegalArgumentException("Thao tác từ chối: Không thể chỉnh sửa chuyến xe đã Hoàn thành hoặc Đã hủy.");
        }

        // 3. Chuyến xe ĐANG CHẠY (IN_PROGRESS) 
        if (trip.getStatus() == TripStatus.IN_PROGRESS) {
            // Chặn đổi trạng thái lùi
            if (newStatus == TripStatus.CANCELLED || newStatus == TripStatus.SCHEDULED) {
                throw new IllegalArgumentException("Lỗi logic: Xe ĐANG VẬN HÀNH trên đường, không thể chuyển về trạng thái Hủy hoặc Chuẩn bị.");
            }
            // Chặn(Đang chạy thì cấm đổi Xe, cấm đổi Tài xế, Tuyến đường)
            if (trip.getRouteID() != routeID) {
                throw new IllegalArgumentException("Cảnh báo: Không thể thay đổi Tuyến đường khi chuyến xe đang lăn bánh!");
            }
        }
        if (newStatus == TripStatus.IN_PROGRESS && trip.getStatus() != TripStatus.IN_PROGRESS) {

            // Lỗi 1: Ép chạy chuyến ở tương lai hoặc quá khứ
            // (Lưu ý: Nếu xe bạn có chạy đêm qua 00:00, hãy  lùi 4 tiếng 
            LocalDate operationalToday = LocalDate.now();
            if (!tripDate.equals(operationalToday)) {
                throw new IllegalArgumentException("Thao tác từ chối: Chỉ có thể kích hoạt IN_PROGRESS cho các chuyến xe thuộc ngày vận hành hôm nay.");
            }

            // Lỗi 2: Tài xế đang bị kẹt ở chuyến khác
            if (tripDAO.isDriverCurrentlyDriving(driverID, tripID)) {
                throw new IllegalArgumentException("Xung đột nhân sự: Tài xế này đang vận hành một chuyến xe khác chưa kết thúc!");
            }

            // Lỗi 3: Xe buýt đang bị kẹt ở chuyến khác
            if (tripDAO.isBusCurrentlyRunning(busID, tripID)) {
                throw new IllegalArgumentException("Xung đột thiết bị: Xe buýt này đang chạy một chuyến khác chưa về bến!");
            }
        }

        trip.setRouteID(routeID);
        trip.setBusID(busID);
        trip.setDriverID(driverID);
        trip.setAssistantID(assistantID);
        trip.setTripDate(tripDate);
        trip.setStartTime(startTime);
        trip.setEndTime(endTime);
        trip.setDirection(direction);
        trip.setStatus(TripStatus.valueOf(status));

        if (!tripDAO.update(trip)) {
            throw new Exception("Lỗi hệ thống: Không thể cập nhật thông tin chuyến xe.");
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

        // 1. Kiểm tra logic mốc thời gian
        if (startTime != null && endTime != null && !startTime.isBefore(endTime)) {
            throw new IllegalArgumentException("Khung giờ không hợp lệ: Giờ xuất phát phải nhỏ hơn giờ cập bến dự kiến.");
        }

        // 2. Test Driver != Assistant (Tránh trường hợp tự phân vai cho chính mình)
        if (assistantID != null && driverID == assistantID.intValue()) {
            throw new IllegalArgumentException("Vi phạm phân bổ: Nhân sự tài xế và phụ xe không thể là cùng một người.");
        }

        // 3. Chiều chạy phải hợp lệ
        if (direction != 1 && direction != 2) {
            throw new IllegalArgumentException("Dữ liệu sai lệch: Chiều chạy của xe buýt bắt buộc phải là Lượt đi (1) hoặc Lượt về (2).");
        }

        // 4. Test Route Inactive (Chặn bypass qua HTML)
        model.Route route = routeDAO.getRouteById(routeID);
        // Vì RouteDAO.getRouteById đã lọc sẵn WHERE IsActive = 1 nên nếu trả về null tức là tuyến không tồn tại hoặc đã bị khóa.
        if (route == null && !route.isIsActive()) {
            throw new IllegalArgumentException("Yêu cầu bị từ chối: Tuyến đường này không khả dụng hoặc đã bị ngừng hoạt động (Inactive).");
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
