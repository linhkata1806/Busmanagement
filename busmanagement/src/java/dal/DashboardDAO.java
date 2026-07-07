package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Date;
import java.util.Map;
import java.util.HashMap;

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
        // ĐÃ SỬA: Status = 'COMPLETED' theo đúng đặc tả mục II.6
        String ticketSql = "SELECT SUM(Price) FROM Tickets WHERE Status = 'COMPLETED' AND CAST(CreatedAt AS DATE) = CAST(GETDATE() AS DATE)";
        String passSql = "SELECT SUM(Price) FROM MonthlyPasses WHERE Status = 'APPROVED' AND CAST(UpdatedAt AS DATE) = CAST(GETDATE() AS DATE)";

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
        // ĐÃ SỬA: Status = 'COMPLETED'
        String ticketSql = "SELECT SUM(Price) FROM Tickets WHERE Status = 'COMPLETED' AND MONTH(CreatedAt) = ? AND YEAR(CreatedAt) = ?";
        String passSql = "SELECT SUM(Price) FROM MonthlyPasses WHERE Status = 'APPROVED' AND MONTH(UpdatedAt) = ? AND YEAR(UpdatedAt) = ?";

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
        // ĐÃ SỬA: Status = 'COMPLETED'
        String ticketSql = "SELECT SUM(Price) FROM Tickets WHERE Status = 'COMPLETED' AND CreatedAt BETWEEN ? AND ?";
        String passSql = "SELECT SUM(Price) FROM MonthlyPasses WHERE Status = 'APPROVED' AND UpdatedAt BETWEEN ? AND ?";

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
                + "  (SELECT COUNT(*) FROM Notifications) AS totalNotifications";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                metrics.put("accounts", rs.getInt("totalAccounts"));
                metrics.put("routes", rs.getInt("totalRoutes"));
                metrics.put("stops", rs.getInt("totalStops"));
                metrics.put("trips", rs.getInt("totalTrips"));
                metrics.put("tickets", rs.getInt("totalTickets"));
                metrics.put("passes", rs.getInt("totalPasses"));
                metrics.put("notifications", rs.getInt("totalNotifications"));
            }
        } catch (Exception e) {
            System.out.println("Lỗi getDatabaseScaleMetrics: " + e.getMessage());
        }
        return metrics;
    }
}
