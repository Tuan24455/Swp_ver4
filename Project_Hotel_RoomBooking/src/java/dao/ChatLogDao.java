package dao;

import dal.DBContext;
import model.ChatLog;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO class for handling chat log operations
 */
public class ChatLogDao extends DBContext {
    
    /**
     * Save a chat log entry
     * @param chatLog ChatLog object to save
     * @return boolean indicating success
     */
    public boolean saveChatLog(ChatLog chatLog) {
        String sql = "INSERT INTO chat_logs (user_id, user_message, bot_response, session_id, timestamp) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, chatLog.getUserId());
            ps.setString(2, chatLog.getUserMessage());
            ps.setString(3, chatLog.getBotResponse());
            ps.setString(4, chatLog.getSessionId());
            ps.setTimestamp(5, Timestamp.valueOf(chatLog.getTimestamp()));
            
            int result = ps.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.err.println("Error saving chat log: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Get chat history for a specific session
     * @param sessionId Session ID
     * @param limit Maximum number of messages to retrieve
     * @return List of ChatLog entries
     */
    public List<ChatLog> getChatHistory(String sessionId, int limit) {
        List<ChatLog> history = new ArrayList<>();
        String sql = "SELECT TOP (?) user_message, bot_response, timestamp FROM chat_logs " +
                    "WHERE session_id = ? ORDER BY timestamp DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, limit);
            ps.setString(2, sessionId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ChatLog chatLog = new ChatLog();
                    chatLog.setUserMessage(rs.getString("user_message"));
                    chatLog.setBotResponse(rs.getString("bot_response"));
                    chatLog.setTimestamp(rs.getTimestamp("timestamp").toLocalDateTime());
                    chatLog.setSessionId(sessionId);
                    history.add(chatLog);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error retrieving chat history: " + e.getMessage());
            e.printStackTrace();
        }
        
        // Reverse to get chronological order (oldest first)
        List<ChatLog> chronological = new ArrayList<>();
        for (int i = history.size() - 1; i >= 0; i--) {
            chronological.add(history.get(i));
        }
        
        return chronological;
    }
    
    /**
     * Clear chat history for a specific session
     * @param sessionId Session ID to clear
     * @return boolean indicating success
     */
    public boolean clearChatHistory(String sessionId) {
        String sql = "DELETE FROM chat_logs WHERE session_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, sessionId);
            int result = ps.executeUpdate();
            return result >= 0; // Even 0 rows affected is considered success
            
        } catch (SQLException e) {
            System.err.println("Error clearing chat history: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Get recent chat sessions
     * @param userId User ID (0 for anonymous)
     * @param limit Maximum number of sessions
     * @return List of session IDs
     */
    public List<String> getRecentSessions(int userId, int limit) {
        List<String> sessions = new ArrayList<>();
        String sql = "SELECT DISTINCT TOP (?) session_id FROM chat_logs " +
                    "WHERE user_id = ? ORDER BY MAX(timestamp) DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, limit);
            ps.setInt(2, userId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    sessions.add(rs.getString("session_id"));
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error retrieving recent sessions: " + e.getMessage());
            e.printStackTrace();
        }
        
        return sessions;
    }
} 