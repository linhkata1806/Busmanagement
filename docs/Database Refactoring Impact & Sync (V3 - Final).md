# **Tài liệu Đặc tả Sửa đổi Kiến trúc: Database Refactoring Impact (V3 \- Final)**

## **Tổng quan Chiến lược Refactor**

Hệ thống không thực hiện đập đi viết lại toàn bộ project (No Full-Rewrite), mà áp dụng chiến lược **Sửa đổi khoanh vùng (Targeted Refactoring)**. Toàn bộ tầng Service tiếp tục tuân thủ nghiêm ngặt mô hình **Exception-based Service** (ném lỗi trực tiếp bằng IllegalArgumentException thay vì trả về giá trị logic).

## **PHẦN A: CÁC HẠNG MỤC CẦN REFACTOR NGAY LẬP TỨC (Sprint 4, 5, 6\)**

### **1\. Module Tuyến Xe (Routes)**

**Mục tiêu bổ sung:** Đồng bộ trường dữ liệu EstimatedDuration phục vụ ước tính tổng thời gian hành trình.

* **Tầng Model (Route.java):** Thêm thuộc tính: private int estimatedDuration;  
* **Tầng Dữ liệu (RouteDAO.java):**  
  * Ánh xạ từ ResultSet: route.setEstimatedDuration(rs.getInt("EstimatedDuration"));  
  * Hàm insert/update: Cập nhật câu lệnh SQL truyền tham số EstimatedDuration.  
* **Tầng Nghiệp vụ (RouteService.java):** Validate:  
  if (estimatedDuration \<= 0\) {  
      throw new IllegalArgumentException("Thời gian dự kiến phải \> 0 phút.");  
  }

* **Tầng Hiển thị (JSP Views):** Thêm thẻ input nhập thời gian dự kiến (phút) vào create-route.jsp và edit-route.jsp.

### **2\. Module Điểm Dừng Tuyến (Route\_Stop)**

**Mục tiêu bổ sung:** Tích hợp DistanceFromStart làm nền tảng cốt lõi phục vụ Map Animation, Bus Tracking và ETA.

* **Tầng DTO (RouteStopDTO.java):** Thêm private double distanceFromStart;  
* **Tầng Dữ liệu (RouteStopDAO.java):**  
  * Ánh xạ: dto.setDistanceFromStart(rs.getDouble("DistanceFromStart"));  
  * Sửa câu lệnh: INSERT INTO Route\_Stop (RouteID, StopID, StopOrder, DistanceFromStart) VALUES (?, ?, ?, ?);  
* **Tầng Nghiệp vụ (RouteStopService.java):**  
  public void addStopToRoute(int routeID, int stopID, int position, double distance) {  
      if (distance \< 0\) throw new IllegalArgumentException("Distance phải \>= 0");  
      // ...  
  }

* **Tầng Servlet & View:** Lấy tham số distance và hiển thị cột tương ứng.

### **3\. Module Lịch Trình Chuyến Đi (Trips)**

**Mục tiêu bổ sung:** Lưu trữ chính xác mốc thời gian thực tế.

* **Tầng Model (Trip.java):** Thêm private Timestamp actualStartTime; và private Timestamp actualEndTime;  
* **Tầng Dữ liệu (TripDAO.java):** Ánh xạ dữ liệu rs.getTimestamp ở tất cả mệnh đề SELECT.  
* **Tầng Nghiệp vụ (DriverTripService.java):**  
  * Start Trip: Update status sang IN\_PROGRESS và set ActualStartTime \= GETDATE()  
  * Finish Trip: Update status sang COMPLETED và set ActualEndTime \= GETDATE()

### **4\. Vòng Đời Trạng Thái Vé (Tickets)**

**Mục tiêu bổ sung:** Thiết lập State Machine chi tiết cho vé lẻ.

* **Tầng Model (Ticket.java):** Đổi sang 5 constants: UNUSED, CHECKED\_IN, COMPLETED, EXPIRED, CANCELLED.  
* **Assistant Module:** Khi phụ xe check-in vé thành công: UNUSED \-\> CHECKED\_IN (Thay vì USED như trước).  
* **Driver Module (Finish Trip):** Tự động chốt vé: Tài xế kết thúc chuyến $\\rightarrow$ DB quét tất cả vé đang CHECKED\_IN của chuyến đó và đổi sang COMPLETED.

