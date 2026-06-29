<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.regex.*" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="com.google.gson.reflect.TypeToken" %>
<%@ page import="java.lang.reflect.Type" %>

<%!
    // Nested helper classes for structured data mapping
    static class StopMatch {
        int num;
        String name;
        StopMatch(int num, String name) {
            this.num = num;
            this.name = name;
        }
    }
    
    static class RouteData {
        int id;
        String number;
        String name;
        String start;
        String end;
        String hours;
        String freq;
        int price;
        double dist;
    }

    static class StopData {
        int id;
        String name;
        String address;
        double lat;
        double lng;
    }

    static class RouteStopData {
        int routeId;
        int stopId;
        int order;
    }

    public static String cleanText(String text) {
        if (text == null) return "";
        return text.replaceAll("\\s+", " ").trim();
    }

    public static String formatOperatingHours(String raw) {
        if (raw == null || raw.trim().isEmpty()) {
            return "05:00 - 22:00";
        }
        
        // Sửa lỗi chính tả/mã hóa thô trước khi quét số
        String prepared = raw.replace("Nu?c Ng?m", "Nước Ngầm")
                             .replace("Phú Di?n", "Phú Diễn")
                             .replace("Yên Nghi", "Yên Nghĩa")
                             .replace("Giáp B", "Giáp Bát")
                             .replace("Phúc L?", "Phúc Lợi");

        // Tìm tất cả các mốc giờ dạng HhMM hoặc H:MM
        Pattern timePat = Pattern.compile("(\\d{1,2})[h:](\\d{2})");
        Matcher m = timePat.matcher(prepared);
        
        int minMin = 24 * 60; // Bắt đầu từ số phút lớn nhất trong ngày
        int maxMin = 0;       // Bắt đầu từ 0
        boolean found = false;
        
        while (m.find()) {
            int hour = Integer.parseInt(m.group(1));
            int min = Integer.parseInt(m.group(2));
            int totalMin = hour * 60 + min;
            
            if (totalMin < minMin) minMin = totalMin;
            if (totalMin > maxMin) maxMin = totalMin;
            found = true;
        }
        
        if (!found) {
            return "05:00 - 22:00";
        }
        
        // Định dạng lại thành HhMM - HhMM gọn gàng
        int startHour = minMin / 60;
        int startMin = minMin % 60;
        int endHour = maxMin / 60;
        int endMin = maxMin % 60;
        
        return String.format("%dh%02d - %dh%02d", startHour, startMin, endHour, endMin);
    }
    
    public static String formatFrequency(String raw) {
        if (raw == null || raw.trim().isEmpty()) {
            return "10 - 15 phút/chuyến";
        }
        
        // Tách lấy phần giãn cách ngày thường (trước dấu /, ;, hoặc ghi chú Chủ nhật)
        String firstPart = raw.split("(?i)[/;|]|Chủ nhật|CN")[0].trim();
        
        String cleaned = firstPart.replaceAll("\\s+", " ")
                                  .replace("Giãn cách chuyến:", "")
                                  .replace("Giãn cách chuyến:", "")
                                  .replace("Ngày thường:", "")
                                  .replace("Ngày thường", "")
                                  .replace("phút", "phút")
                                  .trim();
        
        // Chuẩn hóa đuôi phút/chuyến
        if (!cleaned.contains("phút/chuyến") && !cleaned.contains("phút/lượt")) {
            Pattern numPat = Pattern.compile("\\d+");
            Matcher m = numPat.matcher(cleaned);
            List<String> nums = new ArrayList<>();
            while (m.find()) {
                nums.add(m.group());
            }
            if (!nums.isEmpty()) {
                cleaned = String.join(" - ", nums) + " phút/chuyến";
            } else {
                cleaned = cleaned + " phút/chuyến";
            }
        }
        
        if (cleaned.endsWith(".")) {
            cleaned = cleaned.substring(0, cleaned.length() - 1);
        }
        
        cleaned = cleaned.replaceAll("\\s*-\\s*", " - ");
        
        return cleaned;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tái tạo Dữ liệu SQL</title>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; padding: 40px; line-height: 1.6; max-width: 800px; margin: 0 auto; color: #333; }
        .card { background: white; padding: 30px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); border: 1px solid #eaeaea; }
        h2 { color: #2d3748; margin-top: 0; }
        pre { background: #1a202c; color: #a0aec0; padding: 20px; border-radius: 8px; overflow-x: auto; font-family: "Courier New", Courier, monospace; font-size: 0.9em; max-height: 300px; }
        .success { color: #38a169; font-weight: bold; background: #f0fff4; border: 1px solid #c6f6d5; padding: 12px; border-radius: 6px; margin-bottom: 20px; }
        .error { color: #e53e3e; font-weight: bold; background: #fff5f5; border: 1px solid #fed7d7; padding: 12px; border-radius: 6px; margin-bottom: 20px; }
        ol { padding-left: 20px; }
        li { margin-bottom: 8px; }
        code { background: #edf2f7; padding: 2px 6px; border-radius: 4px; font-family: monospace; font-size: 0.9em; }
    </style>
</head>
<body style="background: #f7fafc;">
    <div class="card">
        <h2>🛠️ Công cụ tái tạo dữ liệu Xe Buýt Hà Nội (Java Native Engine)</h2>
        <p>Hệ thống đang tiến hành phân tích tệp JSON gốc bằng Java và sinh trực tiếp file SQL nạp dữ liệu sạch.</p>
        
        <%
            StringBuilder log = new StringBuilder();
            try {
                String jsonPath = "d:\\Java_BusManagement\\BusManagement\\docs\\raw-data\\hanoi_bus_routes.json";
                log.append("Đang đọc file JSON tại: ").append(jsonPath).append("\n");
                
                Gson gson = new Gson();
                Type listType = new TypeToken<List<Map<String, Object>>>(){}.getType();
                List<Map<String, Object>> routesData;
                
                try (Reader r = new InputStreamReader(new FileInputStream(jsonPath), "UTF-8")) {
                    routesData = gson.fromJson(r, listType);
                }
                
                log.append("Đã đọc thành công ").append(routesData.size()).append(" tuyến xe từ JSON.\n");
                
                Map<String, StopData> uniqueStops = new LinkedHashMap<>();
                List<RouteData> parsedRoutes = new ArrayList<>();
                List<RouteStopData> parsedRouteStops = new ArrayList<>();
                
                int stopCounter = 1;
                int routeCounter = 1;
                Random rand = new Random();
                
                for (Map<String, Object> entry : routesData) {
                    String routeNumber = cleanText((String) entry.get("routeId"));
                    String routeName = cleanText((String) entry.get("routeName"));
                    
                    if (routeNumber.isEmpty() || routeName.isEmpty()) {
                        continue;
                    }
                    
                    // Parse ticket price
                    String priceStr = (String) entry.get("ticketPrice");
                    if (priceStr == null) priceStr = "7000";
                    Pattern numPattern = Pattern.compile("\\d+");
                    Matcher numMatcher = numPattern.matcher(priceStr);
                    int ticketPrice = numMatcher.find() ? Integer.parseInt(numMatcher.group()) : 7000;
                    
                    // Split start/end point
                    String[] parts = routeName.split(" - ");
                    String startPoint = parts.length > 0 ? cleanText(parts[0]) : "Hà Nội";
                    String endPoint = parts.length > 1 ? cleanText(parts[parts.length - 1]) : "Hà Nội";
                    
                    // Extract operational details
                    String forwardRoute = (String) entry.get("forwardRoute");
                    String returnRoute = (String) entry.get("returnRoute");
                    String fullText = (forwardRoute != null ? forwardRoute : "") + " " + (returnRoute != null ? returnRoute : "");
                    
                    // Distance
                    Pattern distPat = Pattern.compile("Cự ly:\\s*([\\d\\.]+)\\s*km", Pattern.CASE_INSENSITIVE);
                    Matcher distMat = distPat.matcher(fullText);
                    double distance = distMat.find() ? Double.parseDouble(distMat.group(1)) : 15.0;
                    
                    // Hours
                    Pattern hoursPat = Pattern.compile("Thời gian hoạt động:\\s*([^\\n\\r]+?)(?=Thời gian|Giá vé|Số chuyến|Giãn cách|$)", Pattern.CASE_INSENSITIVE);
                    Matcher hoursMat = hoursPat.matcher(fullText);
                    String rawHours = hoursMat.find() ? cleanText(hoursMat.group(1)) : "05:00 - 22:00";
                    String operatingHours = formatOperatingHours(rawHours);
                    if (operatingHours.length() > 150) operatingHours = operatingHours.substring(0, 150);
                    if (operatingHours.length() < 5) operatingHours = "05:00 - 22:00";
                    
                    // Frequency
                    Pattern freqPat = Pattern.compile("Giãn cách chuyến:\\s*([^\\n\\r]+?)(?=phút|Lộ trình|$)", Pattern.CASE_INSENSITIVE);
                    Matcher freqMat = freqPat.matcher(fullText);
                    String rawFreq = freqMat.find() ? cleanText(freqMat.group(1)) : "10-15 phút/chuyến";
                    String frequency = formatFrequency(rawFreq);
                    if (frequency.length() > 150) frequency = frequency.substring(0, 150);
                    
                    RouteData rd = new RouteData();
                    rd.id = routeCounter;
                    rd.number = routeNumber;
                    rd.name = routeName;
                    rd.start = startPoint;
                    rd.end = endPoint;
                    rd.hours = operatingHours;
                    rd.freq = frequency;
                    rd.price = ticketPrice;
                    rd.dist = distance;
                    parsedRoutes.add(rd);
                    
                    // Parse stops in "Chiều đi" list using sequential number boundary matching
                    String routeNumberEscaped = Pattern.quote(routeNumber);
                    Pattern sectionPattern = Pattern.compile("Chiều đi tuyến\\s+" + routeNumberEscaped + ".*?(?=\\(B\\)|Chiều về tuyến|$)", Pattern.CASE_INSENSITIVE);
                    Matcher sectionMatcher = sectionPattern.matcher(fullText);
                    String stopsText = sectionMatcher.find() ? sectionMatcher.group() : fullText;
                    
                    List<StopMatch> stopMatches = new ArrayList<>();
                    int currentNum = 1;
                    int pos = 0;
                    while (true) {
                        Pattern startPat = Pattern.compile("\\b" + currentNum + "\\s+");
                        Matcher startMat = startPat.matcher(stopsText.substring(pos));
                        if (!startMat.find()) {
                            break;
                        }
                        
                        int stopStart = pos + startMat.end();
                        Pattern nextPat = Pattern.compile("\\b" + (currentNum + 1) + "\\s+");
                        Matcher nextMat = nextPat.matcher(stopsText.substring(stopStart));
                        
                        int stopEnd;
                        if (nextMat.find()) {
                            stopEnd = stopStart + nextMat.start();
                            String stopName = stopsText.substring(stopStart, stopEnd);
                            stopMatches.add(new StopMatch(currentNum, stopName));
                            pos = stopEnd;
                        } else {
                            Pattern endPat = Pattern.compile("\\b[A-Za-z]\\s+\\([A-Za-z]\\)");
                            Matcher endMat = endPat.matcher(stopsText.substring(stopStart));
                            if (endMat.find()) {
                                stopEnd = stopStart + endMat.start();
                            } else {
                                stopEnd = stopsText.length();
                            }
                            String stopName = stopsText.substring(stopStart, stopEnd);
                            stopMatches.add(new StopMatch(currentNum, stopName));
                            break;
                        }
                        currentNum++;
                    }
                    
                    int order = 1;
                    for (StopMatch sm : stopMatches) {
                        String stopName = cleanText(sm.name);
                        
                        if (stopName.length() < 3) continue;
                        String stopNameLower = stopName.toLowerCase();
                        if (stopNameLower.contains("chiều đi") || stopNameLower.contains("chiều về") ||
                            stopNameLower.contains("lộ trình") || stopNameLower.contains("giá vé") || stopNameLower.contains("đơn vị")) {
                            continue;
                        }
                        
                        if (!uniqueStops.containsKey(stopName)) {
                            StopData sd = new StopData();
                            sd.id = stopCounter++;
                            sd.name = stopName;
                            sd.address = stopName + ", Hà Nội";
                            sd.lat = 21.0 + (rand.nextDouble() - 0.5) * 0.1;
                            sd.lng = 105.8 + (rand.nextDouble() - 0.5) * 0.1;
                            uniqueStops.put(stopName, sd);
                        }
                        
                        RouteStopData rsd = new RouteStopData();
                        rsd.routeId = routeCounter;
                        rsd.stopId = uniqueStops.get(stopName).id;
                        rsd.order = order++;
                        parsedRouteStops.add(rsd);
                    }
                    routeCounter++;
                }
                
                log.append("Tái cấu trúc thành công: ").append(uniqueStops.size()).append(" điểm dừng duy nhất.\n");
                log.append("Tái cấu trúc thành công: ").append(parsedRouteStops.size()).append(" mối liên kết Route_Stop.\n");
                
                // Build SQL Content
                List<String> sqlLines = new ArrayList<>();
                sqlLines.add("-- ========================================================");
                sqlLines.add("-- MOCK DATA TỰ ĐỘNG SINH TỪ DỮ LIỆU XE BUÝT HÀ NỘI THỰC TẾ (JAVA ENGINE)");
                sqlLines.add("-- ========================================================\n");
                sqlLines.add("USE HanoiBusDB;");
                sqlLines.add("GO\n");
                sqlLines.add("-- NÂNG CẤP CẤU TRÚC CỘT HỖ TRỢ TIẾNG VIỆT VÀ ĐỘ DÀI MÔ TẢ");
                sqlLines.add("ALTER TABLE Routes ALTER COLUMN OperatingHours NVARCHAR(150) NOT NULL;");
                sqlLines.add("ALTER TABLE Routes ALTER COLUMN Frequency NVARCHAR(150);");
                sqlLines.add("IF EXISTS (SELECT * FROM sys.check_constraints WHERE name = 'CHK_Tickets_Status')");
                sqlLines.add("    ALTER TABLE Tickets DROP CONSTRAINT CHK_Tickets_Status;");
                sqlLines.add("ALTER TABLE Tickets ADD CONSTRAINT CHK_Tickets_Status CHECK (Status IN ('PENDING', 'UNUSED', 'USED', 'EXPIRED'));");
                sqlLines.add("ALTER TABLE Tickets ADD CONSTRAINT DF_Tickets_Status DEFAULT 'PENDING' FOR Status;");
                sqlLines.add("GO\n");
                sqlLines.add("-- XÓA DỮ LIỆU CŨ TRƯỚC KHI CHÈN");
                sqlLines.add("DELETE FROM BusLocations;");
                sqlLines.add("DELETE FROM Notifications;");
                sqlLines.add("DELETE FROM SearchHistory;");
                sqlLines.add("DELETE FROM Favorites;");
                sqlLines.add("DELETE FROM MonthlyPasses;");
                sqlLines.add("DELETE FROM MonthlyPassTypes;");
                sqlLines.add("DELETE FROM Tickets;");
                sqlLines.add("DELETE FROM Attendance;");
                sqlLines.add("DELETE FROM Trips;");
                sqlLines.add("DELETE FROM Route_Stop;");
                sqlLines.add("DELETE FROM Buses;");
                sqlLines.add("DELETE FROM Routes;");
                sqlLines.add("DELETE FROM Stops;");
                sqlLines.add("DELETE FROM Accounts;");
                sqlLines.add("DELETE FROM Roles;");
                sqlLines.add("GO\n");
                
                // 1. Roles
                sqlLines.add("-- 1. CHÈN BẢNG ROLES");
                sqlLines.add("SET IDENTITY_INSERT Roles ON;");
                sqlLines.add("INSERT INTO Roles (RoleID, RoleName) VALUES (1, 'ADMIN'), (2, 'STAFF'), (3, 'DRIVER'), (4, 'ASSISTANT'), (5, 'CUSTOMER');");
                sqlLines.add("SET IDENTITY_INSERT Roles OFF;");
                sqlLines.add("GO\n");
                
                // 2. Accounts
                sqlLines.add("-- 2. CHÈN BẢNG ACCOUNTS");
                sqlLines.add("SET IDENTITY_INSERT Accounts ON;");
                sqlLines.add("INSERT INTO Accounts (AccountID, Username, Password, FullName, Email, Phone, RoleID, IsActive) VALUES ");
                sqlLines.add("(1, 'admin', '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'Lê Quản Trị', 'admin@bus.vn', '0901234561', 1, 1),");
                sqlLines.add("(2, 'staff01', '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'Nguyễn Văn Trạm', 'staff01@bus.vn', '0901234562', 2, 1),");
                sqlLines.add("(3, 'staff02', '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'Trần Thị Quầy', 'staff02@bus.vn', '0901234563', 2, 1),");
                sqlLines.add("(4, 'driver01', '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'Bác Tài Số Một', 'driver01@bus.vn', '0901234564', 3, 1),");
                sqlLines.add("(5, 'driver02', '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'Bác Tài Số Hai', 'driver02@bus.vn', '0901234565', 3, 1),");
                sqlLines.add("(6, 'driver03', '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'Bác Tài Số Ba', 'driver03@bus.vn', '0901234566', 3, 1),");
                sqlLines.add("(7, 'assistant01', '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'Hoàng Soát Vé', 'assist01@bus.vn', '0901234567', 4, 1),");
                sqlLines.add("(8, 'assistant02', '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'Đinh Lơ Xe', 'assist02@bus.vn', '0901234568', 4, 1),");
                sqlLines.add("(9, 'customer1', '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'Nguyễn Nhật Linh', 'linh@bus.vn', '0911111111', 5, 1),");
                sqlLines.add("(10, 'customer2', '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'Trần Sinh Viên', 'sv@bus.vn', '0922222222', 5, 1),");
                sqlLines.add("(11, 'customer3', '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'Phan Khách Hàng', 'khach@bus.vn', '0933333333', 5, 1);");
                sqlLines.add("SET IDENTITY_INSERT Accounts OFF;");
                sqlLines.add("GO\n");
                
                // 3. Stops
                List<StopData> stopsList = new ArrayList<>(uniqueStops.values());
                sqlLines.add("-- 3. CHÈN BẢNG STOPS (" + stopsList.size() + " Trạm Dừng)");
                sqlLines.add("SET IDENTITY_INSERT Stops ON;");
                for (int i = 0; i < stopsList.size(); i += 500) {
                    int end = Math.min(i + 500, stopsList.size());
                    List<StopData> chunk = stopsList.subList(i, end);
                    sqlLines.add("INSERT INTO Stops (StopID, StopName, Address, Latitude, Longitude) VALUES ");
                    List<String> values = new ArrayList<>();
                    for (StopData stop : chunk) {
                        String name = stop.name.replace("'", "''");
                        String addr = stop.address.replace("'", "''");
                        values.add(String.format(Locale.US, "(%d, N'%s', N'%s', %.7f, %.7f)", stop.id, name, addr, stop.lat, stop.lng));
                    }
                    sqlLines.add(String.join(",\n", values) + ";");
                }
                sqlLines.add("SET IDENTITY_INSERT Stops OFF;");
                sqlLines.add("GO\n");
                
                // 4. Routes
                sqlLines.add("-- 4. CHÈN BẢNG ROUTES (" + parsedRoutes.size() + " Tuyến Xe)");
                sqlLines.add("SET IDENTITY_INSERT Routes ON;");
                for (int i = 0; i < parsedRoutes.size(); i += 500) {
                    int end = Math.min(i + 500, parsedRoutes.size());
                    List<RouteData> chunk = parsedRoutes.subList(i, end);
                    sqlLines.add("INSERT INTO Routes (RouteID, RouteNumber, RouteName, StartPoint, EndPoint, OperatingHours, Frequency, TicketPrice, TotalDistance) VALUES ");
                    List<String> values = new ArrayList<>();
                    for (RouteData r : chunk) {
                        String name = r.name.replace("'", "''");
                        String start = r.start.replace("'", "''");
                        String endPt = r.end.replace("'", "''");
                        String hours = r.hours.replace("'", "''");
                        String freq = r.freq.replace("'", "''");
                        values.add(String.format(Locale.US, "(%d, '%s', N'%s', N'%s', N'%s', N'%s', N'%s', %d, %.2f)", r.id, r.number, name, start, endPt, hours, freq, r.price, r.dist));
                    }
                    sqlLines.add(String.join(",\n", values) + ";");
                }
                sqlLines.add("SET IDENTITY_INSERT Routes OFF;");
                sqlLines.add("GO\n");
                
                // 5. Route Stops mapping
                sqlLines.add("-- 5. CHÈN BẢNG ROUTE_STOP (" + parsedRouteStops.size() + " Bản Ghi Mapping)");
                Set<String> seenMappings = new HashSet<>();
                Set<String> seenOrders = new HashSet<>();
                List<RouteStopData> dedupedRouteStops = new ArrayList<>();
                for (RouteStopData rs : parsedRouteStops) {
                    String mapKey = rs.routeId + "_" + rs.stopId;
                    String orderKey = rs.routeId + "_" + rs.order;
                    if (!seenMappings.contains(mapKey) && !seenOrders.contains(orderKey)) {
                        seenMappings.add(mapKey);
                        seenOrders.add(orderKey);
                        dedupedRouteStops.add(rs);
                    }
                }
                for (int i = 0; i < dedupedRouteStops.size(); i += 500) {
                    int end = Math.min(i + 500, dedupedRouteStops.size());
                    List<RouteStopData> chunk = dedupedRouteStops.subList(i, end);
                    sqlLines.add("INSERT INTO Route_Stop (RouteID, StopID, StopOrder) VALUES ");
                    List<String> values = new ArrayList<>();
                    for (RouteStopData rs : chunk) {
                        values.add(String.format("(%d, %d, %d)", rs.routeId, rs.stopId, rs.order));
                    }
                    sqlLines.add(String.join(",\n", values) + ";");
                }
                sqlLines.add("GO\n");
                
                // 6. Buses
                sqlLines.add("-- 6. CHÈN BẢNG BUSES (Xe Buýt)");
                sqlLines.add("INSERT INTO Buses (LicensePlate, Capacity, BusType, Status) VALUES ");
                List<String> busValues = new ArrayList<>();
                for (int i = 0; i < 30; i++) {
                    String plate = String.format("29B-%03d.%02d", rand.nextInt(900) + 100, rand.nextInt(90) + 10);
                    int cap = Arrays.asList(30, 60, 80).get(rand.nextInt(3));
                    String btype = Arrays.asList("Thường", "Xe buýt điện VinBus", "Xe buýt nối toa").get(rand.nextInt(3));
                    String status = Arrays.asList("ACTIVE", "ACTIVE", "ACTIVE", "MAINTENANCE").get(rand.nextInt(4));
                    busValues.add(String.format("(%s'%s', %d, N'%s', '%s')", "", plate, cap, btype, status));
                }
                sqlLines.add(String.join(",\n", busValues) + ";");
                sqlLines.add("GO\n");
                
                // 7. Trips
                sqlLines.add("-- 7. CHÈN BẢNG TRIPS (Chuyến Đi)");
                sqlLines.add("INSERT INTO Trips (RouteID, BusID, DriverID, AssistantID, TripDate, StartTime, EndTime, Direction, Status) VALUES ");
                List<String> tripValues = new ArrayList<>();
                String today = java.time.LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
                int routeLimit = Math.min(11, parsedRoutes.size() + 1);
                for (int routeId = 1; routeId < routeLimit; routeId++) {
                    for (int hour : Arrays.asList(6, 8, 10, 14, 16, 18)) {
                        int busId = rand.nextInt(20) + 1;
                        int driverId = Arrays.asList(4, 5, 6).get(rand.nextInt(3));
                        Integer assistantId = Arrays.asList(7, 8, null).get(rand.nextInt(3));
                        String startTime = String.format("%02d:00", hour);
                        String endTime = String.format("%02d:30", hour + 1);
                        int direction = rand.nextBoolean() ? 1 : 2;
                        String status = "SCHEDULED";
                        String assistantStr = (assistantId != null) ? String.valueOf(assistantId) : "NULL";
                        tripValues.add(String.format("(%d, %d, %d, %s, '%s', '%s', '%s', %d, '%s')", routeId, busId, driverId, assistantStr, today, startTime, endTime, direction, status));
                    }
                }
                sqlLines.add(String.join(",\n", tripValues) + ";");
                sqlLines.add("GO\n");
                
                // 8. Tickets
                sqlLines.add("-- 8. CHÈN BẢNG TICKETS (Vé Lượt)");
                sqlLines.add("INSERT INTO Tickets (AccountID, TripID, RouteID, TicketCode, Price, SaleChannel, Status, PurchasedAt) VALUES ");
                List<String> ticketValues = new ArrayList<>();
                for (int i = 1; i <= 14; i++) {
                    Integer acc = Arrays.asList(9, 10, 11, null).get(rand.nextInt(4));
                    int trip = rand.nextInt(10) + 1;
                    int route = rand.nextInt(5) + 1;
                    String code = String.format("TK-%02d-MOCK%03d", route, i);
                    int price = 7000;
                    String chan = Arrays.asList("ONLINE", "COUNTER", "ON_BUS").get(rand.nextInt(3));
                    String stat = Arrays.asList("UNUSED", "USED").get(rand.nextInt(2));
                    String accStr = (acc != null) ? String.valueOf(acc) : "NULL";
                    ticketValues.add(String.format("(%s, %d, %d, '%s', %d, '%s', '%s', GETDATE())", accStr, trip, route, code, price, chan, stat));
                }
                sqlLines.add(String.join(",\n", ticketValues) + ";");
                sqlLines.add("GO\n");
                
                // 9-14 Static inserts
                sqlLines.add("-- 9. CHÈN BẢNG MONTHLY PASS TYPES");
                sqlLines.add("SET IDENTITY_INSERT MonthlyPassTypes ON;");
                sqlLines.add("INSERT INTO MonthlyPassTypes (PassTypeID, TypeName, DiscountPercentage, Description) VALUES ");
                sqlLines.add("(1, N'Học sinh/Sinh viên (1 Tuyến)', 50.00, N'Dành cho HSSV, chỉ đi 1 tuyến cố định'),");
                sqlLines.add("(2, N'Học sinh/Sinh viên (Liên Tuyến)', 50.00, N'Dành cho HSSV, đi tất cả các tuyến'),");
                sqlLines.add("(3, N'Người cao tuổi', 100.00, N'Miễn phí toàn bộ mạng lưới buýt Hà Nội'),");
                sqlLines.add("(4, N'Phổ thông (Liên Tuyến)', 0.00, N'Vé tháng bình thường đi tất cả các tuyến');");
                sqlLines.add("SET IDENTITY_INSERT MonthlyPassTypes OFF;");
                sqlLines.add("GO\n");
                
                sqlLines.add("-- 10. CHÈN BẢNG MONTHLY PASSES (Vé Tháng)");
                sqlLines.add("INSERT INTO MonthlyPasses (AccountID, RouteID, PassTypeID, PassCode, StartDate, EndDate, Price, Status, ApprovedBy, ApprovedAt) VALUES ");
                sqlLines.add("(10, 1, 1, 'MP-SV-001', '2026-06-01', '2026-06-30', 50000, 'APPROVED', 2, GETDATE()),");
                sqlLines.add("(10, 2, 1, 'MP-SV-002', '2026-07-01', '2026-07-31', 50000, 'APPROVED', 2, GETDATE()),");
                sqlLines.add("(9, NULL, 4, 'MP-PT-001', '2026-06-01', '2026-06-30', 200000, 'PENDING', NULL, NULL),");
                sqlLines.add("(11, NULL, 3, 'MP-CT-001', '2026-01-01', '2026-12-31', 0, 'APPROVED', 1, GETDATE());");
                sqlLines.add("GO\n");
                
                sqlLines.add("-- 11. CHÈN BẢNG FAVORITES (Tuyến Xe Yêu Thích)");
                sqlLines.add("INSERT INTO Favorites (AccountID, RouteID) VALUES ");
                sqlLines.add("(9, 1), (9, 3), (10, 2), (10, 5), (11, 4);");
                sqlLines.add("GO\n");
                
                sqlLines.add("-- 12. CHÈN BẢNG SEARCH HISTORY");
                sqlLines.add("INSERT INTO SearchHistory (AccountID, FromStopID, ToStopID) VALUES ");
                sqlLines.add("(9, 1, 10), (9, 5, 20), (10, 3, 15);");
                sqlLines.add("GO\n");
                
                sqlLines.add("-- 13. CHÈN BẢNG NOTIFICATIONS");
                sqlLines.add("INSERT INTO Notifications (AccountID, NotificationType, Title, Content, IsRead) VALUES ");
                sqlLines.add("(10, 'PASS_APPROVED', N'Vé tháng đã được phê duyệt', N'Yêu cầu gia hạn vé tháng MP-SV-002 của bạn đã được duyệt thành công.', 0),");
                sqlLines.add("(9, 'SYSTEM_ALERT', N'Thay đổi lộ trình tuyến 01', N'Tuyến số 01 thay đổi tạm thời do sửa chữa đường tại phố Tây Sơn.', 0);");
                sqlLines.add("GO\n");
                
                sqlLines.add("-- 14. CHÈN BẢNG BUS LOCATIONS (Vị Trí GPS Xe Buýt)");
                sqlLines.add("INSERT INTO BusLocations (BusID, Latitude, Longitude, UpdatedAt) VALUES ");
                List<String> locValues = new ArrayList<>();
                for (int busId = 1; busId <= 15; busId++) {
                    double lat = 21.028 + (rand.nextDouble() - 0.5) * 0.1;
                    double lng = 105.804 + (rand.nextDouble() - 0.5) * 0.1;
                    locValues.add(String.format(Locale.US, "(%d, %.7f, %.7f, GETDATE())", busId, lat, lng));
                }
                sqlLines.add(String.join(",\n", locValues) + ";");
                sqlLines.add("GO\n");
                
                // Write out file contents
                String sqlContent = String.join("\n", sqlLines);
                
                String[] outputPaths = {
                    "d:\\Java_BusManagement\\BusManagement\\sql\\InsertMockData.sql",
                    "d:\\Java_BusManagement\\BusManagement\\busmanagement\\sql\\InsertMockData.sql"
                };
                
                for (String path : outputPaths) {
                    try (Writer w = new OutputStreamWriter(new FileOutputStream(path), "UTF-8")) {
                        w.write(sqlContent);
                    }
                    log.append("Đã ghi đè thành công tệp SQL sạch tại: ").append(path).append("\n");
                }
                
                out.println("<div class='success'>✓ Đã biên dịch Java và sinh dữ liệu SQL sạch thành công!</div>");
                out.println("<h4 style='margin-bottom: 5px; color: #2d3748;'>Các bước để cập nhật Database:</h4>");
                out.println("<ol>");
                out.println("<li>Mở phần mềm <b>SQL Server Management Studio (SSMS)</b> của bạn.</li>");
                out.println("<li>Mở tệp SQL mới được sinh ra tại: <code>d:\\Java_BusManagement\\BusManagement\\busmanagement\\sql\\InsertMockData.sql</code></li>");
                out.println("<li>Nhấn <b>Execute (F5)</b> để chạy lại file SQL này. Nó sẽ xóa các bảng dữ liệu cũ và nạp lại toàn bộ dữ liệu mới sạch sẽ.</li>");
                out.println("</ol>");
                
            } catch (Exception e) {
                StringWriter sw = new StringWriter();
                e.printStackTrace(new PrintWriter(sw));
                out.println("<div class='error'>✗ Có lỗi xảy ra trong quá trình sinh dữ liệu: " + e.getMessage() + "</div>");
                log.append("\n[STACkTRACE]\n").append(sw.toString());
            }
            
            out.println("<h3>Nhật ký chi tiết (Java log):</h3>");
            out.println("<pre>" + log.toString() + "</pre>");
        %>
    </div>
</body>
</html>
