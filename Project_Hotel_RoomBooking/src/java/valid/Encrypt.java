package valid;

import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;
import java.util.Base64;
import java.util.Scanner;
import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;

public class Encrypt {

    private static final String ALGORITHM = "AES";
    private static final String SECRET_KEY = "mahoadacbietcuatoiladay!"; // 24 ký tự cho AES-128

    public static String encrypt(String plainText) {
        try {
            SecretKeySpec key = new SecretKeySpec(SECRET_KEY.getBytes(), ALGORITHM);
            Cipher cipher = Cipher.getInstance(ALGORITHM);
            cipher.init(Cipher.ENCRYPT_MODE, key);

            byte[] encryptedBytes = cipher.doFinal(plainText.getBytes());
            return Base64.getEncoder().encodeToString(encryptedBytes);

        } catch (InvalidKeyException | NoSuchAlgorithmException | BadPaddingException | IllegalBlockSizeException | NoSuchPaddingException e) {
            throw new RuntimeException("Lỗi mã hóa AES", e);
        }
    }

    public static String decrypt(String encryptedText) {
        try {
            SecretKeySpec key = new SecretKeySpec(SECRET_KEY.getBytes(), ALGORITHM);
            Cipher cipher = Cipher.getInstance(ALGORITHM);
            cipher.init(Cipher.DECRYPT_MODE, key);

            byte[] decodedBytes = Base64.getDecoder().decode(encryptedText);
            byte[] decryptedBytes = cipher.doFinal(decodedBytes);
            return new String(decryptedBytes);
        } catch (InvalidKeyException | NoSuchAlgorithmException | BadPaddingException | IllegalBlockSizeException | NoSuchPaddingException e) {
            throw new RuntimeException("Lỗi giải mã AES", e);
        }
    }

    // ✅ Hàm main để test
    public static void main(String[] args) {
//        Scanner scanner = new Scanner(System.in);

        System.out.print("Nhập chuỗi cần mã hóa: ");
//        String input = scanner.nextLine();

//        String encrypted = encrypt(input);
        String decrypted = decrypt("iOIn6rY20XzbTxNEc2fEuQ==");

//        System.out.println("🔐 Đã mã hóa: " + encrypted);
        System.out.println("🔓 Giải mã lại : " + decrypted);
    }
}
