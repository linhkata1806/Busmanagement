-- ============================================================
-- PHẦN 1: CẤU TRÚC BẢNG, RÀNG BUỘC (CONSTRAINTS) VÀ DỮ LIỆU MẪU
-- ============================================================

USE master;
GO

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'HanoiBusDB')
BEGIN
    CREATE DATABASE HanoiBusDB;
END
GO

USE HanoiBusDB;
GO

-- XÓA BẢNG CŨ NẾU CÓ
IF OBJECT_ID('Notifications',  'U') IS NOT NULL DROP TABLE Notifications;
IF OBJECT_ID('BusLocations',   'U') IS NOT NULL DROP TABLE BusLocations;
IF OBJECT_ID('SearchHistory',  'U') IS NOT NULL DROP TABLE SearchHistory;
IF OBJECT_ID('Favorites',      'U') IS NOT NULL DROP TABLE Favorites;
IF OBJECT_ID('MonthlyPasses',  'U') IS NOT NULL DROP TABLE MonthlyPasses;
IF OBJECT_ID('MonthlyPassTypes','U') IS NOT NULL DROP TABLE MonthlyPassTypes;
IF OBJECT_ID('Tickets',        'U') IS NOT NULL DROP TABLE Tickets;
IF OBJECT_ID('Attendance',     'U') IS NOT NULL DROP TABLE Attendance;
IF OBJECT_ID('Trips',          'U') IS NOT NULL DROP TABLE Trips;
IF OBJECT_ID('Route_Stop',     'U') IS NOT NULL DROP TABLE Route_Stop;
IF OBJECT_ID('Buses',          'U') IS NOT NULL DROP TABLE Buses;
IF OBJECT_ID('Routes',         'U') IS NOT NULL DROP TABLE Routes;
IF OBJECT_ID('Stops',          'U') IS NOT NULL DROP TABLE Stops;
IF OBJECT_ID('Accounts',       'U') IS NOT NULL DROP TABLE Accounts;
IF OBJECT_ID('Roles',          'U') IS NOT NULL DROP TABLE Roles;
GO

-- ================== TẠO BẢNG ==================

