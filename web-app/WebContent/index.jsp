<%@page import="db.DBConnection"%>
<jsp:useBean id="ldap" scope="session" class="ldap.LDAPAuthenticate" />
<%
	session.invalidate();
	String error = request.getParameter("error");
	if (error == null || error == "null") {
		error = "";
	} else {
		//DBConnection.getInstance().closeConnection();
		//DBConnection conn = DBConnection.getInstance();
		System.out.println("error=Logged out");
	}
%>
<!DOCTYPE html>
<html>
<head>
<link rel='stylesheet' type='text/css' href='css/login.css' />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>User Login Page</title>
<script type="text/javascript">
	function trim(s) {
		return s.replace(/^\s*/, "").replace(/\s*$/, "");
	}
	function validate() {
		if (trim(document.formLogin.username.value) == "") {
			alert("Login empty");
			document.formLogin.username.focus();
			return false;
		} else if (trim(document.formLogin.password.value) == "") {
			alert("Password empty");
			document.formLogin.password.focus();
			return false;
		}
	}
</script>
</head>
<body>
	<!-- Prints 'error' on the screen. -->
	<div id="error">
		<h2><%=error%></h2>
	</div>

	<!-- Login form. -->
	<form id="login" name="formLogin" action="auth.jsp"
		onSubmit="return validate();" method="post">
		<h1>Log In</h1>
		<fieldset id="inputs">
			<input id="SenecaLDAPBBBLogin" name="SenecaLDAPBBBLogin" type="text"
				placeholder="Username" autofocus required> <input
				id="SenecaLDAPBBBLoginPass" name="SenecaLDAPBBBLoginPass"
				type="password" placeholder="Password" required>
		</fieldset>
		<fieldset id="actions">
			<input type="submit" id="submit" value="Log in">
		</fieldset>
	</form>
</body>
</html>
