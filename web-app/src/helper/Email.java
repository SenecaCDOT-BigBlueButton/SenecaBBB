package helper;

import java.util.*;
import javax.mail.*;
import javax.mail.internet.*;
import config.Config;

public class Email {
    public boolean send(String to,String subject,String messageText){
        boolean flag = false;
        try{
            boolean sessionDebug = false;
            Properties props = System.getProperties(); 
            props.put("mail.host",Config.getProperty("emailhost")); 
            props.put("mail.transport.protocol", Config.getProperty("mailtransportprotocol"));
            props.put("mail.smtp.auth", Config.getProperty("smtpauth")); 
            props.put("mail.smtp.port", Config.getProperty("mailport")); 
            Session mailSession = Session.getDefaultInstance(props, new SMTPAuthenticator()); 
            mailSession.setDebug(sessionDebug); 
            Message msg = new MimeMessage(mailSession); 
            msg.setFrom(new InternetAddress(Config.getProperty("fromemail"))); 
            InternetAddress[] address = {new InternetAddress(to)}; 
            msg.setRecipients(Message.RecipientType.TO, address);
            msg.setSubject(subject); msg.setSentDate(new Date()); 
            msg.setContent(messageText+"<p>"+ Config.getProperty("emailsignature") +"</p>","text/html");
            Transport transport = mailSession.getTransport("smtp");
            transport.connect();
            transport.sendMessage(msg, msg.getAllRecipients()); 
            transport.close(); 
            flag = true;
        }
        catch(Exception e){
            GetExceptionLog elog = new GetExceptionLog();
            elog.writeLog("[SendEmail: ] " + e.getMessage() + "/n"+ e.getStackTrace().toString());
        }
        return flag;
    }

}
