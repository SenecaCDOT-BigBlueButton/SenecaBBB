<!doctype html>
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Seneca | Invite Guest</title>
<link rel="shortcut icon" href="http://www.cssreset.com/favicon.png" />
<!--<link href="css/style.css" rel="stylesheet" type="text/css" media="screen and (min-width:1280px)">-->
<link href="css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="css/fonts.css" rel="stylesheet" type="text/css" media="all">
<script type="text/javascript" src="http://code.jquery.com/jquery-1.9.1.js"></script>
<script type="text/javascript" src="js/modernizr.custom.79639.js"></script>
<script type="text/javascript" src="js/component.js"></script>
<script type="text/javascript" src="js/componentStepper.js"></script>

<% 
	String message = request.getParameter("message");
	if (message == null || message == "null") {
		message="";
	}
	
	String firstName = request.getParameter("firstName");
	if (firstName == null || firstName == "null") {
		firstName="";
	}
	
	String lastName = request.getParameter("lastName");
	if (lastName == null || lastName == "null") {
		lastName="";
	}
	
	String email = request.getParameter("email");
	if (email == null || email == "null") {
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
