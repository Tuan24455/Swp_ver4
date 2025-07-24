package config;

/**
 * Configuration class for Gemini AI API
 */
public class GeminiConfig {
    // Gemini API endpoint
    public static final String GEMINI_API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent";
    
    // API Key from ApiKeys class
    public static final String API_KEY = ApiKeys.GEMINI_API_KEY;
    
    // Model configuration
    public static final String MODEL_NAME = "gemini-pro";
    
    // Generation config parameters
    public static final double TEMPERATURE = 0.7;
    public static final int MAX_OUTPUT_TOKENS = 1000;
    public static final double TOP_P = 0.8;
    public static final int TOP_K = 40;
    
    // Safety settings (block none to allow hotel-related content)
    public static final String SAFETY_CATEGORY_HARASSMENT = "BLOCK_NONE";
    public static final String SAFETY_CATEGORY_HATE_SPEECH = "BLOCK_NONE";
    public static final String SAFETY_CATEGORY_SEXUALLY_EXPLICIT = "BLOCK_NONE";
    public static final String SAFETY_CATEGORY_DANGEROUS_CONTENT = "BLOCK_NONE";
}
