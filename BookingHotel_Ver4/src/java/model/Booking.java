/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.Date;

/**
 *
 * @author Phạm Quốc Tuấn
 */
public class Booking {
    private int id;
    private int userId;
    private Date createdAt;
    private int promotionId;
    private double totalPrices;
    private String status;
    private Integer roomReviewId;
    private Integer serviceReviewId;

    // Getter and Setter methods

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public int getPromotionId() {
        return promotionId;
    }

    public void setPromotionId(int promotionId) {
        this.promotionId = promotionId;
    }

    public double getTotalPrices() {
        return totalPrices;
    }

    public void setTotalPrices(double totalPrices) {
        this.totalPrices = totalPrices;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getRoomReviewId() {
        return roomReviewId;
    }

    public void setRoomReviewId(Integer roomReviewId) {
        this.roomReviewId = roomReviewId;
    }

    public Integer getServiceReviewId() {
        return serviceReviewId;
    }

    public void setServiceReviewId(Integer serviceReviewId) {
        this.serviceReviewId = serviceReviewId;
    }
}