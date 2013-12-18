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
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.core.css">
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.theme.css">
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.selectmenu.css">
<script type="text/javascript" src="js/jquery-1.9.1.js"></script>  
<script type="text/javascript" src="js/modernizr.custom.79639.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.position.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.selectmenu.js"></script>    
<script type="text/javascript" src="js/jquery.validate.min.js"></script>
<script type="text/javascript" src="js/additional-methods.min.js"></script>

<%
    //Start page validation
    String userId = usersession.getUserId();
    GetExceptionLog elog = new GetExceptionLog();
    if (userId.equals("")) {
    	session.setAttribute("redirecturl", request.getRequestURI()+(request.getQueryString()!=null?"?"+request.getQueryString():""));
        response.sendRedirect("index.jsp?message=Please log in");
        return;
    }
    if (!usersession.isSuper()) {
        elog.writeLog("[edit_user:] " + " username: "+ userId + " tried to access this page, permission denied" +" /n");       
        response.sendRedirect("calendar.jsp?message=You don't have permission to access that page!");
        return;
    }
    if (dbaccess.getFlagStatus() == false) {
    	elog.writeLog("[edit_user:] " + "Database connection error /n");
        response.sendRedirect("index.jsp?message=Database connection error");
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
    
    User user = new User(dbaccess);
    MyBoolean prof = new MyBoolean();
    HashMap<String, Integer> userSettings = new HashMap<String, Integer>();
    HashMap<String, Integer> meetingSettings = new HashMap<String, Integer>();
    HashMap<String, Integer> roleMask = new HashMap<String, Integer>();
    userSettings = usersession.getUserSettingsMask();
    meetingSettings = usersession.getUserMeetingSettingsMask();
    roleMask = usersession.getRoleMask();
    ArrayList<ArrayList<String>> bbbUserInfo = new ArrayList<ArrayList<String> >();
    ArrayList<ArrayList<String>> userRoleList = new ArrayList<ArrayList<String> >();

    
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
            elog.writeLog("[edit_user:] " + message +" /n");
            response.sendRedirect("calendar.jsp?message=" + message);
            return; 
        } 
        else {
	        if (!user.isUser(myBool, bu_id)) {
	            message = user.getErrMsg("AS04");
	            elog.writeLog("[edit_user:] " + message +" /n");
	            response.sendRedirect("calendar.jsp?message=" + message);
	            return;   
	        }
	        // User already in Database
	        if (myBool.get_value()) {   
	            searchSucess = true;
	        } 
	        else {
	            message = "Invalid User Id";
	            elog.writeLog("[edit_user:] " + message +" /n");
	            response.sendRedirect("calendar.jsp?message=" + message);
	            return;
	        }
        }
    }
    // End User Validatation
   
    //get all information for this user
    if(searchSucess){
    	user.isnonLDAP(isNonLdap, bu_id);
        user.getUserInfo(bbbUserInfo, bu_id);
        user.getRoleInfo(userRoleList);
    }else{
    	elog.writeLog("[edit_user:] " + "invalid user id" +" /n");
    	response.sendRedirect("calendar.jsp?message=Invalid User Id");
    	return;
    }
        
%>
<script type="text/javascript">
	$(document).ready(function() {
		<%if (bbbUserInfo.get(0).get(2).equals("0")) {%>
		    $(".checkbox .box:eq(0)").next(".checkmark").toggle();
		    $(".checkbox .box:eq(0)").attr("aria-checked", "false");
		    $(".checkbox .box:eq(0)").siblings().last().prop("checked", false);
		<%}%>
		<%if (bbbUserInfo.get(0).get(3).equals("0")) {%>
		    $(".checkbox .box:eq(1)").next(".checkmark").toggle();
		    $(".checkbox .box:eq(1)").attr("aria-checked", "false");
		    $(".checkbox .box:eq(1)").siblings().last().prop("checked", false);
		<%}%>
		<%if (bbbUserInfo.get(0).get(7).equals("0")) {%>
		    $(".checkbox .box:eq(2)").next(".checkmark").toggle();
		    $(".checkbox .box:eq(2)").attr("aria-checked", "false");
		    $(".checkbox .box:eq(2)").siblings().last().prop("checked", false);
		<%}%>
	});
	/* SELECT BOX */
	$(function(){
	    $('select').selectmenu();
	});
