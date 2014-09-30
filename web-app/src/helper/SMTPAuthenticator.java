package helper;

import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;
import config.Config;

public class SMTPAuthenticator extends Authenticator {

   public SMTPAuthenticator() {
        // TODO Auto-generated constructor stub
   }
   
   @Override
   public PasswordAuthentication getPasswordAuthentication() {
       String username = Config.getProperty("fromusername");
       String password = Config.getProperty("frompassword");
       if ((username != null) && (username.length() > 0) && (password != null) && (password.length () > 0)) {
           return new PasswordAuthentication(username, password);
       }else{
           return null;
       }
   }
}       