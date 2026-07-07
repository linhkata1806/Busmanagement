/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Enum.java to edit this template
 */
package enums;

import model.*;

/**
 * Định nghĩa tập hợp cố định các loại thông báo của hệ thống.
 * Giúp đảm bảo an toàn kiểu dữ liệu (Type Safety) và tránh lỗi gõ sai chính tả.
 * 
 * @author Administrator
 */
public enum NotificationType {
    TICKET,
    PASS_APPROVED,
    PASS_REJECTED,
    SYSTEM_ALERT,
    BUS_ALERT,
    PROMOTION,
    ROUTE_DELAY,
    ROUTE_CHANGE,
    SYSTEM_MAINTENANCE
}
