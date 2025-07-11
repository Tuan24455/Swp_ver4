/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Mai Tien Dung
 */
public class Service {

    private int id;
    private String name;
    private int typeId;
    private String typeName;
    private double price;
    private String description;
    private String imageUrl;

    public Service() {
    }

    public Service(int id, String name, int typeId, double price, String description, String imageUrl) {
        this.id = id;
        this.name = name;
        this.typeId = typeId;
        this.price = price;
        this.description = description;
        this.imageUrl = imageUrl;
    }

    public Service(int id, String name, int typeId, double price, String description, String imageUrl, String typeName) {
        this.id = id;
        this.name = name;
        this.typeId = typeId;
        this.price = price;
        this.description = description;
        this.imageUrl = imageUrl;
        this.typeName = typeName;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getTypeId() {
        return typeId;
    }

    public void setTypeId(int typeId) {
        this.typeId = typeId;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
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

    public String getTypeName() {
        return typeName;
    }

    public void setTypeName(String typeName) {
        this.typeName = typeName;
    }

}
