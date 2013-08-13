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
	int userSettings = 0;
	if (request.getParameter("setting1box").equals("on"))
		System.out.println("<><><><>");
	   Enumeration paramNames = request.getParameterNames();

	   while(paramNames.hasMoreElements()) {
	      String paramName = (String)paramNames.nextElement();
	      out.print("<tr><td>" + paramName + "</td>\n");
	      String paramValue = request.getHeader(paramName);
	      out.println("<td> " + paramValue + "</td></tr>\n");
	   }
	
%>