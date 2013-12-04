<%@page import="db.DBConnection"%>
<%@page import="helper.*"%>
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<!doctype html>
<html lang="en">
<head>
<title>Seneca | Change Password</title>
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
<script type="text/javascript">

    function trim(s) {
        return s.replace(/^\s*/, "").replace(/\s*$/, "");
    }
    function validate() {
        if (trim(document.getElementById("currentPassword").value) == "") {
            alert("Please enter your current password");
            document.getElementById("currentPassword").focus();
            return false;
        } 
        if (trim(document.getElementById("newPassword").value) == "") {
            alert("Please enter a password");
            document.getElementById("newPassword").focus();
            return false;
        } 
        if (trim(document.getElementById("confirmPassword").value) == "") {
            alert("Please confirm your new password");
            document.getElementById("confirmPassword").focus();
            return false;
        }
        if (document.getElementById("newPassword").value != document.getElementById("confirmPassword").value) {
            alert ("Passwords don't match");
            document.getElementById("newPassword").focus();
            return false;
        }
        return true;
    }
</script>
<%  
	//Start page validation
	String userId = usersession.getUserId();
    GetExceptionLog elog = new GetExceptionLog();
	if (userId.equals("")) {
		elog.writeLog("[edit_password:] " + "unauthenticated user tried to access this page /n");
		response.sendRedirect("index.jsp?error=Please log in");
		return;
	}
	if (dbaccess.getFlagStatus() == false) {
		elog.writeLog("[edit_password:] " + "database connection error /n");
		response.sendRedirect("index.jsp?error=Database connection error");
		return;
	} //End page validation
	
    String message = request.getParameter("message");
    String successMessage = request.getParameter("successMessage");
    if (message == null || message == "null") {
        message="";
    }
    if (successMessage == null) {
        successMessage="";
    }
%>
</head>
<body>
<div id="page">
	<jsp:include page="header.jsp"/>
	<jsp:include page="menu.jsp"/>
	<section>
		<header>
			<p><a href="calendar.jsp" tabindex="13">home</a> » <a href="settings.jsp" tabindex="14">settings</a> » <a href="edit_password.jsp" tabindex="15">change password</a></p>
			<h1>Change Password</h1>
			<div class="warningMessage"><%=message %></div>
			<div class="successMessage"><%=successMessage %></div> 
		</header>
		<form action="persist_password.jsp" method="get" onSubmit="return validate()">
			<article>
				<header>
					<h2>Edit Password</h2>
					<img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content"/></header>
				<div class ="content">
					<fieldset>
						<div class="component">
							<label for="currentPassword" class="label">Current password:</label>
							<input type="hidden" name="frompage" id="frompage" value="edit_password">
							<input type="password" name="currentPassword" id="currentPassword" class="input" tabindex="16" title="Current password" required>
						</div>
						<div class="component">
							<label for="newPassword" class="label">New password:</label>
							<input type="password" name="newPassword" id="newPassword" class="input" tabindex="17" title="New password" required>
						</div>
						<div class="component">
							<label for="confirmPassword" class="label">Confirm password:</label>
							<input type="password" name="confirmPassword" id="confirmPassword" class="input" tabindex="18" title="Confirm password" required>
						</div>
					</fieldset>
				</div>
			</article>
			<article>
				<h4></h4>
				<fieldset>
					<div class="actionButtons">
						<button type="submit" name="submit" id="save" class="button" title="Click here to save inserted data">Save</button>
						<button type="button" name="button" id="cancel" class="button" title="Click here to cancel" onclick="window.location.href='settings.jsp'">Cancel</button>
					</div>
				</fieldset>
			</article>
		</form>
	</section>
	<jsp:include page="footer.jsp"/>
</div>
</body>
</html>