/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Phạm Quốc Tuấn
 */
public class Room {

    private int id;
    private String roomNumber;
    private int roomTypeId;
    private String roomTypeName;
    private double roomPrice;
    private String roomStatus;
    private int capacity;
    private String description;
    private String imageUrl;
    private int floor;
    private boolean isDeleted;

    public Room() {
    }

    public Room(String roomNumber, int roomTypeId, double roomPrice, String roomStatus, int capacity, String description, String imageUrl, int floor) {
        this.roomNumber = roomNumber;
        this.roomTypeId = roomTypeId;
        this.roomPrice = roomPrice;
        this.roomStatus = roomStatus;
        this.capacity = capacity;
        this.description = description;
        this.imageUrl = imageUrl;
        this.floor = floor;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getRoomNumber() {
        return roomNumber;
    }

    public void setRoomNumber(String roomNumber) {
        this.roomNumber = roomNumber;
    }

    public int getRoomTypeId() {
        return roomTypeId;
    }

    public void setRoomTypeId(int roomTypeId) {
        this.roomTypeId = roomTypeId;
    }

    public double getRoomPrice() {
        return roomPrice;
    }

    public void setRoomPrice(double roomPrice) {
        this.roomPrice = roomPrice;
    }

    public String getRoomStatus() {
        return roomStatus;
    }

    public void setRoomStatus(String roomStatus) {
        this.roomStatus = roomStatus;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public int getFloor() {
        return floor;
    }

    public void setFloor(int floor) {
        this.floor = floor;
    }

    public boolean isDeleted() {
        return isDeleted;
    }

    public void setDeleted(boolean isDeleted) {
        this.isDeleted = isDeleted;
    }

    public String getRoomTypeName() {
        return roomTypeName;
    }

    public void setRoomTypeName(String roomTypeName) {
        this.roomTypeName = roomTypeName;
    }

    @Override
    public String toString() {
        return "Room{" + "id=" + id + ", roomNumber=" + roomNumber + ", roomTypeId=" + roomTypeId + ", roomTypeName=" + roomTypeName + ", roomPrice=" + roomPrice + ", roomStatus=" + roomStatus + ", capacity=" + capacity + ", description=" + description + ", imageUrl=" + imageUrl + ", floor=" + floor + ", isDeleted=" + isDeleted + '}';
    }

}
