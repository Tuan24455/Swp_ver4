package valid;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import org.junit.Test;
import static org.junit.Assert.*;

public class InputValidatorTest {

    // ---------- TC01: Kiểm thử isValidEmail ----------
    @Test
    public void testIsValidEmail() {
        assertTrue(InputValidator.isValidEmail("a.b@example.com"));     // TC01.1: Email hợp lệ → true
        assertFalse(InputValidator.isValidEmail("invalid-email"));      // TC01.2: Không đúng format → false
        assertFalse(InputValidator.isValidEmail(null));                 // TC01.3: null → false
    }

    // ---------- TC02: Kiểm thử isValidPhone ----------
    @Test
    public void testIsValidPhone() {
        assertTrue(InputValidator.isValidPhone("0123456789"));          // TC02.1: Số hợp lệ → true
        assertFalse(InputValidator.isValidPhone("123456789"));          // TC02.2: Thiếu số → false
        assertFalse(InputValidator.isValidPhone("phone123"));           // TC02.3: Chứa ký tự chữ → false
        assertFalse(InputValidator.isValidPhone(null));                 // TC02.4: null → false
    }

    // ---------- TC03: Kiểm thử isValidPassword ----------
    @Test
    public void testIsValidPassword() {
        assertTrue(InputValidator.isValidPassword("Abcd1234"));         // TC03.1: Đủ điều kiện → true
        assertFalse(InputValidator.isValidPassword("abcd1234"));        // TC03.2: Thiếu chữ hoa → false
        assertFalse(InputValidator.isValidPassword("ABCD1234"));        // TC03.3: Thiếu chữ thường → false
        assertFalse(InputValidator.isValidPassword("Abcdefgh"));        // TC03.4: Thiếu số → false
        assertFalse(InputValidator.isValidPassword("A1b"));             // TC03.5: Quá ngắn → false
        assertFalse(InputValidator.isValidPassword(null));              // TC03.6: null → false
    }

    // ---------- TC04: Kiểm thử isValidUsername ----------
    @Test
    public void testIsValidUsername() {
        assertTrue(InputValidator.isValidUsername("username"));         // TC04.1: Độ dài hợp lệ (8+) → true
        assertFalse(InputValidator.isValidUsername("user"));            // TC04.2: Ngắn < 8 → false
        assertFalse(InputValidator.isValidUsername(null));              // TC04.3: null → false
    }

    // ---------- TC05: Kiểm thử isAtLeast18YearsOld ----------
    @Test
    public void testIsAtLeast18YearsOld() {
        Calendar c = Calendar.getInstance();
        c.add(Calendar.YEAR, -20);
        assertTrue(InputValidator.isAtLeast18YearsOld(c.getTime()));   // TC05.1: Trên 18 tuổi → true

        c = Calendar.getInstance();
        c.add(Calendar.YEAR, -17);
        assertFalse(InputValidator.isAtLeast18YearsOld(c.getTime()));  // TC05.2: Dưới 18 tuổi → false

        assertFalse(InputValidator.isAtLeast18YearsOld(null));         // TC05.3: null → false
    }

    // ---------- TC06: Kiểm thử parseDate ----------
    @Test
    public void testParseDate() throws Exception {
        Date expected = new SimpleDateFormat("yyyy-MM-dd").parse("2020-01-01");
        assertEquals(expected, InputValidator.parseDate("2020-01-01")); // TC06.1: Chuỗi hợp lệ → Date đúng

        try {
            InputValidator.parseDate("invalid-date");                   // TC06.2: Sai định dạng → ParseException
            fail("Expected ParseException");
        } catch (ParseException e) {
            // expected
        }
    }

    // ---------- TC07: Kiểm thử isValidPriceRange ----------
    @Test
    public void testIsValidPriceRange() {
        assertTrue(InputValidator.isValidPriceRange(10.0, 20.0));       // TC07.1: from ≤ to → true
        assertFalse(InputValidator.isValidPriceRange(30.0, 20.0));      // TC07.2: from > to → false
        assertTrue(InputValidator.isValidPriceRange(null, 20.0));       // TC07.3: from = null → true
        assertTrue(InputValidator.isValidPriceRange(null, null));       // TC07.4: cả 2 null → true
    }

    // ---------- TC08: Kiểm thử isValidDateRange ----------
    @Test
    public void testIsValidDateRange() throws ParseException {
        Date d1 = InputValidator.parseDate("2023-01-01");
        Date d2 = InputValidator.parseDate("2023-12-31");

        assertTrue(InputValidator.isValidDateRange(d1, d2));            // TC08.1: from ≤ to → true
        assertFalse(InputValidator.isValidDateRange(d2, d1));           // TC08.2: from > to → false
        assertTrue(InputValidator.isValidDateRange(null, d2));          // TC08.3: from = null → true
        assertTrue(InputValidator.isValidDateRange(null, null));        // TC08.4: cả 2 null → true
    }

    // ---------- TC09: Kiểm thử parseDateOrNull ----------
    @Test
    public void testParseDateOrNull() {
        assertNotNull(InputValidator.parseDateOrNull("2023-01-01"));   // TC09.1: Đúng format → không null
        assertNull(InputValidator.parseDateOrNull("not-a-date"));      // TC09.2: Sai format → null
        assertNull(InputValidator.parseDateOrNull(""));                // TC09.3: Chuỗi rỗng → null
        assertNull(InputValidator.parseDateOrNull(null));              // TC09.4: null → null
    }

    // ---------- TC10: Kiểm thử parseIntegerOrNull ----------
    @Test
    public void testParseIntegerOrNull() {
        assertEquals(Integer.valueOf(123), InputValidator.parseIntegerOrNull("123")); // TC10.1: Hợp lệ → 123
        assertNull(InputValidator.parseIntegerOrNull("abc"));          // TC10.2: Sai format → null
        assertNull(InputValidator.parseIntegerOrNull(""));             // TC10.3: Chuỗi rỗng → null
        assertNull(InputValidator.parseIntegerOrNull(null));           // TC10.4: null → null
    }

    // ---------- TC11: Kiểm thử parseDoubleOrNull ----------
    @Test
    public void testParseDoubleOrNull() {
        assertEquals(Double.valueOf(12.34), InputValidator.parseDoubleOrNull("12.34")); // TC11.1: Hợp lệ
        assertNull(InputValidator.parseDoubleOrNull("abc"));         // TC11.2: Sai format → null
        assertNull(InputValidator.parseDoubleOrNull(""));            // TC11.3: Chuỗi rỗng → null
        assertNull(InputValidator.parseDoubleOrNull(null));          // TC11.4: null → null
    }

    // ---------- TC12: Kiểm thử parseIntegerOrDefault ----------
    @Test
    public void testParseIntegerOrDefault() {
        assertEquals(10, InputValidator.parseIntegerOrDefault("10", 5));   // TC12.1: Hợp lệ → 10
        assertEquals(5, InputValidator.parseIntegerOrDefault("abc", 5));   // TC12.2: Sai format → default
        assertEquals(7, InputValidator.parseIntegerOrDefault("", 7));      // TC12.3: Rỗng → default
    }
}
