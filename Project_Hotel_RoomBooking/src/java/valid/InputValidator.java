package valid;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

public class InputValidator {

    public static boolean isValidEmail(String email) {
        return email != null && email.matches("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,6}$");
    }

    public static boolean isValidPhone(String phone) {
        return phone != null && phone.matches("^0\\d{9}$");
    }

    public static boolean isValidPassword(String password) {
        return password != null
                && password.length() >= 8
                && password.length() <= 16
                && password.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[A-Za-z\\d]{8,16}$");
    }

    public static boolean isValidUsername(String username) {
        return username != null && username.length() >= 8;
    }

    public static boolean isAtLeast18YearsOld(Date birthDate) {
        if (birthDate == null) {
            return false;
        }

        // Lấy ngày hiện tại
        Calendar today = Calendar.getInstance();
        // Lấy ngày sinh
        Calendar birth = Calendar.getInstance();
        birth.setTime(birthDate);

        // Tính tuổi
        int age = today.get(Calendar.YEAR) - birth.get(Calendar.YEAR);

        // Nếu chưa đến sinh nhật năm nay thì trừ đi 1
        if (today.get(Calendar.DAY_OF_YEAR) < birth.get(Calendar.DAY_OF_YEAR)) {
            age--;
        }

        return age >= 18;
    }

    public static Date parseDate(String dateStr) throws ParseException {
        return new SimpleDateFormat("yyyy-MM-dd").parse(dateStr);
    }

    // So sánh 2 giá trị Double
    public static boolean isValidPriceRange(Double from, Double to) {
        if (from == null || to == null) {
            return true; // không so sánh nếu thiếu
        }
        return from <= to;
    }

    // So sánh 2 ngày (java.util.Date)
    public static boolean isValidDateRange(Date from, Date to) {
        if (from == null || to == null) {
            return true;
        }
        return !from.after(to); // from ≤ to
    }

    // Parse ngày từ chuỗi (nếu chưa có)
    public static Date parseDateOrNull(String dateStr) {
        try {
            if (dateStr == null || dateStr.trim().isEmpty()) {
                return null;
            }
            return new SimpleDateFormat("yyyy-MM-dd").parse(dateStr);
        } catch (ParseException e) {
            return null;
        }
    }

    public static Integer parseIntegerOrNull(String value) {
        try {
            return (value != null && !value.trim().isEmpty()) ? Integer.valueOf(value) : null;
        } catch (NumberFormatException e) {
            return null;
        }
    }

    public static Double parseDoubleOrNull(String value) {
        try {
            return (value != null && !value.trim().isEmpty()) ? Double.valueOf(value) : null;
        } catch (NumberFormatException e) {
            return null;
        }
    }

    public static int parseIntegerOrDefault(String value, int defaultValue) {
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    public static boolean isValidFullName(String fullName) {
        if (fullName == null) {
            return false;
        }
        String trimmedFullName = fullName.trim();
        // Check if the trimmed string is not empty and contains only letters and spaces
        return !trimmedFullName.isEmpty() && trimmedFullName.matches("^[\\p{L} ]+$");
    }
}
