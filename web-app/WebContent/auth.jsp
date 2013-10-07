<%@page import="db.DBConnection"%>
<%@page import="hash.PasswordHash"%>
<%@page import="sql.User"%>
<%@page import="java.util.*"%>
<%@page import="helper.MyBoolean"%>
<jsp:useBean id="ldap" class="ldap.LDAPAuthenticate" scope="session" />
<jsp:useBean id="hash" class="hash.PasswordHash" scope="session" />
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />


<%@ page language="java" import="java.sql.*" errorPage=""%>
<%
    // Gets inserted user and password.
    User user = new User(dbaccess);
	ArrayList<ArrayList<String>> result = new ArrayList<ArrayList<String>>();
	String userID = request.getParameter("SenecaLDAPBBBLogin");
	String password = request.getParameter("SenecaLDAPBBBLoginPass");
	HashMap<String, Integer> mask = new HashMap<String, Integer>();
	if (userID != null && password != null) {
		// User exists in LDAP
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
				user.getUserInfo(result, userID);
				// User doesn't exist in our db
				if (result.isEmpty()){
					user.createUser(userID, "", true, ur_id);
					usersession.setNick(userID);
					user.getDefaultUserSetting(mask);
					usersession.setUserSettingsMask(mask);
					mask.clear();
					user.getDefaultMeetingSetting(mask);
					usersession.setUserMeetingSettingsMask(mask);
				}
				// User exists in our db
				else {
					user.getUserRoleSetting(mask, ur_id);
					usersession.setRoleMask(mask);
					usersession.setNick(result.get(0).get(1));
					usersession.setSuper(result.get(0).get(7).equals("1"));
					user.getUserSetting(mask, userID);
					usersession.setUserSettingsMask(mask);
					mask.clear();
					user.getUserMeetingSetting(mask, userID);
					usersession.setUserMeetingSettingsMask(mask);
					user.getIsDepartmentAdmin(result, userID);
					if (result.size() > 0)
						usersession.setDepartmentAdmin(result.get(0).get(0).equals("1"));
					else
						usersession.setDepartmentAdmin(false);
				}
				response.sendRedirect("calendar.jsp");
			}
		}
		// User is registed in database.
		else if (hash.validatePassword(password.toCharArray(), userID)) {
			/* User is authenticated */
			MyBoolean prof = new MyBoolean();
			MyBoolean depAdmin = new MyBoolean();
			if (user.getUserInfo(result, userID)) {
				ArrayList<String> userInfo = result.get(0);
				int ur_id = Integer.parseInt(userInfo.get(8));
				user.getUserSetting(mask, userID);
				usersession.setUserSettingsMask(mask);
				usersession.setUserId(userID);
				usersession.setGivenName(userInfo.get(11) + " " + userInfo.get(12));
				usersession.setSuper(userInfo.get(7).equals("1"));
				user.getIsDepartmentAdmin(result, userID);
				if (result.size() > 0)
					usersession.setDepartmentAdmin(result.get(0).get(0).equals("1"));
				else
					usersession.setDepartmentAdmin(false);
				usersession.setEmail(userInfo.get(13));
				usersession.setNick(userInfo.get(1));
				user.isProfessor(prof, userID);
				user.isDepartmentAdmin(depAdmin, userID);
				usersession.setProfessor(prof.get_value());
				usersession.setDepartmentAdmin(depAdmin.get_value());
				mask.clear();
				user.getUserMeetingSetting(mask, userID);
				usersession.setUserMeetingSettingsMask(mask);
				mask.clear();
				user.getUserRoleSetting(mask, ur_id);
				usersession.setRoleMask(mask);
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
		// User doesn't exist in database or LDAP
		} else {
			String message = "Invalid username and/or password.";
			response.sendRedirect("index.jsp?error=" + message);
		}
	} else {
		String message = "Invalid username and/or password.**";
		response.sendRedirect("index.jsp?error=" + message);
	}
%>