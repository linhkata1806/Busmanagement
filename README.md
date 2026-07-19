# Bus Management System (PRJ301 Final Project)

Hướng dẫn chi tiết dành cho các thành viên phát triển dự án **BusManagement**, bao gồm cấu trúc thư mục chi tiết, phân hệ chức năng, hướng dẫn thiết lập cơ sở dữ liệu, quy trình làm việc với Git, và các quy tắc phát triển cốt lõi.

---

## 📂 Project Structure (Cấu trúc thư mục)

```text
.
├── busmanagement/      # Mã nguồn Java Web Project (NetBeans Ant project)
│   ├── src/java/       # Mã nguồn Java (Controller, Service, DAO, Model...)
│   ├── web/            # Các trang JSP, Assets (CSS, JS, Images), WEB-INF
│   └── sql/            # Các script SQL khởi tạo cơ sở dữ liệu
├── docs/               # Tài liệu phân tích thiết kế chi tiết từng phân hệ
└── tools/              # Các công cụ hỗ trợ như BusMapCrawler sinh dữ liệu tự động
```

### Chi tiết cấu trúc mã nguồn Java (`busmanagement/src/java/`)

| Package | Mục đích & Mô tả |
| :--- | :--- |
| **`api/`** | Cung cấp các REST API phục vụ cho gọi dữ liệu không đồng bộ (AJAX) hoặc tích hợp. |
| **`controller/`** | Servlet tiếp nhận request, gọi Service xử lý và điều phối luồng hiển thị JSP. Phân tách theo vai trò: `admin`, `assistant`, `authen`, `driver`, `customer`, `payment`, `guest`, `staff`... |
| **`dal/`** | Lớp Data Access Object (DAO) thực thi các truy vấn SQL trực tiếp tới cơ sở dữ liệu. |
| **`dto/`** | Data Transfer Object chứa dữ liệu ghép từ nhiều bảng phục vụ hiển thị (ví dụ: `RouteStopDTO`). |
| **`enums/`** | Định nghĩa các tập hằng số trạng thái (ví dụ: trạng thái chuyến đi `TripStatus`, trạng thái vé). |
| **`filter/`** | Các bộ lọc bảo mật để kiểm tra đăng nhập và phân quyền truy cập (Authorization Filters). |
| **`model/`** | Lớp thực thể ánh xạ 1-1 với cấu trúc bảng trong SQL Server. |
| **`service/`** | Tầng nghiệp vụ xử lý logic, tính toán và kiểm tra dữ liệu trước khi đẩy xuống DAO. |
| **`util/`** | Các tiện ích hệ thống như cấu hình kết nối DB (`DBContext`), mã hóa mật khẩu, định dạng ngày tháng... |

### Chi tiết thư mục giao diện (`busmanagement/web/`)

- **`web/view/`**: Chứa các file JSP tổ chức phân mục theo nhóm người dùng (`admin/`, `driver/`, `assistant/`, `customer/`, `guest/`...) để phục vụ hiển thị tương thích.
- **`web/WEB-INF/`**: Chứa file cấu hình cấu trúc web `web.xml` và file kết nối cơ sở dữ liệu cá nhân `ConnectDB.properties` (đã gitignore).

---

## 🛠️ Core Modules (Các phân hệ & Tính năng cốt lõi)

Dự án được phân chia chặt chẽ thành các phân hệ nghiệp vụ sau:

### 1. Phân hệ Quản trị & Nhân sự (Admin & Staff Module)
- **Quản lý tài khoản**: Xem danh sách, tìm kiếm kết hợp và lọc theo vai trò (Staff, Driver, Assistant, Customer) bằng truy vấn SQL JOIN bảng `Roles`.
- **Khóa/Mở khóa tài khoản**: Quản lý trực tiếp qua giá trị logic của cột `IsActive` (BIT) trong cơ sở dữ liệu.
- **Tạo tài khoản & Bảo mật**: Cho phép tạo tài khoản Staff, Driver, Assistant, Customer. Chặn tuyệt đối quyền tạo mới tài khoản ADMIN từ giao diện. Mật khẩu mặc định được mã hóa an toàn qua **BCrypt**.
- **Cấp lại mật khẩu**: Reset mật khẩu của người dùng về định dạng `Bus@<Năm_Hiện_Tại>` (ví dụ: `Bus@2026`) và tự động mã hóa BCrypt.
- **Báo cáo doanh thu**: Tổng hợp doanh thu thực tế từ Vé lẻ (Vé có trạng thái `COMPLETED`) và Vé tháng (Monthly Pass có trạng thái `APPROVED`).
- **Gửi thông báo hàng loạt (Broadcast)**: Do bảng `Notifications` yêu cầu khóa ngoại `AccountID`, nghiệp vụ gửi tin nhắn nhóm/toàn bộ sẽ được Service xử lý bằng vòng lặp lưu lần lượt bản ghi thông báo cho từng người dùng đích.

