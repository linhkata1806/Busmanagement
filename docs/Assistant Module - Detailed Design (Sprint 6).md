# **Sprint 6 – ASSISTANT MODULE (Detailed Design)**

## **I. Mục tiêu & Phạm vi phân quyền**

Assistant (Phụ xe) là người hỗ trợ Driver trong quá trình vận hành chuyến xe thực tế. Assistant không có quyền CRUD (Thêm, Sửa, Xóa) dữ liệu hệ thống mà chỉ thao tác nghiệp vụ giới hạn trên các Chuyến đi (Trips) được phân công.

AssistantID \= CurrentUserID

**Các nhiệm vụ chính trong Sprint 6:** Xem danh sách chuyến xe được phân công, xem chi tiết lộ trình điểm dừng, kiểm tra tính hợp lệ của vé hành khách thủ công qua mã vé (Ticket Code), xác nhận hành khách lên xe (Passenger Check-In), và tiếp nhận thông báo hệ thống.

## **II. Kiến trúc tổng thể thư mục & Package**

Assistant  
│  
├── Controller/assistant/  
│   ├── AssistantDashboardServlet.java  
│   ├── MyTripServlet.java  
│   ├── TripDetailServlet.java  
│   ├── TicketValidationServlet.java  
│   ├── PassengerCheckServlet.java  
│   ├── NotificationServlet.java  
│   ├── ProfileServlet.java  
│   └── ChangePasswordServlet.java  
│  
├── Service/  
│   ├── AssistantDashboardService.java  
│   ├── PassengerCheckService.java  
│   └── TicketValidationService.java  
│  
└── view/assistant/  
    ├── dashboard.jsp  
    ├── my-trip.jsp  
    ├── trip-detail.jsp  
    ├── passenger-check.jsp  
    ├── notification.jsp  
    ├── profile.jsp  
    └── change-password.jsp

## **III. Chi tiết các chức năng Phân hệ**

### **1\. Assistant Dashboard**

**URL:** GET /assistant/dashboard | **View:** view/assistant/dashboard.jsp  
Hiển thị thông tin tổng quan vận hành của chuyến đi hiện tại (trạng thái RUNNING hoặc SCHEDULED gần nhất). Servlet chỉ gọi qua AssistantDashboardService để lấy dữ liệu, tuyệt đối không viết SQL trực tiếp trong Servlet.  
**Các thông tin hiển thị (Cards):**

* Current Trip (Mã chuyến), Current Route (Tuyến), Current Bus (Biển số xe)  
* Current Trip Status (Trạng thái chuyến), Current Stop (Điểm dừng hiện tại), Next Stop (Điểm dừng kế tiếp)  
* Total Passengers Checked (Hành khách đã lên xe), Passengers Remaining (Hành khách còn lại), Pending Notifications (Thông báo chờ)

### **2\. Chuyến xe của tôi (My Trip)**

**URL:** GET /assistant/trip | **View:** view/assistant/my-trip.jsp  
Đổi tên từ AssignedTripServlet thành MyTripServlet để thống nhất cấu trúc phân hệ. Assistant chỉ được xem các Trip được phân công cho chính mình thông qua bộ lọc mã AssistantID, không sử dụng hàm getAllTrips() tổng quan.

// Gọi tương ứng từ Service  
List\<TripDTO\> assignedTrips \= tripService.getTripsByAssistant(currentUserID);

// SQL thực thi ngầm gộp trong DAO  
SELECT \* FROM Trips WHERE AssistantID \= ?

**Hiển thị bảng:** Trip Code, Route, Bus Plate, Driver, Departure Time, Arrival Time, Status. Chỉ có nút hành động \[View Detail\], khóa cứng quyền Create, Update, Delete.

### **3\. Chi tiết Chuyến xe (Trip Detail)**

**URL:** GET /assistant/trip/detail?id={tripID} | **View:** view/assistant/trip-detail.jsp  
Hiển thị toàn bộ thông tin chung của chuyến xe và danh sách điểm dừng lộ trình được kết xuất theo thứ tự từ bảng liên kết: Trip → Route → Route\_Stop (Sắp xếp tăng dần theo StopOrder) → Stop.

### **4\. Soát vé & Xác nhận lên xe (Ticket Validation & Passenger Check)**

Trong Sprint 6, quy trình kiểm tra được thực hiện thủ công bằng cách nhập chuỗi văn bản (Ticket Code) để mô phỏng nghiệp vụ, làm nền tảng để thay thế bằng Camera Scan QR Code ở Sprint cuối.

* **Kiểm tra vé (Ticket Validation):** Nhập mã vé → Hệ thống check: Vé tồn tại, Vé còn hiệu lực, Vé trùng khớp với lịch trình chuyến xe hiện tại và Vé ở trạng thái chưa sử dụng (UNUSED).  
* **Xác nhận lên xe (Passenger Check):** Nếu hợp lệ, Assistant bấm xác nhận Check-In → Hệ thống bọc Transaction chuyển đổi trạng thái vé:  
  UNUSED (Chưa sử dụng) → USED (Đã sử dụng)

### **5\. Tiếp nhận Thông báo (Notification)**

