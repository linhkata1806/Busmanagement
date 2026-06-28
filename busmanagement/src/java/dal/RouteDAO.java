/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.util.ArrayList;
import java.util.List;
import model.Route;
import model.Stop;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 *
 * @author Administrator
 */
public class RouteDAO extends DBContext {

    //top n popular
    public List<Route> getPopularRoutes(int limit) {
        List<Route> list = new ArrayList<>();
        String sql = "SELECT TOP (?) * "
                + "FROM Routes WHERE IsActive = 1 ORDER BY RouteNumber ASC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRoute(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private Route mapRoute(ResultSet rs) throws Exception {
        Route route = new Route();
        route.setRouteID(rs.getInt("RouteID"));
        route.setRouteNumber(rs.getString("RouteNumber"));
        route.setRouteName(rs.getString("RouteName"));        // ← tên field là route
        route.setStartPoint(rs.getString("StartPoint"));
        route.setEndPoint(rs.getString("EndPoint"));
        route.setOperatingHours(rs.getString("OperatingHours"));
        route.setFrequence(rs.getString("Frequency"));    // ← frequence
        route.setTicketPrice(rs.getLong("TicketPrice"));  // ← long
        route.setTotalDistance(rs.getDouble("TotalDistance")); // ← double
        route.setIsActive(rs.getBoolean("IsActive"));
        return route;
    }

    //search base on rout name or route number
    public List<Route> searchRoutes(String keyword) {
        List<Route> list = new ArrayList<>();
        String sql = "SELECT * "
                + "FROM Routes WHERE IsActive = 1 "
                + "AND (RouteNumber LIKE ? OR RouteName LIKE ? OR StartPoint LIKE ? OR EndPoint LIKE ?) "
                + "ORDER BY RouteNumber ASC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            if (keyword == null) {
                keyword = "";
            }

            String kw = "%" + keyword.trim() + "%";
            ps.setString(1, kw);
            ps.setString(2, kw);
            ps.setString(3, kw);
            ps.setString(4, kw);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRoute(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    //get all active routes
    public List<Route> getAllActiveRoutes() {
        List<Route> list = new ArrayList<>();
        String sql = "SELECT * FROM Routes WHERE IsActive = 1 ORDER BY RouteNumber ASC";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRoute(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    //get all suspended routes
    public List<Route> getSuspendedRoutes() {
        List<Route> list = new ArrayList<>();
        String sql = "SELECT * FROM Routes WHERE IsActive = 0 ORDER BY RouteNumber ASC";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRoute(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    //get route by id
    public Route getRouteById(int routeId) {
        String sql = "SELECT * FROM Routes WHERE RouteID = ? AND IsActive = 1";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, routeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRoute(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean existsRoute(int routeId) {
        String sql = "SELECT 1\n"
                + "FROM Routes\n"
                + "WHERE RouteID=? and IsActive = 1";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, routeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public Route getRouteByNumber(String routeNumber) {
        String sql = "SELECT *\n"
                + "FROM Routes\n"
                + "WHERE RouteNumber=? and IsActive = 1";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, routeNumber);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRoute(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Route> findRoutesBetweenStops(int fromStopID, int toStopID) {
        List<Route> list = new ArrayList<>();
        String sql = "SELECT r.* FROM Routes r "
                + "JOIN Route_Stop rs1 ON r.RouteID = rs1.RouteID "
                + "JOIN Route_Stop rs2 ON r.RouteID = rs2.RouteID "
                + "WHERE rs1.StopID = ? "
                + "AND rs2.StopID = ? "
                + "AND rs1.StopOrder < rs2.StopOrder "
                + "AND r.IsActive = 1"; // Chỉ lấy các tuyến đang hoạt động
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, fromStopID);
            st.setInt(2, toStopID);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                // mapRoute là hàm đọc dữ liệu từ ResultSet vào Object Route của bạn
                Route route = mapRoute(rs);
                list.add(route);
            }
        } catch (Exception e) {
            System.out.println("Lỗi findRoutesBetweenStops: " + e.getMessage());
        }
        return list;
    }
}
