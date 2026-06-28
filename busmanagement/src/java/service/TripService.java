/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.TripDAO;

/**
 *
 * @author Administrator
 */
public class TripService {
    private TripDAO tripDAO = new TripDAO();

    public int countTripsToday() {
        return tripDAO.countTripsToday();
    }
    
}
