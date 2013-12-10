<%@page import="java.util.*"%>
<%@page import="helper.*"%>
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<!doctype html>
<html lang="en">
<head>
	<title>Seneca | Create Guest Account</title>
	<link rel="stylesheet" type="text/css" media="all" href="css/fonts.css">
	<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/style.css">
	<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.core.css">
	<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.theme.css">
	<script type="text/javascript" src="js/jquery-1.9.1.js"></script>
	<script type="text/javascript" src="js/modernizr.custom.79639.js"></script>
	<script type="text/javascript" src="js/ui/jquery.ui.core.js"></script>
	<script type="text/javascript" src="js/ui/jquery.ui.widget.js"></script>
	<script type="text/javascript" src="js/ui/jquery.ui.position.js"></script>
	<script type="text/javascript" src="js/ui/jquery.ui.stepper.js"></script>
	<script type="text/javascript" src="js/jquery.validate.min.js"></script>
	<script type="text/javascript" src="js/additional-methods.min.js"></script>
</head>
<body>
<%
	//Start page validation
	String userId = usersession.getUserId();
    GetExceptionLog elog = new GetExceptionLog();
    HashMap<String, Integer> roleMask = usersession.getRoleMask();
	if (userId.equals("")) {
		elog.writeLog("[invite_guest:] " + "unauthenticated user tried to access this page /n");
	    response.sendRedirect("index.jsp?message=Please log in");
	    return;
	}
	if(!(usersession.isSuper()||usersession.getUserLevel().equals("employee")||roleMask.get("guestAccountCreation") == 0)) {
	    elog.writeLog("[invite_guest:] " + " username: "+ userId + " tried to access this page, permission denied" +" /n");	       
		response.sendRedirect("calendar.jsp?message=You do not have permission to access that page");
	    return;
	}
    if (dbaccess.getFlagStatus() == false) {
        elog.writeLog("[invite_guest:] " + "database connection error /n");
        response.sendRedirect("index.jsp?message=Database connection error");
        return;
    }//End page validation
    
    String message = request.getParameter("message");
    String successMessage = request.getParameter("successMessage");
    if (message == null || message == "null") {
        message="";
    }
    if (successMessage == null) {
        successMessage="";
    }

    String firstName = request.getParameter("firstName");
    String lastName = request.getParameter("lastName");
    String email = request.getParameter("email");
%>
<div id="page">
	<jsp:include page="header.jsp"/>
	<jsp:include page="menu.jsp"/>
	<section>
		<header>
	        <p><a href="calendar.jsp" tabindex="13">home</a>  » <a href="invite_guest.jsp" tabindex="14">create guest account</a></p>
	        <h1>Create Guest Account</h1>
            <!-- WARNING MESSAGES -->
            <div class="warningMessage"><%= message %></div>
            <div class="successMessage"><%=successMessage %></div> 
	    </header>
	    <form name="guestaccuntinfo" id="guestaccuntinfo"  method="get" action="generate_guest.jsp">
			<article>
				<header>
				    <h2>Guest Information</h2>
                </header>
				<fieldset>
				    <div class="component">
				        <label for="firstName" class="label"> first name:</label>
				        <input type="text" name="firstName" id="firstName" class="input" tabindex="15" title="First Name" <% if(firstName != null) out.print("value="+firstName); %>>
				    </div>
				    <div class="component">
				        <label for="lastName" class="label"> last name:</label>
				        <input type="text" name="lastName" id="lastName" class="input" tabindex="16" title="Last Name" <% if(lastName != null) out.print("value="+lastName); %>>
				    </div>
				    <div class="component">
				        <label for="email" class="label">Guest email:</label>
				        <input type="email" name="email" id="email" class="input" tabindex="17" title="Email" <% if(email != null) out.print("value="+email); %>>
				    </div>
				</fieldset>
			</article>
			<article>
		        <fieldset>
		            <div class="buttons">
		                <button type="submit" name="submit" id="save" class="button" title="Click here to create account">Create</button>
		                <button type="button" name="button" id="cancel"  class="button" title="Click here to cancel" onclick="window.location.href='<% if(usersession.isSuper()) out.print("manage_users.jsp"); else out.print("calendar.jsp");%>'">Cancel</button>
		            </div>
		        </fieldset>
	        </article>
	    </form>
	</section>
	<script>    
   // form validation, edit the regular expression pattern and error messages to meet your needs
       $(document).ready(function(){
            $('#guestaccuntinfo').validate({
                validateOnBlur : true,
                rules: {
                	firstName: {
                       required: true,
                       pattern: /^\s*[a-zA-Z]+[\.\-a-zA-Z]*\s*$/
                   },
                   lastName:{
                       required: true,
                       pattern: /^\s*[a-zA-Z]+[\.\-a-zA-Z]*\s*$/
                   },
                   email:{
                       required: true,
                       email: true
                   }

                },
                messages: {
                    firstName: {
                        required: "Please enter guest first name",
                        pattern: "invalid name"
                    },
                    lastName:{
                        required: "Please enter guest last name",
                        pattern: "invalid name"
                    },
                    email:{
                        required: "Please enter guest email",
                        email: "invalid email"
                    }
                }
            });
        });
    </script>
	<jsp:include page="footer.jsp"/>
</div>
</body>
</html>
