/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.staff;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.NotificationService;

/**
 *
 * @author Administrator
 */
public class DeleteNotificationServlet extends HttpServlet {

   
    private NotificationService notificationService = new NotificationService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            if (notificationService.deleteNotification(id)) {
                request.getSession().setAttribute("msgSuccess", "Đã xóa thông báo!");
            } else {
                request.getSession().setAttribute("msgError", "Không thể xóa thông báo này!");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("msgError", "Lỗi mã thông báo không hợp lệ!");
        }
        response.sendRedirect(request.getContextPath() + "/staff/notification");
    }

}
