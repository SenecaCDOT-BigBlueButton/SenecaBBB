<%@page import="db.DBConnection"%>
<%@page import="hash.PasswordHash"%>
<%@page import="sql.User"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@page import="helper.MyBoolean"%>
<%@page import= "sql.User" %>
<%@page import= "helper.Settings" %>
<jsp:useBean id="ldap" class="ldap.LDAPAuthenticate" scope="session" />
<jsp:useBean id="hash" class="hash.PasswordHash" scope="session" />
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<%@ page language="java" import="java.sql.*" errorPage=""%>

<%
	String userId = usersession.getUserId();
	HashMap<String, Integer> roleMask = usersession.getRoleMask();
	if (userId.equals("") || dbaccess.getFlagStatus() == false) {
		return;
	}
	else {
		String message = "";
		HashMap<String, Integer> map = new HashMap<String, Integer>();
		User user = new User(dbaccess);
		
		String firstName = request.getParameter("firstName");
		String lastName = request.getParameter("lastName");
		String email = request.getParameter("email");
		
		if (firstName == "" || lastName == "" || email == "") {
			//response.sendRedirect("invite_guest.jsp?message=Please complete all fields&firstName=" + firstName + "&lastName=" + lastName + "&email=" + email);
			out.write ("Please fill in all the fields");
			return;
		}
		else {
			String bu_id = "guest." + firstName.toLowerCase().substring(0, 1) + lastName.toLowerCase();
			String key = hash.createRandomSalt();
			ArrayList<ArrayList<String>> result = new ArrayList<ArrayList<String>>();
			user.getUsersLike(result, bu_id);
			System.out.println(result);
			int counter = 0;
			String name, pattern = bu_id + "\\d*";
			while (!result.isEmpty()){
				name = result.get(0).get(0);
				if (name.matches(pattern))
					counter++;
				result.remove(0);
			}
			if (counter > 0)
				bu_id += counter;
			System.out.println(bu_id);
			
			if (user.createUser(bu_id, "This is a guest account", false, 3)) {
				if (user.createNonLdapUser(bu_id, firstName, lastName, key, key, email)) {
					//response.sendRedirect("guest_setup.jsp?key=" + key + "&bu_id=" + bu_id);
					out.write("User with username " + bu_id + " successfully created.");
					return;
				}
				else {
					//response.sendRedirect("invite_guest.jsp?message=Please complete all fields&firstName=" + firstName + "&lastName=" + lastName + "&email=" + email);
					out.write("Please fill in all fields");
				}
			}
		}
	}
	
%>