### **5\. Module Vé Tháng (Monthly Pass)**

**Mục tiêu bổ sung:** Tạo hạ tầng token hóa bảo mật phục vụ quét camera.

* **Tầng Model (MonthlyPass.java):** Thêm private String qrCodeToken; và private Timestamp lastUsedAt;.  
* **Tầng Dữ liệu:** Ánh xạ 2 trường mới trong mọi lệnh SELECT.  
* **Luồng Approve:** Khi Staff duyệt (APPROVED), sinh mã định danh duy nhất (Ví dụ: UUID.randomUUID()) lưu thẳng vào cột QRCodeToken.

## **PHẦN B: ĐẶC TẢ CÁC MODULE TÍNH NĂNG MỚI (Sprint Cuối)**

*Các module này được triển khai độc lập, có thể dời lại làm ở Sprint sau cùng mà không ảnh hưởng mã nguồn hiện tại.*

* **PAYMENT MODULE:** PaymentDAO, PaymentService. Xử lý luồng: Generate QR → Pending → Success → Tự động Create Ticket.  
* **DISCOUNT MODULE:** DiscountDAO, DiscountService. Thực thi hàm áp mã trừ tiền trực tiếp vào giỏ hàng Payment.  
* **NOTIFICATION REFRACTORING:** Sửa cột AccountID thành NULL (gửi nhóm), thêm bảng NotificationRead để quản lý trạng thái đã đọc của từng User khi Admin broadcast tin nhắn hàng loạt theo TargetRole.  
* **BUS LOCATION HISTORY:** Lưu vết tọa độ định vị GPS của xe buýt định kỳ.  
* **TRIP PROGRESS & ETA:** Tính thời gian xe đến trạm dựa trên thuộc tính DistanceFromStart và vận tốc chạy ước tính trên tuyến.

## **PHẦN C: MA TRẬN TÁC ĐỘNG SỬA ĐỔI (MATRIX IMPACT)**

| Tên Module | Model | DAO | Service | Controller | JSP View | Mức độ ưu tiên |
| ----- | :---: | :---: | :---: | :---: | :---: | :---: |
| **Route** | ✅ Sửa | ✅ Sửa | ✅ Sửa | ❌ Không | ✅ Sửa | 🛠️ Refactor Ngay |
| **RouteStop** | ✅ Sửa | ✅ Sửa | ✅ Sửa | ✅ Sửa | ✅ Sửa | 🛠️ Refactor Ngay |
| **Trip** | ✅ Sửa | ✅ Sửa | ✅ Sửa | ✅ Sửa | ❌ Không | 🛠️ Refactor Ngay |
| **Ticket** | 🟡 Định nghĩa lại | 🟡 Đổi tên biến | 🟡 Đổi tên biến | 🟡 Đổi tên biến | ❌ Không | 🛠️ Refactor Ngay |
| **MonthlyPass** | ✅ Sửa | ✅ Sửa | ✅ Sửa | ❌ Không | ❌ Không | 🛠️ Refactor Ngay |
| **Payment** | 🆕 Tạo mới | 🆕 Tạo mới | 🆕 Tạo mới | 🆕 Tạo mới | 🆕 Tạo mới | 🛠️ Refactor Ngay |
| **Discount** | 🆕 Tạo mới | 🆕 Tạo mới | 🆕 Tạo mới | ❌ Không | ❌ Không | 🛠️ Refactor Ngay |
| **Notification** | 🟡 Sửa | 🆕 Tạo bảng đọc | 🆕 Tạo mới | 🟡 Sửa | 🟡 Sửa | 🛠️ Refactor Ngay |
| **BusLocHistory** | 🆕 Tạo mới | 🆕 Tạo mới | 🆕 Tạo mới | ❌ Không | ❌ Không | 🛠️ Refactor Ngay |
| **TripProgress** | 🆕 Tạo mới | 🆕 Tạo mới | 🆕 Tạo mới | 🆕 Tạo mới | 🆕 Tạo mới | 🛠️ Refactor Ngay |

