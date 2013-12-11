<%@page import="db.DBConnection"%>
<%@page import="sql.User"%>
<%@page import="java.util.*"%>
<%@page import="java.lang.Integer"%>
<%@page import="helper.*"%>

<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<jsp:useBean id="ldap" class="ldap.LDAPAuthenticate" scope="session" />
<!doctype html>
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Seneca | Manage Users</title>
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
<script type="text/javascript" src="js/ui/jquery.ui.stepper.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.dataTable.js"></script>
<%@ include file="search.jsp" %>
<script type="text/javascript">
function searchUser(){
    var xmlhttp;
    if (window.XMLHttpRequest)
    {// code for IE7+, Firefox, Chrome, Opera, Safari
      xmlhttp=new XMLHttpRequest();
    }
    else
    {// code for IE6, IE5
      xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
    }
    xmlhttp.onreadystatechange=function()
    {
      if (xmlhttp.readyState==4 && xmlhttp.status==200)
      {
          var json = xmlhttp.responseText;
          obj = JSON.parse(json);
        document.getElementById("responseDiv").innerHTML=xmlhttp.responseText;
      }
    }
    userName = document.getElementById("searchBoxAddAttendee").value;
    xmlhttp.open("GET","search.jsp?userName=" + userName,true);
    xmlhttp.send();
}

//Table
$(screen).ready(function() {
    /* USERS LIST */    
    $('#usersList').dataTable({"sPaginationType": "full_numbers"});
    $('#usersList').dataTable({"aoColumnDefs": [{ "bSortable": false, "aTargets":[5]}], "bRetrieve": true, "bDestroy": true});
    $.fn.dataTableExt.sErrMode = 'throw';
    $('.dataTables_filter input').attr("placeholder", "Filter entries");

});
/* SELECT BOX */
$(function(){
    $('select').selectmenu();
});
</script>
<%
    //Start page validation
    String userId = usersession.getUserId();
    GetExceptionLog elog = new GetExceptionLog();
    if (userId.equals("")) {
    	elog.writeLog("[manage_users:] " + "unauthenticated user tried to access this page /n");
        response.sendRedirect("index.jsp?message=Please log in");
        return;
    }
    if (!usersession.isSuper()) {
        elog.writeLog("[manage_users:] " + " username: "+ userId + " tried to access this page, permission denied" +" /n");               
    	response.sendRedirect("calendar.jsp?message=You don't have permission to access that page!");
        return;
    }
    if (dbaccess.getFlagStatus() == false) {
    	elog.writeLog("[manage_users:] " + "database connection error /n");
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
    ArrayList<ArrayList<String>>  allUserInfo= new ArrayList<ArrayList<String> >();
    user.getUserInfo(allUserInfo);
    
    // Start User Search
    String bu_id = request.getParameter("searchBox");
    MyBoolean myBool = new MyBoolean();
    if (bu_id!=null) {
        bu_id = Validation.prepare(bu_id);
        if (!(Validation.checkBuId(bu_id))) {
            message = Validation.getErrMsg();
        }
        else {
        	user.isUser(myBool, bu_id);
            if (myBool.get_value()) {
                message = "User "+ bu_id +" already in database";
                response.sendRedirect("manage_users.jsp?message=" + message);
                return;   
            }else {
                // Found userId in LDAP
                if (findUser(dbaccess, ldap, bu_id)) {
                	response.sendRedirect("manage_users.jsp?successMessage=User "+ bu_id +" added in database successfully!");
                	return;
                } else {
                    message = "User Not Found";
                }
            }
        }
    }
    // End User Search

%>
</head>
<body>
<div id="page">
    <jsp:include page="header.jsp"/>
    <jsp:include page="menu.jsp"/>
    <section>
        <header> 
            <!-- BREADCRUMB -->
            <p><a href="calendar.jsp" tabindex="13">home</a> » <a href="manage_users.jsp" tabindex="14">manage users</a></p>
            <!-- PAGE NAME -->
            <h1>Manage Users</h1>
            <!-- WARNING MESSAGES -->
            <div class="warningMessage" ><%=message %></div>          
            <div class="successMessage"><%=successMessage %></div> 
        </header>

        <form>
             <article>
                <header>
                  <h2>Add Internal User</h2>
                  <img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content" alt="Arrow"/>
                </header>
                <div class="content">
                    <fieldset>
                        <div class="component">
                            <label for="searchBoxAddUser" class="label">Add User:</label>
                              <input type="text" name="searchBox" id="searchBox" class="searchBox" tabindex="37" title="Search user">
                              <button type="submit" name="search" class="search" tabindex="38" title="Search user"></button><div id="responseDiv"></div>
                        </div>
                    </fieldset>
                </div>
            </article>
            <article>
                <header>
                    <h2>All Users Information</h2>
                    <img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content"/>
                </header>
                <div class="content">
                    <fieldset>
                        <div class="component">
                            <div class="tableComponent">
				                <table id="usersList" border="0" cellpadding="0" cellspacing="0">
									<thead>
									  <tr>
									    <th width="100" class="firstColumn" tabindex="16" title="Username">ID<span></span></th>
									    <th width="150">Nick Name<span></span></th>
									    <th >Is Banned<span></span></th>
									    <th width="100" title="Last Name">Is Active<span></span></th>
									    <th width="100" title="Email">Is Ldap<span></span></th>
									    <th width="100" title="Created Time">Is Super<span></span></th>
									    <th width="100" title="View Schedule" class="icons"  align="center">Schedule</th>
									    <th width="65" title="Edit" class="icons"  align="center">Edit</th>								    
									  </tr>
									</thead>
									<tbody>
									<% for(int i=0;i<allUserInfo.size();i++){ %>							   
									  <tr>
									    <td class="row"><%= allUserInfo.get(i).get(0) %></td>
									    <td><%= allUserInfo.get(i).get(1) %></td>
									    <td><%= allUserInfo.get(i).get(2) %></td>
									    <td><%= allUserInfo.get(i).get(3) %></td>
									    <td><%= allUserInfo.get(i).get(6) %></td>
									    <td><%= allUserInfo.get(i).get(7) %></td>
									    <td class="icons" align="center"><a  class="schedule"  href='view_schedule.jsp?id=<%= allUserInfo.get(i).get(0) %>' ><img alt="Search" src="images/iconPlaceholder.svg" width="17" height="17" title="User Schedule" /></a></td>
									    <td class="icons" align="center"><a  class="modify" href= <%= "edit_user.jsp?id=" +  allUserInfo.get(i).get(0)  +"&action=edit" %>><img alt="Edit" src="images/iconPlaceholder.svg" width="17" height="17" title="Edit User" /></a></td>
									 </tr>
								   <%}%>
									</tbody>
				                </table>
                            </div>
                        </div>
                    </fieldset>
                </div>
            </article>
        </form>
    </section>
    <jsp:include page="footer.jsp"/>
</div>
</body>
</html>
