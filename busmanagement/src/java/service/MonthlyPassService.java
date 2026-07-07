package service;

import dal.MonthlyPassDAO;
import dal.MonthlyPassTypeDAO;
import dal.NotificationDAO;
import dto.MonthlyPassDTO;
import enums.PassStatus;
import model.MonthlyPass;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import model.MonthlyPassType;
import model.Notification;
import enums.NotificationType;

public class MonthlyPassService {

    private MonthlyPassDAO monthlyPassDAO;
    private NotificationDAO notificationDAO;

    public MonthlyPassService() {
        monthlyPassDAO = new MonthlyPassDAO();
        notificationDAO = new NotificationDAO();
    }

    // dang ky ve thang hco 1 chuyen
    public void registerRoutePass(int accountID, int routeId, int passTypeID, String imageProof) {
        if (monthlyPassDAO.hasPendingOrApprovedPass(accountID, routeId)) {
            throw new IllegalArgumentException("Bạn đã đăng ký vé tháng cho tuyến này.");
        }

        MonthlyPass pass = new MonthlyPass();
        pass.setAccountID(accountID);
        pass.setRouteID(routeId);
        pass.setPassTypeID(passTypeID);
        pass.setPassCode(generatePassCode("Route"));

        LocalDate today = LocalDate.now();
        pass.setStartDate(today);
        pass.setEndDate(today.plusMonths(1));

        pass.setPrice(calculatePassPrice(routeId, passTypeID));
        pass.setStatus(PassStatus.PENDING);
        pass.setImageProof(imageProof);

        monthlyPassDAO.insert(pass);
    }

    // dang ky lien chuyen
    public void registerAllRoutePass(int accountID, int passTypeID, String imageProof) {
        if (monthlyPassDAO.hasPendingOrApprovedAllRoutePass(accountID)) {
            throw new IllegalArgumentException("Bạn đã có vé tháng liên tuyến.");
        }

        MonthlyPass pass = new MonthlyPass();
        pass.setAccountID(accountID);
        pass.setRouteID(null); // NULL = liên tuyến
        pass.setPassTypeID(passTypeID);
        pass.setPassCode(generatePassCode("ALL"));

        // FIX: Dùng logic giống registerRoutePass để khớp với LocalDateTime
        LocalDate today = LocalDate.now();
        pass.setStartDate(today);
        pass.setEndDate(today.plusMonths(1));

        // Lưu ý: hàm tính giá cần truyền đúng tham số (null cho routeId vì là liên tuyến)
        // Nếu hàm calculatePassPrice yêu cầu int routeId, bạn cần xử lý trường hợp null này
        pass.setPrice(calculatePassPrice(null, passTypeID)); // Cần kiểm tra lại hàm tính giá của bạn

        pass.setStatus(PassStatus.PENDING);
        pass.setImageProof(imageProof);

        monthlyPassDAO.insert(pass);
    }

    private String generatePassCode(String route) {

        return "PASS-" + System.currentTimeMillis();
    }

    //==========customer
    public long calculatePassPrice(Integer routeId, int passTypeID) {
        MonthlyPassTypeDAO monthlyPassType = new MonthlyPassTypeDAO();
        long basePrice = (routeId == null) ? 200000 : 100000;

        MonthlyPassType passType = monthlyPassType.getById(passTypeID);

        if (passType == null) {
            throw new IllegalArgumentException("Loại vé tháng không tồn tại.");
        }

        double discount = passType.getDiscountPercentage();

        return Math.round(basePrice * (100 - discount) / 100.0);
    }

    //=====customer Lấy danh sách vé tháng đơn tuyến dạng DTO
    public List<MonthlyPassDTO> getRoutePasses(int accountID) {
         monthlyPassDAO.updateExpiredPasses();
        return monthlyPassDAO.getRoutePasses(accountID);
    }

    //======customer Lấy danh sách vé tháng liên tuyến dạng DTO
    public List<MonthlyPassDTO> getAllRoutePasses(int accountID) {
         monthlyPassDAO.updateExpiredPasses();
        return monthlyPassDAO.getAllRoutePasses(accountID);
    }

    //======customer Kiểm tra khách hàng đã có vé tháng đang chờ duyệt hoặc đã duyệt cho tuyến này chưa
    public boolean hasPendingOrApprovedPass(int accountID, int routeId) {
        return monthlyPassDAO.hasPendingOrApprovedPass(accountID, routeId);
    }

