package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Date;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.util.List;

public class DashboardDAO extends DBContext {

    // =========================================================================
    // 1. DÀNH CHO TRANG DASHBOARD (TỔNG QUAN KINH DOANH)
    // =========================================================================
    public int countAccounts() {
        String sql = "SELECT COUNT(*) FROM Accounts";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("Lỗi tại countAccounts: " + e.getMessage());
        }
        return 0;
    }

    public int countCustomers() {
        String sql = "SELECT COUNT(*) FROM Accounts a "
                + "JOIN Roles r ON a.RoleID = r.RoleID "
                + "WHERE r.RoleName = 'CUSTOMER'";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("Lỗi tại countCustomers: " + e.getMessage());
        }
        return 0;
    }

    public int countPendingPasses() {
        String sql = "SELECT COUNT(*) FROM MonthlyPasses WHERE Status = 'PENDING'";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("Lỗi tại countPendingPasses: " + e.getMessage());
        }
        return 0;
    }

    // =========================================================================
    // 2. DÀNH CHO BÁO CÁO DOANH THU (REVENUE REPORT)
    // =========================================================================
    public double getTodayRevenue() {
        // ĐÃ FIX: Đổi CreatedAt thành PurchasedAt cho Tickets và UpdatedAt thành ApprovedAt cho MonthlyPasses
        String ticketSql = "SELECT SUM(Price) FROM Tickets WHERE Status = 'COMPLETED' AND CAST(PurchasedAt AS DATE) = CAST(GETDATE() AS DATE)";
        String passSql = "SELECT SUM(Price) FROM MonthlyPasses WHERE Status = 'APPROVED' AND CAST(ApprovedAt AS DATE) = CAST(GETDATE() AS DATE)";

        double revenue = 0.0;
        try {
            try (PreparedStatement ps = connection.prepareStatement(ticketSql); ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    revenue += rs.getDouble(1);
                }
            }
            try (PreparedStatement ps = connection.prepareStatement(passSql); ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    revenue += rs.getDouble(1);
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi tại getTodayRevenue: " + e.getMessage());
        }
        return revenue;
    }

    public double getRevenueByMonth(int month, int year) {
        // ĐÃ FIX: Đổi CreatedAt thành PurchasedAt và UpdatedAt thành ApprovedAt
        String ticketSql = "SELECT SUM(Price) FROM Tickets WHERE Status = 'COMPLETED' AND MONTH(PurchasedAt) = ? AND YEAR(PurchasedAt) = ?";
        String passSql = "SELECT SUM(Price) FROM MonthlyPasses WHERE Status = 'APPROVED' AND MONTH(ApprovedAt) = ? AND YEAR(ApprovedAt) = ?";

        double revenue = 0.0;
        try {
            try (PreparedStatement ps = connection.prepareStatement(ticketSql)) {
                ps.setInt(1, month);
                ps.setInt(2, year);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        revenue += rs.getDouble(1);
                    }
                }
            }
            try (PreparedStatement ps = connection.prepareStatement(passSql)) {
                ps.setInt(1, month);
                ps.setInt(2, year);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        revenue += rs.getDouble(1);
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi tại getRevenueByMonth: " + e.getMessage());
        }
        return revenue;
    }

    public double getRevenueByRange(java.util.Date fromDate, java.util.Date toDate) {
        // ĐÃ FIX: Đổi CreatedAt thành PurchasedAt và UpdatedAt thành ApprovedAt
        String ticketSql = "SELECT SUM(Price) FROM Tickets WHERE Status = 'COMPLETED' AND PurchasedAt BETWEEN ? AND ?";
        String passSql = "SELECT SUM(Price) FROM MonthlyPasses WHERE Status = 'APPROVED' AND ApprovedAt BETWEEN ? AND ?";

        double revenue = 0.0;
        try {
            java.sql.Timestamp start = new java.sql.Timestamp(fromDate.getTime());
            java.sql.Timestamp end = new java.sql.Timestamp(toDate.getTime());

            try (PreparedStatement ps = connection.prepareStatement(ticketSql)) {
                ps.setTimestamp(1, start);
                ps.setTimestamp(2, end);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        revenue += rs.getDouble(1);
                    }
                }
            }
            try (PreparedStatement ps = connection.prepareStatement(passSql)) {
                ps.setTimestamp(1, start);
                ps.setTimestamp(2, end);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        revenue += rs.getDouble(1);
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi tại getRevenueByRange: " + e.getMessage());
        }
        return revenue;
    }

    // =========================================================================
    // 3. DÀNH CHO TRANG TÀI NGUYÊN HỆ THỐNG (SYSTEM REPORT - TÍNH NĂNG MỚI)
    // =========================================================================
    public Map<String, Integer> getDatabaseScaleMetrics() {
        Map<String, Integer> metrics = new HashMap<>();
        String sql = "SELECT "
                + "  (SELECT COUNT(*) FROM Accounts) AS totalAccounts, "
                + "  (SELECT COUNT(*) FROM Routes) AS totalRoutes, "
                + "  (SELECT COUNT(*) FROM Stops) AS totalStops, "
                + "  (SELECT COUNT(*) FROM Trips) AS totalTrips, "
                + "  (SELECT COUNT(*) FROM Tickets) AS totalTickets, "
                + "  (SELECT COUNT(*) FROM MonthlyPasses) AS totalPasses, "
                + "  (SELECT COUNT(*) FROM MonthlyPasses WHERE Status = 'PENDING') AS pendingPasses, "
                + "  (SELECT COUNT(*) FROM MonthlyPasses WHERE Status = 'APPROVED') AS approvedPasses, "
                + "  (SELECT COUNT(*) FROM MonthlyPasses WHERE Status = 'REJECTED') AS rejectedPasses, "
                + "  (SELECT COUNT(*) FROM Notifications) AS totalNotifications";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                metrics.put("accounts", rs.getInt("totalAccounts"));
                metrics.put("routes", rs.getInt("totalRoutes"));
                metrics.put("stops", rs.getInt("totalStops"));
                metrics.put("trips", rs.getInt("totalTrips"));
                metrics.put("tickets", rs.getInt("totalTickets"));
                metrics.put("passes", rs.getInt("totalPasses"));
                // Put thêm 3 trạng thái mới vào Map
                metrics.put("pendingPasses", rs.getInt("pendingPasses"));
                metrics.put("approvedPasses", rs.getInt("approvedPasses"));
                metrics.put("rejectedPasses", rs.getInt("rejectedPasses"));
                metrics.put("notifications", rs.getInt("totalNotifications"));
            }
        } catch (Exception e) {
            System.out.println("Lỗi getDatabaseScaleMetrics: " + e.getMessage());
        }
        return metrics;
    }

    //Hàm doanh thu
    public List<Map<String, Object>> getRevenueByRouteAndType(
        Date fromDate,
        Date toDate
) {
    List<Map<String, Object>> list = new ArrayList<>();

    String sql
            = "SELECT r.RouteNumber, "
            + "       ISNULL(t.TicketRev, 0) AS TicketRev, "
            + "       ISNULL(p.PassRev, 0) AS PassRev "
            + "FROM Routes r "
            + "LEFT JOIN ( "
            + "    SELECT RouteID, SUM(Price) AS TicketRev "
            + "    FROM Tickets "
            + "    WHERE Status = 'COMPLETED' "
            + "      AND CAST(PurchasedAt AS DATE) BETWEEN ? AND ? "
            + "    GROUP BY RouteID "
            + ") t ON r.RouteID = t.RouteID "
            + "LEFT JOIN ( "
            + "    SELECT RouteID, SUM(Price) AS PassRev "
            + "    FROM MonthlyPasses "
            + "    WHERE Status = 'APPROVED' "
            + "      AND CAST(ApprovedAt AS DATE) BETWEEN ? AND ? "
            + "    GROUP BY RouteID "
            + ") p ON r.RouteID = p.RouteID "
            + "ORDER BY r.RouteNumber ASC";

    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setDate(1, fromDate);
        ps.setDate(2, toDate);
        ps.setDate(3, fromDate);
        ps.setDate(4, toDate);

        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();

                map.put("route", rs.getString("RouteNumber"));
                map.put("ticket", rs.getDouble("TicketRev"));
                map.put("pass", rs.getDouble("PassRev"));

                list.add(map);
            }
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return list;
}
}
