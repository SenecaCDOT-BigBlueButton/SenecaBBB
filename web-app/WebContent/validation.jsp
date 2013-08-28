<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<%
	String userId = usersession.getUserId();
	if (userId.equals("")) {
		response.sendRedirect("index.jsp?error=Please log in");
		return;
	}
%>