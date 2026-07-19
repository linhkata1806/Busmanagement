Sprint 6 – DRIVER MODULE (Updated theo Database hiện tại)

I. Mục tiêu \& Phạm vi phân quyền

Driver (Tài xế) là người trực tiếp điều khiển xe buýt vận hành trên tuyến.

Driver không có quyền CRUD dữ liệu hệ thống.

Driver chỉ được thao tác trên các Trip có:

trip.getDriverID() == currentUserID

Các nhiệm vụ chính:

Xem Dashboard cá nhân

Xem danh sách chuyến xe được phân công

Xem chi tiết hành trình

Start Trip

Finish Trip

Xem Notification

Quản lý Profile cá nhân

II. Package Structure

controller

└── driver

&#x20;     │

&#x20;     ├── DriverDashboardServlet.java

&#x20;     ├── MyTripServlet.java

&#x20;     ├── TripDetailServlet.java

&#x20;     ├── StartTripServlet.java

&#x20;     ├── FinishTripServlet.java

&#x20;     ├── NotificationServlet.java

&#x20;     ├── ProfileServlet.java

&#x20;     └── ChangePasswordServlet.java

service

│

├── DriverDashboardService.java

└── DriverTripService.java

view

└── driver

&#x20;     │

&#x20;     ├── dashboard.jsp

&#x20;     ├── my-trip.jsp

&#x20;     ├── trip-detail.jsp

&#x20;     ├── notification.jsp

&#x20;     ├── profile.jsp

&#x20;     └── change-password.jsp





III. Driver Dashboard

URL: GET /driver/dashboard

Dashboard chỉ hiển thị thống kê. Không xử lý SQL trực tiếp trong Servlet.

Các Card hiển thị

Current Trip: TripID, TripDate, Status

Current Route: RouteName, StartPoint, EndPoint

Current Bus: LicensePlate, BusType, Capacity

Today's Trips:

SELECT COUNT(\*)

FROM Trips

WHERE DriverID=?

AND TripDate=CAST(GETDATE() AS DATE)

&#x20;       

Pending Notifications:

SELECT COUNT(\*)

FROM Notifications

WHERE AccountID=?

AND IsRead=0

&#x20;       

Running Trip:

SELECT TOP 1 \*

FROM Trips

WHERE DriverID=?

AND Status='IN\_PROGRESS'

&#x20;       

Lưu ý Database hiện tại:

CHECK (

Status IN (

'SCHEDULED',

'IN\_PROGRESS',

'COMPLETED',

'CANCELLED'

))





Không dùng RUNNING, phải đổi thành: IN\_PROGRESS.

IV. My Trip

URL: GET /driver/trip

Driver chỉ được xem Trip của mình:

driverTripService.getTripsByDriver(currentUserID);

DAO:

SELECT

&#x20;   t.\*,

&#x20;   r.RouteName,

&#x20;   b.LicensePlate,

&#x20;   a.FullName AS AssistantName

FROM Trips t

JOIN Routes r ON t.RouteID=r.RouteID

JOIN Buses b ON t.BusID=b.BusID

LEFT JOIN Accounts a ON t.AssistantID=a.AccountID

WHERE t.DriverID=?

ORDER BY TripDate DESC





Hiển thị: TripID, Route, Bus Plate, Assistant, TripDate, StartTime, EndTime, Status

Action: View Detail

Không được: Create, Update, Delete

V. Trip Detail

URL: GET /driver/trip/detail?id=1

Hiển thị: TripID, RouteName, Driver, Assistant, Bus, TripDate, StartTime, EndTime, Status, Danh sách điểm dừng.

Lấy theo: Trip → Route → Route\_Stop → Stops

DAO:

SELECT

&#x20;   rs.StopOrder,

&#x20;   s.StopName,

&#x20;   s.Address

FROM Route\_Stop rs

JOIN Stops s ON rs.StopID=s.StopID

WHERE rs.RouteID=?

ORDER BY rs.StopOrder





VI. Start Trip

URL: POST /driver/trip/start