CREATE TABLE Roles (
    RoleID   INT          PRIMARY KEY IDENTITY(1,1),
    RoleName NVARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Accounts (
    AccountID     INT           PRIMARY KEY IDENTITY(1,1),
    Username      VARCHAR(50)   NOT NULL UNIQUE,
    Password      VARCHAR(255)  NOT NULL,        
    FullName      NVARCHAR(100) NOT NULL,
    Email         VARCHAR(100)  NOT NULL UNIQUE,
    Phone         VARCHAR(15),
    Avatar        VARCHAR(255),
    RememberToken VARCHAR(255), 
    RoleID        INT           NOT NULL,
    IsActive      BIT           NOT NULL DEFAULT 1,
    LastLogin     DATETIME,
    UpdatedAt     DATETIME      NOT NULL DEFAULT GETDATE(),
    CreatedAt     DATETIME      NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Accounts_Roles FOREIGN KEY (RoleID) REFERENCES Roles(RoleID),
    CONSTRAINT CHK_Accounts_Email CHECK (Email LIKE '%_@_%._%')
);

CREATE TABLE Stops (
    StopID      INT           PRIMARY KEY IDENTITY(1,1),
    StopName    NVARCHAR(150) NOT NULL UNIQUE,
    Address     NVARCHAR(255),
    Latitude    DECIMAL(10,7),
    Longitude   DECIMAL(10,7),
    IsActive    BIT           NOT NULL DEFAULT 1
);

CREATE TABLE Routes (
    RouteID       INT           PRIMARY KEY IDENTITY(1,1),
    RouteNumber   VARCHAR(10)   NOT NULL UNIQUE,
    RouteName     NVARCHAR(200) NOT NULL,
    StartPoint    NVARCHAR(150) NOT NULL,
    EndPoint      NVARCHAR(150) NOT NULL,
    OperatingHours NVARCHAR(150) NOT NULL,
    Frequency     NVARCHAR(150),
    TicketPrice   DECIMAL(10,0) NOT NULL,
    TotalDistance DECIMAL(6,2),
    IsActive      BIT           NOT NULL DEFAULT 1,
    CONSTRAINT CHK_Routes_Price CHECK (TicketPrice >= 0)
);

CREATE TABLE Route_Stop (
    RouteStopID INT PRIMARY KEY IDENTITY(1,1),
    RouteID     INT NOT NULL,
    StopID      INT NOT NULL,
    StopOrder   INT NOT NULL,
    CONSTRAINT FK_RouteStop_Route FOREIGN KEY (RouteID) REFERENCES Routes(RouteID) ON DELETE CASCADE,
    CONSTRAINT FK_RouteStop_Stop  FOREIGN KEY (StopID)  REFERENCES Stops(StopID) ON DELETE CASCADE,
    CONSTRAINT UQ_Route_Stop_Order UNIQUE (RouteID, StopOrder),
    CONSTRAINT UQ_Route_Stop       UNIQUE (RouteID, StopID),
    CONSTRAINT CHK_RouteStop_Order CHECK (StopOrder > 0)
);

CREATE TABLE Buses (
    BusID        INT          PRIMARY KEY IDENTITY(1,1),
    LicensePlate VARCHAR(20)  NOT NULL UNIQUE,
    Capacity     INT          NOT NULL,
    BusType      NVARCHAR(50) NOT NULL DEFAULT N'Thường',
    Status       VARCHAR(50)  NOT NULL DEFAULT 'ACTIVE',
    CONSTRAINT CHK_Buses_Capacity CHECK (Capacity > 0),
    CONSTRAINT CHK_Buses_Status   CHECK (Status IN ('ACTIVE', 'MAINTENANCE', 'INACTIVE'))
);

CREATE TABLE Trips (
    TripID      INT      PRIMARY KEY IDENTITY(1,1),
    RouteID     INT      NOT NULL,
    BusID       INT      NOT NULL,
    DriverID    INT      NOT NULL,
    AssistantID INT,
    TripDate    DATE     NOT NULL,
    StartTime   TIME     NOT NULL,
    EndTime     TIME     NOT NULL,
    Direction   TINYINT  NOT NULL DEFAULT 1,
    Status      VARCHAR(50) NOT NULL DEFAULT 'SCHEDULED',
    CONSTRAINT FK_Trips_Route     FOREIGN KEY (RouteID)     REFERENCES Routes(RouteID),
    CONSTRAINT FK_Trips_Bus       FOREIGN KEY (BusID)       REFERENCES Buses(BusID),
    CONSTRAINT FK_Trips_Driver    FOREIGN KEY (DriverID)    REFERENCES Accounts(AccountID),
    CONSTRAINT FK_Trips_Assistant FOREIGN KEY (AssistantID) REFERENCES Accounts(AccountID),
    CONSTRAINT CHK_Trips_Time     CHECK (StartTime < EndTime),
    CONSTRAINT CHK_Trips_Direction CHECK (Direction IN (1, 2)),
    CONSTRAINT CHK_Trips_Status   CHECK (Status IN ('SCHEDULED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED'))
);

CREATE TABLE Attendance (
    AttendanceID INT      PRIMARY KEY IDENTITY(1,1),
    TripID       INT      NOT NULL,
    AccountID    INT      NOT NULL,
    CheckInTime  DATETIME,
    CheckOutTime DATETIME,
    Note         NVARCHAR(255),
    CONSTRAINT FK_Attendance_Trip    FOREIGN KEY (TripID)    REFERENCES Trips(TripID),
    CONSTRAINT FK_Attendance_Account FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID),
    CONSTRAINT UQ_Attendance_TripUser UNIQUE (TripID, AccountID),
    CONSTRAINT CHK_Attendance_Time CHECK (CheckOutTime IS NULL OR CheckInTime IS NULL OR CheckOutTime > CheckInTime)
);

