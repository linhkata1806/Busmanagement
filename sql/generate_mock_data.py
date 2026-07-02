import json
import re
import random
from datetime import datetime

def clean_text(text):
    if not text:
        return ""
    # Remove excessive whitespaces
    return re.sub(r'\s+', ' ', text).strip()

def parse_bus_data():
    json_path = r"d:\Java_BusManagement\BusManagement\docs\raw-data\hanoi_bus_routes.json"
    
    with open(json_path, 'r', encoding='utf-8') as f:
        routes_data = json.load(f)
        
    unique_stops = {} # stop_name -> stop_id
    stop_counter = 1
    
    parsed_routes = []
    parsed_route_stops = []
    
    route_counter = 1
    
    for entry in routes_data:
        route_number = clean_text(entry.get("routeId", ""))
        route_name = clean_text(entry.get("routeName", ""))
        
        # Skip if basic info is missing
        if not route_number or not route_name:
            continue
            
        # Parse Price
        price_str = entry.get("ticketPrice", "7000")
        price_match = re.search(r'\d+', price_str)
        ticket_price = int(price_match.group(0)) if price_match else 7000
        
        # Split Start/End Points
        parts = route_name.split(' - ')
        start_point = clean_text(parts[0]) if len(parts) > 0 else "Hà Nội"
        end_point = clean_text(parts[-1]) if len(parts) > 1 else "Hà Nội"
        
        # Extract metadata from description
        full_text = entry.get("forwardRoute", "") + " " + entry.get("returnRoute", "")
        
        # Parse Distance
        distance_match = re.search(r'Cự ly:\s*([\d\.]+)\s*km', full_text, re.IGNORECASE)
        distance = float(distance_match.group(1)) if distance_match else 15.0
        
        # Parse Operating Hours
        hours_match = re.search(r'Thời gian hoạt động:\s*([^\n\r]+?)(?=Thời gian|Giá vé|Số chuyến|Giãn cách|$)', full_text, re.IGNORECASE)
        operating_hours = clean_text(hours_match.group(1))[:50] if hours_match else "05:00 - 22:00"
        if not operating_hours or len(operating_hours) < 5:
            operating_hours = "05:00 - 22:00"
            
        # Parse Frequency
        freq_match = re.search(r'Giãn cách chuyến:\s*([^\n\r]+?)(?=phút|Lộ trình|$)', full_text, re.IGNORECASE)
        frequency = clean_text(freq_match.group(1))[:50] if freq_match else "10-15 phút/chuyến"
        if not frequency:
            frequency = "10-15 phút/chuyến"
            
        parsed_routes.append({
            "id": route_counter,
            "number": route_number,
            "name": route_name,
            "start": start_point,
            "end": end_point,
            "hours": operating_hours,
            "freq": frequency,
            "price": ticket_price,
            "dist": distance
        })
        
        # Parse Stops
        # Look for "Chiều đi" section stops list
        # Match pattern like "1 StopName 2 StopName ... B (B)"
        stops_section_match = re.search(r'Chiều đi tuyến\s+' + re.escape(route_number) + r'.*?(?=\(B\)|Chiều về tuyến|$)', full_text, re.IGNORECASE)
        stops_text = stops_section_match.group(0) if stops_section_match else full_text
        
        # Phân tích cú pháp trạm dừng tuần tự để tránh chia nhỏ trạm dừng khi tên trạm chứa số
        stop_matches = []
        current_num = 1
        pos = 0
        while True:
            pattern = r'\b' + str(current_num) + r'\s+'
            match = re.search(pattern, stops_text[pos:])
            if not match:
                break
            
            stop_start = pos + match.end()
            next_pattern = r'\b' + str(current_num + 1) + r'\s+'
            next_match = re.search(next_pattern, stops_text[stop_start:])
            
            if next_match:
                stop_end = stop_start + next_match.start()
                stop_name = stops_text[stop_start:stop_end]
                pos = stop_start + next_match.start()
            else:
                end_marker = re.search(r'\b[A-Za-z]\s+\([A-Za-z]\)', stops_text[stop_start:])
                if end_marker:
                    stop_end = stop_start + end_marker.start()
                else:
                    stop_end = len(stops_text)
                stop_name = stops_text[stop_start:stop_end]
                stop_matches.append((current_num, stop_name))
                break
            
            stop_matches.append((current_num, stop_name))
            current_num += 1
            
        order = 1
        for stop_num, raw_stop_name in stop_matches:
            stop_name = clean_text(raw_stop_name)
            
            # Basic validation of stop name
            if len(stop_name) < 3 or any(kw in stop_name.lower() for kw in ["chiều đi", "chiều về", "lộ trình", "giá vé", "đơn vị"]):
                continue
                
            # Deduplicate stops
            if stop_name not in unique_stops:
                unique_stops[stop_name] = {
                    "id": stop_counter,
                    "name": stop_name,
                    "address": stop_name + ", Hà Nội",
                    # Randomize lat/lng near Hanoi (lat ~ 21.0, lng ~ 105.8)
                    "lat": 21.0 + random.uniform(-0.05, 0.05),
                    "lng": 105.8 + random.uniform(-0.05, 0.05)
                }
                stop_counter += 1
                
            parsed_route_stops.append({
                "route_id": route_counter,
                "stop_id": unique_stops[stop_name]["id"],
                "order": order
            })
            order += 1
            
        route_counter += 1
        
    return parsed_routes, list(unique_stops.values()), parsed_route_stops

