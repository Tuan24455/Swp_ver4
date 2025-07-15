package model;

import java.math.BigDecimal;

/**
 * Represents a single row of data in the purchase report.
 */
public class PurchaseReport {

    private String roomType;
    private int numberOfNights;
    private BigDecimal revenue;
    private BigDecimal averagePrice;

    public PurchaseReport() {
    }

    public PurchaseReport(String roomType, int numberOfNights, BigDecimal revenue, BigDecimal averagePrice) {
        this.roomType = roomType;
        this.numberOfNights = numberOfNights;
        this.revenue = revenue;
        this.averagePrice = averagePrice;
    }

    // Getters and Setters
    public String getRoomType() {
        return roomType;
    }

    public void setRoomType(String roomType) {
        this.roomType = roomType;
    }

    public int getNumberOfNights() {
        return numberOfNights;
    }

    public void setNumberOfNights(int numberOfNights) {
        this.numberOfNights = numberOfNights;
    }

    public BigDecimal getRevenue() {
        return revenue;
    }

    public void setRevenue(BigDecimal revenue) {
        this.revenue = revenue;
    }

    public BigDecimal getAveragePrice() {
        return averagePrice;
    }

    public void setAveragePrice(BigDecimal averagePrice) {
        this.averagePrice = averagePrice;
    }

    @Override
    public String toString() {
        return "PurchaseReport{" +
                "roomType='" + roomType + '\'' +
                ", numberOfNights=" + numberOfNights +
                ", revenue=" + revenue +
                ", averagePrice=" + averagePrice +
                '}';
    }
}
