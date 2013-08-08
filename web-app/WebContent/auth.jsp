<%@page import="db.DBConnection"%>
<%@page import="hash.PasswordHash"%>
<%@page import="sql.User"%>
<%@page import="java.util.*"%>
<%@page import="helper.MyBoolean"%>
<%@page import= "sql.User" %>
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
				int ur_id=0;
				if (ldap.getAccessLevel() == 10) {
					usersession.setUserLevel("student");
					ur_id=2;
				} else if (ldap.getAccessLevel() == 20) {
					usersession.setUserLevel("employee");
					ur_id=1;
				} else if (ldap.getAccessLevel() == 30) {
					usersession.setUserLevel("professor");
					ur_id=3;
				}
				usersession.setUserId(ldap.getUserID());
				usersession.setGivenName(ldap.getGivenName());
				usersession.setLDAP(true);
				usersession.setEmail(ldap.getEmailAddress());
				User user = new User(dbaccess);
				ArrayList<ArrayList<String>> result = new ArrayList<ArrayList<String>>();
				user.getUserInfo(result, userID);
				HashMap<String, Integer> roleMask = new HashMap<String, Integer>();
				if (result.isEmpty()){
					roleMask.clear();
					user.createUser(userID, "", true, ur_id);
					usersession.setNick(userID);
					user.getDefaultUserSetting(roleMask);
					System.out.println(roleMask);
					usersession.setUserSettingsMask(roleMask);
				}
				else {
					user.getUserRoleSetting(roleMask, ur_id);
					usersession.setRoleMask(roleMask);	
					usersession.setNick(result.get(0).get(1));
					user.getUserSetting(roleMask, userID);
					usersession.setUserSettingsMask(roleMask);
				}
				System.out.println(usersession.getUserSettingsMask());
				response.sendRedirect("calendar.jsp");
			}
		}
		// Checks if user is registed on database.
		else if (hash.validatePassword(password.toCharArray(), userID)) {
			/* User is authenticated */
			User user = new User(dbaccess);
			MyBoolean prof = new MyBoolean();
			MyBoolean depAdmin = new MyBoolean();
			ArrayList<ArrayList<String>> result = new ArrayList<ArrayList<String>>();
			if (user.getUserInfo(result, userID)) {
				ArrayList<String> userInfo = result.get(0);
				usersession.setUserId(userID);
				usersession.setGivenName(userInfo.get(11) + " " + userInfo.get(12));
				usersession.setSuper(userInfo.get(7).equals("1"));
				usersession.setEmail(userInfo.get(13));
				user.isProfessor(prof, userID);
				user.isDepartmentAdmin(depAdmin, userID);
				usersession.setProfessor(prof.get_value());
				usersession.setDepartmentAdmin(depAdmin.get_value());
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
			else {
				System.out.println("***** "+user.getErrLog());
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