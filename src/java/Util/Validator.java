package Util;

import model.Account;

public class Validator {
    
    
    public static boolean isValidRegisterInfo(Account account) {

        if (account.getUsername() == null
                || account.getUsername().trim().isEmpty()) {
            return false;
        }

        if (account.getPassword() == null
                || account.getPassword().length() < 6) {
            return false;
        }

        if (account.getFullName() == null
                || account.getFullName().trim().isEmpty()) {
            return false;
        }

        if (account.getEmail() == null
                || !isValidEmail(account.getEmail())) {
            return false;
        }

        if (account.getPhone() != null
                && !account.getPhone().isBlank()
                && !isValidPhone(account.getPhone())) {
            return false;
        }

        return true;
    }

    public static boolean isValidEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        return email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$");
    }

    public static boolean isValidPhone(String phone) {
        if (phone == null || phone.trim().isEmpty()) {
            return false; 
            
        }
        return phone.matches("^0\\d{9}$");
    }

}