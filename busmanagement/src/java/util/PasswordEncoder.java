/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

import org.mindrot.jbcrypt.BCrypt;

/**
 *
 * @author Administrator
 */
public class PasswordEncoder {

    // Băm mật khẩu khi đăng ký
    public static String hashPassword(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(12));
    }

    // Kiểm tra mật khẩu khi đăng nhập
    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        return BCrypt.checkpw(plainPassword, hashedPassword);
    }
    public static void main(String[] args) {
        String myHash = hashPassword("123456");
        System.out.println("Copy chuỗi này dán vào SQL nhé các bảo bối:");
        System.out.println(myHash);
    }
}
