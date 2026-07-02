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
import service.TripService;

/**
 *
 * @author Administrator
 */
public class DeleteTripServlet extends HttpServlet {
    private TripService tripService;

    @Override
    public void init() throws ServletException {
        tripService = new TripService();
    }
   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Chặn người dùng gõ URL .../delete trực tiếp trên trình duyệt
        request.getSession().setAttribute("msgError", "Thao tác không hợp lệ! Xóa chuyến xe bắt buộc phải thực hiện thông qua nút bấm trên giao diện.");
        response.sendRedirect(request.getContextPath() + "/staff/trip");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int tripID = Integer.parseInt(request.getParameter("id"));

            // Controller chỉ gọi Service, không cần if-else
            tripService.deleteTrip(tripID);

            request.getSession().setAttribute("msgSuccess", "Đã xóa chuyến xe #" + tripID + " thành công!");

        }catch (IllegalArgumentException e) {
            // Bắt đúng lỗi logic nghiệp vụ và hiển thị cho người dùng
            request.getSession().setAttribute("msgError", e.getMessage());

        }
        // Lỗi truyền sai định dạng ID
         catch (Exception e) {
            // Lỗi hệ thống: Ghi log ngầm để Dev fix, hiển thị câu xin lỗi chung chung cho User
            System.out.println("Delete Trip Error: " + e.getMessage());
            request.getSession().setAttribute("msgError", "Hệ thống đang gặp sự cố. Vui lòng thử lại sau.");
        }
        
        // Luôn Redirect về trang danh sách
        response.sendRedirect(request.getContextPath() + "/staff/trip");
    }
}
