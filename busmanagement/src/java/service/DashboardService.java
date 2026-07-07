/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

/**
 *
 * @author ASUS
 */
import dal.DashboardDAO;
import dto.DashboardDTO;

public class DashboardService {

    private DashboardDAO dashboardDAO;

    public DashboardService() {
        this.dashboardDAO = new DashboardDAO();
    }

    // Gộp các hàm count từ DAO trả về DTO cho Dashboard
    public DashboardDTO getDashboardData() {
        int accounts = dashboardDAO.countAccounts();
        int customers = dashboardDAO.countCustomers();
        int pendingPasses = dashboardDAO.countPendingPasses();

        return new DashboardDTO(accounts, customers, pendingPasses);
    }
}