Database hiện tại KHÔNG có ActualDepartureTime. Do đó, Start Trip chỉ cập nhật Status: SCHEDULED → IN\_PROGRESS.

DAO:

UPDATE Trips SET Status='IN\_PROGRESS' WHERE TripID=?





Service Validate:

if(!trip.getStatus().equals("SCHEDULED")){

&#x20;   throw new IllegalArgumentException("Chuyến xe đã được bắt đầu hoặc đã hoàn thành.");

}





VII. Finish Trip

URL: POST /driver/trip/finish

Database hiện tại KHÔNG có ActualArrivalTime. Do đó, Finish Trip chỉ đổi: IN\_PROGRESS → COMPLETED.

DAO:

UPDATE Trips SET Status='COMPLETED' WHERE TripID=?





Service Validate:

if(!trip.getStatus().equals("IN\_PROGRESS")){

&#x20;   throw new IllegalArgumentException("Chỉ được kết thúc chuyến xe đang hoạt động.");

}





VIII. Notification

URL: GET /driver/notification

Driver: READ ONLY (Không được Create, Edit, Delete).

DAO: notificationDAO.getByAccountID(accountID);

IX. Profile \& Change Password

Profile: Avatar, FullName, Username, Email, Phone, Role, CreatedAt. Cho phép Edit Profile, Change Password. Không cho sửa Username, Role.

Change Password: GET/POST /driver/change-password

Quy trình: Old Password → Check Hash → New Password → Confirm Password → Update Database.

Service: PasswordEncoder.matches() → PasswordEncoder.encode() → accountDAO.updatePassword()

X. Security Rules (Bảo mật bắt buộc)

Driver chỉ thao tác trên Trip của mình, không được sửa URL (Ví dụ: /driver/trip/detail?id=100).

if(trip.getDriverID() != currentUserID){

&#x20;   throw new IllegalArgumentException("Bạn không có quyền truy cập chuyến xe này.");

}





XI. Phân quyền

Được phép

Không được

Dashboard

My Trip

Trip Detail

Start Trip

Finish Trip

Notification

Profile

Change Password

Bus CRUD

Route CRUD

Stop CRUD

Route Stop CRUD

Trip CRUD

Notification CRUD

Monthly Pass CRUD



XII. Sprint cuối (KHÔNG làm Sprint này)

Database hiện tại đã có BusLocations (BusID, Latitude, Longitude, UpdatedAt). Do đó Sprint cuối chỉ cần:

GPS Real-time: Driver → Update BusLocations → Customer View Map → ETA.

Current Stop: BusLocation → Nearest Stop → Current Stop.

ETA: Current Stop → Next Stop → Distance → Speed → ETA.

XIII. Checklist hoàn thành Sprint 6 (Driver Module)

Hạng mục

Chi tiết

TripDAO

getTripsByDriver(int driverID)

TripDAO

getTripByIDAndDriver(tripID, driverID)

TripDAO

updateTripStatus(tripID, status)

RouteStopDAO

getStopsByRoute(routeID)

NotificationDAO

getByAccountID(accountID)

DriverDashboardService

Dashboard statistics

DriverTripService

Start Trip validation (SCHEDULED → IN\_PROGRESS)

DriverTripService

Finish Trip validation (IN\_PROGRESS → COMPLETED)

DriverDashboardServlet

Dashboard

MyTripServlet

Trip list

TripDetailServlet

Ownership check

StartTripServlet

Start trip

FinishTripServlet

Finish trip

dashboard.jsp

Cards

my-trip.jsp

Trip table

trip-detail.jsp

Stops list

notification.jsp

Read-only notifications

profile.jsp

Profile

change-password.jsp

Change password



XIV. Những điểm đã sửa để khớp 100% với DB hiện tại

❌ Bỏ: ActualDepartureTime, ActualArrivalTime, RUNNING.

✅ Thay bằng Status: SCHEDULED → IN\_PROGRESS → COMPLETED.

❌ Không thêm bảng mới.

✅ Tận dụng: BusLocations, Notifications, Trips, Route\_Stop, Stops, Accounts đúng với database hiện tại.



