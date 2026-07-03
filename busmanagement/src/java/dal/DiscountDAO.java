package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Discount;

/**
 * DAO xử lý toàn bộ thao tác CSDL cho bảng Discounts.
 */
public class DiscountDAO extends DBContext {

    // =========================================================================
    // MAPPER
    // =========================================================================
    private Discount mapRow(ResultSet rs) throws SQLException {
        Discount d = new Discount();
        d.setDiscountID(rs.getInt("DiscountID"));
        d.setDiscountCode(rs.getString("DiscountCode"));
        d.setDiscountPercent(rs.getDouble("DiscountPercent"));
        d.setMinimumAmount(rs.getLong("MinimumAmount"));
        d.setStartDate(rs.getTimestamp("StartDate"));
        d.setEndDate(rs.getTimestamp("EndDate"));
        d.setIsActive(rs.getBoolean("IsActive"));
        d.setDescription(rs.getString("Description"));
        return d;
    }

    // =========================================================================
    // READ
    // =========================================================================

    /**
     * Tìm mã giảm giá theo code (dùng khi khách nhập vào giỏ hàng).
     * Chỉ trả về mã còn hợp lệ (IsActive = 1 AND trong thời hạn).
     */
    public Discount findValidCode(String code) {
        String sql = "SELECT * FROM Discounts "
                + "WHERE DiscountCode = ? AND IsActive = 1 "
                + "AND StartDate <= GETDATE() AND EndDate >= GETDATE()";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, code.toUpperCase().trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (Exception e) {
            System.out.println("Lỗi findValidCode Discount: " + e.getMessage());
        }
        return null;
    }

    /**
     * Lấy tất cả mã giảm giá (Admin quản lý).
     */
    public List<Discount> getAll() {
        List<Discount> list = new ArrayList<>();
        String sql = "SELECT * FROM Discounts ORDER BY CreatedAt DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (Exception e) {
            System.out.println("Lỗi getAll Discount: " + e.getMessage());
        }
        return list;
    }

    public Discount getById(int discountID) {
        String sql = "SELECT * FROM Discounts WHERE DiscountID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, discountID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (Exception e) {
            System.out.println("Lỗi getById Discount: " + e.getMessage());
        }
        return null;
    }

    // =========================================================================
    // WRITE
    // =========================================================================

    public boolean insert(Discount d) {
        String sql = "INSERT INTO Discounts (DiscountCode, DiscountPercent, MinimumAmount, "
                + "StartDate, EndDate, IsActive, Description) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, d.getDiscountCode().toUpperCase().trim());
            ps.setDouble(2, d.getDiscountPercent());
            ps.setLong(3, d.getMinimumAmount());
            ps.setTimestamp(4, d.getStartDate());
            ps.setTimestamp(5, d.getEndDate());
            ps.setBoolean(6, d.isIsActive());
            ps.setString(7, d.getDescription());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Lỗi insert Discount: " + e.getMessage());
        }
        return false;
    }

    public boolean update(Discount d) {
        String sql = "UPDATE Discounts SET DiscountPercent=?, MinimumAmount=?, "
                + "StartDate=?, EndDate=?, IsActive=?, Description=? WHERE DiscountID=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setDouble(1, d.getDiscountPercent());
            ps.setLong(2, d.getMinimumAmount());
            ps.setTimestamp(3, d.getStartDate());
            ps.setTimestamp(4, d.getEndDate());
            ps.setBoolean(5, d.isIsActive());
            ps.setString(6, d.getDescription());
            ps.setInt(7, d.getDiscountID());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Lỗi update Discount: " + e.getMessage());
        }
        return false;
    }

    public boolean delete(int discountID) {
        String sql = "DELETE FROM Discounts WHERE DiscountID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, discountID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Lỗi delete Discount: " + e.getMessage());
        }
        return false;
    }

    public boolean codeExists(String code) {
        String sql = "SELECT TOP 1 1 FROM Discounts WHERE DiscountCode = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, code.toUpperCase().trim());
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            System.out.println("Lỗi codeExists Discount: " + e.getMessage());
        }
        return false;
    }
}
