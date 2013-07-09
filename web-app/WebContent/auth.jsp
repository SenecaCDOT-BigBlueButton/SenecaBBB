<%@page import="db.DBConnection"%>
<%@page import="hash.PasswordHash"%>
<jsp:useBean id="ldap" class="ldap.LDAPAuthenticate" scope="session" />
<jsp:useBean id="hash" class="hash.PasswordHash" scope="session" />

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
			DBConnection conn = DBConnection.getInstance();
			ResultSet rsdoLogin = conn.getUserInfo(userID);
			if (rsdoLogin.next()) {
				session.setAttribute("sUserID", userID);
				session.setAttribute("sUserName", rsdoLogin.getString("nu_name") + " " + rsdoLogin.getString("nu_lastname"));
				session.setAttribute("iUserLevel", rsdoLogin.getString("pr_name"));
				session.setAttribute("iUserType", rsdoLogin.getString("pr_name"));
				session.setAttribute("isLDAP", "false");
				response.sendRedirect("calendar.jsp");
				String message = "User login successfully.";
			} else {
				String message = "Invalid username and/or password.";
				response.sendRedirect("index.jsp?error=" + message);
			}
		} else {
			DBConnection.getInstance().closeConnection();
		}
	} else {
		String message = "Invalid username and/or password.";
	}
%>