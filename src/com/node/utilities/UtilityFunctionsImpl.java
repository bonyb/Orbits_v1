package com.node.utilities;

import java.security.InvalidKeyException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import javax.crypto.spec.SecretKeySpec;

public class UtilityFunctionsImpl {

	/**
	 * To allow apostrophes in the text
	 * 
	 * @param textArg1
	 * @param textArg2
	 * @return
	 */
	public String[] setEcsapeTitleDesc(String textArg1, String textArg2) {
		if (!textArg1.isEmpty()) {
			StringBuilder titleEscape = new StringBuilder(textArg1);
			int index = titleEscape.indexOf("'");
			while (index > 0) {
				titleEscape.insert(index, '\'');
				index = titleEscape.indexOf("'", index + 2);
			}
			textArg1 = titleEscape.toString();
		}

		if (textArg2 != null) {
			StringBuilder descEscape = new StringBuilder(textArg2);
			int indexd = descEscape.indexOf("'");
			while (indexd > 0) {
				descEscape.insert(indexd, '\'');
				indexd = descEscape.indexOf("'", indexd + 2);
			}
			textArg2 = descEscape.toString();

		}
		String[] escapetexts = { textArg1, textArg2 };
		return escapetexts;
	}

	/**
	 * To get the current date time and convert it to the correct format for
	 * saving in the DB
	 * 
	 * @return
	 * @throws ParseException
	 */
	public String getCuttentDateTime() throws ParseException {
		// SimpleDateFormat ft = new SimpleDateFormat
		// ("dd MMM yyyy hh:mm:ss a ");
		SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		// String curr= new Date().toString();
		String curr = ft.format(new Date());
		// System.out.println(curr);
		return curr;

	}

	/**
	 * TO display the date & time in a particular for the JSP page
	 * 
	 * @param result
	 * @return
	 * @throws SQLException
	 */
	public String setDisplayTime(String dt) throws SQLException {

		SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String curr = new String();
		try {
			// parset the string and create date object
			Date t = ft.parse(dt);

			// to format the date in the desired format
			SimpleDateFormat newft = new SimpleDateFormat(
					"dd MMM yyyy hh:mm:ss a ");
			curr = newft.format(t);
			// System.out.println(curr);
		} catch (ParseException e) {
			System.out.println("Unparseable using " + ft);
		}
		return curr;

	}

	
	/**
	 * Ecrypt password
	 * @param password
	 * @return
	 */
	public String encryptPassword(String password) {
		String passphrase = "correct horse battery staple";
		byte[] salt = "choose a better salt".getBytes();
		int iterations = 10000;
		SecretKeyFactory factory;
		try {
			factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA1");
		
		SecretKey tmp = factory.generateSecret(new PBEKeySpec(passphrase.toCharArray(), salt, iterations, 128));
		SecretKeySpec key = new SecretKeySpec(tmp.getEncoded(), "AES");
		
		Cipher aes = Cipher.getInstance("AES/ECB/PKCS5Padding");
		aes.init(Cipher.ENCRYPT_MODE, key);
		byte[] ciphertext = aes.doFinal(password.getBytes());
		return ciphertext.toString();
		
		} catch (NoSuchAlgorithmException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InvalidKeySpecException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (NoSuchPaddingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InvalidKeyException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IllegalBlockSizeException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (BadPaddingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}
	
	public String hashPassword(String cleartext){
		MessageDigest md;
		try {
			md = MessageDigest.getInstance("SHA-256");
		
        md.update(cleartext.getBytes());
 
        byte byteData[] = md.digest();

		StringBuffer hexString = new StringBuffer();
    	for (int i=0;i<byteData.length;i++) {
    		String hex=Integer.toHexString(0xff & byteData[i]);
   	     	if(hex.length()==1) hexString.append('0');
   	     	hexString.append(hex);
    	}
    	return hexString.toString();
		} catch (NoSuchAlgorithmException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}
	
	/**
	 * Ecrypt password
	 * @param password
	 * @return
	 */
	public String decryptPassword(String encryptedpassword) {
		byte[] value = encryptedpassword.getBytes();
		String passphrase = "correct horse battery staple";
		byte[] salt = "choose a better salt".getBytes();
		int iterations = 10000;
		SecretKeyFactory factory;
		try {
			factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA1");
		
		SecretKey tmp = factory.generateSecret(new PBEKeySpec(passphrase.toCharArray(), salt, iterations, 128));
		SecretKeySpec key = new SecretKeySpec(tmp.getEncoded(), "AES");
		
		Cipher aes = Cipher.getInstance("AES/ECB/PKCS5Padding");
		aes.init(Cipher.DECRYPT_MODE, key);
		String cleartext = new String(aes.doFinal(value));
		return cleartext;
		
		} catch (NoSuchAlgorithmException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InvalidKeySpecException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (NoSuchPaddingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InvalidKeyException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IllegalBlockSizeException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (BadPaddingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}
}
