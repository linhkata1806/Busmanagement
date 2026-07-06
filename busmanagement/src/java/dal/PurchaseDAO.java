/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import model.Notification;
import model.Ticket;
import java.sql.*;
import model.MonthlyPass;

/**
 *
 * @author Administrator
 */
public class PurchaseDAO extends DBContext {

    private TicketDAO ticketDAO;
    private MonthlyPassDAO monthlyPassDAO;
    private NotificationDAO notificationDAO;

    public PurchaseDAO() {
        super(); // Mở connection từ DBContext
        // Chia sẻ connection cho tất cả các DAO con
        ticketDAO = new TicketDAO();
        ticketDAO.setConnection(this.connection);
        monthlyPassDAO = new MonthlyPassDAO();
        monthlyPassDAO.setConnection(this.connection);
        notificationDAO = new NotificationDAO();
        notificationDAO.setConnection(this.connection);
    }

    public void executePurchaseTicket(Ticket ticket, Notification notification) throws Exception {
        try {
            connection.setAutoCommit(false);
            if (!ticketDAO.insert(ticket)) {
                throw new Exception("Lỗi hệ thống: Không thể ghi nhận vé vào cơ sở dữ liệu.");
            }
            notificationDAO.insert(notification);
            connection.commit();
        } catch (Exception e) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            throw e;
        } finally {
            close(); // Đóng connection sau khi hoàn tất
        }
    }

    /**
     * Lưu vé tháng (đơn tuyến hoặc liên tuyến) + thông báo trong 1 transaction.
     * Nếu lỗi ở bất kỳ bước nào → rollback toàn bộ.
     */
    public void executePurchaseMonthlyPass(MonthlyPass pass, Notification notification) throws Exception {
        try {
            connection.setAutoCommit(false);
            monthlyPassDAO.insert(pass);
            notificationDAO.insert(notification);
            connection.commit();
        } catch (Exception e) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            throw e;
        } finally {
            close(); // Đóng connection sau khi hoàn tất
        }
    }
}
