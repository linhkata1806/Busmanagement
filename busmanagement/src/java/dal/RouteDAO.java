package dal;

import java.util.ArrayList;
import java.util.List;
import model.Route;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class RouteDAO extends DBContext {

    private Route mapRoute(ResultSet rs) throws Exception {
        Route route = new Route();
        route.setRouteID(rs.getInt("RouteID"));
        route.setRouteNumber(rs.getString("RouteNumber"));
        route.setRouteName(rs.getString("RouteName"));
        route.setStartPoint(rs.getString("StartPoint"));
        route.setEndPoint(rs.getString("EndPoint"));
        route.setOperatingHours(rs.getString("OperatingHours"));
        route.setFrequence(rs.getString("Frequency"));
        route.setTicketPrice(rs.getLong("TicketPrice"));
        route.setTotalDistance(rs.getDouble("TotalDistance"));
        route.setIsActive(rs.getBoolean("IsActive"));
        route.setEstimatedDuration(rs.getInt("EstimatedDuration"));
        return route;
    }

    //==== hàm cho guest sau sẽ đổi thành poppular
    public List<Route> getPopularRoutes(int limit) {
        List<Route> list = new ArrayList<>();
        String sql = "SELECT TOP (?) * FROM Routes WHERE IsActive = 1 ORDER BY RouteNumber ASC";
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

    //=== ham cho guest dẩy lên routeList-Servlet
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
    //==== ham cho guest
    public Route getRouteById(int routeId) {
        String sql = "SELECT * FROM Routes WHERE RouteID = ?";
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
    //==== ham cho guest

    public List<Route> searchRoutes(String keyword) {
        List<Route> list = new ArrayList<>();
        String sql = "SELECT * FROM Routes WHERE IsActive = 1 "
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

        //==== ham cho guest
    public List<Route> findRoutesBetweenStops(int fromStopID, int toStopID) {
        List<Route> list = new ArrayList<>();
        String sql = "SELECT r.* FROM Routes r "
                + "JOIN Route_Stop rs1 ON r.RouteID = rs1.RouteID "
                + "JOIN Route_Stop rs2 ON r.RouteID = rs2.RouteID "
                + "WHERE rs1.StopID = ? AND rs2.StopID = ? "
                + "AND rs1.StopOrder < rs2.StopOrder AND r.IsActive = 1";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, fromStopID);
            st.setInt(2, toStopID);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRoute(rs));
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi findRoutesBetweenStops: " + e.getMessage());
        }
        return list;
    }

    public List<Route> getSuspendedRoutes() {
        List<Route> list = new ArrayList<>();
        String sql = "SELECT * FROM Routes WHERE IsActive = 0";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRoute(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean existsRoute(int routeId) {
        String sql = "SELECT 1 FROM Routes WHERE RouteID=? and IsActive = 1";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, routeId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public Route getRouteByNumber(String routeNumber) {
        String sql = "SELECT * FROM Routes WHERE RouteNumber=? and IsActive = 1";
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

    public int countSearchAndFilter(String keyword, String status) {
        String sql = "SELECT COUNT(*) FROM Routes "
                   + "WHERE (RouteNumber LIKE ? OR RouteName LIKE ? OR StartPoint LIKE ? OR EndPoint LIKE ?) "
                   + "AND (?='ALL' OR IsActive=?)";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            String kw = "%" + keyword + "%";
            ps.setString(1, kw);
            ps.setString(2, kw);
            ps.setString(3, kw);
            ps.setString(4, kw);

            ps.setString(5, status);
            int activeValue = "ACTIVE".equalsIgnoreCase(status) ? 1 : 0;
            ps.setInt(6, activeValue);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi countSearchAndFilter Route: " + e.getMessage());
        }
        return 0;
    }

    public List<Route> searchAndFilter(String keyword, String status, int offset, int limit) {
        List<Route> list = new ArrayList<>();

        // Format SQL dễ đọc, dễ maintain
        String sql
                = "SELECT * "
                + "FROM Routes "
                + "WHERE "
                + "(RouteNumber LIKE ? "
                + "OR RouteName LIKE ? "
                + "OR StartPoint LIKE ? "
                + "OR EndPoint LIKE ?) "
                + "AND "
                + "(?='ALL' OR IsActive=?) "
                + "ORDER BY RouteNumber ASC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            String kw = "%" + keyword + "%";
            ps.setString(1, kw);
            ps.setString(2, kw);
            ps.setString(3, kw);
            ps.setString(4, kw);

            ps.setString(5, status);

            // Xử lý điều kiện rõ ràng, tường minh
            int activeValue = 0;
            if ("ACTIVE".equalsIgnoreCase(status)) {
                activeValue = 1;
            }
            ps.setInt(6, activeValue);
            
            ps.setInt(7, offset);
            ps.setInt(8, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRoute(rs));
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi searchAndFilter Route: " + e.getMessage());
        }
        return list;
    }

    public boolean existsRouteNumber(String routeNumber) {
        String sql = "SELECT TOP 1 1 FROM Routes WHERE RouteNumber = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, routeNumber);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean existsById(int routeId) {
        String sql = "SELECT TOP 1 1 FROM Routes WHERE RouteID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, routeId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean insert(Route route) {
        String sql = "INSERT INTO Routes (RouteNumber, RouteName, StartPoint, EndPoint, OperatingHours, Frequency, TicketPrice, TotalDistance, IsActive, EstimatedDuration) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, route.getRouteNumber());
            ps.setString(2, route.getRouteName());
            ps.setString(3, route.getStartPoint());
            ps.setString(4, route.getEndPoint());
            ps.setString(5, route.getOperatingHours());
            ps.setString(6, route.getFrequence());
            ps.setLong(7, route.getTicketPrice());
            ps.setDouble(8, route.getTotalDistance());
            ps.setInt(9, route.isIsActive() ? 1 : 0);
            ps.setInt(10, route.getEstimatedDuration());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Lỗi insert Route: " + e.getMessage());
        }
        return false;
    }

    public boolean update(Route route) {
        String sql = "UPDATE Routes SET RouteName=?, StartPoint=?, EndPoint=?, OperatingHours=?, Frequency=?, TicketPrice=?, TotalDistance=?, IsActive=?, EstimatedDuration=? WHERE RouteID=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, route.getRouteName());
            ps.setString(2, route.getStartPoint()); // BỔ SUNG
            ps.setString(3, route.getEndPoint());   // BỔ SUNG
            ps.setString(4, route.getOperatingHours());
            ps.setString(5, route.getFrequence());
            ps.setLong(6, route.getTicketPrice());
            ps.setDouble(7, route.getTotalDistance());
            ps.setInt(8, route.isIsActive() ? 1 : 0);
            ps.setInt(9, route.getEstimatedDuration());
            ps.setInt(10, route.getRouteID());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Lỗi update Route: " + e.getMessage());
        }
        return false;
    }

    public boolean updateStatus(int routeID, boolean isActive) {
        String sql = "UPDATE Routes SET IsActive = ? WHERE RouteID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, isActive ? 1 : 0);
            ps.setInt(2, routeID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Lỗi updateStatus Route: " + e.getMessage());
        }
        return false;
    }

    public boolean delete(int routeId) {
        String sql = "DELETE FROM Routes WHERE RouteID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, routeId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Lỗi delete Route: " + e.getMessage());
        }
        return false;
    }
}
