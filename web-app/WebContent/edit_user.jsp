<%@page import="db.DBConnection"%>
<%@page import="sql.User"%>
<%@page import="java.util.*"%>
<%@page import="helper.*"%>
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<!doctype html>
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Seneca | Edit User</title>
<link rel="icon" href="http://www.cssreset.com/favicon.png">
<link rel="stylesheet" type="text/css" media="all" href="css/fonts.css">
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/style.css">
<script type="text/javascript" src="http://code.jquery.com/jquery-1.9.1.js"></script>
<script type="text/javascript" src="js/modernizr.custom.79639.js"></script>
<script type="text/javascript" src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.11.1/jquery.validate.min.js"></script>
<script type="text/javascript" src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.11.1/additional-methods.min.js"></script>

<%
    //Start page validation
    String userId = usersession.getUserId();
    if (userId.equals("")) {
        response.sendRedirect("index.jsp?error=Please log in");
        return;
    }
    if (!usersession.isSuper()) {
        response.sendRedirect("calendar.jsp?message=You don't have permission to access that page!");
        return;
    }
    if (dbaccess.getFlagStatus() == false) {
        response.sendRedirect("index.jsp?error=Database connection error");
        return;
    } //End page validation
    
    String message = request.getParameter("message");
    if (message == null || message == "null") {
        message="";
    }
    
    User user = new User(dbaccess);
    MyBoolean prof = new MyBoolean();
    HashMap<String, Integer> userSettings = new HashMap<String, Integer>();
    HashMap<String, Integer> meetingSettings = new HashMap<String, Integer>();
    HashMap<String, Integer> roleMask = new HashMap<String, Integer>();
    userSettings = usersession.getUserSettingsMask();
    meetingSettings = usersession.getUserMeetingSettingsMask();
    roleMask = usersession.getRoleMask();
    int nickName = roleMask.get("nickname");    
    ArrayList<ArrayList<String>>  bbbUserInfo= new ArrayList<ArrayList<String> >();

    
    // Start User Validatation
    int i = 0;
    boolean searchSucess = false;
    MyBoolean myBool = new MyBoolean();
    
    String bu_id = request.getParameter("id");
    MyBoolean isNonLdap = new MyBoolean();
    if (bu_id!=null) {
        bu_id = Validation.prepare(bu_id);
        if (!(Validation.checkBuId(bu_id))) {
            message = Validation.getErrMsg();
            response.sendRedirect("calendar.jsp?message=" + message);
            return; 
        } 
        else {
	        if (!user.isUser(myBool, bu_id)) {
	            message = user.getErrMsg("AS04");
	            response.sendRedirect("calendar.jsp?message=" + message);
	            return;   
	        }
	        // User already in Database
	        if (myBool.get_value()) {   
	            searchSucess = true;
	        } 
	        else {
	            message = "Invalid User Id";
	            response.sendRedirect("calendar.jsp?message=" + message);
	            return;
	        }
        }
    }
    // End User Validatation
   
    //get all information for this user
    if(searchSucess){
    	user.isnonLDAP(isNonLdap, bu_id);
        user.getUserInfo(bbbUserInfo,bu_id);
    }else{
    	response.sendRedirect("calendar.jsp?message=Invalid User Id");
    	return;
    }
        