</script>
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
            <div class="successMessage"><%=successMessage %></div> 
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
                            <label for="bbbUserNickname" class="label">Nick Name:</label>
                            <input name="bbbUserNickname" id="bbbUserNickname" class="input" tabindex="16" title="Nick Name" type="text" value="<%= bbbUserInfo.get(0).get(1) %>" required autofocus>
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
                            <label for="bbbUserList" class="label">User Role:</label>
                            <select name="bbbUserList" id="bbbUserList" title="Please Select a user role">
                            <% for(i=0;i<userRoleList.size();i++){ %>
                                <option <% if(bbbUserInfo.get(0).get(8).equals(Integer.toString(i+1))){out.print("selected=selected");} %>><%= userRoleList.get(i).get(0).concat("-").concat(userRoleList.get(i).get(1)) %></option>
                            <% } %>
                            </select>
                        </div>
                       <div class="component">
                            <div class="checkbox" title="bbbUser Is Banned"> <span class="box" role="checkbox"  aria-checked="true"  aria-labelledby="userinfor1"></span>
                                <label class="checkmark"></label>
                                <label class="text" id="bbbUserIsBanned">Is User Banned</label>
                                <input type="checkbox" name="bbbUserIsBanned" id="bbbUserIsBanned" checked="checked" >
                            </div>
                        </div>
                       <div class="component">
                            <div class="checkbox" title="bbbUser Is Active"> <span class="box" role="checkbox"  aria-checked="true" aria-labelledby="userinfor2"></span>
                                <label class="checkmark"></label>
                                <label class="text" id="bbbUserIsActive">Is User Active</label>
                                <input type="checkbox" name="bbbUserIsActive" id="bbbUserIsActive" checked="checked" >
                            </div>
                        </div>
                       <div class="component">
                            <div class="checkbox" title="bbbUser Is Super"> <span class="box" role="checkbox"  aria-checked="true"  aria-labelledby="userinfor3"></span>
                                <label class="checkmark"></label>
                                <label class="text" id="bbbUserIsSuper">Is Super Admin</label>
                                <input type="checkbox" name="bbbUserIsSuper" id="bbbUserIsSuper" checked="checked" >
                            </div>
                        </div>                                    
                        <div class="component">
                            <div class="buttons">
                               <input type="submit" name="updateUser" id="updateUser" class="button" value="update" title="Click here to update" tabindex="20" >
                               <input type="reset" name="resetUser" id="resetUser" class="button" title="Click here to reset" tabindex="21" >                            
                               <input type="button" name="button" id="cancelEdit"  value="cancel" class="button" title="Click here to cancel" 
                                onclick="window.location.href='manage_users.jsp'" tabindex="22" >
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
                	bbbUserNickname: {
                        required: true,
                        pattern: /^\s*[a-zA-Z]+[\.\-a-zA-Z0-9 ]*\s*$/
                    },                  
                	bbbUserName: {
                       required: true,
                       pattern: /^\s*[a-zA-Z]+[\.\-a-zA-Z0-9 ]*\s*$/
                   },
                   bbbUserLastName: {
                       required: true,
                       pattern: /^\s*[a-zA-Z]+[\.\-a-zA-Z0-9 ]*\s*$/
                   },
                   bbbUserEmail: {
                       required: true,
                       email: true
                   }
                },
                messages: {
                	bbbUserNickname:{
                        required: "this field is required",
                        pattern: "Invalid nick name"
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