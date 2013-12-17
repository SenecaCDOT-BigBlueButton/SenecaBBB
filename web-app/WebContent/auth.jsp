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
    ArrayList<ArrayList<String>> adminResult = new ArrayList<ArrayList<String>>();
    String userID = request.getParameter("SenecaLDAPBBBLogin");
    String password = request.getParameter("SenecaLDAPBBBLoginPass");
    String message;
    MyBoolean mybool = new MyBoolean();
    HashMap<String, Integer> userSetting = new HashMap<String, Integer>();
    HashMap<String, Integer> userRoleMask = new HashMap<String, Integer>();
    HashMap<String, Integer> userMeetingSetting = new HashMap<String, Integer>();
    if (userID != null && password != null) {
        String redirecturl = (String)session.getAttribute("redirecturl");
        // User exists in LDAP
        if (ldap.search(userID, password)) {
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
                user.isUser(mybool, userID);
                // User doesn't exist in our db, save user to dababase
                if(!mybool.get_value()){
                    user.createUser(userID,ldap.getGivenName(),"", true, ur_id);
                }
                user.getUserInfo(result, userID);
                user.getUserSetting(userSetting, userID);
                usersession.setUserSettingsMask(userSetting);
                user.getUserMeetingSetting(userMeetingSetting, userID);
                usersession.setUserMeetingSettingsMask(userMeetingSetting);
                user.getUserRoleSetting(userRoleMask, ur_id);
                usersession.setRoleMask(userRoleMask);
                user.getIsSuperAdmin(adminResult, userID);
                usersession.setSuper(adminResult.get(0).get(0).equals("1")?true:false);
                user.isDepartmentAdmin(mybool, userID);
                usersession.setDepartmentAdmin(mybool.get_value());
                user.isProfessor(mybool, userID);
                usersession.setProfessor(mybool.get_value());
                usersession.setUserId(ldap.getUserID());
                usersession.setGivenName(ldap.getGivenName());
                usersession.setLDAP(true);
                usersession.setEmail(ldap.getEmailAddress());
                usersession.setNick(result.get(0).get(1));
                user.setLastLogin(userID);
                
                
                // Handling system time out
                // Redirect user to proper destination when user refreshes the page or clicks a link 
                // On each page's validation: if (userId.equals("")), save the current request url and query string
                // session.setAttribute("redirecturl", request.getRequestURI()+(request.getQueryString()!=null?"?"+request.getQueryString():""));
                if (redirecturl != null) {
                    session.removeAttribute("redirecturl");
                    response.sendRedirect(redirecturl);
                    return;
                } else {
                    response.sendRedirect("calendar.jsp?successMessage=Login successfully");
                    return;
                }              
        }
        // User is registered in database but is non_ldap user.
        else if (hash.validatePassword(password.toCharArray(), userID)) {
            /* User is authenticated */
            if (user.getUserInfo(result, userID)) {
                ArrayList<String> userInfo = result.get(0);
                int ur_id = Integer.parseInt(userInfo.get(8));
                user.getUserSetting(userSetting, userID);
                usersession.setUserSettingsMask(userSetting);
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
                user.getUserMeetingSetting(userMeetingSetting, userID);
                usersession.setUserMeetingSettingsMask(userMeetingSetting);
                user.getUserRoleSetting(userRoleMask, ur_id);
                usersession.setRoleMask(userRoleMask);              
                if (prof.get_value()) {
                    usersession.setUserLevel("professor");
                }
                else {
                    usersession.setUserLevel(userInfo.get(15));
                }
                usersession.setLDAP(false);
                
                // Handling system time out
                // Redirect user to proper destination when user refreshes the page or clicks a link               
                if (redirecturl != null) {
                    session.removeAttribute("redirecturl");
                    response.sendRedirect(redirecturl);
                    return;
                } else {
                    response.sendRedirect("calendar.jsp?successMessage=Login successfully");
                    return;
                }  
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