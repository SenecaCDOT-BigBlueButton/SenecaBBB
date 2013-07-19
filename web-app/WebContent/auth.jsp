<%@page import="db.DBConnection"%>
<%@page import="hash.PasswordHash"%>
<%@page import="dao.User"%>
<%@page import="java.util.ArrayList"%>
<jsp:useBean id="ldap" class="ldap.LDAPAuthenticate" scope="session" />
<jsp:useBean id="hash" class="hash.PasswordHash" scope="session" />
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />

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
					session.setAttribute("iUserType", "student");
					session.setAttribute("iUserLevel", "student");
				} else if (ldap.getAccessLevel() == 20) {
					session.setAttribute("iUserType", "employee");
					session.setAttribute("iUserLevel", "employee");
				} else if (ldap.getAccessLevel() == 30) {
					session.setAttribute("iUserType", "professor");
					session.setAttribute("iUserLevel", "professor");
				}
				session.setAttribute("sUserID", ldap.getUserID());
				session.setAttribute("sUserName", ldap.getGivenName());
				session.setAttribute("isLDAP", "true");
				response.sendRedirect("calendar.jsp");
			}
		}
		// Checks if user is registed on database.
		else if (hash.validatePassword(password.toCharArray(), userID)) {

			/* User is authenticated */
			User user = new User(dbaccess);
			DBConnection conn = DBConnection.getInstance();
			ArrayList<ArrayList<String>> result = new ArrayList<ArrayList<String>>();
			if (user.getUserInfo(result, userID)) {
				ArrayList<String> userInfo = result.get(0);
				session.setAttribute("sUserID", userID);
				session.setAttribute("sUserID", userID);
				session.setAttribute("sUserName", userInfo.get(userInfo.indexOf("nu_name")) + " " + userInfo.get(userInfo.indexOf("nu_lastname")));
				session.setAttribute("iUserLevel", userInfo.get(userInfo.indexOf("pr_name")));
				session.setAttribute("iUserType", userInfo.get(userInfo.indexOf("pr_name")));
				session.setAttribute("isLDAP", "false");
				response.sendRedirect("calendar.jsp");
				String message = "User login successfully.";
			} else {
				String message = "Invalid username and/or password.";
				response.sendRedirect("index.jsp?error=" + message);
			}
		} else {
			dbaccess.closeConnection();
		}
	} else {
		String message = "Invalid username and/or password.";
	}
%>