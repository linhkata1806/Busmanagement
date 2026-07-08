/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

/**
 *
 * @author Administrator
 */
public class VNPayConfig {
    // URL của VNPay Sandbox
    public static final String vnp_PayUrl = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";
    
    // Đường dẫn hệ thống của cậu để VNPay trả kết quả về (Sửa localhost:8081 cho đúng với máy cậu nhé)
    public static final String vnp_ReturnUrl = "http://localhost:8081/BusManagement/vnpay-return";
    
    // Mã Terminal lấy từ email
    public static final String vnp_TmnCode = "7YRRIF43";
    
    // Chuỗi bí mật mã hóa lấy từ email
    public static final String vnp_HashSecret = "XB4VJUVZLLZW38JY1BEM2EO4JKQJONG0";
    
    // Version API
    public static final String vnp_Version = "2.1.0";
    public static final String vnp_Command = "pay";
}