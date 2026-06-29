package service;

import dal.MonthlyPassDAO;
import dal.MonthlyPassTypeDAO;
import dto.MonthlyPassDTO;
import enums.PassStatus;
import model.MonthlyPass;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import model.MonthlyPassType;

public class MonthlyPassService {

    private MonthlyPassDAO monthlyPassDAO = new MonthlyPassDAO();

    public MonthlyPassService() {
    }

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

        pass.setPrice(calculatePassPrice(null, passTypeID));

        pass.setStatus(PassStatus.PENDING);
        pass.setImageProof(imageProof);

        monthlyPassDAO.insert(pass);
    }

    private String generatePassCode(String route) {

        return "PASS-" + System.currentTimeMillis();
    }

    private long calculatePassPrice(Integer routeId, int passTypeID) {
        MonthlyPassTypeDAO monthlyPassType = new MonthlyPassTypeDAO();
        double basePrice = (routeId == null) ? 200000 : 100000;

        MonthlyPassType passType = monthlyPassType.getById(passTypeID);

        if (passType == null) {
            throw new IllegalArgumentException("Loại vé tháng không tồn tại.");
        }

        double discount = passType.getDiscountPercentage();

        return (long) (basePrice * (100 - discount) / 100);
    }
    
    // HÀM MỚI 1: Lấy danh sách vé tháng đơn tuyến dạng DTO
    public List<MonthlyPassDTO> getRoutePasses(int accountID) {
        return monthlyPassDAO.getRoutePasses(accountID);
    }

    // HÀM MỚI 2: Lấy danh sách vé tháng liên tuyến dạng DTO
    public List<MonthlyPassDTO> getAllRoutePasses(int accountID) {
        return monthlyPassDAO.getAllRoutePasses(accountID);
    }
}
