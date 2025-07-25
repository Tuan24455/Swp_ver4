/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
/**
 *
 * @author Phạm Quốc Tuấn
 */
public class DBContext {

    public Connection connection;

    public DBContext() {
        try {
            // Change the username, password, and URL to match your database settings
            String username = "sa";
<<<<<<< HEAD
            String password = "123456";
=======
            String password = "123";
>>>>>>> 3a90dcb734a8acd8c2ee3fbed49134379c02aa09
            String url = "jdbc:sqlserver://localhost:1433;databaseName=BookingHotel_v4;encrypt=true;trustServerCertificate=true";
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            connection = DriverManager.getConnection(url, username, password);
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public Connection getConnection() throws SQLException {
        // Kiểm tra xem kết nối hiện tại có null hoặc đã đóng không
        if (connection == null || connection.isClosed()) {
            // Tạo kết nối mới nếu cần
            try {
                String username = "sa";
                String password = "123456";
                String url = "jdbc:sqlserver://localhost:1433;databaseName=BookingHotel_v4;encrypt=true;trustServerCertificate=true";
                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                connection = DriverManager.getConnection(url, username, password);
            } catch (ClassNotFoundException | SQLException ex) {
                Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, null, ex);
                throw new SQLException("Failed to establish database connection: " + ex.getMessage(), ex);
            }
        }
        return connection;
    }

    public boolean isConnected() {
        try {
            return connection != null && !connection.isClosed();
        } catch (SQLException ex) {
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
    }

    public static void main(String[] args) {
        DBContext dbContext = new DBContext();
        if (dbContext.isConnected()) {
            System.out.println("Đã kết nối đến cơ sở dữ liệu.");
        } else {
            System.out.println("Chưa kết nối được đến cơ sở dữ liệu.");
        }
    }

}
