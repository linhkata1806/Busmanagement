/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dto;

/**
 *
 * @author ASUS
 */
public class DashboardDTO {

    private int totalAccounts;
    private int totalCustomers;
    private int pendingPasses;

    public DashboardDTO(int totalAccounts, int totalCustomers, int pendingPasses) {
        this.totalAccounts = totalAccounts;
        this.totalCustomers = totalCustomers;
        this.pendingPasses = pendingPasses;
    }

    public int getTotalAccounts() {
        return totalAccounts;
    }

    public int getTotalCustomers() {
        return totalCustomers;
    }

    public int getPendingPasses() {
        return pendingPasses;
    }
}
