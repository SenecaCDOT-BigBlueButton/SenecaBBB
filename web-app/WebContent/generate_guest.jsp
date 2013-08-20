<%@page import="db.DBConnection"%>
<%@page import="hash.PasswordHash"%>
<%@page import="sql.User"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@page import="helper.MyBoolean"%>
<%@page import= "sql.User" %>
<%@page import= "helper.Settings" %>
<%@ page import="java.io.*,javax.mail.*"%>
<%@ page import="javax.mail.internet.*,javax.activation.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<jsp:useBean id="ldap" class="ldap.LDAPAuthenticate" scope="session" />
<jsp:useBean id="hash" class="hash.PasswordHash" scope="session" />
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<%@ page language="java" import="java.sql.*" errorPage=""%>
<%
	String message = "";
	HashMap<String, Integer> map = new HashMap<String, Integer>();
	User user = new User(dbaccess);
	
	String firstName = request.getParameter("firstName");
	String lastName = request.getParameter("lastName");
	String email = request.getParameter("email");
	
	if (firstName == "" || lastName == "" || email == "") {
		response.sendRedirect("invite_guest.jsp?message=Please complete all fields&firstName=" + firstName + "&lastName=" + lastName + "&email=" + email);
	}
	else {
		String bu_id = "guest." + firstName.toLowerCase().substring(0, 1) + lastName.toLowerCase();
		
		String key = hash.createRandomSalt();
		ArrayList<ArrayList<String>> result = new ArrayList<ArrayList<String>>();
		user.getUsersLike(result, bu_id);
		if (result.size() > 0)
			bu_id += result.size();
		
		/*if (user.createUser(bu_id, "This is a guest account", false, 3)) {
			if (user.createNonLdapUser(bu_id, firstName, lastName, key, key, email)) {
				response.sendRedirect("guest_setup.jsp?key=" + key + "&bu_id=" + bu_id);
				return;
			}
			else {
				response.sendRedirect("invite_guest.jsp?message=Please complete all fields&firstName=" + firstName + "&lastName=" + lastName + "&email=" + email);
			}
		}*/
		
		
		Context initCtx = new InitialContext();
		Context envCtx = (Context) initCtx.lookup("java:comp/env");
		Session session = (Session) envCtx.lookup("mail/Session");
		
		DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		Calendar cal = Calendar.getInstance();
		System.out.println("*************"+dateFormat.format(cal.getTime()));
		String host = "localhost";
		String to = email;
		String from = "noreply@bbb.senecacollege.ca";
		String subject = "Account activation";
		String messageText = "Please visit google.com";
		boolean sessionDebug = false;
		// Create some properties and get the default Session.
		Properties props = System.getProperties();
		props.put("mail.host", host);
		props.put("mail.transport.protocol", "smtp");
		Session mailSession = Session.getDefaultInstance(props, null);
		 
		// Set debug on the Session
		// Passing false will not echo debug info, and passing True will.
		 
		mailSession.setDebug(sessionDebug);
		 
		// Instantiate a new MimeMessage and fill it with the 
		// required information.
		 
		Message msg = new MimeMessage(mailSession);
		msg.setFrom(new InternetAddress(from));
		InternetAddress[] address = {new InternetAddress(to)};
		msg.setRecipients(Message.RecipientType.TO, address);
		msg.setSubject(subject);
		msg.setSentDate(cal.getTime());
		msg.setText(messageText);
		 
		// Hand the message to the default transport service
		// for delivery.
		 
		Transport.send(msg);
		out.println("Mail was sent to " + to);
		out.println(" from " + from);
		out.println(" using host " + host + ".");
		
		
	}
	
%>