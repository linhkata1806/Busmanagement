package service;

import dal.AccountDAO;
import java.util.List;
import model.Account;
import util.PasswordEncoder;

public class AccountManagementService {

    private AccountDAO accountDAO;

    public AccountManagementService() {
        this.accountDAO = new AccountDAO();
    }

    // ==========================================================
    // 1. CÁC HÀM VALIDATE (DÙNG ĐỂ CHẶN DỮ LIỆU SAI)
    // ==========================================================
    private boolean isBlank(String str) {
        return str == null || str.trim().isEmpty();
    }

    private boolean isValidPhone(String phone) {
        return phone != null && phone.matches("^0\\d{9}$");
    }

    private boolean isValidEmail(String email) {
        return email != null && email.matches("^[A-Za-z0-9+_.-]+@(.+)$");
    }

    // ==========================================================
    // 2. CÁC NGHIỆP VỤ CHÍNH
    // ==========================================================
    public List<Account> getAllAccounts() {
        return accountDAO.getAllAccounts();
    }

    public List<Account> searchAndFilter(String keyword, String roleName) {
        return accountDAO.searchAndFilter(keyword, roleName);
    }

    public boolean createAccount(Account newAccount, String roleName) throws Exception {
        // Validate dữ liệu trống
        if (isBlank(newAccount.getUsername())) {
            throw new Exception("Tên đăng nhập không được để trống!");
        }
        if (isBlank(newAccount.getFullName())) {
            throw new Exception("Họ tên không được để trống!");
        }
        if (isBlank(newAccount.getPassword())) {
            throw new Exception("Mật khẩu không được để trống!");
        }

        if ("ADMIN".equalsIgnoreCase(roleName)) {
            throw new IllegalArgumentException("Lỗi: Không được phép tạo thêm tài khoản Admin từ hệ thống.");
        }

        // Validate định dạng
        if (!isValidPhone(newAccount.getPhone())) {
            throw new Exception("Số điện thoại không hợp lệ! Phải bắt đầu bằng số 0 và gồm đúng 10 chữ số.");
        }
        if (!isValidEmail(newAccount.getEmail())) {
            throw new Exception("Định dạng email không hợp lệ!");
        }

        // Validate trùng lặp
        if (accountDAO.existsByUsername(newAccount.getUsername())) {
            throw new Exception("Tên đăng nhập đã tồn tại!");
        }
        if (accountDAO.existsByEmail(newAccount.getEmail())) {
            throw new Exception("Email đã được sử dụng!");
        }
        if (accountDAO.existsByPhone(newAccount.getPhone())) {
            throw new Exception("Số điện thoại đã được sử dụng!");
        }

        String hashedPw = PasswordEncoder.hashPassword(newAccount.getPassword());
        newAccount.setPassword(hashedPw);

        return accountDAO.insertAccount(newAccount);
    }

    public boolean updateAccount(Account account) throws Exception {
        // Validate dữ liệu trống
        if (isBlank(account.getFullName())) {
            throw new Exception("Họ tên không được để trống!");
        }

        // Validate định dạng
        if (!isValidPhone(account.getPhone())) {
            throw new Exception("Số điện thoại không hợp lệ! Phải bắt đầu bằng số 0 và gồm đúng 10 chữ số.");
        }
        if (!isValidEmail(account.getEmail())) {
            throw new Exception("Định dạng email không hợp lệ!");
        }

        Account existing = accountDAO.getAccountById(account.getAccountID());
        if (existing == null) {
            throw new Exception("Tài khoản không tồn tại!");
        }
        return accountDAO.updateProfile(
                account.getAccountID(),
                account.getFullName(),
                account.getEmail(),
                account.getPhone(),
                account.getAvatar()
        );
    }

    public boolean lockAccount(int id) {
        return accountDAO.updateStatus(id, false);
    }

    public boolean unlockAccount(int id) {
        return accountDAO.updateStatus(id, true);
    }

    public boolean resetPassword(int accountId) {
        try {
            String defaultPassword = "Bus@" + java.time.Year.now().getValue();
            String hashedPw = PasswordEncoder.hashPassword(defaultPassword);
            return accountDAO.changePassword(accountId, hashedPw);
        } catch (Exception e) {
            System.out.println("Lỗi resetPassword Service: " + e.getMessage());
            return false;
        }
    }
}
