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
import jakarta.servlet.http.Part;
import java.io.File;
import java.util.UUID;

public class MonthlyPassService {

    private MonthlyPassDAO monthlyPassDAO;
    private NotificationDAO notificationDAO;

    public MonthlyPassService() {
        monthlyPassDAO = new MonthlyPassDAO();
        notificationDAO = new NotificationDAO();
    }

    // dang ky ve thang hco 1 chuyen
    public void registerRoutePass(int accountID, int routeId, int passTypeID, String imageProof) {
        if (monthlyPassDAO.hasPendingOrApprovedPass(accountID, routeId) || monthlyPassDAO.hasPendingOrApprovedAllRoutePass(accountID)) {
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
        notif.setTargetRole("CUSTOMER");
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

    public String processAndSaveProof(Part filePart, String realPath) throws IllegalArgumentException, Exception {
        // 1. Kiểm tra file rỗng
        if (filePart == null || filePart.getSize() == 0) {
            throw new IllegalArgumentException("Vui lòng tải lên ảnh minh chứng.");
        }

        // 2. Kiểm tra dung lượng (Max 5MB = 5 * 1024 * 1024 bytes)
        if (filePart.getSize() > 5 * 1024 * 1024) {
            throw new IllegalArgumentException("Dung lượng ảnh vượt quá giới hạn 5MB.");
        }

        // 3. Kiểm tra MIME Type từ Header để chặn file giả mạo 
        String contentType = filePart.getContentType();
        if (contentType == null || (!contentType.equals("image/jpeg") && !contentType.equals("image/png"))) {
            throw new IllegalArgumentException("Định dạng file không hợp lệ. Chỉ chấp nhận ảnh JPG/PNG.");
        }

        // 4. Lấy tên gốc của file và trích xuất phần mở rộng (Extension)
        String submittedFileName = filePart.getSubmittedFileName();
        if (submittedFileName == null || !submittedFileName.contains(".")) {
            throw new IllegalArgumentException("Tên file không hợp lệ.");
        }

        // Cắt lấy đuôi file (ví dụ: ".jpg", ".png") và chuyển về chữ thường để check an toàn kép
        String extension = submittedFileName.substring(submittedFileName.lastIndexOf(".")).toLowerCase();
        if (!extension.equals(".jpg") && !extension.equals(".jpeg") && !extension.equals(".png")) {
            throw new IllegalArgumentException("Đuôi file mở rộng không được hỗ trợ.");
        }

        // 5. Sinh tên file Unique, Ngắn gọn (Ví dụ: 550e8400-e29b-41d4-a716-446655440000.jpg)
        String uniqueFileName = UUID.randomUUID().toString() + extension;

        // 6. Tạo thư mục lưu trữ nếu chưa tồn tại trên Server
        File uploadDir = new File(realPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        // 7. Ghi file vào ổ cứng của Server
        String savePath = realPath + File.separator + uniqueFileName;
        filePart.write(savePath);

        // 8. Trả về đường dẫn tương đối chuẩn xác để lưu vào Database
        return "uploads/pass-proof/" + uniqueFileName;
    }

}
