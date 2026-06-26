/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import util.PasswordEncoder;
import util.Validator;
import dal.AccountDAO;
import dal.RoleDAO;
import model.Account;
import model.Role;

/**
 *
 * @author Administrator
 */
public class AuthService {

    private final AccountDAO accountDAO;
    private final RoleDAO roleDAO;

    public AuthService() {
        accountDAO = new AccountDAO();
        roleDAO = new RoleDAO();
    }

    public Account login(String username, String rawPassword) {

        if (username == null || rawPassword == null) {
            return null;
        }

        username = username.trim();

        Account account = accountDAO.getAccountByUsername(username);

        if (account == null) {
            return null;
        }

        if (!account.isActive()) {
            return null;
        }

        if (!PasswordEncoder.checkPassword(rawPassword, account.getPassword())) {
            return null;
        }

        accountDAO.updateLastLogin(account.getAccountID());

        return account;
    }

    public boolean register(Account account) {

        if (account == null) {
            return false;
        }

        // Validate cơ bản
        if (!Validator.isValidRegisterInfo(account)) {
            return false;
        }

        // Check trùng username
        if (accountDAO.existsByUsername(account.getUsername().trim())) {
            return false;
        }

        // Check trùng email
        if (accountDAO.existsByEmail(account.getEmail().trim())) {
            return false;
        }

        // Mã hóa mật khẩu
        String hashedPassword
                = PasswordEncoder.hashPassword(account.getPassword());

        account.setPassword(hashedPassword);

        // Gán role CUSTOMER
        Role customerRole = roleDAO.getRoleByName("CUSTOMER");

        if (customerRole == null) {
            return false;
        }

        account.setRoleID(customerRole.getRoleID());

        return accountDAO.insertAccount(account);
    }

}
