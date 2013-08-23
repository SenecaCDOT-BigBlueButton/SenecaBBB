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
<meta http-equiv="Content-Type" content="text/html"; charset="utf-8" />
<title>Seneca | Conference Management System</title>
<link rel="shortcut icon" href="http://www.cssreset.com/favicon.png" />
<link href="css/style.css" rel="stylesheet" type="text/css" media="all">
<script type="text/javascript" src="http://code.jquery.com/jquery-1.9.1.js"></script>
<script type="text/javascript" src="js/components.js"></script>
<script type="text/css" src="css/select.css"></script>
<script type="text/javascript">
	function trim(s) {
		return s.replace(/^\s*/, "").replace(/\s*$/, "");
	}
	function validate() {
		if (trim(document.getElementById("SenecaLDAPBBBLogin").value) == "") {
			alert("Login empty");
			document.getElementById("SenecaLDAPBBBLogin").focus();
			return false;
		} else if (trim(document.getElementById("SenecaLDAPBBBLoginPass").value) == "") {
			alert("Password empty");
			document.getElementById("SenecaLDAPBBBLoginPass").focus();
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
	<div id="page">
  <header id="header"><img src="images/logo.png" alt="Logo" title="Seneca College of Applied Arts and Technology"/> </header>
  <section id="login">
	<form id="login" name="formLogin" action="auth.jsp" onSubmit="return validate();" method="post">
	  <article >
        <div class="content">
          <div class="component">
            <label for="textfield" class="label">Username:</label>
            <input type="text" name="SenecaLDAPBBBLogin" id="SenecaLDAPBBBLogin" class="input">
          </div>
          <div class="component">
            <label for="textfield" class="label">Password:</label>
            <input type="password" name="SenecaLDAPBBBLoginPass" id="SenecaLDAPBBBLoginPass" class="input">
          </div>
        </div>
      </article>
      <article>
        <div class="content"> </div>
      </article>
      <p class="buttons">
        <input type="submit" name="submit" id="save" class="button" value="Login">
      </p>
	</form>
	</section>
  <footer>
    <nav id="footerMenu">
      <ul>
        <li><a href="#">Home</a></li>
        <li>|</li>
        <li><a href="#">Contact Us</a></li>
        <li>|</li>
        <li><a href="#">Help</a></li>
      </ul>
    </nav>
    <p id="copyright">Copyright © 2013 - Seneca College of Applied Arts and Technology</p>
    <div id="footerBar"></div>
  </footer>
  </div>
</body>
</html>