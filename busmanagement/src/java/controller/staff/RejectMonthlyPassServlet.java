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
import jakarta.servlet.http.HttpSession;
import model.Account;
import service.MonthlyPassService;

/**
 *
 * @author Administrator
 */
public class RejectMonthlyPassServlet extends HttpServlet {
    private MonthlyPassService monthlyPassService;

    @Override
    public void init() throws ServletException {
         monthlyPassService = new MonthlyPassService();
    }
    
    
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet RejectMonthlyPassServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet RejectMonthlyPassServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Account currentStaff = (Account) session.getAttribute("USER");

        try {
            // 2. Lấy ID hồ sơ từ đường dẫn link
            int passID = Integer.parseInt(request.getParameter("id"));
            int staffID = currentStaff.getAccountID();

            // 3. Tái sử dụng hàm rejectPass trong Service của bạn (sau khi đã sửa lỗi PENDING thành REJECTED)
            boolean isSuccess = monthlyPassService.rejectPass(passID, staffID);

            if (isSuccess) {
                session.setAttribute("msgSuccess", "Đã từ chối đơn đăng ký và gửi thông báo phản hồi tới khách hàng.");
            } else {
                session.setAttribute("msgError", "Từ chối thất bại! Vui lòng kiểm tra lại trạng thái hiện tại của hồ sơ.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("msgError", "Yêu cầu xử lý thất bại: Mã số đơn đăng ký không hợp lệ.");
        } catch (Exception e) {
            session.setAttribute("msgError", "Lỗi hệ thống: " + e.getMessage());
        }

        // 4. Điều hướng ngược lại trang danh sách chính
        response.sendRedirect(request.getContextPath() + "/staff/monthly-pass");
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
