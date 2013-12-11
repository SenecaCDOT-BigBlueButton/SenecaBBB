<%@page import="db.DBConnection"%>
<%@page import="hash.PasswordHash"%>
<%@page import="sql.User"%>
<%@page import="java.util.*"%>
<%@page import="helper.*"%>
<jsp:useBean id="ldap" class="ldap.LDAPAuthenticate" scope="session" />
<jsp:useBean id="hash" class="hash.PasswordHash" scope="session" />
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />


<%@ page language="java" import="java.sql.*" errorPage=""%>
<%
    // Gets inserted user and password.
    User user = new User(dbaccess);
	MyBoolean prof = new MyBoolean();
	MyBoolean depAdmin = new MyBoolean();
	GetExceptionLog elog = new GetExceptionLog();
	ArrayList<ArrayList<String>> result = new ArrayList<ArrayList<String>>();
	String userID = request.getParameter("SenecaLDAPBBBLogin");
	String password = request.getParameter("SenecaLDAPBBBLoginPass");
	String message;
	HashMap<String, Integer> userSettingMask = new HashMap<String, Integer>();
	HashMap<String, Integer> userRoleMask = new HashMap<String, Integer>();
	if (userID != null && password != null) {
		// User exists in LDAP
		if (ldap.search(request.getParameter("SenecaLDAPBBBLogin"), request.getParameter("SenecaLDAPBBBLoginPass"))) {
			if (ldap.getAccessLevel() < 0) {
				elog.writeLog("[auth:] " + "permission denied" +"/n");
				response.sendRedirect("index.jsp?message=Sorry,you don't have permission to access this system!");
				return;
			} else {
				int ur_id=0;
				if (ldap.getPosition().equals("Student")) {
					usersession.setUserLevel("student");
					ur_id=2;
				} else if (ldap.getPosition().equals("Employee")) {
					usersession.setUserLevel("employee");
					ur_id=1;
				} else {
					usersession.setUserLevel("guest");
					ur_id=3;
				}
				usersession.setUserId(ldap.getUserID());
				usersession.setGivenName(ldap.getGivenName());
				usersession.setLDAP(true);
				usersession.setEmail(ldap.getEmailAddress());
				user.getUserInfo(result, userID);
				// User doesn't exist in our db
				if (result.isEmpty()){
					user.createUser(userID,ldap.getGivenName(),"", true, ur_id);
					usersession.setNick(ldap.getGivenName());
					user.getDefaultUserSetting(userSettingMask);
					user.setUserSetting(userSettingMask, userID);
					user.getPredefinedUserRoleSetting(userRoleMask,usersession.getUserLevel());
					usersession.setRoleMask(userRoleMask);
					usersession.setUserSettingsMask(userSettingMask);
					userSettingMask.clear();
					user.getDefaultMeetingSetting(userSettingMask);
					user.setUserMeetingSetting(userSettingMask, userID);
					usersession.setUserMeetingSettingsMask(userSettingMask);
					user.setLastLogin(userID);
				}
				// User exists in our db but first time login
				else if(result.get(0).get(5)==null){
					usersession.setNick(ldap.getGivenName());
					user.setLastLogin(userID);
					user.setNickName(userID, ldap.getGivenName());
					user.getDefaultUserSetting(userSettingMask);
					user.setUserSetting(userSettingMask, userID);
					user.getPredefinedUserRoleSetting(userRoleMask,usersession.getUserLevel());
					usersession.setRoleMask(userRoleMask);
					usersession.setUserSettingsMask(userSettingMask);
					userSettingMask.clear();
					user.getDefaultMeetingSetting(userSettingMask);
					user.setUserMeetingSetting(userSettingMask, userID);
					usersession.setUserMeetingSettingsMask(userSettingMask);	
				}
				//User exists in db and not the first login
				else {
		            user.getUserRoleSetting(userRoleMask, ur_id);
					usersession.setRoleMask(userRoleMask);
					usersession.setNick(result.get(0).get(1));
					usersession.setSuper(result.get(0).get(7).equals("1"));
					user.getUserSetting(userSettingMask, userID);
					usersession.setUserSettingsMask(userSettingMask);
					userSettingMask.clear();
					user.getUserMeetingSetting(userSettingMask, userID);
					usersession.setUserMeetingSettingsMask(userSettingMask);
					user.isProfessor(prof, userID);
					user.isDepartmentAdmin(depAdmin, userID);
					usersession.setProfessor(prof.get_value());
					usersession.setDepartmentAdmin(depAdmin.get_value());
					user.setLastLogin(userID);
				}
				response.sendRedirect("calendar.jsp?successMessage=Welcome to BBBMAN Web Conferencing Management System!");
				return;
			}
		}
		// User is registered in database but is non_ldap user.
		else if (hash.validatePassword(password.toCharArray(), userID)) {
			/* User is authenticated */
			if (user.getUserInfo(result, userID)) {
				ArrayList<String> userInfo = result.get(0);
				int ur_id = Integer.parseInt(userInfo.get(8));
				user.getUserSetting(userSettingMask, userID);
				usersession.setUserSettingsMask(userSettingMask);
				usersession.setUserId(userID);
				user.setLastLogin(userID);
				usersession.setGivenName(userInfo.get(11) + " " + userInfo.get(12));
				usersession.setSuper(userInfo.get(7).equals("1"));
				usersession.setEmail(userInfo.get(13));
				usersession.setNick(userInfo.get(1));
				user.isProfessor(prof, userID);
				user.isDepartmentAdmin(depAdmin, userID);
				usersession.setProfessor(prof.get_value());
				usersession.setDepartmentAdmin(depAdmin.get_value());
				userSettingMask.clear();
				user.getUserMeetingSetting(userSettingMask, userID);
				usersession.setUserMeetingSettingsMask(userSettingMask);
				userSettingMask.clear();
				user.getUserRoleSetting(userRoleMask, ur_id);
				usersession.setRoleMask(userRoleMask);				
				if (prof.get_value()) {
					usersession.setUserLevel("professor");
				}
				else {
					usersession.setUserLevel(userInfo.get(15));
				}
				usersession.setLDAP(false);
				response.sendRedirect("calendar.jsp?successMessage=Login successfully");
				return;
			} 
			else {
				message = "Invalid username and/or password.";
				elog.writeLog("[auth:] " + "username: "+ userID + "tried to log in with " + message +"/n");
				response.sendRedirect("index.jsp?message=" + message);
				return;
			}
		// User doesn't exist in database or LDAP
		} else {
				message = "Invalid username and/or password.";
				elog.writeLog("[auth:] " + "username: "+ userID + "tried to log in with " + message +"/n");
				response.sendRedirect("index.jsp?message=" + message);
				return;
		}
	} else {
			message = "Invalid username and/or password.**";
			elog.writeLog("[auth:] " + "username: "+ userID + "tried to log in with " + message +"/n");
			response.sendRedirect("index.jsp?message=" + message);
	}
%>