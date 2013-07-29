<%@page import="db.DBConnection"%>
<%@page import="hash.PasswordHash"%>
<%@page import="sql.User"%>
<%@page import="java.util.ArrayList"%>
<%@page import="helper.MyBoolean"%>
<jsp:useBean id="ldap" class="ldap.LDAPAuthenticate" scope="session" />
<jsp:useBean id="hash" class="hash.PasswordHash" scope="session" />
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />

<%@ page language="java" import="java.sql.*" errorPage=""%>
<%
    // Gets inserted user and password.
	String userID = request.getParameter("SenecaLDAPBBBLogin");
	String password = request.getParameter("SenecaLDAPBBBLoginPass");
	// Checks if user and password fields are not empty.
	if (userID != null && password != null) {
		// Checks if user is registed on Seneca's database
		if (ldap.search(request.getParameter("SenecaLDAPBBBLogin"), request.getParameter("SenecaLDAPBBBLoginPass"))) {
			if (ldap.getAccessLevel() < 0) {
				response.sendRedirect("banned.jsp");
			} else {
				if (ldap.getAccessLevel() == 10) {
					usersession.setUserLevel("student");
				} else if (ldap.getAccessLevel() == 20) {
					usersession.setUserLevel("employee");
				} else if (ldap.getAccessLevel() == 30) {
					usersession.setUserLevel("professor");
				}
				usersession.setUserId(ldap.getUserID());
				usersession.setGivenName(ldap.getGivenName());
				usersession.setLDAP(true);
				response.sendRedirect("calendar.jsp");
			}
		}
		// Checks if user is registed on database.
		else if (hash.validatePassword(password.toCharArray(), userID)) {
			/* User is authenticated */
			User user = new User(dbaccess);
			MyBoolean prof = new MyBoolean();
			ArrayList<ArrayList<String>> result = new ArrayList<ArrayList<String>>();
			if (user.getUserInfo(result, userID)) {
				ArrayList<String> userInfo = result.get(0);
				usersession.setUserLevel(userID);
				usersession.setGivenName(userInfo.get(11) + " " + userInfo.get(12));
				user.isProfessor(prof, userID);
				if (prof.get_value()) {
					usersession.setUserLevel("professor");
				}
				else {
					usersession.setUserLevel(userInfo.get(15));
				}
				usersession.setLDAP(false);
				response.sendRedirect("calendar.jsp");
				String message = "User login successfully.";
			} 
		} else {
			String message = "Invalid username and/or password.";
			response.sendRedirect("index.jsp?error=" + message);
		}
	} else {
		String message = "Invalid username and/or password.";
		response.sendRedirect("index.jsp?error=" + message);
	}
%>