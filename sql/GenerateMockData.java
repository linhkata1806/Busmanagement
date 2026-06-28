import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class GenerateMockData {

    private static String cleanText(String text) {
        if (text == null) return "";
        return text.replaceAll("\\s+", " ").trim();
    }

    private static String getField(String block, String fieldName) {
        Pattern p = Pattern.compile("\"" + fieldName + "\":\\s*\"([^\"]*)\"");
        Matcher m = p.matcher(block);
        if (m.find()) {
            return cleanText(m.group(1));
        }
        return "";
    }

    private static String extractBetween(String text, String startLabel, String[] endLabels) {
        int startIdx = text.indexOf(startLabel);
        if (startIdx == -1) return "";
        startIdx += startLabel.length();
        
        int endIdx = text.length();
        for (String label : endLabels) {
            int idx = text.indexOf(label, startIdx);
            if (idx != -1 && idx < endIdx) {
                endIdx = idx;
            }
        }
        if (startIdx >= endIdx) return "";
        return text.substring(startIdx, endIdx).trim();
    }

    public static void main(String[] args) {
        String jsonPath = "docs/raw-data/hanoi_bus_routes.json";
        String outputPath = "sql/InsertMockData.sql";

        if (!Files.exists(Paths.get(jsonPath))) {
            jsonPath = "../docs/raw-data/hanoi_bus_routes.json";
            outputPath = "InsertMockData.sql";
        }

        try {
            System.out.println("\u0110ang \u0111\u1ecdc file JSON...");
            byte[] bytes = Files.readAllBytes(Paths.get(jsonPath));
            String content = new String(bytes, StandardCharsets.UTF_8);

            List<String> blocks = new ArrayList<>();
            int depth = 0;
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < content.length(); i++) {
                char c = content.charAt(i);
                if (c == '{') {
                    depth++;
                    if (depth == 1) {
                        sb.setLength(0);
                        continue;
                    }
                } else if (c == '}') {
                    depth--;
                    if (depth == 0) {
                        blocks.add(sb.toString());
                        continue;
                    }
                }
                if (depth > 0) {
                    sb.append(c);
                }
            }

            List<Map<String, Object>> parsedRoutes = new ArrayList<>();
            Map<String, Map<String, Object>> uniqueStops = new LinkedHashMap<>();
            List<Map<String, Object>> routeStops = new ArrayList<>();

            int stopCounter = 1;
            int routeCounter = 1;

            Random random = new Random(42);

            for (String block : blocks) {
                String routeNumber = getField(block, "routeId");
                String routeName = getField(block, "routeName");

                if (routeNumber.isEmpty() || routeName.isEmpty()) {
                    continue;
                }

                // Parse Ticket Price
                String priceStr = getField(block, "ticketPrice");
                int ticketPrice = 7000;
                Pattern pricePattern = Pattern.compile("\\d+");
                Matcher priceMatcher = pricePattern.matcher(priceStr);
                if (priceMatcher.find()) {
                    ticketPrice = Integer.parseInt(priceMatcher.group());
                }

                // Split Start/End points
                String[] parts = routeName.split(" - ");
                String startPoint = parts.length > 0 ? parts[0] : "H\u00e0 N\u1ed9i";
                String endPoint = parts.length > 1 ? parts[parts.length - 1] : "H\u00e0 N\u1ed9i";

                String forwardRoute = getField(block, "forwardRoute");
                String returnRoute = getField(block, "returnRoute");
                String fullText = forwardRoute + " " + returnRoute;

                // Parse Distance
                double distance = 15.0;
                String distStr = extractBetween(fullText, "C\u01b0\u0323 ly:", new String[]{"km", "\n", "\r"});
                if (distStr.isEmpty()) {
                    distStr = extractBetween(fullText, "C\u1ef1 ly:", new String[]{"km", "\n", "\r"});
                }
                if (!distStr.isEmpty()) {
                    try {
                        distance = Double.parseDouble(distStr.replaceAll("[^0-9\\.]", ""));
                    } catch (Exception e) {}
                }

                // Parse Operating Hours
                String operatingHours = "";
                String[] hoursEnds = new String[]{"Th\u1eddi gian", "Gi\u00e1 v\u00e9", "S\u1ed1 chuy\u1ebfn", "Gia\u0303n ca\u0301ch", "\n", "\r"};
                operatingHours = extractBetween(fullText, "Th\u01a1\u0300i gian hoat\u0323 \u0111\u00f4\u0323ng:", hoursEnds);
                if (operatingHours.isEmpty()) {
                    operatingHours = extractBetween(fullText, "Th\u1eddi gian ho\u1ea1t \u0111\u1ed9ng:", hoursEnds);
                }
                if (operatingHours.isEmpty() || operatingHours.length() < 5) {
                    operatingHours = "05:00 - 22:00";
                }
                if (operatingHours.length() > 50) {
                    operatingHours = operatingHours.substring(0, 50);
                }

                // Parse Frequency
                String frequency = "";
                String[] freqEnds = new String[]{"phu\u0301t", "ph\u00fat", "L\u00f4\u0323 tri\u0300nh", "L\u1ed9 tr\u00ecnh", "\n", "\r"};
                frequency = extractBetween(fullText, "Gia\u0303n ca\u0301ch chuy\u0301n:", freqEnds);
                if (frequency.isEmpty()) {
                    frequency = extractBetween(fullText, "Gi\u00e3n c\u00e1ch chuy\u1ebfn:", freqEnds);
                }
                if (frequency.isEmpty()) {
                    frequency = "10-15 ph\u00fat/chuy\u1ebfn";
                }
                if (frequency.length() > 50) {
                    frequency = frequency.substring(0, 50);
                }

                Map<String, Object> r = new HashMap<>();
                r.put("id", routeCounter);
                r.put("number", routeNumber);
                r.put("name", routeName);
                r.put("start", startPoint);
                r.put("end", endPoint);
                r.put("hours", operatingHours);
                r.put("freq", frequency);
                r.put("price", ticketPrice);
                r.put("dist", distance);
                parsedRoutes.add(r);

                // Parse Stops
                int startIdx = fullText.indexOf("Chi\u1ec1u \u0111i tuy\u1ebfn " + routeNumber);
                if (startIdx == -1) {
                    startIdx = fullText.indexOf("Chi\u1ec1u \u0111i tuy\u1ebfn");
                }
                if (startIdx == -1) {
                    startIdx = fullText.indexOf("L\u00f4\u0323 tri\u0300nh Chi\u1ec1u \u0111i");
                }
                if (startIdx != -1) {
                    startIdx += 10;
                } else {
                    startIdx = 0;
                }

                int endIdx = fullText.indexOf("B (B)", startIdx);
                if (endIdx == -1) {
                    endIdx = fullText.indexOf("Chi\u1ec1u v\u1ec1", startIdx);
                }
                if (endIdx == -1) {
                    endIdx = fullText.length();
                }

                String stopsText = fullText.substring(startIdx, endIdx);

                Pattern stopPattern = Pattern.compile("(\\d+)\\s+([^0-9]+)");
                Matcher stopMatcher = stopPattern.matcher(stopsText);

                int order = 1;
                while (stopMatcher.find()) {
                    String stopName = cleanText(stopMatcher.group(2));

                    if (stopName.length() < 3 || stopName.toLowerCase().contains("chi\u1ec1u \u0111i") || 
                        stopName.toLowerCase().contains("chi\u1ec1u v\u1ec1") || stopName.toLowerCase().contains("l\u1ed9 tr\u00ecnh") ||
                        stopName.toLowerCase().contains("gi\u00e1 v\u00e9") || stopName.toLowerCase().contains("\u0111\u01a1n v\u1ecb")) {
                        continue;
                    }

                    // CASE-INSENSITIVE DUPLICATE CHECK FOR SQL SERVER
                    String stopKey = stopName.toLowerCase().trim();
                    if (!uniqueStops.containsKey(stopKey)) {
                        Map<String, Object> stop = new HashMap<>();
                        stop.put("id", stopCounter);
                        stop.put("name", stopName);
                        stop.put("address", stopName + ", H\u00e0 N\u1ed9i");
                        stop.put("lat", 21.0 + (random.nextDouble() - 0.5) * 0.3);
                        stop.put("lng", 105.8 + (random.nextDouble() - 0.5) * 0.3);
                        uniqueStops.put(stopKey, stop);
                        stopCounter++;
                    }

                    Map<String, Object> rs = new HashMap<>();
                    rs.put("route_id", routeCounter);
                    rs.put("stop_id", uniqueStops.get(stopKey).get("id"));
                    rs.put("order", order);
                    routeStops.add(rs);
                    order++;
                }

                routeCounter++;
            }

            System.out.println("\u0110ang t\u1ea1o k\u1ecbch b\u1ea3n SQL...");
            List<String> sqlLines = new ArrayList<>();
            sqlLines.add("-- ========================================================");
            sqlLines.add("-- MOCK DATA T\u1ef0 \u0110\u1ed8NG SINH T\u1eea D\u1eee LI\u1ec6U XE BU\u00ddT H\u00c0 N\u1ed8I TH\u1ef0C T\u1ebe (JAVA VERSION)");
            sqlLines.add("-- ========================================================\n");
            sqlLines.add("USE HanoiBusDB;");
            sqlLines.add("GO\n");

            sqlLines.add("-- X\u00d3A D\u1eee LI\u1ec6U C\u0168 TR\u01af\u1edac KHI CH\u00c8N");
            sqlLines.add("DELETE FROM BusLocations;");
            sqlLines.add("DELETE FROM Notifications;");
            sqlLines.add("DELETE FROM SearchHistory;");
            sqlLines.add("DELETE FROM Favorites;");
            sqlLines.add("DELETE FROM MonthlyPasses;");
            sqlLines.add("DELETE FROM MonthlyPassTypes;"); // Fixed: Added delete for pass types
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

            // 1. ROLES
            sqlLines.add("-- 1. CH\u00c8N B\u1ea2NG ROLES");
            sqlLines.add("SET IDENTITY_INSERT Roles ON;");
            sqlLines.add("INSERT INTO Roles (RoleID, RoleName) VALUES ");
            sqlLines.add("(1, 'ADMIN'), (2, 'STAFF'), (3, 'DRIVER'), (4, 'ASSISTANT'), (5, 'CUSTOMER');");
            sqlLines.add("SET IDENTITY_INSERT Roles OFF;");
            sqlLines.add("GO\n");

            // 2. ACCOUNTS
            sqlLines.add("-- 2. CH\u00c8N B\u1ea2NG ACCOUNTS (M\u1eadt kh\u1ea9u m\u1eb7c \u0111\u1ecbnh: '123456' \u0111\u00e3 bcrypt)");
            sqlLines.add("SET IDENTITY_INSERT Accounts ON;");
            sqlLines.add("INSERT INTO Accounts (AccountID, [Username], [Password], FullName, Email, Phone, RoleID, IsActive) VALUES ");
            sqlLines.add("(1, 'admin', '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'L\u00ea Qu\u1ea3n Tr\u1ecb', 'admin@bus.vn', '0901234561', 1, 1),");
            sqlLines.add("(2, 'staff01', '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'Nguy\u1ec5n V\u0103n Tr\u1ea1m', 'staff01@bus.vn', '0901234562', 2, 1),");
            sqlLines.add("(3, 'staff02', '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'Tr\u1ea7n Th\u1ecb Qu\u1ea7y', 'staff02@bus.vn', '0901234563', 2, 1),");
            sqlLines.add("(4, 'driver01', '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'B\u00e1c T\u00e0i S\u1ed1 M\u1ed9t', 'driver01@bus.vn', '0901234564', 3, 1),");
            sqlLines.add("(5, 'driver02', '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'B\u00e1c T\u00e0i S\u1ed1 Hai', 'driver02@bus.vn', '0901234565', 3, 1),");
            sqlLines.add("(6, 'driver03', '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'B\u00e1c T\u00e0i S\u1ed1 Ba', 'driver03@bus.vn', '0901234566', 3, 1),");
            sqlLines.add("(7, 'assistant01', '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'Ho\u00e0ng So\u00e1t V\u00e9', 'assist01@bus.vn', '0901234567', 4, 1),");
            sqlLines.add("(8, 'assistant02', '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'\u0110inh L\u01a1 Xe', 'assist02@bus.vn', '0901234568', 4, 1),");
            sqlLines.add("(9, 'customer1', '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'Nguy\u1ec5n Nh\u1eadt Linh', 'linh@bus.vn', '0911111111', 5, 1),");
            sqlLines.add("(10, 'customer2', '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'Tr\u1ea7n Sinh Vi\u00ean', 'sv@bus.vn', '0922222222', 5, 1),");
            sqlLines.add("(11, 'customer3', '$2a$10$.5Elh8fgxypNUWhpUUr/xOa2sZm0VIaE0qWuGGl9otUfobb46T1Pq', N'Phan Kh\u00e1ch H\u00e0ng', 'khach@bus.vn', '0933333333', 5, 1);");
            sqlLines.add("SET IDENTITY_INSERT Accounts OFF;");
            sqlLines.add("GO\n");

            // 3. STOPS
            sqlLines.add("-- 3. CH\u00c8N B\u1ea2NG STOPS (" + uniqueStops.size() + " Tr\u1ea1m D\u1eebng)");
            sqlLines.add("SET IDENTITY_INSERT Stops ON;");
            List<Map<String, Object>> stopsList = new ArrayList<>(uniqueStops.values());
            for (int i = 0; i < stopsList.size(); i += 500) {
                int end = Math.min(i + 500, stopsList.size());
                List<Map<String, Object>> chunk = stopsList.subList(i, end);
                sqlLines.add("INSERT INTO Stops (StopID, StopName, Address, Latitude, Longitude, IsActive) VALUES ");
                List<String> values = new ArrayList<>();
                for (Map<String, Object> stop : chunk) {
                    String name = stop.get("name").toString().replace("'", "''");
                    String addr = stop.get("address").toString().replace("'", "''");
                    values.add(String.format(Locale.US, "(%s, N'%s', N'%s', %.7f, %.7f, 1)", stop.get("id"), name, addr, stop.get("lat"), stop.get("lng")));
                }
                sqlLines.add(String.join(",\n", values) + ";");
            }
            sqlLines.add("SET IDENTITY_INSERT Stops OFF;");
            sqlLines.add("GO\n");

            // 4. ROUTES
            sqlLines.add("-- 4. CH\u00c8N B\u1ea2NG ROUTES (" + parsedRoutes.size() + " Tuy\u1ebfn Xe)");
            sqlLines.add("SET IDENTITY_INSERT Routes ON;");
            for (int i = 0; i < parsedRoutes.size(); i += 500) {
                int end = Math.min(i + 500, parsedRoutes.size());
                List<Map<String, Object>> chunk = parsedRoutes.subList(i, end);
                sqlLines.add("INSERT INTO Routes (RouteID, RouteNumber, RouteName, StartPoint, EndPoint, OperatingHours, Frequency, TicketPrice, TotalDistance, IsActive) VALUES ");
                List<String> values = new ArrayList<>();
                for (Map<String, Object> r : chunk) {
                    String name = r.get("name").toString().replace("'", "''");
                    String start = r.get("start").toString().replace("'", "''");
                    String endP = r.get("end").toString().replace("'", "''");
                    String hours = r.get("hours").toString().replace("'", "''");
                    String freq = r.get("freq").toString().replace("'", "''");
                    values.add(String.format(Locale.US, "(%s, '%s', N'%s', N'%s', N'%s', '%s', N'%s', %s, %s, 1)", r.get("id"), r.get("number"), name, start, endP, hours, freq, r.get("price"), r.get("dist")));
                }
                sqlLines.add(String.join(",\n", values) + ";");
            }
            sqlLines.add("SET IDENTITY_INSERT Routes OFF;");
            sqlLines.add("GO\n");

            // 5. ROUTE_STOP
            sqlLines.add("-- 5. CH\u00c8N B\u1ea2NG ROUTE_STOP (" + routeStops.size() + " B\u1ea3n Ghi Mapping)");
            Set<String> seenMappings = new HashSet<>();
            Set<String> seenOrders = new HashSet<>();
            List<Map<String, Object>> dedupedRouteStops = new ArrayList<>();
            for (Map<String, Object> rs : routeStops) {
                String mapKey = rs.get("route_id") + "-" + rs.get("stop_id");
                String orderKey = rs.get("route_id") + "-" + rs.get("order");
                if (!seenMappings.contains(mapKey) && !seenOrders.contains(orderKey)) {
                    seenMappings.add(mapKey);
                    seenOrders.add(orderKey);
                    dedupedRouteStops.add(rs);
                }
            }
            for (int i = 0; i < dedupedRouteStops.size(); i += 500) {
                int end = Math.min(i + 500, dedupedRouteStops.size());
                List<Map<String, Object>> chunk = dedupedRouteStops.subList(i, end);
                sqlLines.add("INSERT INTO Route_Stop (RouteID, StopID, StopOrder) VALUES ");
                List<String> values = new ArrayList<>();
                for (Map<String, Object> rs : chunk) {
                    values.add(String.format("(%s, %s, %s)", rs.get("route_id"), rs.get("stop_id"), rs.get("order")));
                }
                sqlLines.add(String.join(",\n", values) + ";");
            }
            sqlLines.add("GO\n");

            // 6. BUSES (Fixed: Added IDENTITY_INSERT to prevent auto-increment offset errors)
            sqlLines.add("-- 6. CH\u00c8N B\u1ea2NG BUSES (Xe Bu\u00fdt)");
            sqlLines.add("SET IDENTITY_INSERT Buses ON;");
            sqlLines.add("INSERT INTO Buses (BusID, LicensePlate, Capacity, BusType, Status) VALUES ");
            List<String> busValues = new ArrayList<>();
            for (int i = 1; i <= 30; i++) {
                String plate = String.format("29B-%03d.%02d", random.nextInt(900) + 100, random.nextInt(90) + 10);
                int cap = random.nextBoolean() ? 60 : (random.nextBoolean() ? 80 : 30);
                String btype = cap == 80 ? "Xe bu\u00fdt n\u1ed1i toa" : (cap == 30 ? "Xe bu\u00fdt \u0111i\u1ec7n VinBus" : "Th\u01b0\u1eddng");
                String status = random.nextInt(4) == 0 ? "MAINTENANCE" : "ACTIVE";
                busValues.add(String.format("(%d, '%s', %d, N'%s', '%s')", i, plate, cap, btype, status));
            }
            sqlLines.add(String.join(",\n", busValues) + ";");
            sqlLines.add("SET IDENTITY_INSERT Buses OFF;");
            sqlLines.add("GO\n");

            // 7. TRIPS (Fixed: Added IDENTITY_INSERT to keep TripID stable for Tickets/Attendance tables)
            sqlLines.add("-- 7. CH\u00c8N B\u1ea2NG TRIPS (Chuy\u1ebfn \u0110i)");
            sqlLines.add("SET IDENTITY_INSERT Trips ON;");
            sqlLines.add("INSERT INTO Trips (TripID, RouteID, BusID, DriverID, AssistantID, TripDate, StartTime, EndTime, Direction, Status) VALUES ");
            List<String> tripValues = new ArrayList<>();
            String todayStr = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new Date());
            int maxRoutes = Math.min(11, parsedRoutes.size() + 1);
            int tripIdCounter = 1;
            for (int routeId = 1; routeId < maxRoutes; routeId++) {
                int[] hours = {6, 8, 10, 14, 16, 18};
                for (int hour : hours) {
                    int busId = random.nextInt(20) + 1;
                    int driverId = random.nextInt(3) + 4; // 4, 5, 6
                    Integer assistantId = random.nextBoolean() ? (random.nextBoolean() ? 7 : 8) : null;
                    String startTime = String.format("%02d:00", hour);
                    String endTime = String.format("%02d:30", hour + 1);
                    int direction = random.nextBoolean() ? 1 : 2;
                    String status = "SCHEDULED";
                    String assistantStr = assistantId == null ? "NULL" : assistantId.toString();
                    tripValues.add(String.format("(%d, %d, %d, %d, %s, '%s', '%s', '%s', %d, '%s')", tripIdCounter, routeId, busId, driverId, assistantStr, todayStr, startTime, endTime, direction, status));
                    tripIdCounter++;
                }
            }
            sqlLines.add(String.join(",\n", tripValues) + ";");
            sqlLines.add("SET IDENTITY_INSERT Trips OFF;");
            sqlLines.add("GO\n");

            // 8. TICKETS
            sqlLines.add("-- 8. CH\u00c8N B\u1ea2NG TICKETS (V\u00e9 L\u01b0\u1ee3t)");
            sqlLines.add("INSERT INTO Tickets (AccountID, TripID, RouteID, TicketCode, Price, SaleChannel, Status, PurchasedAt) VALUES ");
            List<String> ticketValues = new ArrayList<>();
            for (int i = 1; i <= 15; i++) {
                Integer acc = random.nextBoolean() ? (random.nextInt(3) + 9) : null;
                int trip = random.nextInt(10) + 1;
                int route = random.nextInt(5) + 1;
                String code = String.format("TK-%02d-MOCK%03d", route, i);
                int price = 7000;
                String chan = random.nextBoolean() ? "ONLINE" : (random.nextBoolean() ? "COUNTER" : "ON_BUS");
                String stat = random.nextBoolean() ? "UNUSED" : "USED";
                String accStr = acc == null ? "NULL" : acc.toString();
                ticketValues.add(String.format("(%s, %d, %d, '%s', %d, '%s', '%s', GETDATE())", accStr, trip, route, code, price, chan, stat));
            }
            sqlLines.add(String.join(",\n", ticketValues) + ";");
            sqlLines.add("GO\n");

            // 9. MONTHLY PASS TYPES
            sqlLines.add("-- 9. CH\u00c8N B\u1ea2NG MONTHLY PASS TYPES");
            sqlLines.add("SET IDENTITY_INSERT MonthlyPassTypes ON;");
            sqlLines.add("INSERT INTO MonthlyPassTypes (PassTypeID, TypeName, DiscountPercentage, Description) VALUES ");
            sqlLines.add("(1, N'H\u1ecdc sinh/Sinh vi\u00ean (1 Tuy\u1ebfn)', 50.00, N'D\u00e0nh cho HSSV, ch\u1ec9 \u0111i 1 tuy\u1ebfn c\u1ed1 \u0111\u1ecbnh'),");
            sqlLines.add("(2, N'H\u1ecdc sinh/Sinh vi\u00ean (Li\u00ean Tuy\u1ebfn)', 50.00, N'D\u00e0nh cho HSSV, \u0111i t\u1ea5t c\u1ea3 c\u00e1c tuy\u1ebfn'),");
            sqlLines.add("(3, N'Ng\u01b0\u1eddi cao tu\u1ed5i', 100.00, N'Mi\u1ec5n ph\u00ed to\u00e0n b\u1ed9 m\u1ea1ng l\u01b0\u1edbi bu\u00fdt H\u00e0 N\u1ed9i'),");
            sqlLines.add("(4, N'Ph\u1ed5 th\u00f4ng (Li\u00ean Tuy\u1ebfn)', 0.00, N'V\u00e9 th\u00e1ng b\u00ecnh th\u01b0\u1eddng \u0111i t\u1ea5t c\u1ea3 c\u00e1c tuy\u1ebfn');");
            sqlLines.add("SET IDENTITY_INSERT MonthlyPassTypes OFF;");
            sqlLines.add("GO\n");

            // 10. MONTHLY PASSES
            sqlLines.add("-- 10. CH\u00c8N B\u1ea2NG MONTHLY PASSES (V\u00e9 Th\u00e1ng)");
            sqlLines.add("INSERT INTO MonthlyPasses (AccountID, RouteID, PassTypeID, PassCode, StartDate, EndDate, Price, Status, ApprovedBy, ApprovedAt) VALUES ");
            sqlLines.add("(10, 1, 1, 'MP-SV-001', '2026-06-01', '2026-06-30', 50000, 'APPROVED', 2, GETDATE()),");
            sqlLines.add("(10, 2, 1, 'MP-SV-002', '2026-07-01', '2026-07-31', 50000, 'APPROVED', 2, GETDATE()),");
            sqlLines.add("(9, NULL, 4, 'MP-PT-001', '2026-06-01', '2026-06-30', 200000, 'PENDING', NULL, NULL),");
            sqlLines.add("(11, NULL, 3, 'MP-CT-001', '2026-01-01', '2026-12-31', 0, 'APPROVED', 1, GETDATE());");
            sqlLines.add("GO\n");

            // 11. FAVORITES
            sqlLines.add("-- 11. CH\u00c8N B\u1ea2NG FAVORITES (Tuy\u1ebfn Xe Y\u00eau Th\u00edch)");
            sqlLines.add("INSERT INTO Favorites (AccountID, RouteID) VALUES ");
            sqlLines.add("(9, 1), (9, 3), (10, 2), (10, 5), (11, 4);");
            sqlLines.add("GO\n");

            // 12. SEARCH HISTORY
            sqlLines.add("-- 12. CH\u00c8N B\u1ea2NG SEARCH HISTORY (L\u1ecbch S\u1eed T\u00ecm Ki\u1ebfm)");
            sqlLines.add("INSERT INTO SearchHistory (AccountID, FromStopID, ToStopID) VALUES ");
            sqlLines.add("(9, 1, 10), (9, 5, 20), (10, 3, 15);");
            sqlLines.add("GO\n");

            // 13. NOTIFICATIONS
            sqlLines.add("-- 13. CH\u00c8N B\u1ea2NG NOTIFICATIONS");
            sqlLines.add("INSERT INTO Notifications (AccountID, NotificationType, Title, Content, IsRead) VALUES ");
            sqlLines.add("(10, 'PASS_APPROVED', N'V\u00e9 th\u00e1ng \u0111\u00e3 \u0111\u01b0\u1ee3c ph\u00ea duy\u1ec7t', N'Y\u00eau c\u1ea7u gia h\u1ea1n v\u00e9 th\u00e1ng MP-SV-002 c\u1ee7a b\u1ea1n \u0111\u00e3 \u0111\u01b0\u1ee3c duy\u1ec7t th\u00e0nh c\u00f4ng.', 0),");
            sqlLines.add("(9, 'SYSTEM_ALERT', N'Thay \u0111\u1ed5i l\u1ed9 tr\u00ecnh tuy\u1ebfn 01', N'Tuy\u1ebfn s\u1ed1 01 thay \u0111\u1ed5i t\u1ea1m th\u1eddi do s\u1eeda ch\u1eefa \u0111\u01b0\u1eddng t\u1ea1i ph\u1ed1 T\u00e2y S\u01a1n.', 0);");
            sqlLines.add("GO\n");

            // 14. BUS LOCATIONS
            sqlLines.add("-- 14. CH\u00c8N B\u1ea2NG BUS LOCATIONS (V\u1ecb Tr\u00ed GPS Xe Bu\u00fdt)");
            sqlLines.add("INSERT INTO BusLocations (BusID, Latitude, Longitude, UpdatedAt) VALUES ");
            List<String> locValues = new ArrayList<>();
            for (int busId = 1; busId <= 15; busId++) {
                double lat = 21.028 + (random.nextDouble() - 0.5) * 0.1;
                double lng = 105.804 + (random.nextDouble() - 0.5) * 0.1;
                locValues.add(String.format(Locale.US, "(%d, %.7f, %.7f, GETDATE())", busId, lat, lng));
            }
            sqlLines.add(String.join(",\n", locValues) + ";");
            sqlLines.add("GO\n");

            Files.write(Paths.get(outputPath), sqlLines, StandardCharsets.UTF_8);
            System.out.println("Th\u00e0nh c\u00f4ng! \u0110\u00e3 ghi file mock data SQL v\u00e0o " + Paths.get(outputPath).toAbsolutePath());

        } catch (IOException e) {
            System.err.println("L\u1ed7i khi x\u1eed l\u00fd file: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
