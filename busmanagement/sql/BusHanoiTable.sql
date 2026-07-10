USE master;
GO

-- 1. NGẮT KẾT NỐI VÀ XÓA DATABASE CŨ
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'HanoiBusDB')
BEGIN
    ALTER DATABASE HanoiBusDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE HanoiBusDB;
END
GO

-- 2. TẠO DATABASE MỚI
CREATE DATABASE HanoiBusDB;
GO

USE HanoiBusDB;
GO

-- ==========================================
-- 3. KHỞI TẠO CẤU TRÚC BẢNGr
-- ==========================================

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
    StopName    NVARCHAR(255) NOT NULL UNIQUE,
    Address     NVARCHAR(500),
    Latitude    DECIMAL(10,7),
    Longitude   DECIMAL(10,7),
    IsActive    BIT           NOT NULL DEFAULT 1
);

CREATE TABLE Routes (
    RouteID        INT           PRIMARY KEY IDENTITY(1,1),
    RouteNumber    VARCHAR(10)   NOT NULL UNIQUE,
    RouteName      NVARCHAR(255) NOT NULL,
    StartPoint     NVARCHAR(255) NOT NULL,
    EndPoint       NVARCHAR(255) NOT NULL,
    OperatingHours NVARCHAR(150) NOT NULL,
    Frequency      NVARCHAR(150),
    TicketPrice    DECIMAL(10,0) NOT NULL,
    TotalDistance  DECIMAL(6,2),
    EstimatedDuration INT, 
    IsActive       BIT           NOT NULL DEFAULT 1,
    CONSTRAINT CHK_Routes_Price CHECK (TicketPrice >= 0)
);

CREATE TABLE Route_Stop (
    RouteStopID       INT PRIMARY KEY IDENTITY(1,1),
    RouteID           INT NOT NULL,
    StopID            INT NOT NULL,
    StopOrder         INT NOT NULL,
    DistanceFromStart DECIMAL(6,2), 
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
    TripID          INT      PRIMARY KEY IDENTITY(1,1),
    RouteID         INT      NOT NULL,
    BusID           INT      NOT NULL,
    DriverID        INT      NOT NULL,
    AssistantID     INT,
    TripDate        DATE     NOT NULL,
    StartTime       TIME     NOT NULL,
    EndTime         TIME     NOT NULL,
    ActualStartTime DATETIME NULL, 
    ActualEndTime   DATETIME NULL, 
    Direction       TINYINT  NOT NULL DEFAULT 1,
    Status          VARCHAR(50) NOT NULL DEFAULT 'SCHEDULED',
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
    CONSTRAINT CHK_Tickets_Status CHECK (Status IN ('UNUSED', 'CHECKED_IN', 'COMPLETED', 'EXPIRED', 'CANCELLED'))
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
    QRCodeToken  VARCHAR(255), 
    StartDate    DATE          NOT NULL,
    EndDate      DATE          NOT NULL,
    Price        DECIMAL(10,0) NOT NULL,
    Status       VARCHAR(50)   NOT NULL DEFAULT 'PENDING',
    ImageProof   VARCHAR(255),
    ApprovedBy   INT,
    ApprovedAt   DATETIME,
    LastUsedAt   DATETIME,     
    CreatedAt    DATETIME      NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Pass_Account  FOREIGN KEY (AccountID)  REFERENCES Accounts(AccountID),
    CONSTRAINT FK_Pass_Route    FOREIGN KEY (RouteID)    REFERENCES Routes(RouteID),
    CONSTRAINT FK_Pass_Type     FOREIGN KEY (PassTypeID) REFERENCES MonthlyPassTypes(PassTypeID),
    CONSTRAINT FK_Pass_Approver FOREIGN KEY (ApprovedBy) REFERENCES Accounts(AccountID),
    CONSTRAINT CHK_Pass_Date    CHECK (StartDate < EndDate),
    CONSTRAINT CHK_Pass_Price   CHECK (Price >= 0),
    CONSTRAINT CHK_Passes_Status CHECK (Status IN ('PENDING', 'APPROVED', 'REJECTED', 'EXPIRED'))
);

