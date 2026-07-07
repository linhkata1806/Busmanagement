/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import util.PasswordEncoder;
import util.Validator;
import dal.AccountDAO;
import dal.RoleDAO;
import java.util.UUID;
import model.Account;
import model.Role;

/**
 *
 * @author Administrator
 */
public class AuthService {

    private final AccountDAO accountDAO;
    private final RoleDAO roleDAO;

    public AuthService() {
        accountDAO = new AccountDAO();
        roleDAO = new RoleDAO();
    }

    public Account login(String username, String rawPassword) throws IllegalArgumentException {
        if (username == null || username.trim().isEmpty()) {
            throw new IllegalArgumentException("Tên đăng nhập hoặc Email không được để trống.");
        }
        if (rawPassword == null || rawPassword.isEmpty()) {
            throw new IllegalArgumentException("Mật khẩu không được để trống.");
        }

        username = username.trim();

        // 1. Kiểm tra định dạng nếu đăng nhập bằng Email
        if (username.contains("@") && !Validator.isValidEmail(username)) {
            throw new IllegalArgumentException("Định dạng Email nhập vào không hợp lệ.");
        }

        Account account = accountDAO.getAccountByUsername(username);

        // 2. Kiểm tra tài khoản tồn tại
        if (account == null) {
            if (username.contains("@")) {
                throw new IllegalArgumentException("Địa chỉ Email này chưa được đăng ký.");
            } else {
                throw new IllegalArgumentException("Tên đăng nhập không tồn tại trên hệ thống.");
            }
        }

        // 3. Kiểm tra mật khẩu
        if (!PasswordEncoder.checkPassword(rawPassword, account.getPassword())) {
            throw new IllegalArgumentException("Mật khẩu không chính xác.");
        }

        // 4. Kiểm tra tài khoản bị khóa
        if (!account.isActive()) {
            throw new IllegalArgumentException("Tài khoản của bạn đã bị khóa hoặc tạm dừng hoạt động.");
        }

        accountDAO.updateLastLogin(account.getAccountID());

        return account;
    }
    
    public String generateAndSaveRememberToken(int accountId) {
        // Sinh chuỗi UUID bảo mật tuyệt đối, không dùng Username theo đúng đặc tả
        String token = UUID.randomUUID().toString();
        boolean success = accountDAO.updateRememberToken(accountId, token);
        return success ? token : null;
    }
    
    // Tìm tài khoản bằng Token
    public Account loginWithToken(String token) {
        return accountDAO.getByRememberToken(token);
    }

    // Xóa Token khỏi DB
    public void clearRememberToken(int accountId) {
        accountDAO.clearRememberToken(accountId);
    }

    public boolean register(Account account) throws IllegalArgumentException {

        if (account == null) {
            throw new IllegalArgumentException("Dữ liệu đăng ký không hợp lệ.");
        }

        // Validate cơ bản từng trường để có lỗi chi tiết
        if (account.getUsername() == null || !account.getUsername().trim().matches("^[a-zA-Z0-9_]{5,30}$")) {
            throw new IllegalArgumentException("Tên đăng nhập phải từ 5-30 ký tự, chỉ chứa chữ, số và dấu gạch dưới.");
        }

        if (account.getPassword() == null || account.getPassword().length() < 6) {
            throw new IllegalArgumentException("Mật khẩu phải có ít nhất 6 ký tự.");
        }

        if (account.getFullName() == null || account.getFullName().trim().isEmpty()) {
            throw new IllegalArgumentException("Họ và tên không được để trống.");
        }

        if (account.getEmail() == null || !Validator.isValidEmail(account.getEmail())) {
            throw new IllegalArgumentException("Email không đúng định dạng.");
        }

        if (account.getPhone() != null && !account.getPhone().isBlank() && !Validator.isValidPhone(account.getPhone())) {
            throw new IllegalArgumentException("Số điện thoại phải gồm 10 chữ số bắt đầu bằng số 0.");
        }

        // Check trùng username
        if (accountDAO.existsByUsername(account.getUsername().trim())) {
            throw new IllegalArgumentException("Tên đăng nhập đã tồn tại trên hệ thống.");
        }

        // Check trùng email
        if (accountDAO.existsByEmail(account.getEmail().trim())) {
            throw new IllegalArgumentException("Địa chỉ Email này đã được đăng ký.");
        }

        // Check trùng số điện thoại
        if (account.getPhone() != null && !account.getPhone().isBlank() && accountDAO.existsByPhone(account.getPhone().trim())) {
            throw new IllegalArgumentException("Số điện thoại này đã được đăng ký.");
        }

        // Mã hóa mật khẩu
        String hashedPassword = PasswordEncoder.hashPassword(account.getPassword());
        account.setPassword(hashedPassword);

        // Gán role CUSTOMER
        Role customerRole = roleDAO.getRoleByName("CUSTOMER");
        if (customerRole == null) {
            throw new IllegalArgumentException("Hệ thống lỗi: Vai trò Khách hàng chưa được cấu hình.");
        }

        account.setRoleID(customerRole.getRoleID());

        boolean isSuccess = accountDAO.insertAccount(account);
        if (!isSuccess) {
            throw new IllegalArgumentException("Lỗi lưu cơ sở dữ liệu. Vui lòng thử lại sau.");
        }
        return true;
    }
    
    public void changePassword(int accountId, String oldPassword, String newPassword) throws IllegalArgumentException, Exception {
        
        // 1. Lấy thông tin tài khoản hiện tại từ DB
        Account account = accountDAO.getAccountById(accountId);
        if (account == null) {
            throw new Exception("Tài khoản không tồn tại trong hệ thống.");
        }

        // 2. Kiểm tra mật khẩu cũ (Ném lỗi IllegalArgumentException nếu sai)
        if (!PasswordEncoder.checkPassword(oldPassword, account.getPassword())) {
            throw new IllegalArgumentException("Mật khẩu hiện tại không chính xác.");
        }

        // 3. Hash mật khẩu mới
        String hash = PasswordEncoder.hashPassword(newPassword);

        // 4. Update xuống Database (Ném lỗi Exception chung nếu DB lỗi)
        boolean isSuccess = accountDAO.changePassword(accountId, hash);
        if (!isSuccess) {
            throw new Exception("không thể cập nhật mật khẩu lúc này.");
        }
    }

}
