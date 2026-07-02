/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.AccountDAO;
import java.util.List;
import model.Account;

/**
 *
 * @author Administrator
 */
public class AccountService {

    private AccountDAO accountDAO;

    public AccountService() {
        accountDAO = new AccountDAO();
    }

    public List<Account> getAccountsByRole(int roleID) {
        return accountDAO.getAccountsByRole(roleID);
    }
}
