<!doctype html>
<%@page import="db.DBConnection"%>
<%@page import="hash.PasswordHash"%>
<%@page import="sql.User"%>
<%@page import="java.util.*"%>
<%@page import="helper.MyBoolean"%>
<%@page import= "helper.Settings" %>
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Seneca | Change Password</title>
<link rel="icon" href="http://www.cssreset.com/favicon.png">
<link rel="stylesheet" type="text/css" media="all" href="css/fonts.css">
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/style.css">
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.core.css">
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.theme.css">
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.selectmenu.css">
<script type="text/javascript" src="http://code.jquery.com/jquery-1.9.1.js"></script>
<script type="text/javascript" src="js/modernizr.custom.79639.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.position.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.selectmenu.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.stepper.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.dataTable.js"></script>
<script type="text/javascript" src="js/componentController.js"></script>
<% 
	String message = request.getParameter("message");
	if (message == null) {
		message="";
	}
	
	String key = request.getParameter("key");
	String bu_id = request.getParameter("user");
	if (key == null || bu_id == null) {
		response.sendRedirect("index.jsp?error=Invalid username or key");
		return;
	}
	
	String successText="";
	String success = request.getParameter("success");
	if (success == null) {
		success="";
	}
	else
		successText = "Log in with username " + bu_id;
	boolean badParams = false;
	User user = new User(dbaccess);
	ArrayList<ArrayList<String>> keyArray = new ArrayList<ArrayList<String>>();
	ArrayList<String> retrievedKey = new ArrayList<String>();
	user.getSalt(keyArray, bu_id);
	if (keyArray.size() == 0) {
		message = "Invalid username or key";
		badParams = true;
	}
	else {
		if (!keyArray.get(0).get(0).equals(key)) {
			message = "Invalid username or key";
			badParams = true;
		}
	}
%>

<script type="text/javascript">
	window.onload = function() {
	    if(document.readyState == 'complete') {
	        document.getElementById('newPassword').onkeyup = function() {
	            document.getElementById('newPasswordHidden').value = this.value;
	        };
	    }
	};
	
	function trim(s) {
		return s.replace(/^\s*/, "").replace(/\s*$/, "");
	}
	function validate() {
		if (trim(document.getElementById("newPassword").value) == "") {
			alert("Please enter a password");
			document.getElementById("newPassword").focus();
			return false;
		} else if (trim(document.getElementById("confirmPassword").value) == "") {
			alert("Password confirm your new password");
			document.getElementById("confirmPassword").focus();
			return false;
		}
		else if (document.getElementById("newPassword").value != document.getElementById("confirmPassword").value) {
			alert ("Passwords don't match");
			document.getElementById("newPassword").focus();
			return false;
		}
	}
</script>
	
</head>
<body>
<div id="page">
	<jsp:include page="header_plain.jsp"/>
	<section>
	 <header>
      <h1>Guest Setup</h1><%=message%> <%if(success.equals("true")) out.write(successText); %>
    </header>
    <form action="persist_password.jsp?page=guest" method="get" onSubmit="return validate()" <%if (badParams)out.write("hidden=\"hidden\""); %>>
		<article>
		<header>
		    <h2>Edit Password</h2>
		    <img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content"/></header>
		  <fieldset>
		    <div class="component">
		      <label for="newPassword" class="label">New password:</label>
		      <input type="password" name="newPassword" id="newPassword" class="input" tabindex="20" title="New password">
		    </div>
		    <div class="component">
		      <label for="confirmPassword" class="label">Confirm password:</label>
		      <input type="password" name="confirmPassword" id="confirmPassword" class="input" tabindex="21" title="Confirm password">
		    </div>
		    <input type=hidden class="input" name="page" id="page" value="guest">
		    <input type=hidden class="input" name="key" id="key" value="<%=key%>">
		    <input type=hidden class="input" name="bu_id" id="bu_id" value="<%=bu_id%>">
		  </fieldset>
		</article>
		 <article>
        <fieldset>
          <div class="buttons">
            <button type="submit" name="submit" id="save" class="button" title="Click here to save inserted data">Save</button>
            <button type="button" name="button" id="cancel"  class="button" title="Click here to cancel" onclick="window.location.href='calendar.jsp'">Cancel</button>
          </div>
        </fieldset>
      </article>
		</form>
	</section>
	<jsp:include page="footer.jsp"/>
</div>
</body>
</html>