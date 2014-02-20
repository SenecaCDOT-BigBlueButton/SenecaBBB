<%@page import="db.DBConnection"%>
<%@page import="hash.PasswordHash"%>
<%@page import="sql.User"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@page import="helper.*"%>
<%@page import= "sql.User" %>
<%@ page import="java.io.*,javax.mail.*"%>
<%@ page import="javax.mail.internet.*,javax.activation.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<jsp:useBean id="ldap" class="ldap.LDAPAuthenticate" scope="session" />
<jsp:useBean id="hash" class="hash.PasswordHash" scope="session" />
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<%@ page language="java" import="java.sql.*" errorPage=""%>

<%
	//Start page validation
	String userId = usersession.getUserId();
    GetExceptionLog elog = new GetExceptionLog();
	String message = request.getParameter("message");
	String successMessage = request.getParameter("successMessage");
	if (message == null || message == "null") {
	    message="";
	}
	if (successMessage == null) {
	    successMessage="";
	}
	HashMap<String, Integer> roleMask = usersession.getRoleMask();
	if (userId.equals("")) {
		elog.writeLog("[generate_guest:] " + "unauthenticated user tried to access this page /n");
	    response.sendRedirect("index.jsp?message=Please log in");
	    return;
	}
	if(!(usersession.isSuper()||usersession.getUserLevel().equals("employee")||roleMask.get("guestAccountCreation") == 0)) {
	    elog.writeLog("[generate_guest:] " + " username: "+ userId + " tried to access this page, permission denied" +" /n");	       
		response.sendRedirect("calendar.jsp?message=You do not have permission to access that page");
	    return;
	}
	if (dbaccess.getFlagStatus() == false) {
	    elog.writeLog("[generate_guest:] " + "database connection error /n");
	    response.sendRedirect("index.jsp?message=Database connection error");
	    return;
	}//End page validation

	HashMap<String, Integer> map = new HashMap<String, Integer>();
	User user = new User(dbaccess);		
	String firstName = request.getParameter("firstName");
	String lastName = request.getParameter("lastName");
	String email = request.getParameter("email");	
	if (firstName == "" || lastName == "" || email == "" ) {
		response.sendRedirect("invite_guest.jsp?message=Please fill all necessary information");	
		return;
	}
	else {
		String[] fName = firstName.split("\\s+");
		String[] lName = lastName.split("\\s+");
		StringBuffer br = new StringBuffer();
		for(int i=0;i<fName.length;i++){
			br = br.append(fName[i]);
			if(i<fName.length-1){
				br.append(" ");
			}
		}
		firstName = br.toString();
		br.setLength(0);
        for(int j=0;j<lName.length;j++){
            br = br.append(lName[j]);
            if(j<lName.length-1){
                br.append(" ");
            }
        }
		lastName = br.toString();
		String bu_id = "guest." + firstName.toLowerCase().substring(0, 1) + lastName.replaceAll(" ","").toLowerCase();
		String key = hash.createRandomSalt();	
		ArrayList<ArrayList<String>> result = new ArrayList<ArrayList<String>>();
		user.getUsersLike(result, bu_id);
		int counter = 0;
		String name, pattern = bu_id + "\\d*";
		while (!result.isEmpty()){
			name = result.get(0).get(0);
			if (name.matches(pattern))
				counter++;
			result.remove(0);
		}
		if (counter > 0){
			bu_id += counter;
		}
		session.setAttribute("key", key);
		session.setAttribute("bu_id", bu_id);
		session.setAttribute("email", email);
		if (user.createUser(bu_id,firstName.concat(".").concat(lastName), "This is a guest account", false, 3)) {
			if (user.createNonLdapUser(bu_id, firstName, lastName, key, key, email)) {
			//	response.sendRedirect("email.jsp?key=" + key + "&bu_id=" + bu_id + "&email=" + email);
			    response.sendRedirect("email.jsp?&firstName=" + firstName + "&lastName=" + lastName);
				//Send an email to guest to change a new password with the following link:
			    //http://localhost:1550/SenecaBBB/guest_setup.jsp?" + key + "&bu_id=" + bu_id
				//out.write("User with username " + bu_id + " successfully created.");
				return;
			}
			else {
				//fallback to invite_guest.jsp and repopulate firstName, lastName,email
				 response.sendRedirect("invite_guest.jsp?&message=Please complete all fields&firstName=" + firstName + "&lastName=" + lastName + "&email=" + email);
				//out.write("Please fill in all fields");
			}
		}
	}
	
%>