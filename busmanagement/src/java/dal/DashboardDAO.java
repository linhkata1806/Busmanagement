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

    public double getRevenueByRange(
        java.util.Date fromDate,
        java.util.Date toDate) {

    String sql = "SELECT ISNULL(SUM(Amount), 0) "
            + "FROM Payments "
            + "WHERE PaymentStatus = 'SUCCESS' "
            + "AND PaidAt >= ? "
            + "AND PaidAt < DATEADD(DAY, 1, ?)";

    java.sql.Date start =
            new java.sql.Date(fromDate.getTime());

    java.sql.Date end =
            new java.sql.Date(toDate.getTime());

    try (PreparedStatement ps =
            connection.prepareStatement(sql)) {

        ps.setDate(1, start);
        ps.setDate(2, end);

        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        }

    } catch (Exception e) {
        System.out.println(
                "Lỗi getRevenueByRange: " + e.getMessage()
        );
    }

    return 0;
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
            Date toDate,
            String routeId) {

        List<Map<String, Object>> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder();

        boolean isFilterByRoute = routeId != null
                && !"ALL".equalsIgnoreCase(routeId.trim());

        sql.append("SELECT r.RouteNumber, ");
        sql.append("       ISNULL(t.TicketRev, 0) AS TicketRev, ");
        sql.append("       ISNULL(mp.PassRev, 0) AS PassRev ");
        sql.append("FROM Routes r ");

        // Doanh thu vé lượt lấy từ giao dịch thanh toán thành công
        sql.append("LEFT JOIN ( ");
        sql.append("    SELECT COALESCE(tr.RouteID, tk.RouteID) AS RouteID, ");
        sql.append("           SUM(pm.Amount) AS TicketRev ");
        sql.append("    FROM Payments pm ");
        sql.append("    JOIN Tickets tk ON pm.TicketID = tk.TicketID ");
        sql.append("    LEFT JOIN Trips tr ON tk.TripID = tr.TripID ");
        sql.append("    WHERE pm.PaymentStatus = 'SUCCESS' ");
        sql.append("      AND pm.PaidAt >= ? ");
        sql.append("      AND pm.PaidAt < DATEADD(DAY, 1, ?) ");
        sql.append("    GROUP BY COALESCE(tr.RouteID, tk.RouteID) ");
        sql.append(") t ON r.RouteID = t.RouteID ");

        // Doanh thu vé tháng theo một tuyến
        sql.append("LEFT JOIN ( ");
        sql.append("    SELECT pass.RouteID, ");
        sql.append("           SUM(pm.Amount) AS PassRev ");
        sql.append("    FROM Payments pm ");
        sql.append("    JOIN MonthlyPasses pass ON pm.PassID = pass.PassID ");
        sql.append("    WHERE pm.PaymentStatus = 'SUCCESS' ");
        sql.append("      AND pm.PaidAt >= ? ");
        sql.append("      AND pm.PaidAt < DATEADD(DAY, 1, ?) ");
        sql.append("      AND pass.RouteID IS NOT NULL ");
        sql.append("    GROUP BY pass.RouteID ");
        sql.append(") mp ON r.RouteID = mp.RouteID ");

        if (isFilterByRoute) {
            // Khi chọn một tuyến cụ thể vẫn trả dòng kể cả doanh thu bằng 0
            sql.append("WHERE r.RouteID = ? ");
        } else {
            // Khi chọn tất cả chỉ hiện tuyến có phát sinh doanh thu
            sql.append("WHERE ISNULL(t.TicketRev, 0) > 0 ");
            sql.append("   OR ISNULL(mp.PassRev, 0) > 0 ");

            // Doanh thu vé tháng liên tuyến
            sql.append("UNION ALL ");
            sql.append("SELECT N'Liên Tuyến' AS RouteNumber, ");
            sql.append("       0 AS TicketRev, ");
            sql.append("       SUM(pm.Amount) AS PassRev ");
            sql.append("FROM Payments pm ");
            sql.append("JOIN MonthlyPasses pass ON pm.PassID = pass.PassID ");
            sql.append("WHERE pm.PaymentStatus = 'SUCCESS' ");
            sql.append("  AND pm.PaidAt >= ? ");
            sql.append("  AND pm.PaidAt < DATEADD(DAY, 1, ?) ");
            sql.append("  AND pass.RouteID IS NULL ");
            sql.append("HAVING SUM(pm.Amount) > 0 ");
        }

        sql.append("ORDER BY RouteNumber");

        try (PreparedStatement ps
                = connection.prepareStatement(sql.toString())) {

            int index = 1;

            // Vé lượt
            ps.setDate(index++, fromDate);
            ps.setDate(index++, toDate);

            // Vé tháng một tuyến
            ps.setDate(index++, fromDate);
            ps.setDate(index++, toDate);

            if (isFilterByRoute) {
                ps.setInt(index++, Integer.parseInt(routeId.trim()));
            } else {
                // Vé tháng liên tuyến
                ps.setDate(index++, fromDate);
                ps.setDate(index++, toDate);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> item = new HashMap<>();

                    item.put("route", rs.getString("RouteNumber"));
                    item.put("ticket", rs.getDouble("TicketRev"));
                    item.put("pass", rs.getDouble("PassRev"));

                    list.add(item);
                }
            }

        } catch (Exception e) {
            System.out.println(
                    "Lỗi getRevenueByRouteAndType: " + e.getMessage()
            );
            e.printStackTrace();
        }

        return list;
    }
}