    //========customer Kiểm tra khách hàng đã có vé tháng liên tuyến đang chờ duyệt hoặc đã duyệt chưa
    public boolean hasPendingOrApprovedAllRoutePass(int accountID) {
        return monthlyPassDAO.hasPendingOrApprovedAllRoutePass(accountID);
    }

    public int countPendingPasses() {
        return monthlyPassDAO.countByStaTus("PENDING");
    }

    // 2. Lấy danh sách tất cả vé tháng (Giao diện Staff)
    public List<MonthlyPassDTO> getAllPassesForStaff() {
         monthlyPassDAO.updateExpiredPasses();
        return monthlyPassDAO.getAllPasses();
    }

    // 3. Lấy danh sách vé tháng theo trạng thái lọc
    public List<MonthlyPassDTO> getPassesByStatusForStaff(String status) {
         monthlyPassDAO.updateExpiredPasses();
        return monthlyPassDAO.getPassesByStatus(status);
    }

    public boolean approvePass(int passID, int staffID) {
        MonthlyPass pass = monthlyPassDAO.getPassByID(passID);
        if (pass == null || PassStatus.PENDING != pass.getStatus()) {
            return false;
        }
        boolean updated = monthlyPassDAO.updateStatus(passID, PassStatus.APPROVED, staffID);
        if (updated) {
            sendNotification(pass.getAccountID(),
                    "PASS_APPROVED",
                    "Vé tháng được duyệt",
                    "Đăng ký vé tháng thành công vé tháng mã: "
                    + pass.getPassCode() + " của bạn đã được phê duyệt hành công");

        }
        return updated;
    }

    public boolean rejectPass(int PassID, int staffID) {
        MonthlyPass pass = monthlyPassDAO.getPassByID(PassID);
        if (pass == null || PassStatus.PENDING != pass.getStatus()) {
            return false;
        }
        boolean updated = monthlyPassDAO.updateStatus(PassID, PassStatus.REJECTED, staffID);
        if (updated) {
            sendNotification(pass.getAccountID(),
                    "PASS_REJECTED",
                    "Vé tháng bị từ chối",
                    "Đăng ký vé tháng thất bại vé tháng mã: "
                    + pass.getPassCode() + " của bạn bị từ chối");

        }
        return updated;
    }

    private void sendNotification(int accountID, String type, String title, String content) {
        Notification notif = new Notification();
        notif.setAccountID(accountID);

        // Dùng luôn tham số 'type' truyền vào, thêm toUpperCase() để tránh lỗi chữ hoa/thường
        notif.setNotificationType(NotificationType.valueOf(type.toUpperCase()));

        notif.setTitle(title);
        notif.setContent(content);
        notif.setCreatedAt(java.time.LocalDateTime.now());

        notificationDAO.insert(notif);
    }

    // ham nay get va all trang tahi
    public List<MonthlyPassDTO> getAllPassesForStaff(String searchQuery) {
        List<MonthlyPassDTO> passList = monthlyPassDAO.getAllPasses();
        return filterPassesBySearchQuery(passList, searchQuery);
    }

    // ham nay get ve theo 1 trang thai nhat dinh
    public List<MonthlyPassDTO> getPassesByStatusForStaff(String status, String searchQuery) {
        List<MonthlyPassDTO> passList = monthlyPassDAO.getPassesByStatus(status);
        return filterPassesBySearchQuery(passList, searchQuery);

    }

    private List<MonthlyPassDTO> filterPassesBySearchQuery(List<MonthlyPassDTO> passList, String searchQuery) {
        //check search query k co j 
        if (searchQuery == null || searchQuery.isBlank()) {
            return passList;// tra ve luon ca danh sach k phai loc
        }

        String query = searchQuery.trim().toLowerCase();
        List<MonthlyPassDTO> filteredList = new ArrayList<>();

        for (MonthlyPassDTO dto : passList) {
            //check xem ma ve hoac ten co khop voi tu khoa tim kiem k
            boolean matchCode = dto.getPassCode() != null && dto.getPassCode().toLowerCase().contains(query);
            boolean matchName = dto.getFullName() != null && dto.getFullName().toLowerCase().contains(query);
            if (matchCode || matchName) {
                filteredList.add(dto);
            }
        }
        return filteredList;
    }

}
