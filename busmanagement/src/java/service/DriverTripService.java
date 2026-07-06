package service;

import dal.TripDAO;
import enums.TripStatus;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.temporal.ChronoUnit;
import model.Trip;

public class DriverTripService {

    private TripDAO tripDAO;

    public DriverTripService() {
        this.tripDAO = new TripDAO();
    }

    public void startTrip(int tripID, int driverID) throws Exception {
        Trip trip = tripDAO.getById(tripID);

        if (trip == null) {
            throw new Exception("Chuyến xe không tồn tại.");
        }

        // 1. Validate quyền
        if (trip.getDriverID() != driverID) {
            throw new Exception("Bạn không có quyền bắt đầu chuyến xe của nhân sự khác.");
        }

        // 2. Validate trạng thái
        if (trip.getStatus() != TripStatus.SCHEDULED) {
            throw new Exception("Chuyến xe không ở trạng thái chờ khởi hành.");
        }

        // 3. Validate ngày (Chỉ cho phép chạy trong ngày hôm nay)
        LocalDate today = LocalDate.now();
        if (!trip.getTripDate().equals(today)) {
            throw new Exception("Chỉ có thể bắt đầu chuyến xe trong đúng ngày được phân công.");
        }

        // 4. Validate thời gian (Khoảng thời gian cho phép: -30 phút đến +30 phút so với giờ StartTime)
        LocalTime now = LocalTime.now();
        LocalTime scheduledTime = trip.getStartTime();

        // Tính chênh lệch phút giữa bây giờ và lịch trình
        long minutesDifference = ChronoUnit.MINUTES.between(scheduledTime, now);

        if (minutesDifference < -5) {
            // Sớm hơn 5 phút
            throw new Exception("Chuyến xe chưa tới giờ (chỉ chạy sớm trước 5 phút), chưa thể bắt đầu.");
        } else if (minutesDifference > 30) {
            // Trễ hơn 30 phút
            // (Tuỳ nghiệp vụ, bạn có thể gọi updateTripStatus thành CANCELLED ở đây luôn nếu muốn)
            throw new Exception("Chuyến xe đã lỡ (chỉ chạy sau giờ tối đa 30 phút), liên hệ với nhân viên.");
        }

        // Đủ điều kiện -> Tiến hành bắt đầu chuyến
        Timestamp actualStart = new Timestamp(System.currentTimeMillis());
        boolean isSuccess = tripDAO.startTripActual(tripID, actualStart);

        if (!isSuccess) {
            throw new Exception("Lỗi hệ thống khi cập nhật chuyến xe.");
        }
    }

    // Bổ sung vào service/DriverTripService.java
    public void finishTrip(int tripID, int driverID) throws Exception {
        Trip trip = tripDAO.getById(tripID);

        if (trip == null) {
            throw new Exception("Chuyến xe không tồn tại.");
        }

        // 1. Validate quyền sở hữu chuyến xe
        if (trip.getDriverID() != driverID) {
            throw new Exception("Bạn không có quyền kết thúc chuyến xe của nhân sự khác.");
        }

        // 2. Validate trạng thái (Chỉ xe đang chạy mới được kết thúc)
        if (trip.getStatus() != TripStatus.IN_PROGRESS) {
            throw new Exception("Chuyến xe không ở trạng thái đang chạy, không thể kết thúc.");
        }

        // 3. Tiến hành kết thúc chuyến đi và ghi nhận giờ thực tế
        Timestamp actualEnd = new Timestamp(System.currentTimeMillis());
        boolean isSuccess = tripDAO.finishTripActual(tripID, actualEnd);

        if (!isSuccess) {
            throw new Exception("Lỗi hệ thống khi cập nhật kết thúc chuyến xe.");
        }
    }
}
