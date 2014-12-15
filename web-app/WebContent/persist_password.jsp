<%@page import="db.DBConnection"%>
<%@page import="hash.PasswordHash"%>
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
    String pageIncoming = request.getParameter("frompage");
    if (pageIncoming == null){
        pageIncoming = "";
    }
    String newPassword = request.getParameter("newPassword");
    String confirmPassword = request.getParameter("confirmPassword");
    String currentPassword = request.getParameter("currentPassword");
    
    if (pageIncoming.equals("edit_password")) {
        if (!(currentPassword == null || newPassword == null || confirmPassword == null)) {
            if (!newPassword.equals(confirmPassword)) {
                response.sendRedirect("edit_password.jsp?message=Please enter the new password twice.");
                return;
            }
            if (hash.validatePassword(currentPassword.toCharArray(),usersession.getUserId())) {
                String newSalt = hash.createRandomSalt();
                String newHash = PasswordHash.createHash(newPassword.toCharArray(), newSalt.getBytes());
                user.setSalt(usersession.getUserId(), newSalt);
                user.setHash(usersession.getUserId(), newHash);
                response.sendRedirect("settings.jsp?successMessage=Password successfully changed.");
                return;
            } else {
                response.sendRedirect("edit_password.jsp?message=Invalid current password entered.");
                return;
            }
        } else {
            response.sendRedirect("edit_password.jsp?message=Please fill in all the fields.");
            return;
        }
    } else if (pageIncoming.equals("guest")) {
        String bu_id = request.getParameter("bu_id");
        String key = request.getParameter("key");
        ArrayList<HashMap<String, String>> storedKeyArray = new ArrayList<HashMap<String, String>>();
        user.getSalt(storedKeyArray, bu_id);
        HashMap<String, String> storedKey = storedKeyArray.get(0);
        if (!(newPassword == null || confirmPassword == null)) {
            if (!newPassword.equals(confirmPassword)) {
                response.sendRedirect("guest_setup.jsp?key=" + key + "&bu_id=" + bu_id + "&message=Please enter the new password twice.");
                return;
            }
            if (key.equals(storedKey.get("nu_salt"))) {
                String newSalt = hash.createRandomSalt();
                String newHash = PasswordHash.createHash(newPassword.toCharArray(), newSalt.getBytes());
                user.setSalt(bu_id, newSalt);
                user.setHash(bu_id, newHash);
                response.sendRedirect("index.jsp?bu_id=" + bu_id + "&successMessage=Password successfully set.&guestCreated=true");
                return;
            } else {
                response.sendRedirect("guest_setup.jsp?key=" + key + "&bu_id=" + bu_id + "&message=Invalid key.");
                return;
            }
        } else {
            response.sendRedirect("guest_setup.jsp?key=" + key + "&bu_id=" + bu_id + "&message=Please fill in all the fields.");
            return;
        }
    } else{
        response.sendRedirect("index.jsp?message=Invalid page");
    }
%>