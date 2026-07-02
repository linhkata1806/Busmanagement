/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.RouteDAO;
import dal.RouteStopDAO;
import dal.StopDAO;
import dto.RouteStopDTO;
import java.util.List;
import model.Stop;

/**
 *
 * @author Administrator
 */
public class RouteStopService {

    private RouteStopDAO routeStopDAO;
    private StopDAO stopDAO;
    private RouteDAO routeDAO;

    public RouteStopService() {
        this.routeStopDAO = new RouteStopDAO();
        this.stopDAO = new StopDAO();
        this.routeDAO = new RouteDAO();
    }

    // 1. LẤY DANH SÁCH STOP TRONG TUYẾN
    public List<RouteStopDTO> getStopsByRoute(int routeID) {
        // Chặn luồng URL Hacking (Validate Route tồn tại)
        if (!routeDAO.existsById(routeID)) {
            throw new IllegalArgumentException("Tuyến xe không tồn tại hoặc đã bị xóa khỏi hệ thống.");
        }
        return routeStopDAO.getStopsByRoute(routeID);
    }

    // 2. LẤY DANH SÁCH STOP ĐỂ HIỂN THỊ LÊN DROPDOWN (Chỉ lấy trạm ACTIVE & chưa có trong tuyến)
    public List<Stop> getAvailableStops(int routeID) {
        // Chặn luồng URL Hacking (Validate Route tồn tại)
        if (!routeDAO.existsById(routeID)) {
            throw new IllegalArgumentException("Tuyến xe không tồn tại.");
        }
        return stopDAO.getAvailableStops(routeID);
    }

    // 3. THÊM STOP VÀO TUYẾN
    public void addStopToRoute(int routeID, int stopID, int position, double distance) throws Exception {

        // Validate 1: Kiểm tra Tuyến xe (Route) có tồn tại không
        if (!routeDAO.existsById(routeID)) {
            throw new IllegalArgumentException("Tuyến xe không tồn tại hoặc đã bị xóa.");
        }

        // Validate 2: Kiểm tra Điểm dừng (Stop) có tồn tại không
        Stop stop = stopDAO.getStopById(stopID);
        if (stop == null) {
            throw new IllegalArgumentException("Điểm dừng không tồn tại trong hệ thống.");
        }

        // Validate 3: Stop chưa tồn tại trên Route này
        if (routeStopDAO.existsStopInRoute(routeID, stopID)) {
            throw new IllegalArgumentException("Điểm dừng '" + stop.getStopName() + "' đã tồn tại trên tuyến này.");
        }

        // Validate 4: Position hợp lệ
        int totalStops = routeStopDAO.countStopsByRoute(routeID);
        if (position < 1 || position > totalStops + 1) {
            throw new IllegalArgumentException("Vị trí chèn điểm dừng không hợp lệ (Phải từ 1 đến " + (totalStops + 1) + ").");
        }

        // Validate 5: Khoảng cách hợp lệ (BỔ SUNG)
        if (distance < 0) {
            throw new IllegalArgumentException("Khoảng cách từ điểm đầu phải >= 0 km.");
        }

        // Gọi DAO lưu xuống DB
        routeStopDAO.addStopToRoute(routeID, stopID, position, distance);
    }

    // 4. XÓA STOP KHỎI TUYẾN
    public void removeStopFromRoute(int routeStopID) throws Exception {
        RouteStopDTO dto = routeStopDAO.getById(routeStopID);

        if (dto == null) {
            throw new IllegalArgumentException("Bản ghi điểm dừng trên tuyến không tồn tại hoặc đã bị xóa bởi người khác.");
        }

        routeStopDAO.removeStop(dto);
    }

    // 5. ĐẨY LÊN TRÊN (Move Up)
    public void moveStopUp(int routeStopID) throws Exception {
        RouteStopDTO current = routeStopDAO.getById(routeStopID);

        if (current == null) {
            throw new IllegalArgumentException("Bản ghi không tồn tại.");
        }

        // Validate: Chặn move khi đang ở vị trí số 1
        if (current.getStopOrder() == 1) {
            throw new IllegalArgumentException("Điểm dừng '" + current.getStopName() + "' đã ở vị trí đầu tiên của tuyến.");
        }

        routeStopDAO.swapStopOrder(
                current.getRouteID(),
                current.getRouteStopID(),
                current.getStopOrder(),
                current.getStopOrder() - 1
        );
    }

    // 6. KÉO XUỐNG DƯỚI (Move Down)
    public void moveStopDown(int routeStopID) throws Exception {
        RouteStopDTO current = routeStopDAO.getById(routeStopID);

        if (current == null) {
            throw new IllegalArgumentException("Bản ghi không tồn tại.");
        }

        // Validate: Chặn move khi đang ở vị trí cuối cùng
        int totalStops = routeStopDAO.countStopsByRoute(current.getRouteID());
        if (current.getStopOrder() == totalStops) {
            throw new IllegalArgumentException("Điểm dừng '" + current.getStopName() + "' đã ở vị trí cuối cùng của tuyến.");
        }

        routeStopDAO.swapStopOrder(
                current.getRouteID(),
                current.getRouteStopID(),
                current.getStopOrder(),
                current.getStopOrder() + 1
        );
    }
    
}
