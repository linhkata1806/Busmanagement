/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.payment;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.util.Enumeration;
import model.Account;
import model.Route;
import service.MonthlyPassService;
import service.RouteService;
import service.PurchaseService;
import service.VNPayService;

/**
 *
 * @author Administrator
 */
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 5 * 1024 * 1024,
        maxRequestSize = 10 * 1024 * 1024
)
public class CreatePaymentServlet extends HttpServlet {

    private VNPayService vnpayService;
    private PurchaseService purchaseService;
    private MonthlyPassService monthlyPassService;

    @Override
    public void init() throws ServletException {
        vnpayService = new VNPayService();
        purchaseService = new PurchaseService();
        monthlyPassService = new MonthlyPassService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Enumeration<String> names = request.getParameterNames();

        while (names.hasMoreElements()) {
            String name = names.nextElement();
            System.out.println(name + " = " + request.getParameter(name));
        }
        // 1. Kiểm tra và parse số tiền an toàn (Bắt NumberFormatException)
        String priceParam = request.getParameter("price");
        long rawAmount = 0;
        try {
            if (priceParam != null && !priceParam.trim().isEmpty()) {
                // Xử lý sạch chuỗi, loại bỏ các ký tự thừa như khoảng trắng hoặc đuôi thập phân
                String cleanPrice = priceParam.replaceAll("[^0-9]", "");
                if (!cleanPrice.isEmpty()) {
                    rawAmount = Long.parseLong(cleanPrice);
                }
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/route-list?error=invalid_price");
            return;
        }

        // 2. Lấy AccountID từ USER session để backup
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("USER");
        Integer accountID = null;
        if (user != null) {
            accountID = user.getAccountID();
            session.setAttribute("pending_accountID", accountID);
        } else {
            accountID = (Integer) session.getAttribute("pending_accountID");
        }

        String ticketType = request.getParameter("ticketType");
        System.out.println("ticketType request = " + ticketType);
        String routeIdStr = request.getParameter("routeID");
        int routeId = (routeIdStr != null && !routeIdStr.isEmpty() && !routeIdStr.equals("0")) ? Integer.parseInt(routeIdStr) : 0;

        String passTypeIDStr = request.getParameter("passTypeID");
        System.out.println("passTypeID request = " + passTypeIDStr);
        int passTypeID = (passTypeIDStr != null && !passTypeIDStr.isEmpty()) ? Integer.parseInt(passTypeIDStr) : 0;

        String imageProofPath = null;

        // Chỉ vé tháng / liên tuyến mới cần ảnh minh chứng. Vé lượt không có
        // input file này trong form nên không được gọi getPart/processAndSaveProof
        // cho loại vé đó (nếu không sẽ luôn bị lỗi "Vui lòng tải lên ảnh minh chứng").
        if ("thang".equals(ticketType) || "lien_chuyen".equals(ticketType)) {
            Part filePart = request.getPart("imageProof");
            String uploadPath = request.getServletContext().getRealPath("")
                    + File.separator + "uploads"
                    + File.separator + "pass-proof";

            try {
                imageProofPath = monthlyPassService.processAndSaveProof(filePart, uploadPath);
                session.setAttribute("pending_imageProof", imageProofPath);
            } catch (IllegalArgumentException e) {
                request.setAttribute("errorMsg", e.getMessage());
                reloadFormContext(request, routeIdStr, ticketType);
                request.getRequestDispatcher("/view/customer/buy-ticket.jsp")
                        .forward(request, response);
                return;
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("errorMsg", "Lỗi khi tải ảnh lên.");
                reloadFormContext(request, routeIdStr, ticketType);
                request.getRequestDispatcher("/view/customer/buy-ticket.jsp")
                        .forward(request, response);
                return;
            }
        } else {
            session.setAttribute("pending_imageProof", null);
        }
        // 3. XỬ LÝ VÉ MIỄN PHÍ (0 ĐỒNG - VÍ DỤ NGƯỜI CAO TUỔI)
        // VNPay không nhận giao dịch dưới 5,000 đ nên vé 0 đ sẽ được bypass gọi thẳng DB
        System.out.println("rawAmount = " + rawAmount);
        System.out.println("priceParam = " + priceParam);
        if (rawAmount <= 0) {
            try {
                if (accountID != null) {
                    System.out.println("===== DEBUG PURCHASE =====");
                    System.out.println("accountID = " + accountID);
                    System.out.println("routeId = " + routeId);
                    System.out.println("ticketType = " + ticketType);
                    System.out.println("passTypeID = " + passTypeID);
                    System.out.println("imageProof = " + imageProofPath);
                    System.out.println("==========================");
                    purchaseService.processPurchase(accountID, routeId, ticketType, passTypeID, imageProofPath);
                }
                // Xóa rác pending nếu có
                session.removeAttribute("pending_routeId");
                session.removeAttribute("pending_ticketType");
                session.removeAttribute("pending_passTypeID");

                response.sendRedirect(request.getContextPath() + "/view/customer/payment-success.jsp");
                return;
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/view/customer/payment-fail.jsp?error=insert_failed");
                return;
            }
        }

        // 4. Lưu toàn bộ context vào Session để dùng lúc VNPay Return cho các vé có phí
        long vnp_Amount = rawAmount * 100; // VNPay bắt buộc nhân 100
        String vnp_TxnRef = "TXN" + System.currentTimeMillis();

        session.setAttribute("pending_txnRef", vnp_TxnRef);
        session.setAttribute("pending_routeId", request.getParameter("routeID"));
        session.setAttribute("pending_ticketType", ticketType);
        session.setAttribute("pending_passTypeID", request.getParameter("passTypeID"));

        // 5. Gọi VNPayService để lấy link và Redirect sang cổng thanh toán (chạy trực tiếp trong pop-up)
        String paymentUrl = vnpayService.createPaymentURL(request, vnp_Amount, vnp_TxnRef);
        response.sendRedirect(paymentUrl);
    }

    private void reloadFormContext(HttpServletRequest request, String routeIdStr, String ticketType) {
        try {
            int routeId = (routeIdStr != null && !routeIdStr.isEmpty() && !routeIdStr.equals("0")) ? Integer.parseInt(routeIdStr) : 0;
            RouteService routeService = new RouteService();
            request.setAttribute("route", routeService.getRouteById(routeId));
            request.setAttribute("ticketType", ticketType);
            request.setAttribute("currentDate", new java.util.Date());
        } catch (Exception ignored) {
        }
    }
}