CREATE TABLE Payments(
    PaymentID       INT PRIMARY KEY IDENTITY(1,1),
    AccountID       INT NOT NULL,
    TicketID        INT NULL,
    PassID          INT NULL,
    Amount          DECIMAL(10,0) NOT NULL,
    PaymentMethod   VARCHAR(50) NOT NULL, 
    TransactionCode VARCHAR(100),
    QRImage         VARCHAR(255),
    PaymentStatus   VARCHAR(50) NOT NULL DEFAULT 'PENDING', 
    PaidAt          DATETIME,
    CreatedAt       DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Payments_Account FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID),
    CONSTRAINT FK_Payments_Ticket FOREIGN KEY (TicketID) REFERENCES Tickets(TicketID),
    CONSTRAINT FK_Payments_Pass FOREIGN KEY (PassID) REFERENCES MonthlyPasses(PassID),
    CONSTRAINT CHK_Payments_Status CHECK (PaymentStatus IN ('PENDING', 'SUCCESS', 'FAILED', 'REFUNDED')),
    CONSTRAINT CHK_Payments_Target CHECK (
        (TicketID IS NOT NULL AND PassID IS NULL) OR 
        (TicketID IS NULL AND PassID IS NOT NULL)
    )
);

CREATE TABLE Discounts (
    DiscountID      INT PRIMARY KEY IDENTITY(1,1),
    DiscountCode    VARCHAR(50) NOT NULL UNIQUE,
    DiscountPercent DECIMAL(5,2) NOT NULL,
    MinimumAmount   DECIMAL(10,0) DEFAULT 0, 
    StartDate       DATETIME NOT NULL,
    EndDate         DATETIME NOT NULL,
    IsActive        BIT NOT NULL DEFAULT 1,
    Description     NVARCHAR(255),
    CONSTRAINT CHK_DiscountPercent CHECK (DiscountPercent > 0 AND DiscountPercent <= 100),
    CONSTRAINT CHK_DiscountMinAmount CHECK (MinimumAmount >= 0)
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
    AccountID        INT NULL,                  
    TargetRole       VARCHAR(50) DEFAULT 'ALL', 
    NotificationType VARCHAR(50) NOT NULL,
    Title            NVARCHAR(150) NOT NULL,
    Content          NVARCHAR(500) NOT NULL,
    IsRead           BIT NOT NULL DEFAULT 0,
    CreatedAt        DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Notifications_Account FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID) ON DELETE CASCADE
);

CREATE TABLE NotificationReads (
    ReadID         INT PRIMARY KEY IDENTITY(1,1),
    NotificationID INT NOT NULL,
    AccountID      INT NOT NULL,
    ReadAt         DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_NotificationReads_Noti FOREIGN KEY (NotificationID) REFERENCES Notifications(NotificationID) ON DELETE CASCADE,
    -- ĐÃ FIX LỖI Ở ĐÂY: Xóa ON DELETE CASCADE để chặn Multiple Cascade Path
    CONSTRAINT FK_NotificationReads_Acc FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID), 
    CONSTRAINT UQ_NotificationReads UNIQUE(NotificationID, AccountID) 
);

CREATE TABLE BusLocationHistory (
    HistoryID  INT PRIMARY KEY IDENTITY(1,1),
    BusID      INT NOT NULL, 
    TripID     INT NOT NULL, 
    Latitude   DECIMAL(10,7) NOT NULL,
    Longitude  DECIMAL(10,7) NOT NULL,
    RecordedAt DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_BusLocationHistory_Bus FOREIGN KEY (BusID) REFERENCES Buses(BusID) ON DELETE CASCADE,
    CONSTRAINT FK_BusLocationHistory_Trip FOREIGN KEY (TripID) REFERENCES Trips(TripID) ON DELETE CASCADE,
    CONSTRAINT CHK_BusLocations_Lat CHECK (Latitude >= -90.0 AND Latitude <= 90.0),
    CONSTRAINT CHK_BusLocations_Lng CHECK (Longitude >= -180.0 AND Longitude <= 180.0)
);

