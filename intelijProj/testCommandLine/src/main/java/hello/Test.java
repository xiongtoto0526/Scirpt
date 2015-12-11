package hello;

        import sun.applet.Main;

        import java.io.IOException;
        import java.security.Security;
        import java.util.Base64;

        import javax.crypto.Cipher;
        import javax.crypto.SecretKey;
        import javax.crypto.SecretKeyFactory;
        import javax.crypto.spec.DESKeySpec;


public class Test {

    private final static String DES = "DES";

    private final static String DES_SPECIFIC = "DES/ECB/PKCS5Padding";

    public final static String UTF8 = "UTF-8";

    private final static String PREFIX="XG_";

    public static String encrypt(String data, String appKey) throws Exception{
        byte[] bt = encryptDecypt(data.getBytes(UTF8),
                getSecreKeyString(appKey).getBytes(), Cipher.ENCRYPT_MODE);
        return Base64.getEncoder().encodeToString(bt);
    }

    public static String decrypt(String data, String appKey) throws IOException, Exception {
        if (data == null) {
            return null;
        }
        byte[] bt = encryptDecypt(Base64.getDecoder().decode(data),
                getSecreKeyString(appKey).getBytes(), Cipher.DECRYPT_MODE);
        return new String(bt, UTF8);
    }

    private static String getSecreKeyString(String appKey) {
        return PREFIX + appKey;
    }

    private static byte[] encryptDecypt(byte[] data, byte[] key, int mode) throws Exception {
        DESKeySpec desKey = new DESKeySpec(key);
        SecretKeyFactory factory = SecretKeyFactory.getInstance(DES);
        SecretKey secretKey = factory.generateSecret(desKey);
        Cipher cipher = Cipher.getInstance(DES_SPECIFIC);
        cipher.init(mode, secretKey);
        return cipher.doFinal(data);
    }

    public static void main(String[] args) throws Exception {
        System.out.println("hello 123");
        Security.addProvider(new org.bouncycastle.jce.provider.BouncyCastleProvider());

        String chinese = "帝国塔防3";

        String key = "45550B8C7C3242CB4CFF409AA4BB98EE";
        String enChinese = Test.encrypt(chinese, key);
        System.out.println("encode:"+enChinese);

        String deChinese = Test.decrypt(enChinese, key);
        System.out.println("decode:"+deChinese);
    }
}