def generate_sql():
    routes, stops, route_stops = parse_bus_data()
    
    sql_lines = []
    sql_lines.append("-- ========================================================")
    sql_lines.append("-- MOCK DATA TỰ ĐỘNG SINH TỪ DỮ LIỆU XE BUÝT HÀ NỘI THỰC TẾ")
    sql_lines.append("-- ========================================================\n")
    
    sql_lines.append("USE HanoiBusDB;")
    sql_lines.append("GO\n")
    
    sql_lines.append("-- XÓA DỮ LIỆU CŨ TRƯỚC KHI CHÈN")
    sql_lines.append("DELETE FROM BusLocations;")
    sql_lines.append("DELETE FROM Notifications;")
    sql_lines.append("DELETE FROM SearchHistory;")
    sql_lines.append("DELETE FROM Favorites;")
    sql_lines.append("DELETE FROM MonthlyPasses;")
    sql_lines.append("DELETE FROM Tickets;")
    sql_lines.append("DELETE FROM Attendance;")
    sql_lines.append("DELETE FROM Trips;")
    sql_lines.append("DELETE FROM Route_Stop;")
    sql_lines.append("DELETE FROM Buses;")
    sql_lines.append("DELETE FROM Routes;")
    sql_lines.append("DELETE FROM Stops;")
    sql_lines.append("DELETE FROM Accounts;")
    sql_lines.append("DELETE FROM Roles;")
    sql_lines.append("GO\n")
    
    # 1. ROLES
    sql_lines.append("-- 1. CHÈN BẢNG ROLES")
    sql_lines.append("SET IDENTITY_INSERT Roles ON;")
    sql_lines.append("INSERT INTO Roles (RoleID, RoleName) VALUES ")
    sql_lines.append("(1, 'ADMIN'), (2, 'STAFF'), (3, 'DRIVER'), (4, 'ASSISTANT'), (5, 'CUSTOMER');")
    sql_lines.append("SET IDENTITY_INSERT Roles OFF;")
    sql_lines.append("GO\n")
    
    # 2. ACCOUNTS
    sql_lines.append("-- 2. CHÈN BẢNG ACCOUNTS (Mật khẩu mặc định: '123456' đã bcrypt)")
    sql_lines.append("SET IDENTITY_INSERT Accounts ON;")
    sql_lines.append("INSERT INTO Accounts (AccountID, Username, Password, FullName, Email, Phone, RoleID, IsActive) VALUES ")
    sql_lines.append("(1, 'admin', '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'Lê Quản Trị', 'admin@bus.vn', '0901234561', 1, 1),")
    sql_lines.append("(2, 'staff01', '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'Nguyễn Văn Trạm', 'staff01@bus.vn', '0901234562', 2, 1),")
    sql_lines.append("(3, 'staff02', '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'Trần Thị Quầy', 'staff02@bus.vn', '0901234563', 2, 1),")
    sql_lines.append("(4, 'driver01', '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'Bác Tài Số Một', 'driver01@bus.vn', '0901234564', 3, 1),")
    sql_lines.append("(5, 'driver02', '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'Bác Tài Số Hai', 'driver02@bus.vn', '0901234565', 3, 1),")
    sql_lines.append("(6, 'driver03', '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'Bác Tài Số Ba', 'driver03@bus.vn', '0901234566', 3, 1),")
    sql_lines.append("(7, 'assistant01', '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'Hoàng Soát Vé', 'assist01@bus.vn', '0901234567', 4, 1),")
    sql_lines.append("(8, 'assistant02', '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'Đinh Lơ Xe', 'assist02@bus.vn', '0901234568', 4, 1),")
    sql_lines.append("(9, 'customer1', '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'Nguyễn Nhật Linh', 'linh@bus.vn', '0911111111', 5, 1),")
    sql_lines.append("(10, 'customer2', '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'Trần Sinh Viên', 'sv@bus.vn', '0922222222', 5, 1),")
    sql_lines.append("(11, 'customer3', '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'Phan Khách Hàng', 'khach@bus.vn', '0933333333', 5, 1);")
    sql_lines.append("SET IDENTITY_INSERT Accounts OFF;")
    sql_lines.append("GO\n")
    
    # 3. STOPS
    sql_lines.append(f"-- 3. CHÈN BẢNG STOPS ({len(stops)} Trạm Dừng)")
    sql_lines.append("SET IDENTITY_INSERT Stops ON;")
    # Bulk insert in chunks of 500
    for i in range(0, len(stops), 500):
        chunk = stops[i:i+500]
        sql_lines.append("INSERT INTO Stops (StopID, StopName, Address, Latitude, Longitude) VALUES ")
        values = []
        for stop in chunk:
            name = stop['name'].replace("'", "''")
            addr = stop['address'].replace("'", "''")
            values.append(f"({stop['id']}, N'{name}', N'{addr}', {stop['lat']:.7f}, {stop['lng']:.7f})")
        sql_lines.append(",\n".join(values) + ";")
    sql_lines.append("SET IDENTITY_INSERT Stops OFF;")
    sql_lines.append("GO\n")
    
    # 4. ROUTES
    sql_lines.append(f"-- 4. CHÈN BẢNG ROUTES ({len(routes)} Tuyến Xe)")
    sql_lines.append("SET IDENTITY_INSERT Routes ON;")
    for i in range(0, len(routes), 500):
        chunk = routes[i:i+500]
        sql_lines.append("INSERT INTO Routes (RouteID, RouteNumber, RouteName, StartPoint, EndPoint, OperatingHours, Frequency, TicketPrice, TotalDistance) VALUES ")
        values = []
        for r in chunk:
            name = r['name'].replace("'", "''")
            start = r['start'].replace("'", "''")
            end = r['end'].replace("'", "''")
            hours = r['hours'].replace("'", "''")
            freq = r['freq'].replace("'", "''")
            values.append(f"({r['id']}, '{r['number']}', N'{name}', N'{start}', N'{end}', '{hours}', N'{freq}', {r['price']}, {r['dist']})")
        sql_lines.append(",\n".join(values) + ";")
    sql_lines.append("SET IDENTITY_INSERT Routes OFF;")
    sql_lines.append("GO\n")
    
    # 5. ROUTE_STOP
    sql_lines.append(f"-- 5. CHÈN BẢNG ROUTE_STOP ({len(route_stops)} Bản Ghi Mapping)")
    seen_mappings = set()
    seen_orders = set()
    deduped_route_stops = []
    
    for rs in route_stops:
        map_key = (rs['route_id'], rs['stop_id'])
        order_key = (rs['route_id'], rs['order'])
        if map_key not in seen_mappings and order_key not in seen_orders:
            seen_mappings.add(map_key)
            seen_orders.add(order_key)
            deduped_route_stops.append(rs)
            
    for i in range(0, len(deduped_route_stops), 500):
        chunk = deduped_route_stops[i:i+500]
        sql_lines.append("INSERT INTO Route_Stop (RouteID, StopID, StopOrder) VALUES ")
        values = []
        for rs in chunk:
            values.append(f"({rs['route_id']}, {rs['stop_id']}, {rs['order']})")
        sql_lines.append(",\n".join(values) + ";")
    sql_lines.append("GO\n")
    
    # 6. BUSES
    sql_lines.append("-- 6. CHÈN BẢNG BUSES (Xe Buýt)")
    sql_lines.append("INSERT INTO Buses (LicensePlate, Capacity, BusType, Status) VALUES ")
    bus_plates = [f"29B-{random.randint(100, 999)}.{random.randint(10, 99)}" for _ in range(30)]
    bus_values = []
    for plate in bus_plates:
        cap = random.choice([30, 60, 80])
        btype = random.choice([u'Thường', u'Xe buýt điện VinBus', u'Xe buýt nối toa'])
        status = random.choice(['ACTIVE', 'ACTIVE', 'ACTIVE', 'MAINTENANCE'])
        bus_values.append(f"('{plate}', {cap}, N'{btype}', '{status}')")
    sql_lines.append(",\n".join(bus_values) + ";")
    sql_lines.append("GO\n")
    
    # 7. TRIPS
    sql_lines.append("-- 7. CHÈN BẢNG TRIPS (Chuyến Đi)")
    sql_lines.append("INSERT INTO Trips (RouteID, BusID, DriverID, AssistantID, TripDate, StartTime, EndTime, Direction, Status) VALUES ")
    trip_values = []
    today = datetime.now().strftime('%Y-%m-%d')
    for route_id in range(1, min(11, len(routes) + 1)):
        for hour in [6, 8, 10, 14, 16, 18]:
            bus_id = random.randint(1, 20)
            driver_id = random.choice([4, 5, 6])
            assistant_id = random.choice([7, 8, None])
            start_time = f"{hour:02d}:00"
            end_time = f"{hour+1:02d}:30"
            direction = random.choice([1, 2])
            status = 'SCHEDULED'
            
            assistant_str = str(assistant_id) if assistant_id else "NULL"
            trip_values.append(f"({route_id}, {bus_id}, {driver_id}, {assistant_str}, '{today}', '{start_time}', '{end_time}', {direction}, '{status}')")
    sql_lines.append(",\n".join(trip_values) + ";")
    sql_lines.append("GO\n")
    
    # 8. TICKETS
    sql_lines.append("-- 8. CHÈN BẢNG TICKETS (Vé Lượt)")
    sql_lines.append("INSERT INTO Tickets (AccountID, TripID, RouteID, TicketCode, Price, SaleChannel, Status, PurchasedAt) VALUES ")
    ticket_values = []
    for i in range(1, 15):
        acc = random.choice([9, 10, 11, None])
        trip = random.randint(1, 10)
        route = random.randint(1, 5)
        code = f"TK-{route:02d}-MOCK{i:03d}"
        price = 7000
        chan = random.choice(['ONLINE', 'COUNTER', 'ON_BUS'])
        stat = random.choice(['UNUSED', 'USED'])
        acc_str = str(acc) if acc else "NULL"
        ticket_values.append(f"({acc_str}, {trip}, {route}, '{code}', {price}, '{chan}', '{stat}', GETDATE())")
    sql_lines.append(",\n".join(ticket_values) + ";")
    sql_lines.append("GO\n")
    
    # 9. MONTHLY PASS TYPES
    sql_lines.append("-- 9. CHÈN BẢNG MONTHLY PASS TYPES")
    sql_lines.append("SET IDENTITY_INSERT MonthlyPassTypes ON;")
    sql_lines.append("INSERT INTO MonthlyPassTypes (PassTypeID, TypeName, DiscountPercentage, Description) VALUES ")
    sql_lines.append("(1, N'Học sinh/Sinh viên (1 Tuyến)', 50.00, N'Dành cho HSSV, chỉ đi 1 tuyến cố định'),")
    sql_lines.append("(2, N'Học sinh/Sinh viên (Liên Tuyến)', 50.00, N'Dành cho HSSV, đi tất cả các tuyến'),")
    sql_lines.append("(3, N'Người cao tuổi', 100.00, N'Miễn phí toàn bộ mạng lưới buýt Hà Nội'),")
    sql_lines.append("(4, N'Phổ thông (Liên Tuyến)', 0.00, N'Vé tháng bình thường đi tất cả các tuyến');")
    sql_lines.append("SET IDENTITY_INSERT MonthlyPassTypes OFF;")
    sql_lines.append("GO\n")
    
    # 10. MONTHLY PASSES
    sql_lines.append("-- 10. CHÈN BẢNG MONTHLY PASSES (Vé Tháng)")
    sql_lines.append("INSERT INTO MonthlyPasses (AccountID, RouteID, PassTypeID, PassCode, StartDate, EndDate, Price, Status, ApprovedBy, ApprovedAt) VALUES ")
    pass_values = []
    pass_values.append("(10, 1, 1, 'MP-SV-001', '2026-06-01', '2026-06-30', 50000, 'APPROVED', 2, GETDATE()),")
    pass_values.append("(10, 2, 1, 'MP-SV-002', '2026-07-01', '2026-07-31', 50000, 'APPROVED', 2, GETDATE()),")
    pass_values.append("(9, NULL, 4, 'MP-PT-001', '2026-06-01', '2026-06-30', 200000, 'PENDING', NULL, NULL),")
    pass_values.append("(11, NULL, 3, 'MP-CT-001', '2026-01-01', '2026-12-31', 0, 'APPROVED', 1, GETDATE())")
    sql_lines.append("\n".join(pass_values) + ";")
    sql_lines.append("GO\n")
    
    # 11. FAVORITES
    sql_lines.append("-- 11. CHÈN BẢNG FAVORITES (Tuyến Xe Yêu Thích)")
    sql_lines.append("INSERT INTO Favorites (AccountID, RouteID) VALUES ")
    sql_lines.append("(9, 1), (9, 3), (10, 2), (10, 5), (11, 4);")
    sql_lines.append("GO\n")
    
    # 12. SEARCH HISTORY
    sql_lines.append("-- 12. CHÈN BẢNG SEARCH HISTORY (Lịch Sử Tìm Kiếm)")
    sql_lines.append("INSERT INTO SearchHistory (AccountID, FromStopID, ToStopID) VALUES ")
    sql_lines.append("(9, 1, 10), (9, 5, 20), (10, 3, 15);")
    sql_lines.append("GO\n")
    
    # 13. NOTIFICATIONS
    sql_lines.append("-- 13. CHÈN BẢNG NOTIFICATIONS")
    sql_lines.append("INSERT INTO Notifications (AccountID, NotificationType, Title, Content, IsRead) VALUES ")
    sql_lines.append("(10, 'PASS_APPROVED', N'Vé tháng đã được phê duyệt', N'Yêu cầu gia hạn vé tháng MP-SV-002 của bạn đã được duyệt thành công.', 0),")
    sql_lines.append("(9, 'SYSTEM_ALERT', N'Thay đổi lộ trình tuyến 01', N'Tuyến số 01 thay đổi tạm thời do sửa chữa đường tại phố Tây Sơn.', 0);")
    sql_lines.append("GO\n")
    
    # 14. BUS LOCATIONS
    sql_lines.append("-- 14. CHÈN BẢNG BUS LOCATIONS (Vị Trí GPS Xe Buýt)")
    sql_lines.append("INSERT INTO BusLocations (BusID, Latitude, Longitude, UpdatedAt) VALUES ")
    loc_values = []
    for bus_id in range(1, 16):
        lat = 21.028 + random.uniform(-0.05, 0.05)
        lng = 105.804 + random.uniform(-0.05, 0.05)
        loc_values.append(f"({bus_id}, {lat:.7f}, {lng:.7f}, GETDATE())")
    sql_lines.append(",\n".join(loc_values) + ";")
    sql_lines.append("GO\n")
    
    output_paths = [
        r"d:\Java_BusManagement\BusManagement\sql\InsertMockData.sql",
        r"d:\Java_BusManagement\BusManagement\busmanagement\sql\InsertMockData.sql"
    ]
    for path in output_paths:
        with open(path, 'w', encoding='utf-8') as f:
            f.write("\n".join(sql_lines))
        print(f"Thành công! Đã ghi file mock data SQL vào {path}")

if __name__ == '__main__':
    generate_sql()