### 2. Phân hệ Tài xế (Driver Module)
- **Dashboard tài xế**: Hiển thị nhanh thống kê số chuyến được phân công trong ngày, thông báo chưa đọc, chuyến đi hiện tại đang vận hành (`IN_PROGRESS`).
- **Chuyến đi của tôi (My Trips)**: Danh sách lịch trình chi tiết được phân công cá nhân (`DriverID = CurrentUserID`).
- **Chi tiết hành trình**: Xem danh sách các điểm dừng (`Stops`) sắp xếp theo đúng thứ tự hành trình `StopOrder` của tuyến tương ứng.
- **Vận hành chuyến xe**: Thực hiện chuyển đổi trạng thái chuyến đi (`SCHEDULED` ➔ `IN_PROGRESS` ➔ `COMPLETED`).
- **Bảo mật**: Kiểm soát chặt chẽ quyền sở hữu chuyến đi của tài xế dựa trên Session, chặn mọi hành vi can thiệp trái phép bằng cách sửa ID trên URL.

### 3. Phân hệ Phụ xe (Assistant Module)
- **Dashboard phụ xe**: Thống kê số lượng khách đã soát vé trên chuyến đi hiện tại, số hành khách còn lại cần đón, và thông tin chi tiết xe buýt.
- **Soát vé thủ công (Ticket Check-in)**: Nhập mã vé hành khách để kiểm tra tính hợp lệ (vé có tồn tại, đúng tuyến, đúng ngày chạy, trạng thái phải là `UNUSED`).
- **Cập nhật trạng thái vé**: Chuyển trạng thái vé từ `UNUSED` sang `CHECKED_IN` (hoặc `USED`) khi hành khách lên xe thành công thông qua Transaction an toàn.
- **Tiếp nhận thông báo**: Đọc thông báo điều phối từ hệ thống gửi riêng hoặc gửi chung cho nhóm Phụ xe.

### 4. Phân hệ Khách hàng (Customer Module)
- Đăng nhập, đăng ký tài khoản, chỉnh sửa thông tin cá nhân.
- Tìm kiếm tuyến xe, trạm dừng, tra cứu lộ trình và bản đồ số.
- Đặt mua vé lẻ, đăng ký gia hạn thẻ vé tháng trực tuyến.
- Thanh toán điện tử (Payment) tích hợp mã giảm giá (Discount).

---

## 💾 Database Configuration (Cài đặt Cơ sở dữ liệu)

Dự án sử dụng hệ quản trị cơ sở dữ liệu **Microsoft SQL Server**.

### Quy trình thiết lập DB trên máy local:

1. **Khởi tạo Database**:
   - Mở SQL Server Management Studio (SSMS) hoặc công cụ tương đương.
   - Chạy script tạo cấu trúc bảng: `busmanagement/sql/BusHanoiTable.sql` (Script này sẽ tự động xóa database `HanoiBusDB` cũ nếu có và khởi tạo lại database cùng các bảng liên quan).

2. **Chèn Dữ liệu mẫu (Mock Data)**:
   - Chạy script: `busmanagement/sql/InsertMockData.sql` để nạp dữ liệu trạm dừng thực tế của Hà Nội Bus cùng tài khoản kiểm thử và thông tin mẫu.

3. **Cấu hình kết nối dự án**:
   - Nhân bản file cấu hình mẫu từ `docs/ConnectDB.properties`.
   - Dán vào thư mục đích: `busmanagement/web/WEB-INF/`
   - Mở file `busmanagement/web/WEB-INF/ConnectDB.properties` và cập nhật thông tin đăng nhập SQL Server của bạn:
     ```properties
     url=jdbc:sqlserver://localhost:1433;databaseName=HanoiBusDB;trustServerCertificate=true
     userID=sa
     password=Mật_khẩu_SQL_Server_của_bạn
     ```
   
> ⚠️ **Quan trọng**: File `busmanagement/web/WEB-INF/ConnectDB.properties` được liệt kê trong `.gitignore`. Tuyệt đối không xóa dòng cấu hình này để tránh ghi đè thông tin kết nối cá nhân lên repository chung.

---

## 🔄 Git Workflow (Quy trình làm việc với Git)

