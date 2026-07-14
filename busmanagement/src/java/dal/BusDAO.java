/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import enums.BusStatus;
import java.util.ArrayList;
import java.util.List;
import model.Bus;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 *
 * @author Administrator
 */
public class BusDAO extends DBContext {

    public List<Bus> getAllActiveBuses() {
        List<Bus> list = new ArrayList<>();
        String sql = "SELECT * FROM Buses WHERE Status = 'ACTIVE'";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Bus b = new Bus();
                b.setBusID(rs.getInt("BusID"));
                b.setLicensePlate(rs.getString("LicensePlate"));
                b.setCapacity(rs.getInt("Capacity"));
                b.setBusType(rs.getString("BusType"));
                // Ép kiểu chuỗi từ SQL sang Enum BusStatus
                b.setStatus(BusStatus.valueOf(rs.getString("Status")));
                list.add(b);
            }
        } catch (Exception e) {
            System.out.println("Lỗi getAllActiveBuses: " + e.getMessage());
        }
        return list;
    }

    public model.Bus getBusById(int busID) {
        String sql = "SELECT * FROM Buses WHERE BusID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, busID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    model.Bus b = new model.Bus();
                    b.setBusID(rs.getInt("BusID"));
                    b.setLicensePlate(rs.getString("LicensePlate"));
                    b.setCapacity(rs.getInt("Capacity"));
                    b.setBusType(rs.getString("BusType"));
                    b.setStatus(enums.BusStatus.valueOf(rs.getString("Status")));
                    return b;
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi getBusById: " + e.getMessage());
        }
        return null;
    }

    private Bus mapBus(ResultSet rs) throws Exception {
        Bus b = new Bus();
        b.setBusID(rs.getInt("BusID"));
        b.setLicensePlate(rs.getString("LicensePlate"));
        b.setCapacity(rs.getInt("Capacity"));
        b.setBusType(rs.getString("BusType"));
        String statusStr = rs.getString("Status");
        if (statusStr != null) {
            b.setStatus(BusStatus.valueOf(statusStr.trim().toUpperCase()));
        }
        return b;
    }

    public int countSearchAndFilter(String keyword, String status) {
        String sql = "SELECT COUNT(*) FROM Buses WHERE "
                + "(LicensePlate LIKE ?) "
                + "AND (? = 'ALL' OR Status = ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, status);
            ps.setString(3, status);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi countSearchAndFilter Bus: " + e.getMessage());
        }
        return 0;
    }

    public List<Bus> searchAndFilter(String keyword, String status, int offset, int limit) {
        List<Bus> list = new ArrayList<>();

        String sql = "SELECT * FROM Buses WHERE "
                + "(LicensePlate LIKE ?) "
                + "AND (? = 'ALL' OR Status = ?) "
                + "ORDER BY LicensePlate ASC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, status);
            ps.setString(3, status);
            ps.setInt(4, offset);
            ps.setInt(5, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapBus(rs));
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi searchAndFilter Bus: " + e.getMessage());
        }
        return list;
    }

    // 2. TÍNH NĂNG CREATE: Kiểm tra biển số tồn tại
    public boolean existsLicensePlate(String licensePlate) {
        String sql = "SELECT TOP 1 1 FROM Buses WHERE LicensePlate = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, licensePlate);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 3. TÍNH NĂNG CREATE: Thực thi lệnh chèn xe mới
    public boolean insert(Bus bus) {
        String sql = "INSERT INTO Buses (LicensePlate, BusType, Capacity, Status) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, bus.getLicensePlate());
            ps.setString(2, bus.getBusType());
            ps.setInt(3, bus.getCapacity());

            // Đẩy tên của Enum (.name()) thành String xuống trường VARCHAR trong DB
            ps.setString(4, bus.getStatus().name());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Lỗi insert Bus: " + e.getMessage());
        }
        return false;
    }

    public boolean update(Bus bus) {
        String sql = "UPDATE Buses SET BusType = ?, Capacity = ?, Status = ? WHERE BusID = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);

            // 1. Gán Loại xe
            ps.setString(1, bus.getBusType());

            // 2. Gán Sức chứa
            ps.setInt(2, bus.getCapacity());

            // 3. Gán Trạng thái (Chuyển Enum sang String để lưu xuống DB)
            ps.setString(3, bus.getStatus().name());

            // 4. Gán ID của xe cần cập nhật vào mệnh đề WHERE
            ps.setInt(4, bus.getBusID());

            // Thực thi câu lệnh và kiểm tra xem có dòng nào bị ảnh hưởng không
            int rowsAffected = ps.executeUpdate();

            // Nếu > 0 tức là update thành công
            return rowsAffected > 0;

        } catch (Exception e) {
            System.out.println("Lỗi tại update (BusDAO): " + e.getMessage());
            return false;
        }
    }

    public boolean delete(int busId) {
        String sql = "DELETE FROM Buses WHERE BusID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, busId);

            // executeUpdate trả về số dòng bị ảnh hưởng
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Lỗi delete Bus: " + e.getMessage());
        }
        return false;
    }
}
