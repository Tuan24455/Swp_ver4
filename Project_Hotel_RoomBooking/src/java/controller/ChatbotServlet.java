package controller;

import service.GeminiService;
import service.HotelDataService;
import model.ChatLog;
import model.User;
import dao.ChatLogDao;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.UUID;

/**
 * Servlet for handling chatbot interactions
 */
@WebServlet(name = "ChatbotServlet", urlPatterns = {"/chatbot"})
public class ChatbotServlet extends HttpServlet {
    
    private GeminiService geminiService;
    private HotelDataService hotelDataService;
    private ChatLogDao chatLogDao;
    
    @Override
    public void init() throws ServletException {
        super.init();
        this.geminiService = new GeminiService();
        this.hotelDataService = new HotelDataService();
        this.chatLogDao = new ChatLogDao();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Set response content type and encoding
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        // Enable CORS if needed
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "POST");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type");
        
        PrintWriter out = response.getWriter();
        
        try {
            // Read request body
            StringBuilder sb = new StringBuilder();
            try (BufferedReader reader = request.getReader()) {
                String line;
                while ((line = reader.readLine()) != null) {
                    sb.append(line);
                }
            }
            
            String requestBody = sb.toString();
            if (requestBody.trim().isEmpty()) {
                sendErrorResponse(out, "Không có dữ liệu đầu vào");
                return;
            }
            
            // Parse JSON request
            JsonObject jsonRequest = JsonParser.parseString(requestBody).getAsJsonObject();
            
            if (!jsonRequest.has("message")) {
                sendErrorResponse(out, "Thiếu thông điệp");
                return;
            }
            
            String userMessage = jsonRequest.get("message").getAsString().trim();
            
            if (userMessage.isEmpty()) {
                sendErrorResponse(out, "Thông điệp trống");
                return;
            }
            
            // Get session information
            HttpSession session = request.getSession();
            String sessionId = session.getId();
            
            // Get user information if logged in
            User user = (User) session.getAttribute("user");
            int userId = (user != null) ? user.getId() : 0; // 0 for anonymous users
            
            // Check for special commands
            if (userMessage.toLowerCase().equals("/clear") || userMessage.toLowerCase().equals("/end")) {
                chatLogDao.clearChatHistory(sessionId);
                JsonObject clearResponse = new JsonObject();
                clearResponse.addProperty("success", true);
                clearResponse.addProperty("message", "Cuộc hội thoại đã được xóa. Bạn có thể bắt đầu cuộc trò chuyện mới!");
                clearResponse.addProperty("action", "clear_chat");
                clearResponse.addProperty("timestamp", System.currentTimeMillis());
                out.print(clearResponse.toString());
                return;
            }
            
            // Get chat history for context
            List<ChatLog> chatHistory = chatLogDao.getChatHistory(sessionId, 5); // Last 5 exchanges
            StringBuilder historyBuilder = new StringBuilder();
            
            for (ChatLog log : chatHistory) {
                historyBuilder.append("Người dùng: ").append(log.getUserMessage()).append("\n");
                historyBuilder.append("Bot: ").append(log.getBotResponse()).append("\n\n");
            }
            
            String chatHistoryString = historyBuilder.toString().trim();
            
            // Get system prompt based on page context
            String referer = request.getHeader("Referer");
            String baseUrl = getBaseUrl(request);
            String systemPrompt;
            
            if (referer != null && referer.contains("/service")) {
                systemPrompt = hotelDataService.getServicePagePrompt();
            } else {
                systemPrompt = hotelDataService.getSystemPrompt();
            }
            
            // Add base URL context for link generation
            systemPrompt += "\n\nBASE_URL cho link: " + baseUrl + "/\n" +
                          "Khi tạo link, sử dụng: [Xem chi tiết](room-detail?id=ROOM_ID)";
            
            // Get response from Gemini with history context
            String botResponse = geminiService.getChatResponse(userMessage, systemPrompt, chatHistoryString);
            
            // Save chat log
            saveChatLog(userId, userMessage, botResponse, sessionId);
            
            // Send response
            JsonObject jsonResponse = new JsonObject();
            jsonResponse.addProperty("success", true);
            jsonResponse.addProperty("message", botResponse);
            jsonResponse.addProperty("timestamp", System.currentTimeMillis());
            
            out.print(jsonResponse.toString());
            
        } catch (Exception e) {
            System.err.println("Error in ChatbotServlet: " + e.getMessage());
            e.printStackTrace();
            sendErrorResponse(out, "Lỗi hệ thống. Vui lòng thử lại sau.");
        } finally {
            out.flush();
            out.close();
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        
        // Return chatbot status
        JsonObject status = new JsonObject();
        status.addProperty("service", "Hotel Chatbot");
        status.addProperty("status", "active");
        status.addProperty("message", "Chatbot service is running");
        
        out.print(status.toString());
        out.flush();
        out.close();
    }
    
    /**
     * Send error response
     */
    private void sendErrorResponse(PrintWriter out, String errorMessage) {
        JsonObject errorResponse = new JsonObject();
        errorResponse.addProperty("success", false);
        errorResponse.addProperty("error", errorMessage);
        errorResponse.addProperty("message", "Xin lỗi, tôi đang gặp sự cố. Vui lòng thử lại sau.");
        
        out.print(errorResponse.toString());
    }
    
    /**
     * Save chat log to database
     */
    private void saveChatLog(int userId, String userMessage, String botResponse, String sessionId) {
        try {
            ChatLog chatLog = new ChatLog(userId, userMessage, botResponse, sessionId);
            chatLogDao.saveChatLog(chatLog);
        } catch (Exception e) {
            System.err.println("Failed to save chat log: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * Get base URL from request
     */
    private String getBaseUrl(HttpServletRequest request) {
        String scheme = request.getScheme();
        String serverName = request.getServerName();
        int serverPort = request.getServerPort();
        String contextPath = request.getContextPath();
        
        StringBuilder baseUrl = new StringBuilder();
        baseUrl.append(scheme).append("://").append(serverName);
        
        if ((scheme.equals("http") && serverPort != 80) || 
            (scheme.equals("https") && serverPort != 443)) {
            baseUrl.append(":").append(serverPort);
        }
        
        baseUrl.append(contextPath);
        return baseUrl.toString();
    }
}
