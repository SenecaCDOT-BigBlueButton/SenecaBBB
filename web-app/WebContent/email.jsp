<%@page import="db.DBConnection"%>
<%@ page import="java.util.*, javax.mail.*, javax.mail.internet.*" %> 
<%@page import="sql.Admin"%>
<%@page import="sql.User"%>
<%@page import="helper.MyBoolean"%>
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<%
    String message="";
    HashMap<String, Integer> roleMask = usersession.getRoleMask();
	//Start page validation
	String userId = usersession.getUserId();
	if (userId.equals("")) {
	    response.sendRedirect("index.jsp?message=Please log in");
	    return;
	}
	if(!(usersession.isSuper()||usersession.isProfessor()||roleMask.get("guestAccountCreation") == 0)) {
	    response.sendRedirect("calendar.jsp?message=You do not have permission to access that page");
	}
	if (dbaccess.getFlagStatus() == false) {
	    return;
	}
    //End page validation   
	try{	
	    String host = "mercury.senecac.on.ca";
	    String to = session.getAttribute("email").toString();
	    String from = usersession.getEmail();
		String subject = "SenecaBBB Guest Account Activation"; 
	    String key = session.getAttribute("key").toString();
	    String bu_id = session.getAttribute("bu_id").toString();
		String link = "http://localhost:1550/SenecaBBB/guest_setup.jsp?&key=" + key + "&user=" + bu_id;
		String messageText = "<body><p>Dear Guest User:</p><p>You are invited to join an event in SenecaBBB. A guest account is created for you.</p><p> Your user name is: <strong>" 
		                     + bu_id + "</strong></p><p> Please visit the following link to activate your account:</p>"+ link
		                     + "<p>Regards</p><p>Seneca College</p></body>"; 
		boolean sessionDebug = false;
		Properties props = System.getProperties(); 
		props.put("mail.host", host); 
		props.put("mail.transport.protocol", "smtp");
		props.put("mail.smtp.auth", "false"); 
		props.put("mail.smtp.port", "25"); 
		Session mailSession = Session.getDefaultInstance(props, null); 
		mailSession.setDebug(sessionDebug); 
		Message msg = new MimeMessage(mailSession); 
		msg.setFrom(new InternetAddress(from)); 
		InternetAddress[] address = {new InternetAddress(to)}; 
		msg.setRecipients(Message.RecipientType.TO, address);
		msg.setSubject(subject); msg.setSentDate(new Date()); 
		msg.setContent(messageText,"text/html");
		Transport transport = mailSession.getTransport("smtp");
		transport.connect();
		transport.sendMessage(msg, msg.getAllRecipients()); 
		transport.close(); 
		message="email send to your guest";
		response.sendRedirect("calendar.jsp?message="+ message);
	}
	catch(Exception e){
		message="Can't send email to your guest,please contact super admin!"+e.getMessage();
		response.sendRedirect("invite_guest.jsp?&message=" + message + "&firstName=" + request.getParameter("firstName") + "&lastName=" + request.getParameter("lastName") + "&email=" + session.getAttribute("email").toString());
	}	
%>