/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.staff.trip;

import dto.TripDTO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.time.LocalDate;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import service.RouteService;
import service.TripService;

/**
 *
 * @author Administrator
 */
public class TripManagementServlet extends HttpServlet {

    private TripService tripService;
    private RouteService routeService;

    @Override
    public void init() throws ServletException {
        tripService = new TripService();
        routeService = new RouteService();
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
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String dateStr = request.getParameter("date");
        String routeIdStr = request.getParameter("routeID");
        String plate = request.getParameter("plate");
        String status = request.getParameter("status");

        // Làm sạch chuỗi
        dateStr = dateStr == null ? "" : dateStr.trim();
        routeIdStr = routeIdStr == null ? "" : routeIdStr.trim();
        plate = plate == null ? "" : plate.trim();
        status = status == null ? "" : status.trim();

        // 2. Ép kiểu RouteID (Nếu là ALL hoặc rỗng thì gán = -1 để DAO hiểu là lấy tất cả)
        int routeID = -1;

        if (!routeIdStr.isEmpty() && !"ALL".equalsIgnoreCase(routeIdStr)) {
            try {
                routeID = Integer.parseInt(routeIdStr);
            } catch (NumberFormatException e) {
                routeID = -1;
                request.setAttribute("errorMsg", "Mã tuyến không hợp lệ.");
            }
        }
        // 3. Gọi DUY NHẤT 1 hàm search (Gọn gàng vô cùng!)
        List<TripDTO> list = tripService.searchTrips(dateStr, routeID, plate, status);

        // Đổ dữ liệu tuyến xe vào Dropdown (Nhớ gọi hàm DAO/Service thực tế của nhé e yeu)
        request.setAttribute("routes", routeService.getAllActiveRoutes());

        // 4. Giữ lại filter trên giao diện và forward
        request.setAttribute("filterDate", dateStr);
        request.setAttribute("filterRoute", routeIdStr);
        request.setAttribute("filterPlate", plate);
        request.setAttribute("filterStatus", status);

        StringBuilder qs = new StringBuilder();
        if (dateStr != null && !dateStr.isEmpty()) qs.append("date=").append(dateStr).append("&");
        if (routeIdStr != null && !routeIdStr.isEmpty()) qs.append("routeID=").append(routeIdStr).append("&");
        if (plate != null && !plate.isEmpty()) qs.append("plate=").append(plate).append("&");
        if (status != null && !status.isEmpty()) qs.append("status=").append(status).append("&");
        if (qs.length() > 0) {
            qs.deleteCharAt(qs.length() - 1);
            request.setAttribute("queryString", qs.toString());
        }

        int page = 1;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
            } catch (Exception e) {}
        }
        util.Page<TripDTO> pageInfo = new util.Page<>(list, page, list.size(), 10);
        int start = (page - 1) * 10;
        int end = Math.min(start + 10, list.size());
        List<TripDTO> pagedList = list.isEmpty() ? list : list.subList(start, end);

        request.setAttribute("trips", pagedList);
        request.setAttribute("currentPage", pageInfo.getCurrentPage());
        request.setAttribute("totalPages", pageInfo.getTotalPages());

        request.getRequestDispatcher("/view/staff/trip/trip-management.jsp").forward(request, response);
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
        doGet(request, response);
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