CREATE TABLE TripProgress (
    TripProgressID    INT PRIMARY KEY IDENTITY(1,1),
    TripID            INT NOT NULL,
    CurrentStopID     INT NOT NULL,
    NextStopID        INT,
    DistanceRemaining DECIMAL(6,2), 
    EstimatedArrival  DATETIME,
    UpdatedAt         DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_TripProgress_Trip FOREIGN KEY (TripID) REFERENCES Trips(TripID) ON DELETE CASCADE,
    CONSTRAINT FK_TripProgress_CurrentStop FOREIGN KEY (CurrentStopID) REFERENCES Stops(StopID),
    CONSTRAINT FK_TripProgress_NextStop FOREIGN KEY (NextStopID) REFERENCES Stops(StopID),
    CONSTRAINT UQ_TripProgress UNIQUE(TripID) 
);
GO
ALTER TABLE Tickets DROP CONSTRAINT CHK_Tickets_Status;

-- 2. Tạo lại constraint mới khít 100% với danh sách trạng thái V2
ALTER TABLE Tickets ADD CONSTRAINT CHK_Tickets_Status 
CHECK (Status IN ('UNUSED', 'CHECKED_IN', 'COMPLETED', 'EXPIRED', 'CANCELLED'));

-- ==========================================
-- 4. INSERT MOCK DATA TỰ ĐỘNG
-- ==========================================

INSERT INTO Roles (RoleName) VALUES 
('ADMIN'), ('STAFF'), ('DRIVER'), ('ASSISTANT'), ('CUSTOMER');

