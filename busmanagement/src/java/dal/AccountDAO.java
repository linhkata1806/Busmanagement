/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import model.Account;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Administrator
 */
public class AccountDAO extends DBContext {

    private Account mapAccount(ResultSet rs) throws SQLException {
        Account acc = new Account();

        acc.setAccountID(rs.getInt("AccountID"));
        acc.setUsername(rs.getString("Username"));
        acc.setPassword(rs.getString("Password"));
        acc.setFullName(rs.getString("FullName"));
        acc.setEmail(rs.getString("Email"));
        acc.setPhone(rs.getString("Phone"));
        acc.setAvatar(rs.getString("Avatar"));
        acc.setRememberToken(rs.getString("RememberToken"));
        acc.setRoleID(rs.getInt("RoleID"));
        acc.setActive(rs.getBoolean("IsActive"));

        Timestamp ts = rs.getTimestamp("LastLogin");
        if (ts != null) {
            acc.setLastLogin(ts.toLocalDateTime());
        }

        try {
            acc.setRoleName(rs.getString("RoleName"));
        } catch (SQLException e) {
            // Bỏ qua nếu cột RoleName không tồn tại
        }

        return acc;
    }

    //=== đoạnn này dành cho authen
    public Account getAccountByUsername(String username) {
        String sql = "SELECT a.*, r.RoleName FROM Accounts a "
                + "JOIN Roles r ON a.RoleID = r.RoleID "
                + "WHERE a.Username = ? OR a.Email = ?";

        // BƯỚC 2: Gọi thẳng biến 'connection' được thừa kế từ DBContext
        try  {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapAccount(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    //=========authen
    public boolean updateRememberToken(int accountId, String token) {
        String sql = "UPDATE Accounts SET RememberToken = ? WHERE AccountID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, token);
            ps.setInt(2, accountId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    //===========authen  (Dùng cho AuthFilter)
    public Account getByRememberToken(String token) {
        String sql = "SELECT a.*, r.RoleName FROM Accounts a "
                + "JOIN Roles r ON a.RoleID = r.RoleID "
                + "WHERE a.RememberToken = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, token);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapAccount(rs); // Gọi lại hàm mapAccount có sẵn của cậu
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    //====authen xóa khi logout
    public boolean clearRememberToken(int accountId) {
        return updateRememberToken(accountId, null);
    }

    public boolean insertAccount(Account account) {
        String sql = "INSERT INTO Accounts (Username, Password, FullName, Email, Phone, RoleID) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, account.getUsername());
            ps.setString(2, account.getPassword());
            ps.setString(3, account.getFullName());
            ps.setString(4, account.getEmail());
            ps.setString(5, account.getPhone());
            ps.setInt(6, account.getRoleID());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateLastLogin(int accountID) {
        String sql = "UPDATE Accounts SET LastLogin = GETDATE() WHERE AccountID = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, accountID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean existsByUsername(String username) {
        String sql = "SELECT 1 FROM Accounts WHERE Username = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean existsByEmail(String email) {
        String sql = "SELECT 1 FROM Accounts WHERE Email = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean existsByPhone(String phone) {
        String sql = "SELECT 1 FROM Accounts WHERE Phone = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, phone);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    //=============================

    public boolean updateProfile(int accountID, String fullName, String email, String phone, String avatar) {
        String sql = "UPDATE Accounts SET FullName = ?, Email = ?, Phone = ?, Avatar = ?, UpdatedAt = GETDATE() WHERE AccountID = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, fullName);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setString(4, avatar);
            ps.setInt(5, accountID);

            // executeUpdate() trả về số dòng bị ảnh hưởng. Nếu > 0 nghĩa là update thành công.
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (Exception e) {
            System.out.println("Lỗi tại updateProfile: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean updatePhone(int accountID, String phone) {
        String sql = "UPDATE Accounts SET Phone = ?, UpdatedAt = GETDATE() WHERE AccountID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, phone);
            ps.setInt(2, accountID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Lỗi tại updatePhone: " + e.getMessage());
        }
        return false;
    }

    public Account getAccountById(int accountID) {
        // Đã ghép lệnh JOIN để lấy được cả RoleName
        String sql = "SELECT a.*, r.RoleName "
                + "FROM Accounts a "
                + "JOIN Roles r ON a.RoleID = r.RoleID "
                + "WHERE a.AccountID = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, accountID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // CẢ MỘT ĐOẠN DÀI BÂY GIỜ CHỈ CÒN ĐÚNG 1 DÒNG NÀY:
                    return mapAccount(rs);
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi tại getAccountById: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public boolean changePassword(int accountId, String hashedPassword) {
        // Cập nhật Password và tự động gán luôn thời gian sửa đổi (UpdatedAt)
        String sql = "UPDATE Accounts SET Password = ?, UpdatedAt = GETDATE() WHERE AccountID = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, hashedPassword);
            ps.setInt(2, accountId);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Lỗi tại changePassword: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public List<Account> getAccountsByRole(int roleID) {
        List<Account> list = new ArrayList<>();
        // Chỉ lấy những tài khoản đang Active
        String sql = "SELECT a.*, r.RoleName FROM Accounts a "
                + "JOIN Roles r ON a.RoleID = r.RoleID "
                + "WHERE a.RoleID = ? AND a.IsActive = 1";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, roleID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {

                list.add(mapAccount(rs));
            }

        } catch (Exception e) {
            System.out.println("Lỗi getAccountsByRole: " + e.getMessage());
        }
        return list;
    }

    //Code for ADMIN
    // 1. getAll() - Lấy toàn bộ danh sách tài khoản, sắp xếp mới nhất lên đầu
    public List<Account> getAllAccounts() {
        List<Account> list = new ArrayList<>();
        String sql = "SELECT a.*, r.RoleName "
                + "FROM Accounts a "
                + "JOIN Roles r ON a.RoleID = r.RoleID "
                + "ORDER BY a.AccountID ASC"; // Đã sửa ở đây

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapAccount(rs));
            }
        } catch (Exception e) {
            System.out.println("Lỗi tại getAllAccounts: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    // 2. searchAndFilter() - Tìm kiếm đa cột theo từ khóa và lọc theo RoleName (Bắt buộc dùng JOIN Roles)
    public List<Account> searchAndFilter(String keyword, String roleName) {
        List<Account> list = new ArrayList<>();
        String sql = "SELECT a.*, r.RoleName "
                + "FROM Accounts a "
                + "JOIN Roles r ON a.RoleID = r.RoleID "
                + "WHERE (a.Username LIKE ? OR a.FullName LIKE ? OR a.Email LIKE ?) ";

        boolean isFilterByRole = roleName != null && !roleName.equalsIgnoreCase("ALL") && !roleName.trim().isEmpty();
        if (isFilterByRole) {
            sql += "AND r.RoleName = ? ";
        }
        sql += "ORDER BY a.AccountID ASC"; // Đã sửa ở đây

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            String searchPattern = "%" + (keyword == null ? "" : keyword.trim()) + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);

            if (isFilterByRole) {
                ps.setString(4, roleName);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapAccount(rs));
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi tại searchAndFilter: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

//    // 3. existsPhone() - Kiểm tra trùng lặp số điện thoại khi tạo/sửa tài khoản
//    public boolean existsByPhone(String phone) {
//        String sql = "SELECT 1 FROM Accounts WHERE Phone = ?";
//        try (PreparedStatement ps = connection.prepareStatement(sql)) {
//            ps.setString(1, phone);
//            try (ResultSet rs = ps.executeQuery()) {
//                return rs.next();
//            }
//        } catch (Exception e) {
//            System.out.println("Lỗi tại existsByPhone: " + e.getMessage());
//        }
//        return false;
//    }
    // 4. updateStatus() - Phục vụ tính năng Lock/Unlock tài khoản qua biến IsActive (BIT)
    public boolean updateStatus(int accountId, boolean isActive) {
        String sql = "UPDATE Accounts SET IsActive = ?, UpdatedAt = GETDATE() WHERE AccountID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setBoolean(1, isActive);
            ps.setInt(2, accountId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Lỗi tại updateStatus: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean checkEmailExistsForOtherAccount(String email, int excludeAccountId) {
        String sql = "SELECT TOP 1 1 FROM Accounts WHERE Email = ? AND AccountID != ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setInt(2, excludeAccountId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next(); // Trả về true nếu có người khác đang dùng email này
            }
        } catch (Exception e) {
            System.out.println("Lỗi tại checkEmailExistsForOtherAccount: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
}
