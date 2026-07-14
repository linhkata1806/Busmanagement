/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.FavoriteDAO;
import dto.RouteDTO;
import java.util.List;

/**
 *
 * @author Administrator
 */
public class FavoriteService {
    private FavoriteDAO favoriteDAO;

    public FavoriteService() {
        favoriteDAO = new FavoriteDAO();
    }
    
    public boolean isFavorite(int accountId, int routeId) {
        return favoriteDAO.isFavorite(accountId, routeId);
    }

    public boolean addFavorite(int accountId, int routeId) {
        return favoriteDAO.addFavorite(accountId, routeId);
    }

    public boolean removeFavorite(int accountId, int routeId) {
        return favoriteDAO.removeFavorite(accountId, routeId);
    }

    public int countFavorites(int accountId) {
        return favoriteDAO.countFavorites(accountId);
    }

    public List<RouteDTO> getFavoriteRoutes(int accountId, int offset, int limit) {
        return favoriteDAO.getFavoriteRoutes(accountId, offset, limit);
    }
}
