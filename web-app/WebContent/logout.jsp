<%@page import="db.DBConnection"%>
<%@page import="hash.PasswordHash"%>
<%@page import="sql.User"%>
<%@page import="java.util.*"%>
<%@page import= "helper.Settings" %>
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />

<%@ page language="java" import="java.sql.*" errorPage=""%>
<%
	String message = request.getParameter("message");
	if (message == null) {
		message="";
	}
	session.invalidate();
	response.sendRedirect("index.jsp?message=" + message);
%>