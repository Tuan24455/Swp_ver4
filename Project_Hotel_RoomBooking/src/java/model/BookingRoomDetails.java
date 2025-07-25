package model;

import java.sql.Date;

public class BookingRoomDetails {
    private int id;
    private int bookingId;
    private int roomId;
    private Date checkInDate;
    private Date checkOutDate;
    private int quantity;
    private double prices;

    public BookingRoomDetails() {}

    public BookingRoomDetails(int bookingId, int roomId, Date checkInDate, Date checkOutDate, int quantity, double prices) {
        this.bookingId = bookingId;
        this.roomId = roomId;
        this.checkInDate = checkInDate;
        this.checkOutDate = checkOutDate;
        this.quantity = quantity;
        this.prices = prices;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public int getRoomId() {
        return roomId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public Date getCheckInDate() {
        return checkInDate;
    }

    public void setCheckInDate(Date checkInDate) {
        this.checkInDate = checkInDate;
    }

    public Date getCheckOutDate() {
        return checkOutDate;
    }

    public void setCheckOutDate(Date checkOutDate) {
        this.checkOutDate = checkOutDate;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getPrices() {
        return prices;
    }

    public void setPrices(double prices) {
        this.prices = prices;
    }
}
