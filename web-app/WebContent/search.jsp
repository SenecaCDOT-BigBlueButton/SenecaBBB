<%@page import="sql.User"%>
<jsp:useBean id="ldap" class="ldap.LDAPAuthenticate" scope="session" />
<jsp:useBean id="hash" class="hash.PasswordHash" scope="session" />
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />

<%
	String userId = usersession.getUserId();
	if (userId.equals("") || dbaccess.getFlagStatus() == false) {
		return;
	}
	else {
		String userName = request.getParameter("userName");
		
		if (userName == "") {
			out.write ("Please enter a username to search");
		}
		else {
			if (ldap.search(userName)) {
			  if (ldap.getPosition().equals("Employee") || ldap.getPosition().equals("Professor"))
			  	out.write("{userName:'"+ldap.getUserID()+"',userType:'" +ldap.getPosition()+"',givenName:'" +ldap.getGivenName()+ "'}");
			  else
			    out.write("{'userName':'"+ldap.getUserID()+"','userType':" +ldap.getPosition()+ "'}");
			}
			else
			  out.write("User " + userName + " not found");
		}
	}
	
%>