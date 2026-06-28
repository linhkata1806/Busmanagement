/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import model.MonthlyPassType;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 *
 * @author Administrator
 */
public class MonthlyPassTypeDAO extends DBContext {

    public MonthlyPassType getById(int passTypeID) {
        String sql = "SELECT *\n"
                + "                 FROM MonthlyPassTypes\n"
                + "                 WHERE PassTypeID = ?";

        try (
                PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, passTypeID);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                MonthlyPassType type = new MonthlyPassType();

                type.setPassTypeID(rs.getInt("PassTypeID"));
                type.setTypeName(rs.getString("TypeName"));
                type.setDiscountPercentage(rs.getDouble("DiscountPercentage"));
                type.setDescription(rs.getString("Description"));

                return type;
            }

        } catch (SQLException e) {
            System.out.println("Lỗi getById MonthlyPassType: " + e.getMessage());
        }

        return null;
    }

}
