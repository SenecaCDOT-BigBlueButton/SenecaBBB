<%@page import="java.util.*"%>
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<!doctype html>
<html lang="en">
<head>
<title>Seneca | Invite Guest</title>
<link rel="stylesheet" type="text/css" media="all" href="css/fonts.css">
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/style.css">
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.core.css">
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.theme.css">
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.datepicker.css">
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.selectmenu.css">
<link rel='stylesheet' type="text/css" href='fullcalendar-1.6.3/fullcalendar/fullcalendar.css'>
<script type="text/javascript" src="http://code.jquery.com/jquery-1.9.1.js"></script>
<script type="text/javascript" src='fullcalendar-1.6.3/fullcalendar/fullcalendar.js'></script>
<script type="text/javascript" src="js/modernizr.custom.79639.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.position.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.selectmenu.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.stepper.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.dataTable.js"></script>
<script type="text/javascript" src="js/componentController.js"></script>

<% 
	//Start page validation
	String userId = usersession.getUserId();
	if (userId.equals("")) {
		response.sendRedirect("index.jsp?error=Please log in");
		return;
	}
	if (dbaccess.getFlagStatus() == false) {
		response.sendRedirect("index.jsp?error=Database connection error");
		return;
	} 
	HashMap<String, Integer> roleMask = usersession.getRoleMask();
	if (roleMask.get("guestAccountCreation") == 0){}
		response.sendRedirect("index.jsp?error=Permission denied");
	//End page validation
	
	String message = request.getParameter("message");
	if (message == null) {
		message="";
	}
	
	String firstName = request.getParameter("firstName");
	if (firstName == null) {
		firstName="";
	}
	
	String lastName = request.getParameter("lastName");
	if (lastName == null) {
		lastName="";
	}
	
	String email = request.getParameter("email");
	if (email == null) {
		email="";
	}
%>
	
</head>
<body>
<div id="page">
	<jsp:include page="header.jsp"/>
	<jsp:include page="menu.jsp"/>
	<section>
	 <header>
      <p><a href="calendar.jsp" tabindex="13">home</a> » <a href="create_event.jsp" tabindex="14">create event</a> » invite guest</p>
      <h1>Invite Guest</h1><%=message%>
    </header>
    <form action="generate_guest.jsp" method="get">
		<article>
		<header>
		    <h2>Invite Guest</h2>
		    <img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content"/></header>
		  <fieldset>
		    <div class="component">
		      <label for="firstName" class="label">Guest first name:</label>
		      <input type="text" name="firstName" id="firstName" class="input" tabindex="19" title="First Name" value="<%=firstName%>">
		    </div>
		    <div class="component">
		      <label for="lastName" class="label">Guest last name:</label>
		      <input type="text" name="lastName" id="lastName" class="input" tabindex="20" title="Last Name" value="<%=lastName%>">
		    </div>
		    <div class="component">
		      <label for="email" class="label">Guest email:</label>
		      <input type="email" name="email" id="email" class="input" tabindex="21" title="Email" value="<%=email%>">
		    </div>
		  </fieldset>
		</article>
		 <article>
        <fieldset>
          <div class="buttons">
            <button type="submit" name="submit" id="save" class="button" title="Click here to save inserted data">Save</button>
            <button type="button" name="button" id="cancel"  class="button" title="Click here to cancel">Cancel</button>
          </div>
        </fieldset>
      </article>
		</form>
	</section>
	<jsp:include page="footer.jsp"/>
</div>
</body>
</html>
