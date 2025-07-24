package model;

import java.util.Date;

/**
 * ServiceBooking model class for service payment functionality
 */
public class ServiceBooking {
    private int id;
    private int userId;
    private int serviceId;
    private Date bookingDate;
    private Date usageDate;
    private int quantity;
    private double totalAmount;
    private String status;
    private Date createdAt;
    
    // Additional fields for display purposes
    private String serviceName;
    private String customerName;
    private double unitPrice;
    
    // Constructors
    public ServiceBooking() {
    }
    
    public ServiceBooking(int userId, int serviceId, Date usageDate, int quantity, double totalAmount) {
        this.userId = userId;
        this.serviceId = serviceId;
        this.usageDate = usageDate;
        this.quantity = quantity;
        this.totalAmount = totalAmount;
        this.bookingDate = new Date();
        this.createdAt = new Date();
        this.status = "Pending";
    }
    
    // Getters and Setters
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
    
    public int getServiceId() {
        return serviceId;
    }
    
    public void setServiceId(int serviceId) {
        this.serviceId = serviceId;
    }
    
    public Date getBookingDate() {
        return bookingDate;
    }
    
    public void setBookingDate(Date bookingDate) {
        this.bookingDate = bookingDate;
    }
    
    public Date getUsageDate() {
        return usageDate;
    }
    
    public void setUsageDate(Date usageDate) {
        this.usageDate = usageDate;
    }
    
    public int getQuantity() {
        return quantity;
    }
    
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
    
    public double getTotalAmount() {
        return totalAmount;
    }
    
    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public Date getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
    
    public String getServiceName() {
        return serviceName;
    }
    
    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }
    
    public String getCustomerName() {
        return customerName;
    }
    
    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }
    
    public double getUnitPrice() {
        return unitPrice;
    }
    
    public void setUnitPrice(double unitPrice) {
        this.unitPrice = unitPrice;
    }
} 