<%@page import="db.DBConnection"%>
<jsp:useBean id="ldap" scope="session" class="ldap.LDAPAuthenticate" />
<%
	session.invalidate();
	String error = request.getParameter("error");
	if (error == null || error == "null") {
		error = "";
	} else {
		System.out.println("error=Logged out");
	}
%>
<!doctype html>
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta http-equiv="pragma" content="no-cache" />
<title>Seneca | Conferece Management System</title>
<link rel="shortcut icon" href="http://www.cssreset.com/favicon.png" />
<link href="css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="css/fonts.css" rel="stylesheet" type="text/css" media="all">
<script type="text/javascript" src="http://code.jquery.com/jquery-1.9.1.js"></script>
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
<!-- Login form. -->
<div id="page">
  <header id="header"><a href="calendar.jsp"><img src="images/logo.png" alt="Seneca College of Applied Arts and Technology" tabindex="1" title="Seneca College of Applied Arts and Technology"/></a> </header>
  <section id="login">
    <form id="login" name="formLogin" action="auth.jsp" onSubmit="return validate();" method="post">
      <article >
        <fieldset>
          <div class="component">
            <label for="SenecaLDAPBBBLogin" class="label">Username:</label>
            <input type="text" name="SenecaLDAPBBBLogin" id="SenecaLDAPBBBLogin" class="input" tabindex="2" title="Please insert your username" required autofocus>
          </div>
          <div class="component">
            <label for="SenecaLDAPBBBLoginPass" class="label">Password:</label>
            <input type="password" name="SenecaLDAPBBBLoginPass" id="SenecaLDAPBBBLoginPass" class="input" tabindex="3" title="Please insert your password" required>
          </div>
        </fieldset>
      </article>
      <article>
        <fieldset>
          <div class="buttons">
            <button type="submit" name="submit" id="save" class="button" title="Click here to login">Login</button>
          </div>
        </fieldset>
      </article>
    </form>
  </section>
  <footer>
    <nav id="footerMenu">
      <ul>
        <li><a href="calendar.jsp" title="Click here to go to the home page">Home</a></li>
        <li>|</li>
        <li><a href="contactUs.jsp" title="Click here to enter in contact with us">Contact Us</a></li>
        <li>|</li>
        <li><a href="help.jsp" title="Click here to obtain help information">Help</a></li>
      </ul>
    </nav>
    <div id="copyright">Copyright © 2013 - Seneca College of Applied Arts and Technology</div>
  </footer>
</div>
</body>
</html>