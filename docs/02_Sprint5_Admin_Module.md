# **Tài liệu Đặc tả Sprint 5: ADMIN MODULE (V4 \- DB Synced)**

*(Lưu ý: Không thay đổi bất kỳ cấu trúc Database nào. Mọi tính năng giải quyết bằng Logic Java/SQL JOIN).*

## **I. Kiến trúc Điều phối chung (Controllers)**

Tái sử dụng các module của Staff qua cơ chế Filter. Admin chỉ tập trung vào 8 Controller cốt lõi:

1. AdminDashboardServlet  
2. AccountManagementServlet (Gánh toàn bộ nghiệp vụ View/Search/Filter cho Staff/Driver/Assistant/Customer).  
3. CreateAccountServlet  
4. UpdateAccountServlet  
5. ResetPasswordServlet  
6. RevenueReportServlet  
7. SystemReportServlet  
8. ProfileServlet

## **II. Chi tiết Xử lý Tương thích Database**

### **1\. Quản lý Trạng thái Tài khoản (Lock / Unlock)**

* **Database hiện tại:** Dùng cột IsActive BIT DEFAULT 1 trong bảng Accounts.  
* **Giải pháp Logic:** Không dùng trạng thái String "LOCKED", mà map trực tiếp giá trị boolean.  
* **Controller (AccountManagementServlet):**  
  * POST ?action=lock\&id=5 → IsActive \= 0  
  * POST ?action=unlock\&id=5 → IsActive \= 1

**Service & DAO:**

// Service  
public void lockAccount(int id) { accountDAO.updateStatus(id, false); }  
public void unlockAccount(int id) { accountDAO.updateStatus(id, true); }

// DAO  
public void updateStatus(int accountId, boolean isActive) {  
    String sql \= "UPDATE Accounts SET IsActive \= ? WHERE AccountID \= ?";  
    // Thực thi PreparedStatement...  
}

### **2\. Truy vấn Tìm kiếm & Lọc (Search & Filter SQL)**

* **Database hiện tại:** Bảng Accounts chỉ lưu RoleID. Tên role nằm ở bảng Roles.  
* **Giải pháp Logic:** Bắt buộc JOIN 2 bảng để query.

**SQL tại DAO:**

SELECT a.\*, r.RoleName   
FROM Accounts a  
JOIN Roles r ON a.RoleID \= r.RoleID  
WHERE (  
    a.Username LIKE ?   
    OR a.FullName LIKE ?   
    OR a.Email LIKE ?  
)  
AND (  
    ? \= 'ALL' OR r.RoleName \= ?  
)  
ORDER BY a.CreatedAt DESC

### **3\. Bảo mật Tạo Tài khoản (Create Account)**

* **Giải pháp Logic:** Hỗ trợ tạo STAFF, DRIVER, ASSISTANT, CUSTOMER. Chặn tuyệt đối việc tạo quyền ADMIN mới từ giao diện để tránh rủi ro bảo mật.  
* **Mã hóa Password:** Sử dụng **BCrypt**. Cột Password VARCHAR(255) trong DB đã dư sức lưu trữ chuỗi hash 60 ký tự của BCrypt.

**Service Validate:**

if(role.equals("ADMIN")) {  
    throw new IllegalArgumentException("Lỗi: Không được phép tạo thêm tài khoản Admin từ hệ thống.");  
}

### **4\. Cấp lại Mật khẩu (Reset Password)**

**Logic thực thi:** Khi bấm Reset, gán mật khẩu về chuỗi mặc định kết hợp năm hiện tại.

String defaultPassword \= "Bus@" \+ Year.now().getValue(); // VD: Bus@2026  
String hashedPassword \= BCrypt.hashpw(defaultPassword, BCrypt.gensalt());  
accountDAO.updatePassword(accountId, hashedPassword);

### **5\. Broadcast Notification (Thông báo hàng loạt)**

* **Database hiện tại:** Bảng Notifications bắt buộc phải có AccountID (không cho phép NULL).  
* **Giải pháp Logic (Multiple Inserts):** Không sửa DB. Chuyển đổi Broadcast thành một vòng lặp trong Java Service.

// Trích xuất list Account theo Role (VD: Lấy toàn bộ DRIVER)  
List\<Account\> targets \= accountDAO.getAccountsByRole("DRIVER");

// Vòng lặp Insert thông báo cho từng người  
for(Account acc : targets) {  
    Notification notif \= new Notification(acc.getAccountId(), title, content, type);  
    notificationDAO.insert(notif);  
}

### **6\. Thống kê Doanh thu (Revenue Report)**

* **Database hiện tại:** Chỉ có Tickets (vé lẻ) và MonthlyPasses (vé tháng). Sprint 5 chưa có các bảng Payment/Discount (để dành Sprint cuối).  
* **Giải pháp Logic:** Lấy số liệu trực tiếp từ 2 bảng này.

\-- Tổng doanh thu vé lẻ  
SELECT SUM(Price) FROM Tickets WHERE Status \= 'COMPLETED';

\-- Tổng doanh thu vé tháng  
SELECT SUM(Price) FROM MonthlyPasses WHERE Status \= 'APPROVED';

## **III. Checklist Giao Việc (Dành cho Dev)**

### **1\. DAO Layer**

* **AccountDAO**  
  * \[ \] getAll() / getById()  
  * \[ \] searchAndFilter(String keyword, String role) (Nhớ dùng JOIN Roles)  
  * \[ \] existsUsername(), existsEmail(), existsPhone()  
  * \[ \] updateStatus(int id, boolean isActive) (Phục vụ Lock/Unlock)  
  * \[ \] updatePassword(int id, String hashedPw) (Phục vụ Reset)  
* **DashboardDAO / ReportDAO** (Có thể viết gộp hoặc tái sử dụng TripDAO, TicketDAO, MonthlyPassDAO)  
  * \[ \] countAccounts(), countCustomers(), countPendingPasses()  
  * \[ \] getTodayRevenue(), getRevenueByMonth(), getRevenueByRange()

### **2\. Service Layer**

* **AccountManagementService**  
  * \[ \] createAccount() (Bắt ngoại lệ nếu chọn role ADMIN, mã hóa BCrypt)  
  * \[ \] updateAccount()  
  * \[ \] lockAccount(), unlockAccount() (Bắn sang updateStatus)  
  * \[ \] resetPassword() (Gán chuỗi Bus@Year, mã hóa BCrypt)  
* **DashboardService**  
  * \[ \] getDashboardData() (Gộp các hàm count từ DAO trả về DTO cho Dashboard)  
* **ReportService**  
  * \[ \] getRevenueReport() (Kết xuất chuỗi JSON/Dữ liệu cho Chart.js)

### **3\. Controller Layer**

* \[ \] AdminDashboardServlet (Nạp data vào dashboard.jsp)  
* \[ \] AccountManagementServlet (Nhận GET để search/filter. Nhận POST với action=lock/unlock)  
* \[ \] CreateAccountServlet (Nhận form)  
* \[ \] UpdateAccountServlet (Sửa thông tin, Readonly Username)  
* \[ \] ResetPasswordServlet (POST request)  
* \[ \] RevenueReportServlet (Nạp data báo cáo tài chính)  
* \[ \] SystemReportServlet (Nạp data tài nguyên hệ thống)  
* \[ \] ProfileServlet (Lấy thông tin cá nhân của Admin)