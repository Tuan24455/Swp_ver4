package model;

/**
 * DTO đại diện cho tồn kho.
 */
public class StockItem {
    private int id;
    private String itemName;
    private String category;
    private int remainingStock;
    private double unitPrice;
    private int minRequired;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public int getRemainingStock() {
        return remainingStock;
    }

    public void setRemainingStock(int remainingStock) {
        this.remainingStock = remainingStock;
    }

    public double getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(double unitPrice) {
        this.unitPrice = unitPrice;
    }

    public int getMinRequired() {
        return minRequired;
    }

    public void setMinRequired(int minRequired) {
        this.minRequired = minRequired;
    }

    public double getTotalValue() {
        return unitPrice * remainingStock;
    }
    
    public boolean isLowStock() {
        return remainingStock <= minRequired && minRequired > 0;
    }
    
    public String getStockStatus() {
        if (minRequired <= 0) return "normal";
        if (remainingStock <= 0) return "out-of-stock";
        if (remainingStock <= minRequired) return "low-stock";
        if (remainingStock <= minRequired * 1.5) return "warning";
        return "normal";
    }
}
