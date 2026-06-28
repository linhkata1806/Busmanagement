/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import dto.MonthlyPassDTO;
import enums.PassStatus;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.MonthlyPass;

/**
 *
 * @author Administrator
 */
public class MonthlyPassDAO extends DBContext {

    public int countActivePasses(int accountId) {
        String sql = "SELECT COUNT(*) FROM MonthlyPasses "
                + "WHERE AccountID = ? AND Status = 'APPROVED' AND EndDate >= CAST(GETDATE() AS DATE)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean hasPendingOrApprovedPass(int accountID, int routeId) {
        String sql = "SELECT 1\n"
                + "                 FROM MonthlyPasses\n"
                + "                 WHERE AccountID = ?\n"
                + "                 AND RouteID = ?\n"
                + "                 AND Status IN ('PENDING', 'APPROVED')";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, accountID);
            ps.setInt(2, routeId);

            ResultSet rs = ps.executeQuery();

            return rs.next();

        } catch (SQLException e) {
            System.out.println("Error hasPendingOrApprovedPass: " + e.getMessage());
        }

        return false;
    }

    public void insert(MonthlyPass pass) {
        String sql = """
                 INSERT INTO MonthlyPasses(
                     AccountID,
                     RouteID,
                     PassTypeID,
                     PassCode,
                     StartDate,
                     EndDate,
                     Price,
                     Status,
                     ImageProof
                 )
                 VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
                 """;

        try (
                PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, pass.getAccountID());

            // RouteID có thể NULL (vé liên tuyến)
            if (pass.getRouteID() == null) {
                ps.setNull(2, java.sql.Types.INTEGER);
            } else {
                ps.setInt(2, pass.getRouteID());
            }

            ps.setInt(3, pass.getPassTypeID());

            ps.setString(4, pass.getPassCode());

            ps.setObject(5, pass.getStartDate());

            ps.setObject(6, pass.getEndDate());

            ps.setDouble(7, pass.getPrice());

            ps.setString(8, pass.getStatus().name());

            ps.setString(9, pass.getImageProof());

            ps.executeUpdate();

        } catch (SQLException e) {

            throw new RuntimeException(
                    "Lỗi thêm vé tháng: " + e.getMessage()
            );
        }
    }

    public boolean hasPendingOrApprovedAllRoutePass(int accountID) {
        String sql = "                 SELECT 1\n"
                + "                 FROM MonthlyPasses\n"
                + "                 WHERE AccountID = ?\n"
                + "                 AND RouteID IS NULL\n"
                + "                 AND Status IN ('PENDING', 'APPROVED')";

        try (
                PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, accountID);

            ResultSet rs = ps.executeQuery();

            return rs.next();

        } catch (SQLException e) {
            System.out.println("Error hasPendingOrApprovedAllRoutePass: "
                    + e.getMessage());
        }

        return false;
    }

    public List<MonthlyPassDTO> getRoutePasses(int accountID) {
        List<dto.MonthlyPassDTO> list = new ArrayList<>();
        String sql = "SELECT mp.PassCode, mp.StartDate, mp.EndDate, mp.Status, "
                + "r.RouteNumber, r.RouteName, mpt.TypeName "
                + "FROM MonthlyPasses mp "
                + "LEFT JOIN Routes r ON mp.RouteID = r.RouteID "
                + "JOIN MonthlyPassTypes mpt ON mp.PassTypeID = mpt.PassTypeID "
                + "WHERE mp.AccountID = ? AND mp.RouteID IS NOT NULL "
                + "ORDER BY mp.CreatedAt DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, accountID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowToMonthlyPassDTO(rs)); // Gọi hàm mapper ở trên
                }
            }
        } catch (SQLException e) {
            System.out.println("Lỗi getRoutePasses: " + e.getMessage());
        }
        return list;
    }

    public List<MonthlyPassDTO> getAllRoutePasses(int accountID) {
        List<dto.MonthlyPassDTO> list = new ArrayList<>();
        String sql = "SELECT mp.PassCode, mp.StartDate, mp.EndDate, mp.Status, "
                + "r.RouteNumber, r.RouteName, mpt.TypeName "
                + "FROM MonthlyPasses mp "
                + "LEFT JOIN Routes r ON mp.RouteID = r.RouteID "
                + "JOIN MonthlyPassTypes mpt ON mp.PassTypeID = mpt.PassTypeID "
                + "WHERE mp.AccountID = ? AND mp.RouteID IS NULL "
                + "ORDER BY mp.CreatedAt DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, accountID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowToMonthlyPassDTO(rs)); // Gọi hàm mapper ở trên
                }
            }
        } catch (SQLException e) {
            System.out.println("Lỗi getAllRoutePasses: " + e.getMessage());
        }
        return list;
    }

    private dto.MonthlyPassDTO mapRowToMonthlyPassDTO(ResultSet rs) throws SQLException {
        dto.MonthlyPassDTO dto = new dto.MonthlyPassDTO();

        dto.setPassCode(rs.getString("PassCode"));
        dto.setStartDate(rs.getDate("StartDate").toLocalDate());
        dto.setEndDate(rs.getDate("EndDate").toLocalDate());
        dto.setStatus(enums.PassStatus.valueOf(rs.getString("Status")));

        // Các trường lấy từ câu lệnh JOIN (RouteID liên tuyến có thể null nên dùng LEFT JOIN)
        dto.setRouteNumber(rs.getString("RouteNumber"));
        dto.setRouteName(rs.getString("RouteName"));
        dto.setTypeName(rs.getString("TypeName"));

        return dto;
    }

    private MonthlyPass mapRowToMonthlyPass(ResultSet rs) throws SQLException {
        MonthlyPass mp = new MonthlyPass();
        mp.setPassID(rs.getInt("PassID"));
        mp.setAccountID(rs.getInt("AccountID"));

        // Xử lý Integer null an toàn
        int routeId = rs.getInt("RouteID");
        mp.setRouteID(rs.wasNull() ? null : routeId);

        mp.setPassTypeID(rs.getInt("PassTypeID"));
        mp.setPassCode(rs.getString("PassCode"));
        mp.setStartDate(rs.getDate("StartDate").toLocalDate());
        mp.setEndDate(rs.getDate("EndDate").toLocalDate());
        mp.setPrice(rs.getLong("Price"));
        mp.setStatus(PassStatus.valueOf(rs.getString("Status")));
        mp.setImageProof(rs.getString("ImageProof"));

        int approvedBy = rs.getInt("ApprovedBy");
        mp.setApprovedBy(rs.wasNull() ? null : approvedBy);

        java.sql.Date approvedAt = rs.getDate("ApprovedAt");
        if (approvedAt != null) {
            mp.setApprovedAt(approvedAt.toLocalDate());
        }
        mp.setCreatedAt(rs.getDate("CreatedAt").toLocalDate());
        return mp;
    }
}
