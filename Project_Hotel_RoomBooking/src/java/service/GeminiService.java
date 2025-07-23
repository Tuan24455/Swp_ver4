package service;

import config.GeminiConfig;
import com.google.gson.JsonObject;
import com.google.gson.JsonArray;
import com.google.gson.JsonParser;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

/**
 * Service class for interacting with Google Gemini AI API
 */
public class GeminiService {
    
    private static final String USER_AGENT = "HotelManagementSystem/1.0";
    
    /**
     * Send a message to Gemini and get response
     * @param message User message
     * @param systemPrompt System prompt with context
     * @return AI response
     * @throws IOException if API call fails
     */
    public String getChatResponse(String message, String systemPrompt) throws IOException {
        return getChatResponse(message, systemPrompt, null);
    }
    
    /**
     * Send a message to Gemini with chat history and get response
     * @param message User message
     * @param systemPrompt System prompt with context
     * @param chatHistory Previous conversation history
     * @return AI response
     * @throws IOException if API call fails
     */
    public String getChatResponse(String message, String systemPrompt, String chatHistory) throws IOException {
        // Check if API key is configured
        if (GeminiConfig.API_KEY == null || GeminiConfig.API_KEY.equals("YOUR_GEMINI_API_KEY_HERE")) {
            System.err.println("API Key not configured: " + GeminiConfig.API_KEY);
            return "Xin lỗi, dịch vụ chatbot hiện chưa được cấu hình. Vui lòng liên hệ quản trị viên.";
        }
        
        System.out.println("Using API key: " + GeminiConfig.API_KEY.substring(0, 10) + "...");
        
        try {
            // Prepare the request
            URL url = new URL(GeminiConfig.GEMINI_API_URL + "?key=" + GeminiConfig.API_KEY);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            
            // Set request properties
            connection.setRequestMethod("POST");
            connection.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
            connection.setRequestProperty("User-Agent", USER_AGENT);
            connection.setDoOutput(true);
            
            // Build request body with chat history
            JsonObject requestBody = buildRequestBody(message, systemPrompt, chatHistory);
            
            System.out.println("Sending request to: " + url.toString());
            System.out.println("Request body: " + requestBody.toString());
            
            // Send request
            try (OutputStreamWriter writer = new OutputStreamWriter(connection.getOutputStream(), StandardCharsets.UTF_8)) {
                writer.write(requestBody.toString());
                writer.flush();
            }
            
            // Get response
            int responseCode = connection.getResponseCode();
            if (responseCode == 200) {
                StringBuilder response = new StringBuilder();
                try (BufferedReader reader = new BufferedReader(
                        new InputStreamReader(connection.getInputStream(), StandardCharsets.UTF_8))) {
                    String line;
                    while ((line = reader.readLine()) != null) {
                        response.append(line);
                    }
                }
                
                return parseResponse(response.toString());
            } else {
                // Handle error response
                StringBuilder errorResponse = new StringBuilder();
                try (BufferedReader reader = new BufferedReader(
                        new InputStreamReader(connection.getErrorStream(), StandardCharsets.UTF_8))) {
                    String line;
                    while ((line = reader.readLine()) != null) {
                        errorResponse.append(line);
                    }
                }
                
                System.err.println("Gemini API Error (" + responseCode + "): " + errorResponse.toString());
                System.err.println("Request URL: " + url.toString());
                System.err.println("Request Body: " + requestBody.toString());
                return "Lỗi API (" + responseCode + "): " + errorResponse.toString();
            }
            
        } catch (Exception e) {
            System.err.println("Error calling Gemini API: " + e.getMessage());
            e.printStackTrace();
            return "Lỗi kết nối: " + e.getMessage();
        }
    }
    
    /**
     * Build request body for Gemini API
     * @param userMessage User's message
     * @param systemPrompt System prompt with context
     * @return JsonObject request body
     */
    private JsonObject buildRequestBody(String userMessage, String systemPrompt) {
        return buildRequestBody(userMessage, systemPrompt, null);
    }
    
