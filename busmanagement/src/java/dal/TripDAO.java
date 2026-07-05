/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import dto.TripDTO;
import enums.TripStatus;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Trip;

/**
 *
 * @author Administrator
 */
public class TripDAO extends DBContext {

    public int countTripsToday() {
        String sql = "SELECT COUNT(*) FROM Trips WHERE CAST(TripDate AS DATE) = CAST(GETDATE() AS DATE)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi countTripsToday: " + e.getMessage());
        }
        return 0;
    }

    // HÀM TÌM KIẾM ĐỘNG (Gộp tất cả các bộ lọc vào làm 1)
    public List<TripDTO> searchTrips(String date, int routeID, String plate, String status) {
        List<TripDTO> list = new ArrayList<>();

        // 1. Câu SQL gốc (Có thêm WHERE 1=1 để dễ dàng nối chuỗi bằng AND)
        StringBuilder sql = new StringBuilder(
                "SELECT t.TripID, r.RouteNumber, r.RouteName, b.LicensePlate AS BusPlate, "
                + "ad.FullName AS DriverName, aa.FullName AS AssistantName, "
                + "t.TripDate, t.StartTime, t.EndTime, t.Direction, t.Status, "
                + "t.ActualStartTime, t.ActualEndTime "
                + "FROM Trips t "
                + "JOIN Routes r ON t.RouteID = r.RouteID "
                + "JOIN Buses b ON t.BusID = b.BusID "
                + "JOIN Accounts ad ON t.DriverID = ad.AccountID "
                + "LEFT JOIN Accounts aa ON t.AssistantID = aa.AccountID "
                + "WHERE 1=1 "
        );

        // 2. Danh sách chứa các giá trị tham số để set vào PreparedStatement
        List<Object> params = new ArrayList<>();

        // 3. Người dùng nhập bộ lọc nào, ta nối thêm câu SQL của bộ lọc đó
        if (date != null && !date.isEmpty()) {
            sql.append("AND t.TripDate = ? ");
            params.add(date);
        }
        if (routeID > 0) {
            sql.append("AND t.RouteID = ? ");
            params.add(routeID);
        }
        if (plate != null && !plate.trim().isEmpty()) {
            sql.append("AND b.LicensePlate LIKE ? ");
            params.add("%" + plate.trim() + "%"); // Dùng LIKE để tìm gần đúng biển số
        }
        if (status != null && !status.trim().isEmpty() && !"ALL".equals(status)) {
            sql.append("AND t.Status = ? ");
            params.add(status);
        }

        sql.append("ORDER BY t.TripDate DESC, t.StartTime ASC");

        // 4. Thực thi câu lệnh
        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            // Đổ tham số vào các dấu ? tương ứng
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) { // Đã fix lỗi while(true) của bạn
                    list.add(mapRowtoDTO(rs));
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi searchTrips: " + e.getMessage());
        }
        return list;
    }

    public Trip getById(int tripID) {
        String sql = " select * from trips where TripID=?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, tripID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Trip t = new Trip();
                t.setTripID(rs.getInt("TripID"));
                t.setRouteID(rs.getInt("RouteID"));
                t.setBusID(rs.getInt("BusID"));
                t.setDriverID(rs.getInt("DriverID"));

                int assistantId = rs.getInt("AssistantID");
                t.setAssistantID(rs.wasNull() ? null : assistantId);

                java.sql.Date d = rs.getDate("TripDate");
                if (d != null) {
                    t.setTripDate(d.toLocalDate());
                }

                java.sql.Time st = rs.getTime("StartTime");
                if (st != null) {
                    t.setStartTime(st.toLocalTime());
                }

                java.sql.Time et = rs.getTime("EndTime");
                if (et != null) {
                    t.setEndTime(et.toLocalTime());
                }

                t.setDirection(rs.getInt("Direction"));
                t.setStatus(TripStatus.valueOf(rs.getString("Status")));

                // BỔ SUNG: Thời điểm thực tế bắt đầu và kết thúc
                t.setActualStartTime(rs.getTimestamp("ActualStartTime"));
                t.setActualEndTime(rs.getTimestamp("ActualEndTime"));

                return t;
            }
        } catch (Exception e) {
        }
        return null;
    }

    // 4. Sửa lại hàm Insert
    public boolean insert(Trip trip) {
        String sql = "INSERT INTO Trips (RouteID, BusID, DriverID, AssistantID, TripDate, StartTime, EndTime, Direction, Status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, trip.getRouteID());
            ps.setInt(2, trip.getBusID());
            ps.setInt(3, trip.getDriverID());

            if (trip.getAssistantID() == null) {
                ps.setNull(4, java.sql.Types.INTEGER);
            } else {
                ps.setInt(4, trip.getAssistantID());
            }

            // Gửi toàn bộ bằng chuỗi (String) để né lỗi convert ngầm của Java
            ps.setString(5, trip.getTripDate().toString());
            ps.setString(6, trip.getStartTime().toString());
            ps.setString(7, trip.getEndTime().toString());
            ps.setInt(8, trip.getDirection());
            ps.setString(9, trip.getStatus().name());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Lỗi insert Trip: " + e.getMessage());
        }
        return false;
    }

    // 5. Sửa lại hàm Update
    public boolean update(Trip trip) {
        String sql = "UPDATE Trips SET RouteID=?, BusID=?, DriverID=?, AssistantID=?, TripDate=?, StartTime=?, EndTime=?, Direction=?, Status=? WHERE TripID=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, trip.getRouteID());
            ps.setInt(2, trip.getBusID());
            ps.setInt(3, trip.getDriverID());

            if (trip.getAssistantID() == null) {
                ps.setNull(4, java.sql.Types.INTEGER);
            } else {
                ps.setInt(4, trip.getAssistantID());
            }

            ps.setString(5, trip.getTripDate().toString());
            ps.setString(6, trip.getStartTime().toString());
            ps.setString(7, trip.getEndTime().toString());
            ps.setInt(8, trip.getDirection());
            ps.setString(9, trip.getStatus().name());
            ps.setInt(10, trip.getTripID());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Lỗi update Trip: " + e.getMessage());
        }
        return false;
    }

    public boolean delete(int tripID) {
        String sql = "DELETE FROM Trips WHERE TripID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, tripID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Lỗi delete Trip: " + e.getMessage());
        }
        return false;
    }

    private TripDTO mapRowtoDTO(ResultSet rs) throws Exception {
        TripDTO dto = new TripDTO();
        dto.setTripID(rs.getInt("TripID"));
        dto.setRouteNumber(rs.getString("RouteNumber"));
        dto.setRouteName(rs.getString("RouteName"));
        dto.setBusPlate(rs.getString("BusPlate"));
        dto.setDriverName(rs.getString("DriverName"));
        dto.setAssistantName(rs.getString("AssistantName"));

        java.sql.Date d = rs.getDate("TripDate");
        if (d != null) {
            dto.setTripDate(d.toLocalDate());
        }

        java.sql.Time st = rs.getTime("StartTime");
        if (st != null) {
            dto.setStartTime(st.toLocalTime());
        }

        java.sql.Time et = rs.getTime("EndTime");
        if (et != null) {
            dto.setEndTime(et.toLocalTime());
        }

        dto.setDirection(rs.getInt("Direction"));
        dto.setStatus(rs.getString("Status"));
        dto.setActualStartTime(rs.getTimestamp("ActualStartTime"));
        dto.setActualEndTime(rs.getTimestamp("ActualEndTime"));
        return dto;
    }

    // 1. Kiểm tra trùng lịch Tài xế
    public boolean hasDriverConflict(int driverID, java.time.LocalDate date, java.time.LocalTime start, java.time.LocalTime end, Integer excludeTripID) {
        // FIX: Thêm CAST(? AS TIME) vào để bảo vệ câu lệnh SQL
        String sql = "SELECT COUNT(*) FROM Trips WHERE DriverID = ? AND TripDate = ? AND Status != 'CANCELLED' AND StartTime < CAST(? AS TIME) AND EndTime > CAST(? AS TIME)";
        if (excludeTripID != null && excludeTripID > 0) {
            sql += " AND TripID != " + excludeTripID;
        }
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, driverID);
            ps.setString(2, date.toString()); // FIX: Ép LocalDate thành String ('YYYY-MM-DD')
            ps.setString(3, end.toString());  // FIX: Ép LocalTime thành String ('HH:mm')
            ps.setString(4, start.toString());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi check driver conflict: " + e.getMessage());
        }
        return false;
    }

    // 2. Kiểm tra trùng lịch Xe buýt
    public boolean hasBusConflict(int busID, java.time.LocalDate date, java.time.LocalTime start, java.time.LocalTime end, Integer excludeTripID) {
        String sql = "SELECT COUNT(*) FROM Trips WHERE BusID = ? AND TripDate = ? AND Status != 'CANCELLED' AND StartTime < CAST(? AS TIME) AND EndTime > CAST(? AS TIME)";
        if (excludeTripID != null && excludeTripID > 0) {
            sql += " AND TripID != " + excludeTripID;
        }
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, busID);
            ps.setString(2, date.toString());
            ps.setString(3, end.toString());
            ps.setString(4, start.toString());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi check bus conflict: " + e.getMessage());
        }
        return false;
    }

    // 3. Kiểm tra trùng lịch Phụ xe
    public boolean hasAssistantConflict(int assistantID, java.time.LocalDate date, java.time.LocalTime start, java.time.LocalTime end, Integer excludeTripID) {
        String sql = "SELECT COUNT(*) FROM Trips WHERE AssistantID = ? AND TripDate = ? AND Status != 'CANCELLED' AND StartTime < CAST(? AS TIME) AND EndTime > CAST(? AS TIME)";
        if (excludeTripID != null && excludeTripID > 0) {
            sql += " AND TripID != " + excludeTripID;
        }
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, assistantID);
            ps.setString(2, date.toString());
            ps.setString(3, end.toString());
            ps.setString(4, start.toString());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi check assistant conflict: " + e.getMessage());
        }
        return false;
    }

    // Kiểm tra xem Tuyến xe này đã từng có chuyến xe nào chạy chưa (Dùng cho Soft Delete)
    public boolean existsByRouteId(int routeID) {
        String sql = "SELECT TOP 1 1 FROM Trips WHERE RouteID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, routeID);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            System.out.println("Lỗi existsByRouteId: " + e.getMessage());
        }
        return false;
    }

    public boolean existsByBusId(int busID) {
        String sql = "SELECT TOP 1 1 FROM Trips WHERE BusID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, busID);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next(); // Trả về true nếu xe đã từng có chuyến đi
            }
        } catch (Exception e) {
            System.out.println("Lỗi existsByBusId: " + e.getMessage());
        }
        return false;
    }

    public List<TripDTO> getTripsByAssistant(int assistantID) {
        List<TripDTO> list = new ArrayList<>();
        String sql = "SELECT t.TripID, r.RouteNumber, r.RouteName, b.LicensePlate AS BusPlate, "
                + "ad.FullName AS DriverName, aa.FullName AS AssistantName, "
                + "t.TripDate, t.StartTime, t.EndTime, t.Direction, t.Status, "
                + "t.ActualStartTime, t.ActualEndTime "
                + "FROM Trips t "
                + "JOIN Routes r ON t.RouteID = r.RouteID "
                + "JOIN Buses b ON t.BusID = b.BusID "
                + "JOIN Accounts ad ON t.DriverID = ad.AccountID "
                + "LEFT JOIN Accounts aa ON t.AssistantID = aa.AccountID "
                + "WHERE t.AssistantID = ? "
                + "ORDER BY t.TripDate DESC, t.StartTime ASC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, assistantID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    try {
                        list.add(mapRowtoDTO(rs));
                    } catch (Exception ex) {
                        ex.printStackTrace();
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi getTripsByAssistant: " + e.getMessage());
        }
        return list;
    }

    public TripDTO getCurrentTripByAssistant(int assistantID) {
        String sql = "SELECT TOP 1 t.TripID, r.RouteNumber, r.RouteName, b.LicensePlate AS BusPlate, "
                + "ad.FullName AS DriverName, aa.FullName AS AssistantName, "
                + "t.TripDate, t.StartTime, t.EndTime, t.Direction, t.Status, "
                + "t.ActualStartTime, t.ActualEndTime "
                + "FROM Trips t "
                + "JOIN Routes r ON t.RouteID = r.RouteID "
                + "JOIN Buses b ON t.BusID = b.BusID "
                + "JOIN Accounts ad ON t.DriverID = ad.AccountID "
                + "LEFT JOIN Accounts aa ON t.AssistantID = aa.AccountID "
                + "WHERE t.AssistantID = ? AND t.Status IN ('IN_PROGRESS', 'SCHEDULED') "
                + "ORDER BY CASE t.Status WHEN 'IN_PROGRESS' THEN 1 WHEN 'SCHEDULED' THEN 2 ELSE 3 END, "
                + "t.TripDate ASC, t.StartTime ASC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, assistantID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    try {
                        return mapRowtoDTO(rs);
                    } catch (Exception ex) {
                        ex.printStackTrace();
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi getCurrentTripByAssistant: " + e.getMessage());
        }
        return null;
    }

    // ==========================================
    // DRIVER MODULE METHODS
    // ==========================================
    public List<TripDTO> getTripsByDriver(int driverID) {
        List<TripDTO> list = new ArrayList<>();
        String sql = "SELECT t.TripID, r.RouteNumber, r.RouteName, b.LicensePlate AS BusPlate, "
                + "ad.FullName AS DriverName, aa.FullName AS AssistantName, "
                + "t.TripDate, t.StartTime, t.EndTime, t.Direction, t.Status, "
                + "t.ActualStartTime, t.ActualEndTime "
                + "FROM Trips t "
                + "JOIN Routes r ON t.RouteID = r.RouteID "
                + "JOIN Buses b ON t.BusID = b.BusID "
                + "JOIN Accounts ad ON t.DriverID = ad.AccountID "
                + "LEFT JOIN Accounts aa ON t.AssistantID = aa.AccountID "
                + "WHERE t.DriverID = ? "
                + "ORDER BY t.TripDate DESC, t.StartTime ASC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, driverID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    try {
                        list.add(mapRowtoDTO(rs));
                    } catch (Exception ex) {
                        ex.printStackTrace();
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi getTripsByDriver: " + e.getMessage());
        }
        return list;
    }

    public TripDTO getTripByIDAndDriver(int tripID, int driverID) {
        String sql = "SELECT t.TripID, r.RouteNumber, r.RouteName, b.LicensePlate AS BusPlate, "
                + "ad.FullName AS DriverName, aa.FullName AS AssistantName, "
                + "t.TripDate, t.StartTime, t.EndTime, t.Direction, t.Status, "
                + "t.ActualStartTime, t.ActualEndTime "
                + "FROM Trips t "
                + "JOIN Routes r ON t.RouteID = r.RouteID "
                + "JOIN Buses b ON t.BusID = b.BusID "
                + "JOIN Accounts ad ON t.DriverID = ad.AccountID "
                + "LEFT JOIN Accounts aa ON t.AssistantID = aa.AccountID "
                + "WHERE t.TripID = ? AND t.DriverID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, tripID);
            ps.setInt(2, driverID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    try {
                        return mapRowtoDTO(rs);
                    } catch (Exception ex) {
                        ex.printStackTrace();
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi getTripByIDAndDriver: " + e.getMessage());
        }
        return null;
    }

    public boolean updateTripStatus(int tripID, String status) {
        String sql = "UPDATE Trips SET Status = ? WHERE TripID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, tripID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Lỗi updateTripStatus: " + e.getMessage());
        }
        return false;
    }

    public int countDriverTripsToday(int driverID) {
        String sql = "SELECT COUNT(*) FROM Trips WHERE DriverID = ? AND TripDate = CAST(GETDATE() AS DATE)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, driverID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi countDriverTripsToday: " + e.getMessage());
        }
        return 0;
    }

    public TripDTO getCurrentTripByDriver(int driverID) {
        String sql = "SELECT TOP 1 t.TripID, r.RouteNumber, r.RouteName, b.LicensePlate AS BusPlate, "
                + "ad.FullName AS DriverName, aa.FullName AS AssistantName, "
                + "t.TripDate, t.StartTime, t.EndTime, t.Direction, t.Status, "
                + "t.ActualStartTime, t.ActualEndTime "
                + "FROM Trips t "
                + "JOIN Routes r ON t.RouteID = r.RouteID "
                + "JOIN Buses b ON t.BusID = b.BusID "
                + "JOIN Accounts ad ON t.DriverID = ad.AccountID "
                + "LEFT JOIN Accounts aa ON t.AssistantID = aa.AccountID "
                + "WHERE t.DriverID = ? AND t.Status IN ('IN_PROGRESS', 'SCHEDULED') "
                + "ORDER BY CASE t.Status WHEN 'IN_PROGRESS' THEN 1 WHEN 'SCHEDULED' THEN 2 ELSE 3 END, "
                + "t.TripDate ASC, t.StartTime ASC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, driverID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    try {
                        return mapRowtoDTO(rs);
                    } catch (Exception ex) {
                        ex.printStackTrace();
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi getCurrentTripByDriver: " + e.getMessage());
        }
        return null;
    }

    /**
     * Bắt đầu chuyến xe: cập nhật Status = 'IN_PROGRESS' và ghi ActualStartTime
     * = NOW().
     *
     * @throws SQLException khi có lỗi kết nối hoặc thực thi DB
     * @throws Exception khi không tìm thấy chuyến xe hợp lệ
     */
    public void startTrip(int tripID) throws Exception {
        String sql = "UPDATE Trips SET Status = 'IN_PROGRESS', ActualStartTime = GETDATE() WHERE TripID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, tripID);
            if (ps.executeUpdate() == 0) {
                throw new Exception("Không tìm thấy chuyến xe để bắt đầu hoặc trạng thái không hợp lệ.");
            }
        }
    }

    /**
     * Kết thúc chuyến xe: cập nhật Status = 'COMPLETED' và ghi ActualEndTime =
     * NOW(). Đồng thời cập nhật tất cả vé CHECKED_IN của chuyến thành
     * COMPLETED.
     *
     * @throws SQLException khi có lỗi kết nối hoặc thực thi DB
     * @throws Exception khi không tìm thấy chuyến xe hợp lệ để kết thúc
     */
    public void finishTrip(int tripID) throws Exception {
        String sqlTrip = "UPDATE Trips SET Status = 'COMPLETED', ActualEndTime = GETDATE() WHERE TripID = ?";
        String sqlTickets = "UPDATE Tickets SET Status = 'COMPLETED' WHERE TripID = ? AND Status = 'CHECKED_IN'";

        try {
            connection.setAutoCommit(false);

            // 1. Cập nhật trạng thái chuyến xe
            try (PreparedStatement psTrip = connection.prepareStatement(sqlTrip)) {
                psTrip.setInt(1, tripID);
                if (psTrip.executeUpdate() == 0) {
                    throw new Exception("Không tìm thấy chuyến xe để kết thúc.");
                }
            }

            // 2. Cập nhật trạng thái các vé liên quan (có thể có hoặc không có vé nào checked_in nên không cần check == 0)
            try (PreparedStatement psTickets = connection.prepareStatement(sqlTickets)) {
                psTickets.setInt(1, tripID);
                psTickets.executeUpdate();
            }

            connection.commit();
        } catch (Exception e) {
            if (connection != null) {
                try {
                    connection.rollback();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
            // Rethrow lỗi để tầng Service/Controller bắt được và xử lý hiển thị thông báo
            throw new Exception("Lỗi khi kết thúc chuyến xe: " + e.getMessage());
        } finally {
            if (connection != null) {
                try {
                    connection.setAutoCommit(true);
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
        }
    }
}
