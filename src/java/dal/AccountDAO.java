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

    public Account getAccountByUsername(String username) {
        String sql = "SELECT a.*, r.RoleName FROM Accounts a "
                + "JOIN Roles r ON a.RoleID = r.RoleID "
                + "WHERE a.Username = ?";

        // BƯỚC 2: Gọi thẳng biến 'connection' được thừa kế từ DBContext
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, username);
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

}