%>
</head>
<body>
<div id="page">
    <jsp:include page="header.jsp"/>
    <jsp:include page="menu.jsp"/>
    <section>
        <header> 
            <!-- BREADCRUMB -->
            <p><a href="calendar.jsp" tabindex="13">home</a> » <a href="manage_users.jsp" tabindex="14">manage users</a>» <a href="edit_user.jsp" tabindex="15">edit user</a></p>
            <!-- PAGE NAME -->
            <h1>Edit User Information</h1>
            <!-- WARNING MESSAGES -->
            <div class="warningMessage"><%=message %></div>
        </header>
        <form name="userInfor" id="userInfor" action="persist_user_info.jsp" method="get">
            <article>
                <header>
                    <h2>User's Information</h2>
                    <img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content"/>
                </header>
                <div class="content">            
                    <fieldset>
	                    <div class="component">
		                    <label for="bbbUserId" class="label">User ID:</label>
		                    <input name="bbbUserId" id="bbbUserId" class="input" tabindex="16" title="User ID" type="text" value="<%= bu_id %>"  readonly>
	                    </div>
	                    <div class="component">
                            <label for="bbbUserIsLdap" class="label">Is Ldap:</label>
                            <input name="bbbUserIsLdap" id="bbbUserIsLdap" class="input" tabindex="22" title="Is Ldap" type="text" value="<%= bbbUserInfo.get(0).get(6) %>"  readonly>
                        </div>
	                    <div class="component">
                            <label for="bbbUserIsBanned" class="label">Is Banned:</label>
                            <input name="bbbUserIsBanned" id="bbbUserIsBanned" class="input" tabindex="22" title="Is Banned" type="text" value="<%= bbbUserInfo.get(0).get(2) %>" required autofocus>
                        </div>
                        <div class="component">
                            <label for="bbbUserIsActive" class="label">Is Active:</label>
                            <input name="bbbUserIsActive" id="bbbUserIsActive" class="input" tabindex="23" title="Is Active" type="text" value="<%= bbbUserInfo.get(0).get(3) %>" required autofocus>
                        </div>  
                        <div class="component">
                            <label for="bbbUserIsSuper" class="label">Is Super:</label>
                            <input name="bbbUserIsSuper" id="bbbUserIsSuper" class="input" tabindex="23" title="Is Active" type="text" value="<%= bbbUserInfo.get(0).get(7) %>" required autofocus>
                        </div>  
	                        <%  if (isNonLdap.get_value()){ %> 
			                    <div class="component">
		                            <label for="bbbUserName" class="label">First Name:</label>
		                            <input name="bbbUserName" id="bbbUserName" class="input" tabindex="17" title="User Name" type="text" value="<%= bbbUserInfo.get(0).get(11) %>" required autofocus>
		                        </div>
		                        <div class="component">
		                            <label for="bbbUserLastName" class="label">Last Name:</label>
		                            <input name="bbbUserLastName" id="bbbUserLastName" class="input" tabindex="18" title="Last Name" type="text" value="<%= bbbUserInfo.get(0).get(12) %>" required autofocus>
		                        </div>                       
		                        <div class="component">
		                            <label for="bbbUserEmail" class="label">User Email:</label>
		                            <input name="bbbUserEmail" id="bbbUserEmail" class="input" tabindex="19" title="User Email" type="text" value="<%= bbbUserInfo.get(0).get(13) %>" required autofocus>
		                        </div>
	                         <%} %>                 
                        <div class="component">
                            <div class="buttons">
                               <input type="submit" name="updateUser" id="updateUser" class="button" value="update" title="Click here to update" >
                               <input type="reset" name="resetUser" id="resetUser" class="button" title="Click here to reset">                            
                               <input type="button" name="button" id="cancelEdit"  value="cancel" class="button" title="Click here to cancel" 
                                onclick="window.location.href='manage_users.jsp'">
                            </div>
                        </div>
                    </fieldset>
                </div>
            </article>
        </form>
    </section>
    <script>    
   // form validation, edit the regular expression pattern and error messages to meet your needs
       $(document).ready(function(){
            $('#userInfor').validate({
                validateOnBlur : true,
                rules: {
                	bbbUserIsBanned: {
                       required: true,
                       pattern: /^\s*[01]\s*$/
                   },
                   bbbUserIsActive: {
                       required: true,
                       pattern: /^\s*[01]\s*$/
                   },
                   bbbUserIsSuper: {
                       required: true,
                       pattern: /^\s*[01]\s*$/
                   },
                   bbbUserName: {
                       required: true,
                       pattern: /^\s*[a-zA-Z]+[\.\-a-zA-Z]*\s*$/
                   },
                   bbbUserLastName: {
                       required: true,
                       pattern: /^\s*[a-zA-Z]+[\.\-a-zA-Z]*\s*$/
                   },
                   bbbUserEmail: {
                       required: true,
                       email: true
                   }
                },
                messages: {
                	bbbUserIsBanned: { 
                        pattern:"Only 0 or 1 is valid",
                        required:"this field is required"
                    },
                    bbbUserIsActive:{
                        required: "this field is require",
                        pattern: "Only 0 or 1 is valide"
                    },
                    bbbUserIsSuper:{
                        required: "this field is required",
                        pattern: "Only 0 or 1 is valid"
                    },
                    bbbUserName:{
                        required: "this field is required",
                        pattern: "Invalid name"
                    },
                    bbbUserLastName:{
                        required: "this field is required",
                        pattern: "Invalid name"
                    },
                    bbbUserEmail:{
                        required: "this field is required",
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