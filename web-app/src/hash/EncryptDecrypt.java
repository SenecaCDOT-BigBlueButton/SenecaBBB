package hash;

import helper.GetExceptionLog;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Arrays;
import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;
import org.apache.commons.codec.binary.Base64;

/**
 * Aes encryption
 */
public class EncryptDecrypt {

    private SecretKeySpec secretKey;
    private byte[] key;
    private String decryptedString;
    private String encryptedString;
    private GetExceptionLog elog = new GetExceptionLog();
    
    public void setKey(String myKey) {

        MessageDigest sha = null;
        try {
            key = myKey.getBytes("UTF-8");
            sha = MessageDigest.getInstance("SHA-1");
            key = sha.digest(key);
            key = Arrays.copyOf(key, 16); // use only first 128 bit
            secretKey = new SecretKeySpec(key, "AES");

        } catch (NoSuchAlgorithmException e) {
            elog.writeLog("[EncryptDecrypt setkey:] " + e.getMessage() + "/n"+ e.getStackTrace().toString());           
        } catch (UnsupportedEncodingException e) {
            elog.writeLog("[EncryptDecrypt setkey:] " + e.getMessage() + "/n"+ e.getStackTrace().toString());           
        }

    }

    public String getDecryptedString() {
        return decryptedString;
    }

    public void setDecryptedString(String decryptedString) {
        this.decryptedString = decryptedString;
    }

    public String getEncryptedString() {
        return encryptedString;
    }

    public void setEncryptedString(String encryptedString) {
        this.encryptedString = encryptedString;
    }

    public String encrypt(String strToEncrypt) {
        try {
            Cipher cipher = Cipher.getInstance("AES/ECB/PKCS5Padding");
            cipher.init(Cipher.ENCRYPT_MODE, secretKey);
            setEncryptedString(Base64.encodeBase64String(cipher.doFinal(strToEncrypt.getBytes("UTF-8"))));
        } catch (Exception e) {
            elog.writeLog("[EncryptDecrypt encrypt:] " + e.getMessage() + "/n"+ e.getStackTrace().toString());           
        }
        return null;
    }

    public String decrypt(String strToDecrypt) {
        try {
            Cipher cipher = Cipher.getInstance("AES/ECB/PKCS5PADDING");
            cipher.init(Cipher.DECRYPT_MODE, secretKey);
            setDecryptedString(new String(cipher.doFinal(Base64.decodeBase64(strToDecrypt))));
        } catch (Exception e) {
            elog.writeLog("[EncryptDecrypt decrypt:] " + e.getMessage() + "/n"+ e.getStackTrace().toString());           
        }
        return null;
    }
}
