/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.BusDAO;
import dal.TripDAO;
import enums.BusStatus;
import java.util.Arrays;
import java.util.List;
import model.Bus;

/**
 *
 * @author Administrator
 */
public class BusService {

    private BusDAO busDAO;
    private TripDAO tripDAO;

    public BusService() {
        busDAO = new BusDAO();
        tripDAO = new TripDAO();
    }

    public List<Bus> getAllActiveBuses() {
        return busDAO.getAllActiveBuses();
    }

    public List<Bus> searchAndFilter(String keyword, String status) {
        if (keyword == null) {
            keyword = "";
        }
        keyword = keyword.trim();

        if (status == null || status.trim().isEmpty()) {
            status = "ALL";
        }

        // tham số trên URL
        if (!status.equals("ALL") && !status.equals("ACTIVE")
                && !status.equals("MAINTENANCE") && !status.equals("INACTIVE")) {
            status = "ALL";
        }

        return busDAO.searchAndFilter(keyword, status);

    }

    public void createBus(String licensePlate, String busType, int capacity) {
        if (licensePlate == null || licensePlate.trim().isEmpty()) {
            throw new IllegalArgumentException(
                    "Biển số xe không được để trống.");
        }

        String plate = licensePlate.trim().toUpperCase();

        String regex
                = "^[0-9]{2}[A-Z]{1,2}-([0-9]{5}|[0-9]{3}\\.[0-9]{2})$";

        if (!plate.matches(regex)) {
            throw new IllegalArgumentException(
                    "Biển số xe không hợp lệ. VD: 29B-12345 hoặc 29B-123.45");
        }

        if (busDAO.existsLicensePlate(plate)) {
            throw new IllegalArgumentException(
                    "Biển số xe '" + plate + "' đã tồn tại.");
        }
        if (busType == null || busType.trim().isEmpty()) {
            throw new IllegalArgumentException("Loại phương tiện không được để trống.");
        }

        java.util.List<String> validBusTypes = java.util.Arrays.asList(
                "Bus Thường (Diesel)",
                "VinBus (Điện)",
                "BRT (Bus Nhanh)",
                "Minibus (Cỡ nhỏ)"
        );

        if (!validBusTypes.contains(busType.trim())) {
            throw new IllegalArgumentException("Loại phương tiện không hợp lệ. Vui lòng chọn từ danh sách gợi ý.");
        }

        if (busType.trim().length() > 50) {
            throw new IllegalArgumentException(
                    "Loại xe không được vượt quá 50 ký tự.");
        }

// ===== Validate sức chứa =====
        if (capacity <= 0) {
            throw new IllegalArgumentException(
                    "Sức chứa phải lớn hơn 0.");
        }

// ===== Tạo Bus =====
        Bus bus = new Bus();

        bus.setLicensePlate(plate);
        bus.setBusType(busType.trim());
        bus.setCapacity(capacity);
        bus.setStatus(BusStatus.ACTIVE);

// ===== Insert DB =====
        if (!busDAO.insert(bus)) {
            throw new IllegalStateException(
                    "Không thể lưu phương tiện xuống cơ sở dữ liệu.");
        }
    }

    public Bus getBusById(int busId) {
        try {

            return busDAO.getBusById(busId);
        } catch (Exception e) {
            System.out.println("Lỗi tại getBusById (Service): " + e.getMessage());
            return null;
        }
    }

    public void updateBus(
            int busId,
            String busType,
            int capacity,
            String status
    ) {
        List<String> validBusTypes = Arrays.asList(
                "Bus Thường (Diesel)",
                "VinBus (Điện)",
                "BRT (Bus Nhanh)",
                "Minibus (Cỡ nhỏ)"
        );

        busType = busType == null ? "" : busType.trim();

        if (!validBusTypes.contains(busType)) {
            throw new IllegalArgumentException(
                    "Loại phương tiện không hợp lệ."
            );
        }

        if (capacity <= 0) {
            throw new IllegalArgumentException(
                    "Sức chứa phải là một số nguyên dương lớn hơn 0."
            );
        }

        BusStatus busStatus;

        try {
            busStatus = BusStatus.valueOf(
                    status.trim().toUpperCase()
            );
        } catch (Exception e) {
            throw new IllegalArgumentException(
                    "Trạng thái vận hành không hợp lệ."
            );
        }

        Bus bus = getBusById(busId);

        if (bus == null) {
            throw new IllegalArgumentException(
                    "Không tìm thấy phương tiện với ID "
                    + busId + " để cập nhật."
            );
        }

        bus.setBusType(busType);
        bus.setCapacity(capacity);
        bus.setStatus(busStatus);

        if (!busDAO.update(bus)) {
            throw new RuntimeException(
                    "Không thể cập nhật thông tin phương tiện vào cơ sở dữ liệu."
            );
        }
    }

    public String deleteBus(int busId) throws Exception {
        if (busDAO.getBusById(busId) == null) {
            throw new IllegalArgumentException("Phương tiện không tồn tại!");
        }

        // 2. Kiểm tra lịch sử chuyến đi (Sử dụng hàm vừa thêm ở TripDAO)
        if (tripDAO.existsByBusId(busId)) {

            model.Bus bus = busDAO.getBusById(busId);
            bus.setStatus(enums.BusStatus.INACTIVE); // Chuyển sang INACTIVE

            if (!busDAO.update(bus)) {
                throw new Exception("Lỗi hệ thống: Không thể cập nhật trạng thái phương tiện.");
            }
            return "INACTIVATED";
        }

        // 3. Hard Delete (Nếu chưa từng có Trip)
        // Tái sử dụng phương thức delete từ BusDAO (bạn cần đảm bảo đã có hàm delete trong BusDAO)[cite: 1]
        if (!busDAO.delete(busId)) {
            throw new Exception("Không thể xóa phương tiện khỏi cơ sở dữ liệu.");
        }

        return "DELETED";
    }
}