**URL:** GET /assistant/notification | **View:** view/assistant/notification.jsp  
Assistant đóng vai trò read-only, xem các thông báo điều xe, thay đổi tuyến, thông báo hệ thống được gửi đích danh hoặc luồng thông báo hàng loạt dành cho nhóm Phụ xe (All Assistants) do Staff/Admin phát đi.

### **6\. Thay đổi mật khẩu (Change Password)**

**URL:** GET/POST /assistant/change-password | **View:** view/assistant/change-password.jsp  
Quy trình bọc mật mã an toàn: Nhập mật khẩu cũ (Old Password) → Nhập mật khẩu mới & xác nhận → Service Hash Password mã hóa → Cập nhật DB.

## **IV. Quy tắc Bảo mật & Phân quyền**

* **Quyền hạn được phép:** Xem Dashboard, Xem danh sách chuyến xe được phân công cá nhân (My Trips), Xem chi tiết chuyến xe sở hữu, Đọc thông báo, Quản lý Profile cá nhân, Soát vé thủ công & Check-In hành khách.  
* **Tuyệt đối nghiêm cấm (Chặn Filter):** CRUD Bus, CRUD Route, CRUD Stop, CRUD Route Stop, CRUD Trip, CRUD Notification, CRUD Monthly Pass.  
* **Ràng buộc không gian chạy:** Mỗi Assistant chỉ được phép truy cập và thực thi các thao tác soát vé trên chuyến đi có cấu hình AssistantID \= CurrentUserID. Nếu cố ý chỉnh sửa ID trên thanh URL để can thiệp chuyến xe của người khác, Service sẽ chủ động throw Exception chặn đứng hành vi bẻ khóa ảo.

## **V. Kế hoạch mở rộng Sprint cuối**

Sprint hiện tại tập trung hoàn thiện giao diện, luồng kiểm tra nghiệp vụ và xử lý logic đồng bộ trạng thái vé. Sprint cuối sẽ nâng cấp:

* Tích hợp luồng Camera Scan QR Code bằng JavaScript/Thư viện ngoài để lấy dữ liệu tự động thay cho nhập chuỗi văn bản.  
* Hệ thống tự động hóa điểm dừng (Boarding tự động) dựa trên GPS định vị, kiểm tra soát vé tháng bằng QR, và thống kê biểu đồ số lượng người lên/xuống chi tiết theo từng điểm dừng theo thời gian thực.

## **VI. Checklist Hoàn Thành Sprint 6 (Assistant Module)**

| Hạng mục lớp | Yêu cầu Checklist Kiểm tra nghiệm thu chi tiết |
| :---- | :---- |
| **DAO (Data Layer)** | \[ \] TripDAO — Viết hoàn thành hàm getTripsByAssistant(int assistantID) kết hợp JOIN lấy DTO hiển thị. \[ \] TicketDAO — Viết hàm truy tìm thông tin vé: getByCode(String ticketCode) phục vụ soát vé. \[ \] TicketDAO — Hàm cập nhật trạng thái vé: updateTicketStatus(int ticketID, String status). \[ \] RouteStopDAO — Hàm getStopsByRouteId(int routeID) sắp xếp điểm dừng tăng dần dựa trên StopOrder. |
| **SERVICE (Business Layer)** | \[ \] AssistantDashboardService — Logic tính toán nhanh các chỉ số vận hành tĩnh của chuyến đi đang chạy. \[ \] TicketValidationService — Cài đặt bộ quy tắc validate vé nghiêm ngặt (Tồn tại, đúng tuyến, đúng ngày chạy, trạng thái phải là UNUSED), ném Exception lỗi trực tiếp nếu sai lệch. \[ \] PassengerCheckService — Logic bọc Transaction cập nhật chuyển đổi trạng thái vé từ UNUSED sang USED. |
| **CONTROLLER** | \[ \] AssistantDashboardServlet — Tổng hợp dữ liệu đẩy về giao diện tổng quan. \[ \] MyTripServlet — Thu thập AccountID từ Session USER đang đăng nhập để truyền vào Service giới hạn phạm vi truy cập. \[ \] TripDetailServlet — Cài đặt bộ lọc rà soát bảo mật an toàn quyền sở hữu chuyến xe (AssistantID \== CurrentUserID) trước khi mở trang chi tiết. \[ \] TicketValidationServlet / PassengerCheckServlet — Khối bọc try/catch thu bắt lỗi ném Exception để in ra màn hình thông báo lỗi nhập vé. |
| **VIEW (JSP Pages)** | \[ \] dashboard.jsp — Hiển thị các khối thẻ (Cards) mô phỏng trạng thái chuyến đi thực tế đang chạy. \[ \] my-trip.jsp — Bảng danh sách chuyến xe được phân công cá nhân, khóa cứng mọi quyền xóa/sửa. \[ \] trip-detail.jsp — Hiển thị thông tin hành trình và danh sách điểm dừng đổ tuần tự từ thẻ JSTL vòng lặp. \[ \] passenger-check.jsp — Biểu mẫu nhập mã soát vé thủ công và hiển thị bảng thông tin hành khách. \[ \] change-password.jsp — Biểu mẫu thay đổi mật khẩu cá nhân. |

