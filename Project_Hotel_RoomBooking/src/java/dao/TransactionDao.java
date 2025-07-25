package dao;

import dal.DBContext;
import model.Transaction;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;

public class TransactionDao {
    
    private DBContext dbContext;
    
    public TransactionDao() {
        dbContext = new DBContext();
    }
    
    /**
     * Create a new transaction record
     * @param transaction Transaction object to insert
     * @return Generated transaction ID, or -1 if failed
     */
    public int createTransaction(Transaction transaction) {
        String sql = "INSERT INTO Transactions (booking_id, transaction_date, amount, payment_method, status) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, transaction.getBookingId());
            ps.setTimestamp(2, transaction.getTransactionDate());
            ps.setDouble(3, transaction.getAmount());
            ps.setString(4, transaction.getPaymentMethod());
            ps.setString(5, transaction.getStatus());
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1);
                    }
                }
            }
            
        } catch (SQLException e) {
            System.out.println("Error creating transaction: " + e.getMessage());
            e.printStackTrace();
        }
        
        return -1;
    }
    
    /**
     * Update transaction status
     * @param transactionId Transaction ID to update
     * @param status New status
     * @return true if successful, false otherwise
     */
    public boolean updateTransactionStatus(int transactionId, String status) {
        String sql = "UPDATE Transactions SET status = ? WHERE id = ?";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setInt(2, transactionId);
            
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
            
        } catch (SQLException e) {
            System.out.println("Error updating transaction status: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Get transaction by booking ID
     * @param bookingId Booking ID
     * @return Transaction object or null if not found
     */
    public Transaction getTransactionByBookingId(int bookingId) {
        String sql = "SELECT * FROM Transactions WHERE booking_id = ?";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, bookingId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Transaction transaction = new Transaction();
                    transaction.setId(rs.getInt("id"));
                    transaction.setBookingId(rs.getInt("booking_id"));
                    transaction.setTransactionDate(rs.getTimestamp("transaction_date"));
                    transaction.setAmount(rs.getDouble("amount"));
                    transaction.setPaymentMethod(rs.getString("payment_method"));
                    transaction.setStatus(rs.getString("status"));
                    return transaction;
                }
            }
            
        } catch (SQLException e) {
            System.out.println("Error getting transaction by booking ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
}
