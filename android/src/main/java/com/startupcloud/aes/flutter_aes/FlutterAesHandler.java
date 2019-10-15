package com.startupcloud.aes.flutter_aes;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;


/**
 * @author luopeng
 * Created at 2019-10-15 10:38
 */
public class FlutterAesHandler {
    private static String ALGORITHM = "AES/CBC/PKCS5Padding";

    private static byte[] iv = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };

    public static String encrypt(String key, String cleartext) throws Exception {
        SecretKeySpec skeySpec = new SecretKeySpec(toByte(key), "AES");
        Cipher cipher = Cipher.getInstance(ALGORITHM);
        IvParameterSpec ivc =  new IvParameterSpec(iv);
        cipher.init(Cipher.ENCRYPT_MODE, skeySpec, ivc);
        byte[] encrypted = cipher.doFinal(cleartext.getBytes("utf-8"));
        return Base64.encode(encrypted);
    }

    public static String decrypt(String key, String encrypted) throws Exception {
        SecretKeySpec skeySpec = new SecretKeySpec(toByte(key), ALGORITHM);
        byte[] enc = Base64.decode(encrypted);
        Cipher cipher = Cipher.getInstance(ALGORITHM);
        IvParameterSpec ivc =  new IvParameterSpec(iv);
        cipher.init(Cipher.DECRYPT_MODE, skeySpec, ivc);
        byte[] decrypted = cipher.doFinal(enc);
        return new String(decrypted);
    }

    private static String toHex(String txt) {
        return toHex(txt.getBytes());
    }

    private static String fromHex(String hex) {
        return new String(toByte(hex));
    }

    private static byte[] toByte(String hexString) {
        int len = hexString.length() / 2;
        byte[] result = new byte[len];
        for (int i = 0; i < len; i++) {
            result[i] = Integer.valueOf(hexString.substring(2 * i, 2 * i + 2), 16).byteValue();
        }
        return result;
    }

    private static String toHex(byte[] buf) {
        if (buf == null) {
            return "";
        }
        StringBuffer result = new StringBuffer(2 * buf.length);
        for (int i = 0; i < buf.length; i++) {
            appendHex(result, buf[i]);
        }
        return result.toString();
    }

    private final static String HEX = "0123456789ABCDEF";

    private static void appendHex(StringBuffer sb, byte b) {
        sb.append(HEX.charAt((b >> 4) & 0x0f)).append(HEX.charAt(b & 0x0f));
    }
}
