/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.staff;

import dal.StopDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Stop;
import service.StopService;

/**
 *
 * @author Administrator
 */
public class UpdateStopServlet extends HttpServlet {

    private StopService stopService;
    private StopDAO stopDAO;

    @Override
    public void init() throws ServletException {
        stopService = new StopService();
        stopDAO = new StopDAO();
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
        String idStr = request.getParameter("id");
        try {
            int stopId = Integer.parseInt(idStr);
            Stop stop = stopDAO.getStopById(stopId);

            if (stop == null) {
                request.getSession().setAttribute("msgError", "Không tìm thấy điểm dừng!");
                response.sendRedirect(request.getContextPath() + "/staff/stop");
                return;
            }

            request.setAttribute("stop", stop);
            request.getRequestDispatcher("/view/staff/edit-stop.jsp").forward(request, response);
        } catch (Exception e) {
            request.getSession().setAttribute("msgError", "Mã điểm dừng không hợp lệ!");
            response.sendRedirect(request.getContextPath() + "/staff/stop");
        }
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
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String idStr = request.getParameter("stopID");
        String stopName = request.getParameter("stopName");
        String address = request.getParameter("address");
        String latStr = request.getParameter("latitude");
        String lngStr = request.getParameter("longitude");
        String isActiveStr = request.getParameter("isActive");

        try {

            int stopId = Integer.parseInt(idStr.trim());

            double lat = Double.parseDouble(latStr.trim());
            double lng = Double.parseDouble(lngStr.trim());

            boolean isActive
                    = "true".equalsIgnoreCase(isActiveStr);

            stopService.updateStop(
                    stopId,
                    stopName,
                    address,
                    lat,
                    lng,
                    isActive
            );

            request.getSession().setAttribute(
                    "msgSuccess",
                    "Đã cập nhật thông tin điểm dừng thành công!"
            );

            response.sendRedirect(
                    request.getContextPath() + "/staff/stop"
            );

        } catch (NumberFormatException e) {

            handleError(
                    request,
                    response,
                    "ID và tọa độ phải là số hợp lệ!",
                    idStr,
                    stopName,
                    address,
                    latStr,
                    lngStr,
                    isActiveStr
            );

        } catch (IllegalArgumentException e) {

            handleError(
                    request,
                    response,
                    e.getMessage(),
                    idStr,
                    stopName,
                    address,
                    latStr,
                    lngStr,
                    isActiveStr
            );

        } catch (Exception e) {

            e.printStackTrace();

            handleError(
                    request,
                    response,
                    "Hệ thống đang gặp sự cố. Vui lòng thử lại sau.",
                    idStr,
                    stopName,
                    address,
                    latStr,
                    lngStr,
                    isActiveStr
            );

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

    private void handleError(HttpServletRequest request, HttpServletResponse response, String errorMsg,
            String stopID, String stopName, String address, String lat, String lng, String isActive)
            throws ServletException, IOException {
        request.setAttribute("msgError", errorMsg);

        // Dựng lại Object Stop để JSP dễ dàng dùng lại cú pháp ${stop.stopName}, ${stop.latitude}...
        Stop stop = new Stop();
        try {
            stop.setStopID(Integer.parseInt(stopID));
        } catch (Exception ignored) {
        }
        stop.setStopName(stopName);
        stop.setAddress(address);
        try {
            stop.setLatitude(Double.parseDouble(lat));
        } catch (Exception ignored) {
        }
        try {
            stop.setLongitude(Double.parseDouble(lng));
        } catch (Exception ignored) {
        }
        stop.setIsActive(Boolean.parseBoolean(isActive));

        request.setAttribute("stop", stop);
        request.getRequestDispatcher("/view/staff/edit-stop.jsp").forward(request, response);
    }

}
