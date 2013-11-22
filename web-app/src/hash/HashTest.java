package hash;

import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;

public class HashTest {

    /**
     * @param args
     * @throws InvalidKeySpecException 
     * @throws NoSuchAlgorithmException 
     */
    public static void main(String[] args) throws NoSuchAlgorithmException, InvalidKeySpecException {
        // TODO Auto-generated method stub
        PasswordHash hash = new PasswordHash();
        String newSalt = hash.createRandomSalt();
        String newHash = PasswordHash.createHash("11#$qwdQQ$seneca".toCharArray(), newSalt.getBytes());
        System.out.println(newSalt);
        System.out.println(newHash);
    }

}
