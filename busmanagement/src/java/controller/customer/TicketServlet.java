/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.customer;

import dto.MonthlyPassDTO;
import dto.TicketDTO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.util.List;
import model.Account;
import service.MonthlyPassService;
import service.TicketService;

/**
 *
 * @author Administrator
 */
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
        maxFileSize = 1024 * 1024 * 5, // 5 MB (Bắt buộc theo Spec)
        maxRequestSize = 1024 * 1024 * 10 // 10 MB
)
public class TicketServlet extends HttpServlet {

    private TicketService ticketService;
    private MonthlyPassService monthlyPassService;

    @Override
    public void init() throws ServletException {
        ticketService = new TicketService();
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
        String tab = request.getParameter("tab");
        Account user = (Account) session.getAttribute("USER");
        int accountID = user.getAccountID();
        if (tab == null) {
            tab = "ticket";
        }
        //service lay du lieu tu DTO
        List<TicketDTO> ticketList = ticketService.getTicketsByAccount(accountID);
        List<MonthlyPassDTO> routePassList = monthlyPassService.getRoutePasses(accountID);
        List<MonthlyPassDTO> allRoutePassList = monthlyPassService.getAllRoutePasses(accountID);

        //SET DTO trong request
        request.setAttribute("activeTab", tab);
        request.setAttribute("ticketList", ticketList);
        request.setAttribute("routePassList", routePassList);
        request.setAttribute("allRoutePassList", allRoutePassList);
        request.getRequestDispatcher("/view/customer/ticket.jsp").forward(request, response);
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
        String action = request.getParameter("action");
        if ("registerPass".equals(action)) {
            try {
                HttpSession session = request.getSession(false);
                Account user = (Account) session.getAttribute("USER");
                if (user == null) {
                    response.sendRedirect(request.getContextPath() + "/login");
                    return;
                }
                //Lấy Part chứa file ảnh từ form
                Part filePart = request.getPart("imageProof");
                //Định vị thư mục thực tế trên Server
                String applicationPath = request.getServletContext().getRealPath("");
                String uploadPath = applicationPath + File.separator + "uploads" + File.separator + "pass-proof";
                //Gọi Service xử lý lưu file (hàm processAndSaveProof tớ vừa viết cho cậu ở trên)
                String dbImagePath = monthlyPassService.processAndSaveProof(filePart, uploadPath);
                //Lấy các thông số đăng ký vé từ Form
                int passTypeID = Integer.parseInt(request.getParameter("passTypeID"));
                String routeIdParam = request.getParameter("routeID");
                if (routeIdParam != null && !routeIdParam.trim().isEmpty()) {
                    // Vé 1 tuyến
                    int routeID = Integer.parseInt(routeIdParam);
                    monthlyPassService.registerRoutePass(user.getAccountID(), routeID, passTypeID, dbImagePath);
                } else {
                    // Vé liên tuyến (truyền routeID = null ngầm bên trong hàm)
                    monthlyPassService.registerAllRoutePass(user.getAccountID(), passTypeID, dbImagePath);
                }
                session.setAttribute("successMsg", "Đăng ký vé tháng thành công! Vui lòng chờ nhân viên xét duyệt.");
                response.sendRedirect(request.getContextPath() + "/customer/ticket?tab=pass");
            } catch (IllegalArgumentException e) {
                // Lỗi file rác, quá 5MB -> Trả về chữ đỏ
                request.setAttribute("errorMsg", e.getMessage());
                // Chuyển hướng lại trang form đăng ký
                request.getRequestDispatcher("/view/customer/register-pass.jsp").forward(request, response);
            } catch (Exception e) {
                // Lỗi hệ thống
                request.setAttribute("errorMsg", "Lỗi hệ thống khi tải ảnh lên.");
                request.getRequestDispatcher("/view/customer/register-pass.jsp").forward(request, response);
            }
        }
        else {
            doGet(request, response);
        }
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