CREATE TABLE Tickets (
    TicketID     INT           PRIMARY KEY IDENTITY(1,1),
    AccountID    INT,
    TripID       INT,
    RouteID      INT           NOT NULL,
    TicketCode   VARCHAR(50)   NOT NULL UNIQUE,
    Price        DECIMAL(10,0) NOT NULL,
    SaleChannel  VARCHAR(50)   NOT NULL DEFAULT 'ONLINE',
    Status       VARCHAR(50)   NOT NULL DEFAULT 'PENDING',
    PurchasedAt  DATETIME      NOT NULL DEFAULT GETDATE(),
    UsedAt       DATETIME,
    CONSTRAINT FK_Tickets_Account FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID),
    CONSTRAINT FK_Tickets_Trip    FOREIGN KEY (TripID)    REFERENCES Trips(TripID),
    CONSTRAINT FK_Tickets_Route   FOREIGN KEY (RouteID)   REFERENCES Routes(RouteID),
    CONSTRAINT CHK_Tickets_Price  CHECK (Price >= 0),
    CONSTRAINT CHK_Tickets_SaleChannel CHECK (SaleChannel IN ('ONLINE', 'COUNTER', 'ON_BUS')),
    CONSTRAINT CHK_Tickets_Status CHECK (Status IN ('PENDING', 'UNUSED', 'USED', 'EXPIRED'))
);

CREATE TABLE MonthlyPassTypes (
    PassTypeID         INT PRIMARY KEY IDENTITY(1,1),
    TypeName           NVARCHAR(50) NOT NULL UNIQUE,
    DiscountPercentage DECIMAL(5,2) NOT NULL DEFAULT 0,
    Description        NVARCHAR(255),
    CONSTRAINT CHK_Discount_Range CHECK (DiscountPercentage >= 0 AND DiscountPercentage <= 100)
);

CREATE TABLE MonthlyPasses (
    PassID       INT           PRIMARY KEY IDENTITY(1,1),
    AccountID    INT           NOT NULL,
    RouteID      INT,
    PassTypeID   INT           NOT NULL,
    PassCode     VARCHAR(50)   UNIQUE, 
    StartDate    DATE          NOT NULL,
    EndDate      DATE          NOT NULL,
    Price        DECIMAL(10,0) NOT NULL,
    Status       VARCHAR(50)   NOT NULL DEFAULT 'PENDING',
    ImageProof   VARCHAR(255),
    ApprovedBy   INT,
    ApprovedAt   DATETIME,
    CreatedAt    DATETIME      NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Pass_Account  FOREIGN KEY (AccountID)  REFERENCES Accounts(AccountID),
    CONSTRAINT FK_Pass_Route    FOREIGN KEY (RouteID)    REFERENCES Routes(RouteID),
    CONSTRAINT FK_Pass_Type     FOREIGN KEY (PassTypeID) REFERENCES MonthlyPassTypes(PassTypeID),
    CONSTRAINT FK_Pass_Approver FOREIGN KEY (ApprovedBy) REFERENCES Accounts(AccountID),
    CONSTRAINT CHK_Pass_Date    CHECK (StartDate < EndDate),
    CONSTRAINT CHK_Pass_Price   CHECK (Price >= 0),
    CONSTRAINT CHK_Passes_Status CHECK (Status IN ('PENDING', 'APPROVED', 'REJECTED', 'EXPIRED'))
);

CREATE TABLE Favorites (
    AccountID  INT NOT NULL,
    RouteID    INT NOT NULL,
    CreatedAt  DATETIME NOT NULL DEFAULT GETDATE(),
    PRIMARY KEY (AccountID, RouteID),
    CONSTRAINT FK_Favorites_Account FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID) ON DELETE CASCADE,
    CONSTRAINT FK_Favorites_Route   FOREIGN KEY (RouteID)   REFERENCES Routes(RouteID) ON DELETE CASCADE
);

