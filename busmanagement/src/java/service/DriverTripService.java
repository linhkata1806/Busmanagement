package service;

import dal.TripDAO;
import enums.TripStatus;
import model.Trip;

/**
 * Service xử lý các nghiệp vụ chuyến đi của Tài xế:
 * - Bắt đầu chuyến (startTrip): SCHEDULED -> IN_PROGRESS, ghi ActualStartTime
 * - Kết thúc chuyến (finishTrip): IN_PROGRESS -> COMPLETED, ghi ActualEndTime,
 *   đồng thời cập nhật trạng thái tất cả vé CHECKED_IN của chuyến thành COMPLETED
 */
public class DriverTripService {

    private final TripDAO tripDAO;

    public DriverTripService() {
        this.tripDAO = new TripDAO();
    }

    /**
     * Tài xế bắt đầu chuyến xe.
     * Điều kiện: chuyến phải ở trạng thái SCHEDULED.
     * @param tripID ID của chuyến xe cần bắt đầu
     * @throws Exception nếu chuyến không tồn tại hoặc không ở trạng thái SCHEDULED
     */
    public void startTrip(int tripID) throws Exception {
        Trip trip = tripDAO.getById(tripID);
        if (trip == null) {
            throw new IllegalArgumentException("Chuyến xe #" + tripID + " không tồn tại.");
        }
        if (trip.getStatus() != TripStatus.SCHEDULED) {
            throw new IllegalArgumentException(
                "Không thể bắt đầu chuyến. Trạng thái hiện tại: " + trip.getStatus()
                + " (Chỉ có thể bắt đầu khi SCHEDULED)."
            );
        }
        tripDAO.startTrip(tripID);
    }

    /**
     * Tài xế kết thúc chuyến xe.
     * Điều kiện: chuyến phải ở trạng thái IN_PROGRESS.
     * @param tripID ID của chuyến xe cần kết thúc
     * @throws Exception nếu chuyến không tồn tại hoặc không ở trạng thái IN_PROGRESS
     */
    public void finishTrip(int tripID) throws Exception {
        Trip trip = tripDAO.getById(tripID);
        if (trip == null) {
            throw new IllegalArgumentException("Chuyến xe #" + tripID + " không tồn tại.");
        }
        if (trip.getStatus() != TripStatus.IN_PROGRESS) {
            throw new IllegalArgumentException(
                "Không thể kết thúc chuyến. Trạng thái hiện tại: " + trip.getStatus()
                + " (Chỉ có thể kết thúc khi IN_PROGRESS)."
            );
        }
        tripDAO.finishTrip(tripID);
    }
}
