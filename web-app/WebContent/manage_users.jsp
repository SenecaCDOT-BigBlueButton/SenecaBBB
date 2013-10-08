<%@page import="db.DBConnection"%>
<%@page import="sql.User"%>
<%@page import="java.util.*"%>
<%@page import="java.lang.Integer"%>
<%@page import="helper.MyBoolean"%>

<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
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
<script type="text/javascript" src="http://code.jquery.com/jquery-1.9.1.js"></script>
<script type="text/javascript" src="js/modernizr.custom.79639.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.dataTable.js"></script>
<script type="text/javascript" src="js/componentController.js"></script>
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
    /* ATTENDEES LIST 
    $('#addAttendee').dataTable({
        "bPaginate": false,
        "bLengthChange": false,
        "bFilter": false,
        "bSort": true,
        "bInfo": false,
        "bAutoWidth": false});
    $('#addAttendee').dataTable({"aoColumnDefs": [{ "bSortable": false, "aTargets":[5]}], "bRetrieve": true, "bDestroy": true});
    */   $.fn.dataTableExt.sErrMode = 'throw';
    $('.dataTables_filter input').attr("placeholder", "Filter entries");
     
    /* ATTENDEES LIST */    
    $('#attendeesList').dataTable({"sPaginationType": "full_numbers"});
    $('#attendeesList').dataTable({"aoColumnDefs": [{ "bSortable": false, "aTargets":[5]}], "bRetrieve": true, "bDestroy": true});
    $.fn.dataTableExt.sErrMode = 'throw';
    $('.dataTables_filter input').attr("placeholder", "Filter entries");
});
</script>
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
    
    ArrayList<ArrayList<String>>  allUserInfo= new ArrayList<ArrayList<String> >();
    user.getUserInfo(allUserInfo);
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
            <div class="warningMessage" style="color:red;"><%=message %></div>
        </header>
        <form>
            <article>
                <header>
                    <h2>BBB Users</h2>
                    <img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content"/>
                </header>
  
                <div class="content">
                    <fieldset>
                        <div class="component">
                            <div class="tableComponent">
				                <table id="attendeesList" border="0" cellpadding="0" cellspacing="0">
									<thead>
									  <tr>
									    <th width="50" class="firstColumn" tabindex="16" title="Username">ID<span></span></th>
									    <th title="Name">User Name<span></span></th>
									    <th width="100" title="Last Name">Last Name<span></span></th>
									    <th width="200" title="Email">Email<span></span></th>
									    <th width="100" title="Created Time">Created Time<span></span></th>
									    <th width="65" title="View Schedule" class="icons"  align="center">Schedule</th>
									    <th width="65" title="Edit" class="icons"  align="center">Edit</th>
									    <th width="65" title="Remove" class="icons" align="center">Ban</th>
									  </tr>
									</thead>
									<tbody>
									<% for(int i=0;i<allUserInfo.size();i++){ %>							   
									  <tr>
									    <td class="row"><%= allUserInfo.get(i).get(0) %></td>
									    <td><%= allUserInfo.get(i).get(11) %></td>
									    <td><%= allUserInfo.get(i).get(12) %></td>
									    <td><%= allUserInfo.get(i).get(13) %></td>
									    <td><%= allUserInfo.get(i).get(14) %></td>
									    <td  class="icons" align="center"><a class="search" href='view_schedule.jsp?id=<%= allUserInfo.get(i).get(0) %>' ><img alt="Search" src="images/iconPlaceholder.svg" width="17" height="17" title="User Schedule" /></a></td>
									    <td class="icons" align="center"><a class="modify" href='edit_user.jsp?id=<%= allUserInfo.get(i).get(0) %>' ><img alt="Edit" src="images/iconPlaceholder.svg" width="17" height="17" title="Edit User" /></a></td>
									    <td class="icons" align="center"><a href="edit_user.jsp?id=<%= allUserInfo.get(i).get(0) %>" class="remove"><img src="images/iconPlaceholder.svg" width="17" height="17" title="Ban user from system" alt="Ban"/></a></td>
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
