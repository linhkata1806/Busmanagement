package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Payment;
import model.Payment.PaymentStatus;

/**
 * DAO xử lý toàn bộ thao tác CSDL cho bảng Payments.
 * Luồng: Generate QR -> PENDING -> SUCCESS -> Tự động Create Ticket
 */
public class PaymentDAO extends DBContext {

    // =========================================================================
    // MAPPER
    // =========================================================================
    private Payment mapRow(ResultSet rs) throws SQLException {
        Payment p = new Payment();
        p.setPaymentID(rs.getInt("PaymentID"));
        p.setAccountID(rs.getInt("AccountID"));

        int ticketID = rs.getInt("TicketID");
        p.setTicketID(rs.wasNull() ? null : ticketID);

        int passID = rs.getInt("PassID");
        p.setPassID(rs.wasNull() ? null : passID);

        p.setAmount(rs.getLong("Amount"));
        p.setPaymentMethod(rs.getString("PaymentMethod"));
        p.setTransactionCode(rs.getString("TransactionCode"));
        p.setQrImage(rs.getString("QRImage"));
        p.setPaymentStatus(PaymentStatus.valueOf(rs.getString("PaymentStatus")));
        p.setPaidAt(rs.getTimestamp("PaidAt"));
        p.setCreatedAt(rs.getTimestamp("CreatedAt"));
        return p;
    }

    // =========================================================================
    // READ
    // =========================================================================

    /**
     * Lấy lịch sử giao dịch của một tài khoản, sắp xếp mới nhất trước.
     */
    public List<Payment> getByAccount(int accountID) {
        List<Payment> list = new ArrayList<>();
        String sql = "SELECT * FROM Payments WHERE AccountID = ? ORDER BY CreatedAt DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, accountID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi getByAccount Payment: " + e.getMessage());
        }
        return list;
    }

    /**
     * Lấy một giao dịch theo ID.
     */
    public Payment getById(int paymentID) {
        String sql = "SELECT * FROM Payments WHERE PaymentID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, paymentID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (Exception e) {
            System.out.println("Lỗi getById Payment: " + e.getMessage());
        }
        return null;
    }

    /**
     * Lấy tất cả giao dịch (Admin/Staff xem báo cáo).
     */
    public List<Payment> getAll() {
        List<Payment> list = new ArrayList<>();
        String sql = "SELECT * FROM Payments ORDER BY CreatedAt DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (Exception e) {
            System.out.println("Lỗi getAll Payment: " + e.getMessage());
        }
        return list;
    }

    // =========================================================================
    // WRITE
    // =========================================================================

    /**
     * Tạo giao dịch mới với trạng thái PENDING.
     * @return PaymentID vừa tạo, hoặc -1 nếu lỗi.
     */
    public int insert(Payment payment) {
        String sql = "INSERT INTO Payments (AccountID, TicketID, PassID, Amount, PaymentMethod, "
                + "TransactionCode, QRImage, PaymentStatus) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql,
                PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, payment.getAccountID());
            if (payment.getTicketID() == null) ps.setNull(2, java.sql.Types.INTEGER);
            else ps.setInt(2, payment.getTicketID());
            if (payment.getPassID() == null) ps.setNull(3, java.sql.Types.INTEGER);
            else ps.setInt(3, payment.getPassID());
            ps.setLong(4, payment.getAmount());
            ps.setString(5, payment.getPaymentMethod());
            ps.setString(6, payment.getTransactionCode());
            ps.setString(7, payment.getQrImage());
            ps.setString(8, payment.getPaymentStatus().name());
            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) return keys.getInt(1);
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi insert Payment: " + e.getMessage());
        }
        return -1;
    }

    /**
     * Cập nhật trạng thái thanh toán và ghi nhận mã giao dịch khi SUCCESS.
     */
    public boolean updateStatus(int paymentID, PaymentStatus status, String transactionCode) {
        String sql = "UPDATE Payments SET PaymentStatus = ?, TransactionCode = ?, "
                + "PaidAt = CASE WHEN ? = 'SUCCESS' THEN GETDATE() ELSE PaidAt END "
                + "WHERE PaymentID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status.name());
            ps.setString(2, transactionCode);
            ps.setString(3, status.name());
            ps.setInt(4, paymentID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Lỗi updateStatus Payment: " + e.getMessage());
        }
        return false;
    }

    /**
     * Đếm tổng số giao dịch thành công (dùng cho Dashboard).
     */
    public int countSuccessful() {
        String sql = "SELECT COUNT(*) FROM Payments WHERE PaymentStatus = 'SUCCESS'";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            System.out.println("Lỗi countSuccessful Payment: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Tính tổng doanh thu (Amount) từ các giao dịch SUCCESS.
     */
    public long getTotalRevenue() {
        String sql = "SELECT ISNULL(SUM(Amount), 0) FROM Payments WHERE PaymentStatus = 'SUCCESS'";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getLong(1);
        } catch (Exception e) {
            System.out.println("Lỗi getTotalRevenue: " + e.getMessage());
        }
        return 0;
    }
}
