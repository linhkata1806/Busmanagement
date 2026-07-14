package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.BusLocationHistory;

/**
 * DAO xử lý toàn bộ thao tác CSDL cho bảng BusLocationHistory.
 * Dùng để lưu vết tọa độ GPS xe buýt định kỳ phục vụ Map Animation.
 */
public class BusLocationHistoryDAO extends DBContext {

    // =========================================================================
    // MAPPER
    // =========================================================================
    private BusLocationHistory mapRow(ResultSet rs) throws SQLException {
        BusLocationHistory loc = new BusLocationHistory();
        loc.setHistoryID(rs.getInt("HistoryID"));
        loc.setBusID(rs.getInt("BusID"));
        loc.setTripID(rs.getInt("TripID"));
        loc.setLatitude(rs.getDouble("Latitude"));
        loc.setLongitude(rs.getDouble("Longitude"));
        loc.setRecordedAt(rs.getTimestamp("RecordedAt"));
        return loc;
    }

    // =========================================================================
    // READ
    // =========================================================================

    /**
     * Lấy toàn bộ vết GPS của một chuyến xe theo thứ tự thời gian.
     * Dùng để vẽ lại lộ trình xe đã đi (Playback Mode).
     */
    public List<BusLocationHistory> getByTrip(int tripID) {
        List<BusLocationHistory> list = new ArrayList<>();
        String sql = "SELECT * FROM BusLocationHistory WHERE TripID = ? ORDER BY RecordedAt ASC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, tripID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (Exception e) {
            System.out.println("Lỗi getByTrip BusLocationHistory: " + e.getMessage());
        }
        return list;
    }

    /**
     * Lấy vị trí GPS mới nhất của một chuyến xe đang chạy.
     * Dùng cho Map Animation theo thời gian thực.
     */
    public BusLocationHistory getLatestByTrip(int tripID) {
        String sql = "SELECT TOP 1 * FROM BusLocationHistory WHERE TripID = ? ORDER BY RecordedAt DESC";
        try  {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, tripID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (Exception e) {
            System.out.println("Lỗi getLatestByTrip BusLocationHistory: " + e.getMessage());
        }
        return null;
    }

    /**
     * Lấy vị trí GPS mới nhất của một xe (theo BusID), bất kể chuyến nào.
     */
    public BusLocationHistory getLatestByBus(int busID) {
        String sql = "SELECT TOP 1 * FROM BusLocationHistory WHERE BusID = ? ORDER BY RecordedAt DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, busID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (Exception e) {
            System.out.println("Lỗi getLatestByBus BusLocationHistory: " + e.getMessage());
        }
        return null;
    }

    // =========================================================================
    // WRITE
    // =========================================================================

    /**
     * Ghi một bản ghi vị trí GPS mới (gọi định kỳ từ GPS tracker của xe).
     */
    public boolean insert(BusLocationHistory loc) {
        String sql = "INSERT INTO BusLocationHistory (BusID, TripID, Latitude, Longitude) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, loc.getBusID());
            ps.setInt(2, loc.getTripID());
            ps.setDouble(3, loc.getLatitude());
            ps.setDouble(4, loc.getLongitude());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Lỗi insert BusLocationHistory: " + e.getMessage());
        }
        return false;
    }

    /**
     * Xóa toàn bộ lịch sử GPS của một chuyến xe (dùng khi chuyến bị hủy).
     */
    public boolean deleteByTrip(int tripID) {
        String sql = "DELETE FROM BusLocationHistory WHERE TripID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, tripID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Lỗi deleteByTrip BusLocationHistory: " + e.getMessage());
        }
        return false;
    }
}
