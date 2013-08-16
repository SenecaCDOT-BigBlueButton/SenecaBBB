<%@page import="db.DBConnection"%>
<%@page import="hash.PasswordHash"%>
<%@page import="sql.User"%>
<%@page import="java.util.*"%>
<%@page import="helper.MyBoolean"%>
<%@page import= "sql.User" %>
<%@page import= "helper.Settings" %>
<jsp:useBean id="ldap" class="ldap.LDAPAuthenticate" scope="session" />
<jsp:useBean id="hash" class="hash.PasswordHash" scope="session" />
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />

<%@ page language="java" import="java.sql.*" errorPage=""%>
<%
	HashMap<String, Integer> map = new HashMap<String, Integer>();
	User user = new User(dbaccess);
	String message;
	String currentPassword = request.getParameter("currentPassword");
	String newPassword = request.getParameter("newPassword");
	String confirmPassword = request.getParameter("confirmPassword");
	if (!(currentPassword == "" || newPassword == "" || confirmPassword == "")) {
		if (!newPassword.equals(confirmPassword)){
			response.sendRedirect("edit_password.jsp?message=Please enter the new password twice.");
			return;
		}
		if(hash.validatePassword(currentPassword.toCharArray(), usersession.getUserId())){
			String newSalt = hash.createRandomSalt();
			String newHash = PasswordHash.createHash(newPassword.toCharArray(), newSalt.getBytes());
			user.setSalt(usersession.getUserId(), newSalt);
			user.setHash(usersession.getUserId(), newHash);
			response.sendRedirect("edit_password.jsp?message=Password successfully changed.");
			return;
		}
		else {
			response.sendRedirect("edit_password.jsp?message=Invalid password entered.");
			return;
		}
	}
	else {
		response.sendRedirect("edit_password.jsp?message=Please fill in all the fields.");
		return;
	}
%>