    /**
     * Build request body for Gemini API with chat history
     * @param userMessage User's message
     * @param systemPrompt System prompt with context
     * @param chatHistory Previous conversation history
     * @return JsonObject request body
     */
    private JsonObject buildRequestBody(String userMessage, String systemPrompt, String chatHistory) {
        JsonObject requestBody = new JsonObject();
        
        // Contents array
        JsonArray contents = new JsonArray();
        
        // System message (if provided)
        if (systemPrompt != null && !systemPrompt.trim().isEmpty()) {
            String fullSystemPrompt = systemPrompt;
            
            // Add chat history to system prompt if available
            if (chatHistory != null && !chatHistory.trim().isEmpty()) {
                fullSystemPrompt += "\n\nLÀICH SỬ HỘI THOẠI TRƯỚC ĐÓ:\n" + chatHistory + 
                                   "\n\nVui lòng trả lời dựa trên ngữ cảnh cuộc hội thoại trên.";
            }
            
            JsonObject systemContent = new JsonObject();
            JsonArray systemParts = new JsonArray();
            JsonObject systemPart = new JsonObject();
            systemPart.addProperty("text", fullSystemPrompt);
            systemParts.add(systemPart);
            systemContent.add("parts", systemParts);
            systemContent.addProperty("role", "user");
            contents.add(systemContent);
        }
        
        // User message
        JsonObject userContent = new JsonObject();
        JsonArray userParts = new JsonArray();
        JsonObject userPart = new JsonObject();
        userPart.addProperty("text", userMessage);
        userParts.add(userPart);
        userContent.add("parts", userParts);
        userContent.addProperty("role", "user");
        contents.add(userContent);
        
        requestBody.add("contents", contents);
        
        // Generation config
        JsonObject generationConfig = new JsonObject();
        generationConfig.addProperty("temperature", GeminiConfig.TEMPERATURE);
        generationConfig.addProperty("maxOutputTokens", GeminiConfig.MAX_OUTPUT_TOKENS);
        generationConfig.addProperty("topP", GeminiConfig.TOP_P);
        generationConfig.addProperty("topK", GeminiConfig.TOP_K);
        requestBody.add("generationConfig", generationConfig);
        
        // Safety settings
        JsonArray safetySettings = new JsonArray();
        addSafetySetting(safetySettings, "HARM_CATEGORY_HARASSMENT", GeminiConfig.SAFETY_CATEGORY_HARASSMENT);
        addSafetySetting(safetySettings, "HARM_CATEGORY_HATE_SPEECH", GeminiConfig.SAFETY_CATEGORY_HATE_SPEECH);
        addSafetySetting(safetySettings, "HARM_CATEGORY_SEXUALLY_EXPLICIT", GeminiConfig.SAFETY_CATEGORY_SEXUALLY_EXPLICIT);
        addSafetySetting(safetySettings, "HARM_CATEGORY_DANGEROUS_CONTENT", GeminiConfig.SAFETY_CATEGORY_DANGEROUS_CONTENT);
        requestBody.add("safetySettings", safetySettings);
        
        return requestBody;
    }
    
    /**
     * Add safety setting to the array
     */
    private void addSafetySetting(JsonArray safetySettings, String category, String threshold) {
        JsonObject setting = new JsonObject();
        setting.addProperty("category", category);
        setting.addProperty("threshold", threshold);
        safetySettings.add(setting);
    }
    
    /**
     * Parse response from Gemini API
     * @param jsonResponse Raw JSON response
     * @return Extracted text response
     */
    private String parseResponse(String jsonResponse) {
        try {
            JsonObject response = JsonParser.parseString(jsonResponse).getAsJsonObject();
            
            if (response.has("candidates")) {
                JsonArray candidates = response.getAsJsonArray("candidates");
                if (candidates.size() > 0) {
                    JsonObject firstCandidate = candidates.get(0).getAsJsonObject();
                    if (firstCandidate.has("content")) {
                        JsonObject content = firstCandidate.getAsJsonObject("content");
                        if (content.has("parts")) {
                            JsonArray parts = content.getAsJsonArray("parts");
                            if (parts.size() > 0) {
                                JsonObject firstPart = parts.get(0).getAsJsonObject();
                                if (firstPart.has("text")) {
                                    return firstPart.get("text").getAsString().trim();
                                }
                            }
                        }
                    }
                }
            }
            
            // If we can't extract the response normally
            return "Xin lỗi, tôi không thể hiểu được câu hỏi của bạn. Vui lòng thử lại hoặc liên hệ trực tiếp với khách sạn.";
            
        } catch (Exception e) {
            System.err.println("Error parsing Gemini response: " + e.getMessage());
            return "Xin lỗi, tôi đang gặp sự cố kỹ thuật. Vui lòng thử lại sau.";
        }
    }
}