Để đảm bảo mã nguồn không bị xung đột, các thành viên cần tuân thủ quy trình sau:

### 1. Đồng bộ dự án trước khi làm việc
Mỗi ngày trước khi code, hãy chuyển về branch chính và cập nhật mã nguồn mới nhất:
```bash
git fetch -p
git checkout main
git pull origin main
```

### 2. Tạo branch tính năng riêng
Không được code trực tiếp trên branch `main`. Luôn tạo một branch nhánh phụ để phát triển tính năng được phân công:
```bash
# Xem danh sách branch hiện có
git branch -a

# Tạo branch mới từ branch hiện tại (ví dụ: main)
git checkout -b feature/your-name-feature
```

### 3. Đồng bộ và giải quyết xung đột trước khi Push
Trước khi đẩy code lên GitHub, hãy đồng bộ branch cá nhân của bạn với bản cập nhật mới nhất trên nhánh gốc:
```bash
# Lưu và commit code hiện tại trên branch cá nhân
git add .
git commit -m "feat: mô tả tính năng vừa làm"

# Lấy code mới nhất từ main về máy local
git checkout main
git pull origin main

# Chuyển về branch cá nhân và thực hiện merge main vào branch cá nhân
git checkout feature/your-name-feature
git merge main
```
> 💡 Nếu có **conflict (xung đột)** xảy ra, hãy sửa tay trực tiếp trong NetBeans/VS Code, đảm bảo dự án chạy ổn định trước khi tiếp tục.

### 4. Tạo Pull Request (PR)
- Đẩy branch cá nhân lên GitHub:
  ```bash
  git push origin feature/your-name-feature
  ```
- Truy cập vào GitHub repository và tạo **Pull Request** trỏ về branch `main`.
- Đính kèm mô tả các phần đã làm và tag các thành viên liên quan vào review. Chỉ merge khi được Lead phê duyệt và các bài test hoạt động ổn định.

---

## ⚡ Clean and Build (Dọn dẹp và Biên dịch)

Trong môi trường NetBeans + Tomcat Server, các lỗi cache hoặc không nhận diện được file mới rất dễ xảy ra. Khi gặp các tình huống sau:
- Vừa clone hoặc pull code mới từ GitHub về.
- Đổi tên file, package hoặc thay đổi cấu trúc thư mục.
- Thêm các thư viện `.jar` bên ngoài vào thư mục `lib`.

Hãy thực hiện quy trình sau thay vì bấm nút **Run** ngay lập tức:
```text
NetBeans Menu -> Right click Project "busmanagement" -> Chọn Clean and Build
                                  ↓
                       Chờ thông báo SUCCESS
                                  ↓
                        Right click -> Chọn Run
```
> Việc này giúp biên dịch lại toàn bộ các class Java, làm sạch cache biên dịch cũ của Tomcat và tránh tối đa lỗi `ClassNotFoundException` hoặc mã lỗi HTTP Status 500 ảo.

---

## 📐 Development Guidelines (Quy tắc phát triển bắt buộc)

1. **Exception-based Service**:
   - Ở tầng **Service**, không sử dụng cấu trúc try-catch để nuốt lỗi hoặc trả về giá trị boolean/null mang ý nghĩa thất bại. Hãy chủ động throw trực tiếp ngoại lệ (Ví dụ: `throw new IllegalArgumentException("Thông điệp lỗi tiếng Việt cụ thể");`).
   - Ở tầng **Controller (Servlet)**, bọc khối xử lý của Service bằng block `try-catch (IllegalArgumentException e)` để bắt lỗi và chuyển tiếp thông báo hiển thị cho người dùng qua thuộc tính của Request (`request.setAttribute("error", e.getMessage())`).

2. **Chặn chỉnh sửa URL (Security Rules)**:
   - Các Servlet xử lý thông tin cá nhân của Driver/Assistant phải luôn kiểm tra xem mã định danh của Trip/Tài khoản gửi lên từ Request parameter có khớp với ID người dùng đang đăng nhập trong Session hay không.
   - Ví dụ: `if (trip.getDriverID() != currentUserID) { throw new IllegalArgumentException("Bạn không có quyền truy cập..."); }`

3. **Cơ chế lọc quyền (Role-based Filters)**:
   - Sử dụng Java Filters để bảo vệ các thư mục hiển thị trong `view/`. Chặn các request truy cập không hợp lệ tới các thư mục như `/view/admin/*`, `/view/driver/*`, `/view/assistant/*` nếu tài khoản không đúng vai trò tương ứng.