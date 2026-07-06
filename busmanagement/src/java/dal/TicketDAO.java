/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import dto.TicketDTO;
import enums.SaleChannel;
import enums.TicketStatus;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import model.Ticket;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Administrator
 */
public class TicketDAO extends DBContext {

    //===========customer(hien thi trong thong ke o profile)
    public int countUnusedTickets(int accountId) {
        String sql = "SELECT COUNT(*) FROM Tickets WHERE AccountID = ? AND Status = 'UNUSED' AND CAST(PurchasedAt AS DATE) = CAST(GETDATE() AS DATE)";
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

    ///===== customer(dung khi cus mua ve luot)
    public boolean insert(Ticket ticket) {
        String sql = "INSERT INTO Tickets (AccountID, TripID, RouteID, TicketCode, Price, SaleChannel, Status, PurchasedAt) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, ticket.getAccountID());

            // Xử lý Null cho TripID vì SQL cho phép NULL
            if (ticket.getTripID() != null) {
                ps.setInt(2, ticket.getTripID());
            } else {
                ps.setNull(2, Types.INTEGER);
            }

            ps.setInt(3, ticket.getRouteID());
            ps.setString(4, ticket.getTicketCode());
            ps.setDouble(5, ticket.getPrice());

            // Map Enum sang String (đúng chuẩn SQL)
            ps.setString(6, ticket.getSaleChannel().name());
            ps.setString(7, ticket.getStatus().name());

            // Map LocalDateTime sang SQL Timestamp
            ps.setTimestamp(8, Timestamp.valueOf(ticket.getPurchasedAt()));

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    //==========customer(dung trong trang ve cua toi)
    public List<TicketDTO> getTicketsByAccount(int accountID) {
        List<TicketDTO> list = new ArrayList<>();
        String sql = "SELECT t.TicketCode, t.Price, t.Status, t.PurchasedAt, "
                + "r.RouteNumber, r.RouteName "
                + "FROM Tickets t "
                + "JOIN Routes r ON t.RouteID = r.RouteID "
                + "WHERE t.AccountID = ? ORDER BY t.PurchasedAt DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, accountID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TicketDTO dto = new TicketDTO();
                    dto.setTicketCode(rs.getString("TicketCode"));
                    dto.setPrice(rs.getLong("Price"));
                    dto.setStatus(enums.TicketStatus.valueOf(rs.getString("Status")));
                    dto.setPurchasedAt(rs.getTimestamp("PurchasedAt").toLocalDateTime());
                    dto.setRouteNumber(rs.getString("RouteNumber"));
                    dto.setRouteName(rs.getString("RouteName"));
                    list.add(dto);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;

    }

    private Ticket mapRowToTicket(ResultSet rs) throws SQLException {
        Ticket t = new Ticket();
        t.setTicketID(rs.getInt("TicketID"));
        t.setAccountID(rs.getInt("AccountID") == 0 ? null : rs.getInt("AccountID")); // Xử lý null chuẩn
        t.setTripID(rs.getInt("TripID") == 0 ? null : rs.getInt("TripID"));
        t.setRouteID(rs.getInt("RouteID"));
        t.setTicketCode(rs.getString("TicketCode"));
        t.setPrice(rs.getLong("Price"));
        t.setSaleChannel(SaleChannel.valueOf(rs.getString("SaleChannel")));
        t.setStatus(TicketStatus.valueOf(rs.getString("Status")));
        t.setPurchasedAt(rs.getTimestamp("PurchasedAt").toLocalDateTime());

        Timestamp usedAt = rs.getTimestamp("UsedAt");
        if (usedAt != null) {
            t.setUsedAt(usedAt.toLocalDateTime());
        }
        return t;
    }

    //======customer(dung khi  vao lich su chuyen di)
    public List<dto.TripHistoryDTO> getRecentTripsByAccount(int accountID) {
        List<dto.TripHistoryDTO> list = new ArrayList<>();
        String sql = "SELECT tr.TripDate, r.RouteNumber, b.LicensePlate, r.StartPoint, r.EndPoint "
                + "FROM Tickets t "
                + "JOIN Trips tr ON t.TripID = tr.TripID "
                + "JOIN Routes r ON tr.RouteID = r.RouteID "
                + "JOIN Buses b ON tr.BusID = b.BusID "
                + "WHERE t.AccountID = ? AND t.Status = 'COMPLETED' "
                + "ORDER BY tr.TripDate DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, accountID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    dto.TripHistoryDTO dto = new dto.TripHistoryDTO();
                    dto.setDate(rs.getDate("TripDate").toLocalDate());
                    dto.setRouteNumber(rs.getString("RouteNumber"));
                    dto.setBusPlate(rs.getString("LicensePlate"));
                    dto.setStartPoint(rs.getString("StartPoint"));
                    dto.setEndPoint(rs.getString("EndPoint"));
                    list.add(dto);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    //=====customer(hủy vé quá ngày)
    public void updateExpiredTickets() {
        String sql = "UPDATE Tickets SET Status = 'EXPIRED' WHERE Status = 'UNUSED' AND CAST(PurchasedAt AS DATE) < CAST(GETDATE() AS DATE)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public Ticket getByCode(String ticketCode) {
        String sql = "SELECT * FROM Tickets WHERE TicketCode = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, ticketCode);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRowToTicket(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateTicketStatus(int ticketID, String status) {
        String sql = "UPDATE Tickets SET Status = ? WHERE TicketID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, ticketID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean checkInTicket(int ticketID, int tripID, String status) {
        String sql = "UPDATE Tickets SET Status = ?, TripID = ?, UsedAt = GETDATE() WHERE TicketID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, tripID);
            ps.setInt(3, ticketID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int countTicketsByTripAndStatus(int tripID, String status) {
        String sql = "SELECT COUNT(*) FROM Tickets WHERE TripID = ? AND Status = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, tripID);
            ps.setString(2, status);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countUnusedTicketsForRoute(int routeID) {
        String sql = "SELECT COUNT(*) FROM Tickets WHERE RouteID = ? AND Status = 'UNUSED'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, routeID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Ticket> getTicketsByTrip(int tripID) {
        List<Ticket> list = new ArrayList<>();
        String sql = "SELECT * FROM Tickets WHERE TripID = ? ORDER BY UsedAt DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, tripID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowToTicket(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

}
