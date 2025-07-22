package model;

import java.time.LocalDateTime;

/**
 * Model class for chat log entries
 */
public class ChatLog {
    private int id;
    private int userId;
    private String userMessage;
    private String botResponse;
    private LocalDateTime timestamp;
    private String sessionId;
    
    // Constructors
    public ChatLog() {}
    
    public ChatLog(int userId, String userMessage, String botResponse, String sessionId) {
        this.userId = userId;
        this.userMessage = userMessage;
        this.botResponse = botResponse;
        this.sessionId = sessionId;
        this.timestamp = LocalDateTime.now();
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
    
    public String getUserMessage() {
        return userMessage;
    }
    
    public void setUserMessage(String userMessage) {
        this.userMessage = userMessage;
    }
    
    public String getBotResponse() {
        return botResponse;
    }
    
    public void setBotResponse(String botResponse) {
        this.botResponse = botResponse;
    }
    
    public LocalDateTime getTimestamp() {
        return timestamp;
    }
    
    public void setTimestamp(LocalDateTime timestamp) {
        this.timestamp = timestamp;
    }
    
    public String getSessionId() {
        return sessionId;
    }
    
    public void setSessionId(String sessionId) {
        this.sessionId = sessionId;
    }
}
