package util;

public class JsonEscapeUtil {
    
    public static String escapeJsonForJSP(String jsonString) {
        if (jsonString == null) {
            return "{}";
        }
        
        // Escape quotes and other special characters for JSP
        return jsonString
                .replace("\\", "\\\\")  // Escape backslashes first
                .replace("\"", "\\\"")   // Escape double quotes
                .replace("'", "\\'")     // Escape single quotes
                .replace("\n", "\\n")    // Escape newlines
                .replace("\r", "\\r")    // Escape carriage returns
                .replace("\t", "\\t");   // Escape tabs
    }
    
    public static String unescapeJsonFromJSP(String escapedJson) {
        if (escapedJson == null) {
            return "{}";
        }
        
        return escapedJson
                .replace("\\\"", "\"")   // Unescape double quotes
                .replace("\\'", "'")     // Unescape single quotes
                .replace("\\n", "\n")    // Unescape newlines
                .replace("\\r", "\r")    // Unescape carriage returns
                .replace("\\t", "\t")    // Unescape tabs
                .replace("\\\\", "\\");  // Unescape backslashes last
    }
}
