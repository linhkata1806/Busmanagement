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
public class ApproveMonthlyPassServlet extends HttpServlet {

    private MonthlyPassService monthlyPassService;

    @Override
    public void init() throws ServletException {
        monthlyPassService = new MonthlyPassService();
    }

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
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
            out.println("<title>Servlet ApproveMonthlyPassServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ApproveMonthlyPassServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
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
            //lay id pass vs staff ne
            int passID = Integer.parseInt(request.getParameter("id"));
            int staffID = currentStaff.getAccountID();

            boolean isSuccess = monthlyPassService.approvePass(passID, staffID);

            if (isSuccess) {
                session.setAttribute("msgSuccess", "Hệ thống đã phê duyệt hồ sơ và gửi thông báo tới khách hàng thành công!");
            } else {
                session.setAttribute("msgError", "Phê duyệt thất bại! Hồ sơ có thể đã được xử lý bởi người khác hoặc trạng thái không hợp lệ.");
            }

        } catch (Exception e) {
            session.setAttribute("msgError", "Lỗi hệ thống: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath()+"/staff/monthly-pass");
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
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
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