CREATE TABLE SearchHistory (
    HistoryID  INT PRIMARY KEY IDENTITY(1,1),
    AccountID  INT NOT NULL,
    FromStopID INT NOT NULL,
    ToStopID   INT NOT NULL,
    SearchedAt DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_SearchHistory_Account  FOREIGN KEY (AccountID)  REFERENCES Accounts(AccountID) ON DELETE CASCADE,
    CONSTRAINT FK_SearchHistory_FromStop FOREIGN KEY (FromStopID) REFERENCES Stops(StopID) ON DELETE CASCADE,
    CONSTRAINT FK_SearchHistory_ToStop   FOREIGN KEY (ToStopID)   REFERENCES Stops(StopID),
    CONSTRAINT CHK_Search_Stops          CHECK (FromStopID <> ToStopID)
);

CREATE TABLE Notifications (
    NotificationID   INT PRIMARY KEY IDENTITY(1,1),
    AccountID        INT NOT NULL,
    NotificationType VARCHAR(50) NOT NULL,
    Title            NVARCHAR(150) NOT NULL,
    Content          NVARCHAR(500) NOT NULL,
    IsRead           BIT NOT NULL DEFAULT 0,
    CreatedAt        DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Notifications_Account FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID) ON DELETE CASCADE
);

CREATE TABLE BusLocations (
    LocationID INT PRIMARY KEY IDENTITY(1,1),
    BusID      INT NOT NULL UNIQUE, 
    Latitude   DECIMAL(10,7) NOT NULL,
    Longitude  DECIMAL(10,7) NOT NULL,
    UpdatedAt  DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_BusLocations_Bus FOREIGN KEY (BusID) REFERENCES Buses(BusID) ON DELETE CASCADE,
    CONSTRAINT CHK_BusLocations_Lat CHECK (Latitude >= -90.0 AND Latitude <= 90.0),
    CONSTRAINT CHK_BusLocations_Lng CHECK (Longitude >= -180.0 AND Longitude <= 180.0)
);
GO

-- ================== DỮ LIỆU MẪU ==================

INSERT INTO Roles (RoleName) VALUES 
('ADMIN'), ('STAFF'), ('DRIVER'), ('ASSISTANT'), ('CUSTOMER');

