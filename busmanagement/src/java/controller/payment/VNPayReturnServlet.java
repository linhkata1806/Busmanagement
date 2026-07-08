/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.payment;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import service.PurchaseService;
import service.VNPayService;

/**
 *
 * @author Administrator
 */
public class VNPayReturnServlet extends HttpServlet {

    private VNPayService vnpayService;
    private PurchaseService purchaseService;

    @Override
    public void init() throws ServletException {
        vnpayService = new VNPayService();
        purchaseService = new PurchaseService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        boolean isValidSignature = vnpayService.verifyReturn(request);

        if (isValidSignature) {
            String responseCode = request.getParameter("vnp_ResponseCode");
            String txnRef = request.getParameter("vnp_TxnRef");

            // LỖI SỐ 2: Xử lý an toàn Session
            HttpSession session = request.getSession(false);
            if (session == null) {
                response.sendRedirect(request.getContextPath() + "/view/customer/payment-callback.jsp?status=fail&error=session_expired");
                return;
            }

            String pendingTxnRef = (String) session.getAttribute("pending_txnRef");

            // LỖI SỐ 1: Tránh NullPointer khi so sánh chuỗi
            if ("00".equals(responseCode) && pendingTxnRef != null && pendingTxnRef.equals(txnRef)) {
                try {
                    // LỖI SỐ 3: Bắt lỗi NullPointer khi parse AccountID
                    Integer accountID = (Integer) session.getAttribute("pending_accountID");
                    if (accountID == null) {
                        response.sendRedirect(request.getContextPath() + "/view/customer/payment-callback.jsp?status=fail&error=account_not_found");
                        return;
                    }

                    String ticketType = (String) session.getAttribute("pending_ticketType");
                    String routeIdStr = (String) session.getAttribute("pending_routeId");
                    int routeId = (routeIdStr != null && !routeIdStr.isEmpty() && !routeIdStr.equals("0")) ? Integer.parseInt(routeIdStr) : 0;

                    String passTypeIDStr = (String) session.getAttribute("pending_passTypeID");
                    int passTypeID = (passTypeIDStr != null && !passTypeIDStr.isEmpty()) ? Integer.parseInt(passTypeIDStr) : 0;

                    String imageProof = (String) session.getAttribute("pending_imageProof");

                    // Gọi Service thực thi
                    purchaseService.processPurchase(accountID, routeId, ticketType, passTypeID, imageProof);

                    clearPendingSession(session);
                    response.sendRedirect(request.getContextPath() + "/view/customer/payment-callback.jsp?status=success");
                    return;
                } catch (Exception e) {
                    e.printStackTrace();
                    response.sendRedirect(request.getContextPath() + "/view/customer/payment-callback.jsp?status=fail&error=insert_failed");
                    return;
                }
            } else {
                clearPendingSession(session);
                response.sendRedirect(request.getContextPath() + "/view/customer/payment-callback.jsp?status=fail&error=payment_failed");
                return;
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/view/customer/payment-callback.jsp?status=fail&error=invalid_signature");
            return;
        }
    }

    private void clearPendingSession(HttpSession session) {
        session.removeAttribute("pending_txnRef");
        session.removeAttribute("pending_accountID");
        session.removeAttribute("pending_routeId");
        session.removeAttribute("pending_ticketType");
        session.removeAttribute("pending_passTypeID");
        session.removeAttribute("pending_imageProof");
    }
}
