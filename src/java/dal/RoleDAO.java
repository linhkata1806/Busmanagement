/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import model.Role;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
/**
 *
 * @author Administrator
 */
public class RoleDAO extends DBContext{

    public Role getRoleByName(String customer) {
        String sql = "SELECT * FROM Roles WHERE RoleName = ?";

        // Gọi thẳng biến 'connection' thừa kế từ DBContext
        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setString(1, customer);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Role role = new Role();
                    role.setRoleID(rs.getInt("RoleID"));
                    role.setRoleName(rs.getString("RoleName"));

                    // Nếu bảng Roles của bạn có thêm cột mô tả (Description) thì map thêm vào đây:
                    // role.setDescription(rs.getString("Description"));
                    return role;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null; // Trả về null nếu không tìm thấy quyền này trong DB    }

    }
}