-- 2. THÊM ACCOUNTS (Tài khoản đầy đủ các Role)
-- ID sinh ra: 1(Admin), 2,3(Staff), 4,5,6(Driver), 7,8(Assistant), 9,10,11,12(Customer)
INSERT INTO Accounts (Username, Password, FullName, Email, Phone, RoleID, IsActive) VALUES
('admin',       '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'Hệ thống Quản trị',    'admin@bus.vn',     '0900000001', 1, 1),
('staff01',     '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'Nguyễn Văn Trạm',      'staff01@bus.vn',   '0900000002', 2, 1),
('staff02',     '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'Trần Thị Quầy',        'staff02@bus.vn',   '0900000003', 2, 1),
('driver01',    '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'Lê Bác Tài',           'driver01@bus.vn',  '0900000004', 3, 1),
('driver02',    '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'Phạm Tay Lái',         'driver02@bus.vn',  '0900000005', 3, 1),
('driver03',    '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'Vũ Vô Lăng',           'driver03@bus.vn',  '0900000006', 3, 1),
('assistant01', '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'Hoàng Lơ Xe',          'assist01@bus.vn',  '0900000007', 4, 1),
('assistant02', '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'Đinh Soát Vé',         'assist02@bus.vn',  '0900000008', 4, 1),
('khachhang1',  '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'Nguyễn Nhật Linh',     'linhkata@bus.vn',  '0911111111', 5, 1),
('khachhang2',  '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'Trần Sinh Viên',       'sv01@bus.vn',      '0922222222', 5, 1),
('khachhang3',  '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'Lê Văn Du Lịch',       'dulich@bus.vn',    '0933333333', 5, 1),
('khachhang4',  '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'Bà Cụ Hưu Trí',        'cuhuu@bus.vn',     '0944444444', 5, 1);

-- 3. THÊM STOPS (Các trạm phân bố rộng để test thuật toán Find Route)
-- ID từ 1 đến 15
INSERT INTO Stops (StopName, Address, Latitude, Longitude) VALUES
(N'Nhổn', N'Đại học Công Nghiệp, Nam Từ Liêm', 21.0364, 105.7473),
(N'Cầu Diễn', N'Đường 32, Bắc Từ Liêm', 21.0481, 105.7611),
(N'Đại học Quốc Gia', N'144 Xuân Thủy, Cầu Giấy', 21.0378, 105.7816),
(N'Cầu Giấy', N'Điểm trung chuyển Cầu Giấy', 21.0285, 105.8041),
(N'Bến xe Kim Mã', N'Số 1 Kim Mã, Ba Đình', 21.0311, 105.8245),
(N'Ngã tư Vọng', N'Đại La, Hai Bà Trưng', 20.9963, 105.8439),
(N'Bến xe Giáp Bát', N'Giải Phóng, Hoàng Mai', 20.9808, 105.8415),
(N'Bến xe Gia Lâm', N'Ngô Gia Khảm, Long Biên', 21.0456, 105.8761),
(N'Trạm trung chuyển Long Biên', N'Yên Phụ, Ba Đình', 21.0402, 105.8488),
(N'Trần Nhật Duật', N'Hoàn Kiếm', 21.0351, 105.8542),
(N'Đại học Bách Khoa', N'Trần Đại Nghĩa, Hai Bà Trưng', 21.0041, 105.8434),
(N'Bệnh viện Bạch Mai', N'Giải Phóng, Đống Đa', 21.0006, 105.8398),
(N'Ngã Tư Sở', N'Tây Sơn, Đống Đa', 21.0051, 105.8193),
(N'Hà Đông', N'Trần Phú, Hà Đông', 20.9761, 105.7865),
(N'Bến xe Yên Nghĩa', N'Quốc lộ 6, Hà Đông', 20.9502, 105.7468);

-- 4. THÊM ROUTES (Tuyến xe)
INSERT INTO Routes (RouteNumber, RouteName, StartPoint, EndPoint, OperatingHours, Frequency, TicketPrice, TotalDistance) VALUES
('32', N'Nhổn - Giáp Bát', N'Nhổn', N'Bến xe Giáp Bát', '05:00 - 22:30', N'10-15 phút/chuyến', 7000, 18.5),
('01', N'Bến xe Gia Lâm - Bến xe Yên Nghĩa', N'Bến xe Gia Lâm', N'Bến xe Yên Nghĩa', '05:00 - 21:00', N'15 phút/chuyến', 8000, 22.0),
('21A', N'Bến xe Giáp Bát - Bến xe Yên Nghĩa', N'Bến xe Giáp Bát', N'Bến xe Yên Nghĩa', '05:00 - 21:00', N'15-20 phút/chuyến', 7000, 16.0),
('26', N'Mai Động - Sân vận động Quốc Gia', N'Bến xe Giáp Bát', N'Đại học Quốc Gia', '05:00 - 22:30', N'10 phút/chuyến', 7000, 15.0);

-- 5. THÊM ROUTE_STOP (MAPPING TUYẾN - TRẠM) -> Test thuật toán chuyển tuyến
-- Tuyến 32: Nhổn(1) -> Cầu Diễn(2) -> ĐH Quốc Gia(3) -> Cầu Giấy(4) -> Kim Mã(5) -> Giáp Bát(7)
INSERT INTO Route_Stop (RouteID, StopID, StopOrder) VALUES
(1, 1, 1), (1, 2, 2), (1, 3, 3), (1, 4, 4), (1, 5, 5), (1, 7, 6);

-- Tuyến 01: Gia Lâm(8) -> Long Biên(9) -> Trần Nhật Duật(10) -> Ngã Tư Sở(13) -> Hà Đông(14) -> Yên Nghĩa(15)
INSERT INTO Route_Stop (RouteID, StopID, StopOrder) VALUES
(2, 8, 1), (2, 9, 2), (2, 10, 3), (2, 13, 4), (2, 14, 5), (2, 15, 6);

-- Tuyến 21A: Giáp Bát(7) -> Bách Khoa(11) -> BV Bạch Mai(12) -> Ngã Tư Sở(13) -> Hà Đông(14) -> Yên Nghĩa(15)
-- CHÚ Ý: Tuyến 21A và Tuyến 01 giao nhau ở Ngã Tư Sở (13), Hà Đông (14) và Yên Nghĩa (15) 
INSERT INTO Route_Stop (RouteID, StopID, StopOrder) VALUES
(3, 7, 1), (3, 11, 2), (3, 12, 3), (3, 13, 4), (3, 14, 5), (3, 15, 6);

-- Tuyến 26: Giáp Bát(7) -> Ngã tư Vọng(6) -> Bách Khoa(11) -> Cầu Giấy(4) -> ĐH Quốc Gia(3)
INSERT INTO Route_Stop (RouteID, StopID, StopOrder) VALUES
(4, 7, 1), (4, 6, 2), (4, 11, 3), (4, 4, 4), (4, 3, 5);

-- 6. THÊM BUSES (Xe buýt thực tế)
INSERT INTO Buses (LicensePlate, Capacity, BusType, Status) VALUES
('29B-123.45', 60, N'Thường', 'ACTIVE'),
('29B-234.56', 80, N'Xe buýt nối toa', 'ACTIVE'),
('29B-345.67', 60, N'Thường', 'MAINTENANCE'),
('29B-456.78', 60, N'Thường', 'ACTIVE'),
('29B-567.89', 30, N'Xe buýt điện VinBus', 'ACTIVE');

-- 7. THÊM TRIPS (Chuyến đi trong ngày)
-- Driver: 4,5,6 | Assistant: 7,8 | Bus: 1,2,4,5
INSERT INTO Trips (RouteID, BusID, DriverID, AssistantID, TripDate, StartTime, EndTime, Direction, Status) VALUES
(1, 1, 4, 7, CAST(GETDATE() AS DATE), '06:00', '07:30', 1, 'COMPLETED'),
(1, 2, 5, 8, CAST(GETDATE() AS DATE), '08:00', '09:30', 2, 'IN_PROGRESS'),
(2, 4, 6, 7, CAST(GETDATE() AS DATE), '09:00', '10:30', 1, 'SCHEDULED'),
(3, 5, 4, 8, CAST(GETDATE() AS DATE), '14:00', '15:30', 1, 'SCHEDULED'),
(4, 1, 5, NULL, CAST(GETDATE() AS DATE), '16:00', '17:30', 2, 'SCHEDULED'); -- Không có phụ xe

-- 8. THÊM ATTENDANCE (Điểm danh tài xế/phụ xe)
INSERT INTO Attendance (TripID, AccountID, CheckInTime, CheckOutTime, Note) VALUES
(1, 4, DATEADD(minute, -30, GETDATE()), DATEADD(minute, 60, GETDATE()), N'Lái xe an toàn'),
(1, 7, DATEADD(minute, -30, GETDATE()), DATEADD(minute, 60, GETDATE()), N'Đã xé vé đầy đủ'),
(2, 5, DATEADD(minute, -10, GETDATE()), NULL, N'Đang chạy trên đường');

-- 9. THÊM TICKETS (Vé lượt của khách hàng 9,10,11)
INSERT INTO Tickets (AccountID, TripID, RouteID, TicketCode, Price, SaleChannel, Status, PurchasedAt) VALUES
(9, 1, 1, 'TK-01-A123', 7000, 'ONLINE', 'USED', DATEADD(day, -1, GETDATE())),
(10, 2, 1, 'TK-01-B456', 7000, 'ON_BUS', 'UNUSED', GETDATE()),
(11, 3, 2, 'TK-02-C789', 8000, 'ONLINE', 'UNUSED', GETDATE()),
(NULL, 1, 1, 'TK-01-GUEST1', 7000, 'COUNTER', 'USED', DATEADD(day, -1, GETDATE())); -- Khách vãng lai mua tại quầy

-- 10. THÊM MONTHLY PASS TYPES (Loại vé tháng)
INSERT INTO MonthlyPassTypes (TypeName, DiscountPercentage, Description) VALUES
(N'Học sinh/Sinh viên (1 Tuyến)', 50.00, N'Dành cho HSSV, chỉ đi 1 tuyến cố định'),
(N'Học sinh/Sinh viên (Liên Tuyến)', 50.00, N'Dành cho HSSV, đi tất cả các tuyến'),
(N'Người cao tuổi', 100.00, N'Miễn phí toàn bộ mạng lưới buýt Hà Nội'),
(N'Phổ thông (Liên Tuyến)', 0.00, N'Vé tháng bình thường đi tất cả các tuyến');

-- 11. THÊM MONTHLY PASSES (Vé tháng của khách hàng)
INSERT INTO MonthlyPasses (AccountID, RouteID, PassTypeID, PassCode, StartDate, EndDate, Price, Status, ApprovedBy, ApprovedAt) VALUES
(10, 1, 1, 'MP-SV-001', '2024-11-01', '2024-11-30', 50000, 'EXPIRED', 2, '2024-10-25'),
(10, 1, 1, 'MP-SV-002', '2024-12-01', '2024-12-31', 50000, 'APPROVED', 2, '2024-11-28'),
(9, NULL, 4, 'MP-PT-001', '2024-12-01', '2024-12-31', 200000, 'PENDING', NULL, NULL),
(12, NULL, 3, 'MP-CT-001', '2024-01-01', '2025-12-31', 0, 'APPROVED', 1, '2023-12-15');

-- 12. THÊM FAVORITES (Lưu tuyến yêu thích)
INSERT INTO Favorites (AccountID, RouteID) VALUES 
(9, 1), (9, 3), (10, 1), (11, 4);

-- 13. THÊM SEARCH HISTORY (Lịch sử tìm đường)
INSERT INTO SearchHistory (AccountID, FromStopID, ToStopID, SearchedAt) VALUES
(9, 1, 7, DATEADD(hour, -5, GETDATE())),  -- Nhổn -> Giáp Bát
(9, 8, 15, DATEADD(day, -1, GETDATE())),  -- Gia Lâm -> Yên Nghĩa
(10, 3, 11, DATEADD(day, -2, GETDATE())); -- ĐH QG -> Bách Khoa

-- 14. THÊM NOTIFICATIONS (Thông báo hệ thống)
INSERT INTO Notifications (AccountID, NotificationType, Title, Content, IsRead) VALUES
(10, 'PASS_APPROVED', N'Vé tháng đã được gia hạn', N'Vé tháng sinh viên mã MP-SV-002 của bạn đã duyệt thành công!', 1),
(9,  'SYSTEM_ALERT',  N'Thay đổi lộ trình tuyến 32', N'Tuyến 32 tạm thời không qua Cầu Giấy do sửa đường vào cuối tuần này.', 0),
(12, 'PROMOTION',     N'Cập nhật chính sách người cao tuổi', N'Từ năm 2024, thẻ miễn phí có thời hạn lên tới 2 năm.', 0);

-- 15. THÊM BUS LOCATIONS (Mô phỏng vị trí GPS Real-time của xe đang chạy)
INSERT INTO BusLocations (BusID, Latitude, Longitude, UpdatedAt) VALUES
(1, 21.0360, 105.7480, GETDATE()), -- Gần Nhổn
(2, 21.0280, 105.8050, GETDATE()), -- Gần Cầu Giấy
(4, 20.9800, 105.8420, GETDATE()); -- Gần Giáp Bát
GO