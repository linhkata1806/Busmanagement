package controller.driver.account;

import dal.AccountDAO;
import java.io.File;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.Account;
import service.NotificationService;
import util.Validator;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class ProfileServlet extends HttpServlet {
    private AccountDAO accountDAO;
    private NotificationService notificationService;

    @Override
    public void init() throws ServletException {
        accountDAO = new AccountDAO();
        notificationService = new NotificationService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("USER") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        Account user = (Account) session.getAttribute("USER");
        int accountId = user.getAccountID();

        Account account = accountDAO.getAccountById(accountId);
        if (account == null) {
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        request.setAttribute("account", account);

        // Fetch unread notification count for sidebar
        int unreadCount = notificationService.countUnreadNotifications(accountId);
        request.setAttribute("unreadCount", unreadCount);

        request.getRequestDispatcher("/view/driver/account/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("USER") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        Account user = (Account) session.getAttribute("USER");

        String fullNameRaw = request.getParameter("fullName");
        String emailRaw = request.getParameter("email");
        String phoneRaw = request.getParameter("phone");

        if (fullNameRaw == null || emailRaw == null || phoneRaw == null) {
            request.setAttribute("errorMsg", "Hệ thống chưa nhận dạng được cấu hình tải file. Vui lòng Clean & Build dự án!");
            doGet(request, response);
            return;
        }

        String fullName = fullNameRaw.trim();
        String email = emailRaw.trim();
        String phone = phoneRaw.trim();
        
        String avatar = user.getAvatar();

        // Process file upload
        try {
            Part filePart = request.getPart("avatar");
            if (filePart != null && filePart.getSize() > 0) {
                String uploadPath = request.getServletContext().getRealPath("/") + "uploads" + File.separator + "avatars";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                String submittedFileName = filePart.getSubmittedFileName();
                String fileExtension = "";
                int dotIndex = submittedFileName.lastIndexOf('.');
                if (dotIndex >= 0) {
                    fileExtension = submittedFileName.substring(dotIndex);
                }

                String newFileName = "avatar_" + user.getAccountID() + fileExtension;
                String fileSavePath = uploadPath + File.separator + newFileName;

                filePart.write(fileSavePath);
                avatar = "uploads/avatars/" + newFileName;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Validate
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

        // Email uniqueness check
        if (!email.equalsIgnoreCase(user.getEmail())) {
            if (accountDAO.existsByEmail(email)) {
                request.setAttribute("errorMsg", "Email này đã được sử dụng bởi một tài khoản khác!");
                doGet(request, response);
                return;
            }
        }

        boolean isSuccess = accountDAO.updateProfile(user.getAccountID(), fullName, email, phone, avatar);

        if (isSuccess) {
            Account updatedAccount = accountDAO.getAccountById(user.getAccountID());
            session.setAttribute("USER", updatedAccount);
            session.setAttribute("successMsg", "Cập nhật hồ sơ thành công!");
            response.sendRedirect(request.getContextPath() + "/driver/profile");
        } else {
            request.setAttribute("errorMsg", "Hệ thống đang bận. Cập nhật thất bại!");
            doGet(request, response);
        }
    }
}