INSERT INTO Accounts (Username, Password, FullName, Email, Phone, RoleID, IsActive) VALUES
('admin',       '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'Hệ thống Quản trị', 'admin@bus.vn',     '0900000001', 1, 1),
('staff_hoa',   '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'Nguyễn Thị Hoa',    'hoant@bus.vn',     '0900000002', 2, 1),
('staff_tuan',  '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'Trần Anh Tuấn',     'tuanta@bus.vn',    '0900000003', 2, 1),
('driver_binh', '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'Lê Thanh Bình',     'binhlt@bus.vn',    '0900000101', 3, 1),
('driver_hai',  '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'Phạm Quang Hải',    'haipq@bus.vn',     '0900000102', 3, 1),
('driver_cuong','$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'Vũ Quốc Cường',     'cuongvq@bus.vn',   '0900000103', 3, 1),
('driver_long', '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'Đinh Phi Long',     'longdp@bus.vn',    '0900000104', 3, 1),
('driver_son',  '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'Hoàng Thái Sơn',    'sonht@bus.vn',     '0900000105', 3, 1),
('ast_lan',     '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'Ngô Ngọc Lan',      'lannn@bus.vn',     '0900000201', 4, 1),
('ast_phong',   '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'Bùi Văn Phong',     'phongbv@bus.vn',   '0900000202', 4, 1),
('ast_linh',    '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'Đặng Thùy Linh',    'linhdt@bus.vn',    '0900000203', 4, 1),
('linhkata',    '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'Đặng Nhật Linh',    'linhkata@bus.vn',  '0912345678', 5, 1),
('sv_nam',      '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'Trần Văn Nam',      'namsv@gmail.com',  '0988888888', 5, 1),
('kh_mai',      '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'Lê Phương Mai',     'maiphuong@bus.vn', '0977777777', 5, 1),
('kh_hung',     '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'Phạm Tiến Hùng',    'hungpt@bus.vn',    '0966666666', 5, 1);

INSERT INTO Stops (StopName, Address, Latitude, Longitude) VALUES
(N'Bến xe Kim Mã', N'Số 1 Kim Mã, Ba Đình', 21.0311, 105.8245),
(N'Cầu Giấy', N'Điểm trung chuyển Cầu Giấy', 21.0285, 105.8041),
(N'Đại học Quốc Gia', N'144 Xuân Thủy, Cầu Giấy', 21.0378, 105.7816),
(N'Bến xe Mỹ Đình', N'Phạm Hùng, Nam Từ Liêm', 21.0284, 105.7782),
(N'Trung tâm Hội nghị QG', N'Đại lộ Thăng Long', 21.0080, 105.7860),
(N'Thiên Đường Bảo Sơn', N'Đại lộ Thăng Long', 21.0015, 105.7330),
(N'Ngã tư Hòa Lạc', N'Quốc lộ 21, Thạch Thất', 20.9950, 105.5250),
(N'Đại học FPT', N'Khu Công nghệ cao Hòa Lạc', 21.0135, 105.5272),
(N'Làng Văn Hóa', N'Đồng Mô, Sơn Tây', 21.0385, 105.4650),
(N'Nhổn', N'Đại học Công Nghiệp', 21.0364, 105.7473),
(N'Cầu Diễn', N'Đường 32, Bắc Từ Liêm', 21.0481, 105.7611),
(N'Ngã Tư Sở', N'Tây Sơn, Đống Đa', 21.0051, 105.8193),
(N'Hà Đông', N'Trần Phú, Hà Đông', 20.9761, 105.7865),
(N'Bến xe Yên Nghĩa', N'Quốc lộ 6, Hà Đông', 20.9502, 105.7468),
(N'Bến xe Giáp Bát', N'Giải Phóng, Hoàng Mai', 20.9808, 105.8415);

INSERT INTO Routes (RouteNumber, RouteName, StartPoint, EndPoint, OperatingHours, Frequency, TicketPrice, TotalDistance, EstimatedDuration) VALUES
('107',  N'Kim Mã - Làng Văn Hóa',          N'Bến xe Kim Mã',    N'Làng Văn Hóa',       N'05:00 - 20:30', N'15-20 phút/chuyến', 9000, 45.5, 90),
('32',   N'Nhổn - Giáp Bát',                 N'Nhổn',             N'Bến xe Giáp Bát',    N'05:00 - 22:30', N'10-15 phút/chuyến', 7000, 18.5, 50),
('21A',  N'Bến xe Giáp Bát - Yên Nghĩa',     N'Bến xe Giáp Bát',  N'Bến xe Yên Nghĩa',   N'05:00 - 21:00', N'15 phút/chuyến',    7000, 16.0, 45),
('74',   N'Mỹ Đình - Xuân Khanh',            N'Bến xe Mỹ Đình',   N'Xuân Khanh',         N'05:00 - 20:30', N'20 phút/chuyến',    9000, 40.0, 80);

INSERT INTO Route_Stop (RouteID, StopID, StopOrder, DistanceFromStart) VALUES
(1, 1, 1, 0.0), (1, 2, 2, 3.5), (1, 5, 3, 8.0), (1, 6, 4, 15.2), (1, 7, 5, 35.0), (1, 8, 6, 38.5), (1, 9, 7, 45.5),
(2, 10, 1, 0.0), (2, 11, 2, 3.2), (2, 3, 3, 7.5), (2, 2, 4, 10.1), (2, 1, 5, 12.0), (2, 15, 6, 18.5),
(3, 15, 1, 0.0), (3, 12, 2, 5.0), (3, 13, 3, 10.0), (3, 14, 4, 16.0);

INSERT INTO Buses (LicensePlate, Capacity, BusType, Status) VALUES
('29B-107.01', 60, N'Thường', 'ACTIVE'),
('29B-107.02', 60, N'Thường', 'ACTIVE'),
('29B-032.11', 80, N'Nối toa', 'ACTIVE'),
('29B-032.12', 80, N'Nối toa', 'MAINTENANCE'),
('29B-021.55', 60, N'Thường', 'ACTIVE'),
('29B-074.88', 60, N'Thường', 'ACTIVE'),
('29E-111.22', 30, N'VinBus', 'ACTIVE'),
('29E-333.44', 30, N'VinBus', 'ACTIVE');

INSERT INTO Trips (RouteID, BusID, DriverID, AssistantID, TripDate, StartTime, EndTime, ActualStartTime, ActualEndTime, Direction, Status) VALUES
(1, 1, 4, 9, CAST(GETDATE() AS DATE), '06:00', '07:30', '06:05', '07:35', 1, 'COMPLETED'),
(1, 2, 5, 10, CAST(GETDATE() AS DATE), '08:00', '09:30', '08:02', NULL, 1, 'IN_PROGRESS'),
(1, 1, 4, 9, CAST(GETDATE() AS DATE), '16:00', '17:30', NULL, NULL, 2, 'SCHEDULED'),
(2, 3, 6, 11, CAST(GETDATE() AS DATE), '07:00', '08:00', '07:00', '08:10', 1, 'COMPLETED'),
(2, 5, 7, NULL, CAST(GETDATE() AS DATE), '09:00', '10:00', '09:05', NULL, 2, 'IN_PROGRESS'),
(3, 7, 8, 9, CAST(GETDATE() AS DATE), '10:00', '10:50', NULL, NULL, 1, 'SCHEDULED');

INSERT INTO Attendance (TripID, AccountID, CheckInTime, CheckOutTime, Note) VALUES
(1, 4, DATEADD(minute, -30, GETDATE()), DATEADD(minute, 60, GETDATE()), N'Hoàn thành'),
(1, 9, DATEADD(minute, -30, GETDATE()), DATEADD(minute, 60, GETDATE()), N'Hoàn thành'),
(2, 5, DATEADD(minute, -15, GETDATE()), NULL, N'Đang chạy'),
(4, 6, DATEADD(minute, -20, GETDATE()), DATEADD(minute, 70, GETDATE()), N'Kẹt xe ở Cầu Giấy');

INSERT INTO Tickets (AccountID, TripID, RouteID, TicketCode, Price, SaleChannel, Status, PurchasedAt) VALUES
(12, 1, 1, 'TK-107-AA01', 9000, 'ONLINE', 'COMPLETED',   DATEADD(day, -1, GETDATE())),
(13, 2, 1, 'TK-107-BB02', 9000, 'ON_BUS', 'COMPLETED',   GETDATE()),
(14, 4, 2, 'TK-032-CC03', 7000, 'ONLINE', 'COMPLETED',   DATEADD(day, -2, GETDATE())),
(12, 3, 1, 'TK-107-DD04', 9000, 'ONLINE', 'UNUSED', GETDATE()),
(15, 6, 3, 'TK-021-EE05', 7000, 'ONLINE', 'EXPIRED',DATEADD(hour, -2, GETDATE()));

INSERT INTO MonthlyPassTypes (TypeName, DiscountPercentage, Description) VALUES
(N'Sinh viên (1 Tuyến)', 50.00, N'HSSV đi 1 tuyến cố định'),
(N'Phổ thông (Liên Tuyến)', 0.00, N'Đi tất cả các tuyến');

INSERT INTO MonthlyPasses (AccountID, RouteID, PassTypeID, PassCode, QRCodeToken, StartDate, EndDate, Price, Status, ImageProof, ApprovedBy, ApprovedAt, LastUsedAt) VALUES
(12, 1, 1, 'MP-SV-107-A1', 'QR-LINHKATA-107', '2026-07-01', '2026-07-31', 50000, 'APPROVED', 'uploads/pass-proof/4b090f77-026e-4d2e-9ae5-c4106a7baa18.jpg', 2, DATEADD(day, -5, GETDATE()), GETDATE()),
(13, 2, 1, 'MP-SV-032-A2', 'QR-NAM-032', '2026-07-01', '2026-07-31', 50000, 'APPROVED', 'uploads/pass-proof/076dd183-d4f9-4b70-920b-57ed2df438c6.png', 3, DATEADD(day, -3, GETDATE()), DATEADD(day, -1, GETDATE())),
(15, NULL, 2, 'MP-PT-ALL-B1', 'QR-HUNG-ALL', '2026-07-01', '2026-07-31', 200000, 'PENDING', 'uploads/pass-proof/4b2d21d7-14d1-43df-b0ab-c6858bad1a2d.png', NULL, NULL, NULL);

INSERT INTO Payments (AccountID, TicketID, PassID, Amount, PaymentMethod, TransactionCode, PaymentStatus, PaidAt) VALUES
(12, 1, NULL, 9000, 'VNPAY', 'VNP20260701_01', 'SUCCESS', DATEADD(day, -1, GETDATE())),
(14, 3, NULL, 7000, 'MOMO', 'MM20260630_02', 'SUCCESS', DATEADD(day, -2, GETDATE())),
(15, 5, NULL, 7000, 'VNPAY', 'VNP20260702_03', 'REFUNDED', DATEADD(hour, -1, GETDATE())), 
(12, NULL, 1, 50000, 'QR_BANK', 'MBB20260625_04', 'SUCCESS', DATEADD(day, -5, GETDATE())),
(13, NULL, 2, 50000, 'VNPAY', 'VNP20260627_05', 'SUCCESS', DATEADD(day, -3, GETDATE())),
(15, NULL, 3, 200000, 'CASH', NULL, 'PENDING', NULL);

INSERT INTO Discounts (DiscountCode, DiscountPercent, MinimumAmount, StartDate, EndDate, Description) VALUES
('FPTSTUDENT', 10.00, 50000, '2026-01-01', '2026-12-31', N'Giảm 10% vé tháng cho SV FPT'),
('SUMMER2026', 20.00, 100000, '2026-06-01', '2026-08-31', N'Khuyến mãi mùa hè liên tuyến');

INSERT INTO Favorites (AccountID, RouteID) VALUES (12, 1), (12, 2), (13, 2);

INSERT INTO SearchHistory (AccountID, FromStopID, ToStopID, SearchedAt) VALUES
(12, 2, 8, DATEADD(hour, -2, GETDATE())), 
(14, 1, 15, DATEADD(day, -1, GETDATE())); 

INSERT INTO Notifications (AccountID, TargetRole, NotificationType, Title, Content, IsRead, CreatedAt) VALUES
(NULL, 'ALL', 'SYSTEM_MAINTENANCE', N'Bảo trì app', N'Hệ thống bảo trì lúc 00:00 - 02:00 ngày 05/07.', 0, GETDATE()),
(NULL, 'CUSTOMER', 'ROUTE_CHANGE', N'Phân luồng tuyến 107', N'Do sửa đường ĐL Thăng Long, 107 tạm đi ngõ tránh.', 0, GETDATE()),
(12, 'CUSTOMER', 'PASS_APPROVED', N'Vé tháng đã duyệt', N'Thẻ SV của bạn đã duyệt thành công. Bắt đầu QR.', 0, GETDATE());

INSERT INTO NotificationReads (NotificationID, AccountID, ReadAt) VALUES
(1, 12, GETDATE()), (1, 13, GETDATE()), (2, 12, GETDATE()), (3, 12, GETDATE());

INSERT INTO BusLocationHistory (BusID, TripID, Latitude, Longitude, RecordedAt) VALUES
(2, 2, 21.0311, 105.8245, DATEADD(minute, -20, GETDATE())), 
(2, 2, 21.0298, 105.8150, DATEADD(minute, -15, GETDATE())), 
(2, 2, 21.0285, 105.8041, DATEADD(minute, -5, GETDATE()));  

INSERT INTO TripProgress (TripID, CurrentStopID, NextStopID, DistanceRemaining, EstimatedArrival) VALUES
(2, 2, 5, 4.5, DATEADD(minute, 12, GETDATE()));
GO
