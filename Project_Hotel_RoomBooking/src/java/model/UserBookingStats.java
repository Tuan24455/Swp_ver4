/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author ADMIN
 */
public class UserBookingStats {
    private int userId;
    private int totalBookings;
    private int totalRoomReviews;
    private int totalServiceReviews;

    // Constructor
    public UserBookingStats(int userId, int totalBookings, int totalRoomReviews, int totalServiceReviews) {
        this.userId = userId;
        this.totalBookings = totalBookings;
        this.totalRoomReviews = totalRoomReviews;
        this.totalServiceReviews = totalServiceReviews;
    }

    // Getters & Setters
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getTotalBookings() { return totalBookings; }
    public void setTotalBookings(int totalBookings) { this.totalBookings = totalBookings; }

    public int getTotalRoomReviews() { return totalRoomReviews; }
    public void setTotalRoomReviews(int totalRoomReviews) { this.totalRoomReviews = totalRoomReviews; }

    public int getTotalServiceReviews() { return totalServiceReviews; }
    public void setTotalServiceReviews(int totalServiceReviews) { this.totalServiceReviews = totalServiceReviews; }
}
