<%@page import="db.DBConnection"%>
<jsp:useBean id="ldap" scope="session" class="ldap.LDAPAuthenticate" />
<%
	String error = request.getParameter("error");
	if (error == null) {
		error = "";
	} 
	String guestMessage = "";
	String bu_id = "";
	String guestCreated = request.getParameter("guestCreated");
	if (guestCreated == null)
		guestCreated = "false";
	if (guestCreated.equals("true")){
		bu_id = request.getParameter("bu_id");
		if (bu_id == null) {
			bu_id = "";
		} 
		else 
			error = "Log in with username " + bu_id + "and the password you just set";
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
<link href="css/themes/base/style.css" rel="stylesheet" type="text/css" media="all">
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
  <jsp:include page="header_plain.jsp"/>
  <section id="login">
    <form id="login" name="formLogin" action="auth.jsp" onSubmit="return validate();" method="post">
      <article >
        <fieldset>
          <div class="component">
          	<!-- Prints 'error' on the screen. --><%System.out.println(error); %>
            <label id="error" class="label"><%=error%></label>
          </div>
          <div class="component">
            <label for="SenecaLDAPBBBLogin" class="label">Username:</label>
            <input type="text" name="SenecaLDAPBBBLogin" id="SenecaLDAPBBBLogin" class="input" tabindex="2" title="Please insert your username" required autofocus value="<%=bu_id%>">
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
 <jsp:include page="footer.jsp"/>
</div>
</body>
</html>