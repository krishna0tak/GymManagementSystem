package p1;

import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.Random;
import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;

/**
 * Shared AES encryption utility for PowerFit Gym Management System.
 * Centralises the AES key and cipher logic so no servlet needs to duplicate it.
 */
public class AESUtil {

    private static final String AES_KEY = "1234567890abcdef";

    /**
     * Encrypts plaintext using AES/ECB and returns a Base64-encoded string.
     */
    public static String encryptAES(String data) throws Exception {
        SecretKeySpec key = new SecretKeySpec(
                AES_KEY.getBytes(StandardCharsets.UTF_8), "AES");
        Cipher cipher = Cipher.getInstance("AES");
        cipher.init(Cipher.ENCRYPT_MODE, key);
        return Base64.getEncoder().encodeToString(
                cipher.doFinal(data.getBytes(StandardCharsets.UTF_8)));
    }

    /**
     * Generates a random 8-character alphanumeric+symbol password.
     * Used by ForgotPasswordServlet.
     */
    public static String generateRandomPassword() {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@#$";
        StringBuilder sb = new StringBuilder();
        Random rnd = new Random();
        for (int i = 0; i < 8; i++) {
            sb.append(chars.charAt(rnd.nextInt(chars.length())));
        }
        return sb.toString();
    }
}
