package ldap;

import javax.naming.Context;
import javax.naming.NamingEnumeration;
import javax.naming.directory.Attribute;
import javax.naming.directory.Attributes;
import javax.naming.directory.InitialDirContext;
import javax.naming.directory.DirContext;
import javax.naming.directory.SearchControls;
import javax.naming.directory.SearchResult;
import javax.naming.NamingException;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;


//import org.apache.commons.lang.WordUtils;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import config.Config;

import java.io.*;
import java.util.Date;
import java.util.HashMap;
import java.util.Hashtable;

import helper.GetExceptionLog;

public class LDAPAuthenticate {

    private String authenticated;
    private Hashtable<Object, Object> env;
    private DirContext ldapContextNone;
    private SearchControls searchCtrl;
    private String url;
    private String o;
    private String position;
    private String userID;
    private String givenName;
    private String title;
    private Date lastAccess;
    private String emailAddress;
    GetExceptionLog elog = new GetExceptionLog();
    private boolean logout;

    public LDAPAuthenticate() {
        authenticated = "false";
        logout = false;

        //increaseStat(1);
        
        // Get values from the config file
        url = Config.getProperty("ldapurl");
        o = Config.getProperty("ldapo");
        
        env = new Hashtable<Object, Object>();
        env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");

        // specify where the ldap server is running
        env.put(Context.PROVIDER_URL, url);
        env.put(Context.SECURITY_AUTHENTICATION, "none");

        // Create the initial directory context
        try {
            ldapContextNone = new InitialDirContext(env);
        } catch (NamingException e) {
            elog.writeLog("[LDAPAuthenticate IOException] " + "-" + e.getMessage() + "/n"+ e.getStackTrace().toString());            
        }

        searchCtrl = new SearchControls();
        searchCtrl.setSearchScope(SearchControls.SUBTREE_SCOPE);
    }

    public boolean search(String user, String pass) {
        //user = user.toLowerCase();

        search(user);

        if (authenticated.equals("true") && user.toLowerCase().equals(userID.toLowerCase())) {
            try {
                env = new Hashtable<Object, Object>();
                env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");

                // specify where the ldap server is running
                env.put(Context.PROVIDER_URL, url);
                env.put(Context.SECURITY_AUTHENTICATION, "simple");

                env.put(Context.SECURITY_PRINCIPAL, "uid="+user+",ou="+position+",o="+o);
                env.put(Context.SECURITY_CREDENTIALS, pass);

                // this command will throw an exception if the password is incorrect
                DirContext ldapContext = new InitialDirContext(env);
                NamingEnumeration<SearchResult> results = ldapContext.search("o=" + o, "(&(uid="+user+"))", searchCtrl);

                if (!results.hasMore()) // search failed
                {
                    throw new NamingException();
                }

                SearchResult sr = results.next();
                Attributes at = sr.getAttributes();

                givenName = at.get("cn").toString().split(": ")[1];

                if (at.get("title") != null) {
                    title = at.get("title").toString().split(": ")[1];
                } else {
                    title = position;
                }

                //prints out all possible attributes
               // for (NamingEnumeration<?> i = at.getAll(); i.hasMore();) {
                //    System.out.println((Attribute) i.next());
               // }
            	emailAddress = at.get("mail").toString().split(": ")[1];
                authenticated = "true"; //TODO

                if (title.equals("Student")) {
                   // increaseStat(2);
                } else {
                   // increaseStat(3);
                }

                return true;
            } catch (NamingException e) {
                authenticated = "failed";
                e.printStackTrace();
                elog.writeLog("[LDAP Search NamingException] " + "-" + e.getMessage() + "/n"+ e.getStackTrace().toString());                 
            } catch (Exception e) {
                //e.printStackTrace();
                authenticated = "error";
                e.printStackTrace();
                elog.writeLog("[LDAP Search] " + "-" + e.getMessage() + "/n"+ e.getStackTrace().toString());               
            }
        }

        return false;
    }
    
  /**
   * Try to access user email from LDAP, however, we don't have permission to get student's information
   
   
    public String searchEmail(String user){
    	String userEmail=null;
        if (ldapContextNone != null) { // if the initial context was created fine
            try {
                NamingEnumeration<SearchResult> results = ldapContextNone.search("o=" + o, "(&(uid=" + user + "))", searchCtrl);

                if (!results.hasMore()) // search failed
                {
                  System.out.println("test");
                    throw new Exception();
                }

                SearchResult sr = results.next();
                Attributes at = sr.getAttributes();
              for (NamingEnumeration<?> i = at.getAll(); i.hasMore();) {
              System.out.println((Attribute) i.next());
             }
                userEmail = at.get("mailequivalentaddress").toString().split(": ")[1];
                return userEmail;
            } catch (NamingException e) {
                elog.writeLog("[LDAP Search] " + "-" + e.getMessage() + "/n"+ e.getStackTrace().toString());                
            } catch (Exception e) {
               // System.out.println("User " + user + " not found in LDAP. Checking local database for user.");
                elog.writeLog("[LDAP Search] " + "-" + e.getMessage() + "/n"+ e.getStackTrace().toString());                               
            }
        }
    	
    	return userEmail;
    }
    */
    
    public boolean search(String user) {

        if (ldapContextNone != null) { // if the initial context was created fine
            try {
                NamingEnumeration<SearchResult> results = ldapContextNone.search("o=" + o, "(&(uid=" + user + "))", searchCtrl);

                if (!results.hasMore()) // search failed
                {
                  System.out.println("test");
                    throw new Exception();
                }

                SearchResult sr = results.next();
                Attributes at = sr.getAttributes();
              
                //prints out all possible attributes
//              for (NamingEnumeration<?> i = at.getAll(); i.hasMore();) {
//                  System.out.println((Attribute) i.next());
//              }
                
                position = ((sr.getName().split(","))[1].split("="))[1];
                //if (position.equals("Employee")) // don't do this unless you have a password
               //   givenName = at.get(givenNameField).toString().split(": ")[1];
                userID = at.get("uid").toString().split(": ")[1];

                authenticated = "true";
                return true;
            } catch (NamingException e) {
                elog.writeLog("[LDAP Search] " + "-" + e.getMessage() + "/n"+ e.getStackTrace().toString());                
            } catch (Exception e) {
               // System.out.println("User " + user + " not found in LDAP. Checking local database for user.");
                elog.writeLog("[LDAP Search] " + "-" + e.getMessage() + "/n"+ e.getStackTrace().toString());                               
            }
        }

        authenticated = "failed";

        return false;
    }

    // Methods for getting the user's details as fetched by LDAP
    public String getUserID() {
        // getUID()
        return userID;
    }

    public String getGivenName() {
        //getCN()
        return givenName;
    }

    public String getTitle() {
        return title;
    }

    public String getPosition() {
        //getOU()
        return position;
    }

    public String getAuthenticated() {
// Disabling this for now because it needs to use the db
//        Date now = new Date();
//        if (lastAccess != null) {
//            if ((now.getTime() - lastAccess.getTime()) / 1000.0 / 60 > timeoutTime) {
//                lastAccess = null;
//                authenticated = "timeout";
//            } else {
//                lastAccess = now;
//            }
//        }
        return authenticated;
    }

    public void resetAuthenticated() {
        authenticated = "false";
    }

    public boolean isLogout() {
        return logout;
    }

    public void setLogout(boolean l) {
        if (true) {
            reset();
        }
        logout = l;
    }

    private void reset() {
        position = userID = givenName = title = null;
    }

	public String getEmailAddress() {
		return emailAddress;
	}
}