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
    private String vnp_TxnRef;        // VNPay transaction reference
    private String vnp_OrderInfo;     // Order information
    private String vnp_ResponseCode;  // Response code from VNPay
    private String vnp_TransactionStatus; // Transaction status from VNPay
    private String vnp_PayDate;      // Payment date from VNPay
    private String vnp_TransactionNo; // VNPay transaction number
    private String vnp_BankCode;     // Bank code from VNPay
    private String vnp_Amount;       // Payment amount in VND

    // Thêm fields cần cho dashboard (từ query join)
    private String customer; // Tên khách (full_name từ Users)
    private String checkIn; // check_in_date (String format YYYY-MM-DD)
    private String checkOut; // check_out_date (String format YYYY-MM-DD)
    private String statusClass; // 'bg-success', etc. (cho màu badge)

    // Getter and Setter methods (cũ giữ nguyên, thêm mới)

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

    public String getVnp_TxnRef() {
        return vnp_TxnRef;
    }

    public void setVnp_TxnRef(String vnp_TxnRef) {
        this.vnp_TxnRef = vnp_TxnRef;
    }

    public String getVnp_OrderInfo() {
        return vnp_OrderInfo;
    }

    public void setVnp_OrderInfo(String vnp_OrderInfo) {
        this.vnp_OrderInfo = vnp_OrderInfo;
    }

    public String getVnp_ResponseCode() {
        return vnp_ResponseCode;
    }

    public void setVnp_ResponseCode(String vnp_ResponseCode) {
        this.vnp_ResponseCode = vnp_ResponseCode;
    }

    public String getVnp_TransactionStatus() {
        return vnp_TransactionStatus;
    }

    public void setVnp_TransactionStatus(String vnp_TransactionStatus) {
        this.vnp_TransactionStatus = vnp_TransactionStatus;
    }

    public String getVnp_PayDate() {
        return vnp_PayDate;
    }

    public void setVnp_PayDate(String vnp_PayDate) {
        this.vnp_PayDate = vnp_PayDate;
    }

    public String getVnp_TransactionNo() {
        return vnp_TransactionNo;
    }

    public void setVnp_TransactionNo(String vnp_TransactionNo) {
        this.vnp_TransactionNo = vnp_TransactionNo;
    }

    public String getVnp_BankCode() {
        return vnp_BankCode;
    }

    public void setVnp_BankCode(String vnp_BankCode) {
        this.vnp_BankCode = vnp_BankCode;
    }

    public String getVnp_Amount() {
        return vnp_Amount;
    }

    public void setVnp_Amount(String vnp_Amount) {
        this.vnp_Amount = vnp_Amount;
    }

    // Getters/Setters mới cho dashboard
    public String getCustomer() {
        return customer;
    }

    public void setCustomer(String customer) {
        this.customer = customer;
    }

    public String getCheckIn() {
        return checkIn;
    }

    public void setCheckIn(String checkIn) {
        this.checkIn = checkIn;
    }

    public String getCheckOut() {
        return checkOut;
    }

    public void setCheckOut(String checkOut) {
        this.checkOut = checkOut;
    }

    public String getStatusClass() {
        return statusClass;
    }

    public void setStatusClass(String statusClass) {
        this.statusClass = statusClass;
    }

    // Constructor mới cho Booking
    public Booking(String roomNumber, String customer, String checkInDate, String checkOutDate, String status) {
        this.customer = customer;
        this.checkIn = checkInDate;
        this.checkOut = checkOutDate;
        this.status = status;
    }
}