/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.time.LocalDateTime;

/**
 *
 * @author Administrator
 */
public class Account {
    private int accountID;
    private String username;
    private String password;
    private String fullName;
    private String email;
    private String phone;
    private String avatar;
    private String rememberToken;
    private int roleID;
    private boolean isActive;
    private LocalDateTime lastLogin;
    private LocalDateTime updatedAt;
    private LocalDateTime createdAt;
    private String roleName;

    public Account() {
    }

    public Account(int accountID, String username, String password, String fullName, String email, String phone, String avatar, String rememberToken, int roleID, boolean isActive, LocalDateTime lastLogin, LocalDateTime updatedAt, LocalDateTime createdAt, String roleName) {
        this.accountID = accountID;
        this.username = username;
        this.password = password;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.avatar = avatar;
        this.rememberToken = rememberToken;
        this.roleID = roleID;
        this.isActive = isActive;
        this.lastLogin = lastLogin;
        this.updatedAt = updatedAt;
        this.createdAt = createdAt;
        this.roleName = roleName;
    }

    public int getAccountID() {
        return accountID;
    }

    public void setAccountID(int accountID) {
        this.accountID = accountID;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public String getRememberToken() {
        return rememberToken;
    }

    public void setRememberToken(String rememberToken) {
        this.rememberToken = rememberToken;
    }

    public int getRoleID() {
        return roleID;
    }

    public void setRoleID(int roleID) {
        this.roleID = roleID;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean isActive) {
        this.isActive = isActive;
    }

    public LocalDateTime getLastLogin() {
        return lastLogin;
    }

    public void setLastLogin(LocalDateTime lastLogin) {
        this.lastLogin = lastLogin;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }

    @Override
    public String toString() {
        return "Account{" + "accountID=" + accountID + ", username=" + username + ", password=" + password + ", fullName=" + fullName + ", email=" + email + ", phone=" + phone + ", avatar=" + avatar + ", rememberToken=" + rememberToken + ", roleID=" + roleID + ", isActive=" + isActive + ", lastLogin=" + lastLogin + ", updatedAt=" + updatedAt + ", createdAt=" + createdAt + ", roleName=" + roleName + '}';
    }
    
    
}
