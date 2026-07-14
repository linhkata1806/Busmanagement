/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.customer;

import dal.AccountDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.Part;
import java.awt.image.BufferedImage;
import java.io.File;
import javax.imageio.ImageIO;
import model.Account;
import util.Validator;

/**
 *
 * @author Administrator
 */
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class EditProfileServlet extends HttpServlet {

    private AccountDAO accountDAO;

    @Override
    public void init() throws ServletException {
        accountDAO = new AccountDAO();
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
        Account user = (Account) session.getAttribute("USER");

        // Luôn bốc dữ liệu mới nhất từ DB lên để điền vào Form cho chuẩn xác
        Account account = accountDAO.getAccountById(user.getAccountID());

        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        request.setAttribute("account", account);
        request.getRequestDispatcher("/view/customer/edit-profile.jsp").forward(request, response);
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
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        Account user = (Account) session.getAttribute("USER");

        // 1. Lấy dữ liệu từ form
        String fullNameRaw = request.getParameter("fullName");
        String emailRaw = request.getParameter("email");
        String phoneRaw = request.getParameter("phone");

        // Kiểm tra nếu Tomcat chưa nhận diện MultipartConfig
        if (fullNameRaw == null || emailRaw == null || phoneRaw == null) {
            request.setAttribute("errorMsg", "Hệ thống chưa nhận dạng được cấu hình tải file. Vui lòng Clean & Build dự án và Khởi động lại Server (Tomcat) trên NetBeans!");
            doGet(request, response);
            return;
        }

        String fullName = fullNameRaw.trim();
        String email = emailRaw.trim();
        String phone = phoneRaw.trim();

        // 2. Validate dữ liệu đầu vào (Sử dụng Validator của bạn)
        if (Validator.isBlank(fullName)) {
            request.setAttribute("errorMsg", "Họ tên không được để trống.");
            doGet(request, response);
            return;
        }
        if (!Validator.isValidEmail(email)) {
            request.setAttribute("errorMsg", "Định dạng email không hợp lệ.");
            doGet(request, response);
            return;
        }

        if (!Validator.isValidPhone(phone)) {
            request.setAttribute("errorMsg", "Số điện thoại không hợp lệ (cần 10 số, bắt đầu bằng 0).");
            doGet(request, response);
            return;
        }

        // 3. Check trùng Email (Chỉ check nếu khách hàng thực sự thay đổi email)
        if (!email.equalsIgnoreCase(user.getEmail())) {
            if (accountDAO.existsByEmail(email)) {
                request.setAttribute("errorMsg", "Email này đã được sử dụng bởi một tài khoản khác!");
                doGet(request, response);
                return;
            }
        }
        // Mặc định giữ nguyên ảnh đại diện cũ
        String avatar = user.getAvatar();

        // Xử lý tệp tải lên
        try {
            Part filePart = request.getPart("avatar");

            if (filePart != null && filePart.getSize() > 0) {

                String submittedFileName = filePart.getSubmittedFileName();

                if (submittedFileName == null || !submittedFileName.contains(".")) {
                    request.setAttribute("errorMsg", "Tên file ảnh không hợp lệ.");
                    doGet(request, response);
                    return;
                }

                String fileExtension = submittedFileName
                        .substring(submittedFileName.lastIndexOf("."))
                        .toLowerCase();

                if (!fileExtension.equals(".jpg")
                        && !fileExtension.equals(".jpeg")
                        && !fileExtension.equals(".png")) {

                    request.setAttribute("errorMsg", "Chỉ chấp nhận ảnh JPG hoặc PNG.");
                    doGet(request, response);
                    return;
                }

                BufferedImage image = ImageIO.read(filePart.getInputStream());

                if (image == null) {
                    request.setAttribute("errorMsg", "File tải lên không phải ảnh hợp lệ.");
                    doGet(request, response);
                    return;
                }

                String uploadPath = request.getServletContext().getRealPath("/")
                        + "uploads"
                        + File.separator
                        + "avatars";

                File uploadDir = new File(uploadPath);

                if (!uploadDir.exists() && !uploadDir.mkdirs()) {
                    request.setAttribute("errorMsg", "Không thể tạo thư mục lưu ảnh.");
                    doGet(request, response);
                    return;
                }

                String newFileName = "avatar_"
                        + user.getAccountID()
                        + fileExtension;

                String fileSavePath = uploadPath
                        + File.separator
                        + newFileName;

                filePart.write(fileSavePath);

                avatar = "uploads/avatars/" + newFileName;
            }

        } catch (IllegalStateException e) {
            request.setAttribute("errorMsg", "Ảnh đại diện vượt quá dung lượng 10MB.");
            doGet(request, response);
            return;
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "Không thể tải ảnh đại diện lên.");
            doGet(request, response);
            return;
        }

        // 4. Gọi DAO cập nhật xuống DB
        boolean isSuccess = accountDAO.updateProfile(user.getAccountID(), fullName, email, phone, avatar);

        if (isSuccess) {
            // CỰC KỲ QUAN TRỌNG: Cập nhật lại Session USER để đồng bộ Tên/Avatar trên góc phải màn hình
            Account updatedAccount = accountDAO.getAccountById(user.getAccountID());
            session.setAttribute("USER", updatedAccount);

            // Đính kèm thông báo thành công vào session (Flash message)
            session.setAttribute("successMsg", "Cập nhật hồ sơ thành công!");

            // Dùng sendRedirect (Thay vì forward) để chặn lỗi "Submit lại form (F5)"
            response.sendRedirect(request.getContextPath() + "/customer/profile");

        } else {
            // Lỗi hệ thống SQL ngầm
            request.setAttribute("errorMsg", "Hệ thống đang bận. Cập nhật thất bại!");
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
