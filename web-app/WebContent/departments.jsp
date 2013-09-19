<%@page import="db.DBConnection"%>
<%@page import="sql.*"%>
<%@page import="java.util.*"%>
<%@page import="helper.MyBoolean"%>
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<!doctype html>
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Seneca | Departments</title>
<link rel="icon" href="http://www.cssreset.com/favicon.png">
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
	if (!(usersession.isDepartmentAdmin() || usersession.isSuper())) {
	    response.sendRedirect("calendar.jsp");
	}
	//End page validation
	
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
	
	ArrayList<ArrayList<String>> deptList = new ArrayList<ArrayList<String>>();
	Department dept = new Department(dbaccess);
	boolean sql_flag;
	if (usersession.isSuper()) {
	    sql_flag = dept.getDepartment(deptList);    
	}
	else {
	    sql_flag = dept.getDepartment(deptList, userId);
	}
	
	
%>
<script type="text/javascript">
/* TABLE */
$(screen).ready(function() {
	/* DEPARTMENT LIST */
	$('#departmentList').dataTable({"sPaginationType": "full_numbers"});
	$('#departmentList').dataTable({"aoColumnDefs": [{ "bSortable": false, "aTargets":[5]}], "bRetrieve": true, "bDestroy": true});
	$.fn.dataTableExt.sErrMode = 'throw';
	$('.dataTables_filter input').attr("placeholder", "Filter entries");
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
			<p><a href="calendar.jsp" tabindex="13">home</a> » <a href="departments.jsp" tabindex="14">departments</a></p>
			<h1>Departments</h1>
			<div class="warningMessage"><%=message %></div>
		</header>
		<form action="persist_user_settings.jsp" method="get">
			<article>
				<header>
					<h2>Department List</h2>
					<img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content"/></header>
				<div class="content">
					<fieldset>
						<div id="tableAddAttendee" class="tableComponent">
							<table id="departmentList" border="0" cellpadding="0" cellspacing="0">
								<thead>
									<tr>
										<th width="65" class="firstColumn" tabindex="16" title="Code">Code<span></span></th>
										<th title="Name">Name<span></span></th>
										<th width="65" title="View users" class="icons" align="center">Users</th>
										<th width="65" title="Modify" class="icons" align="center">Modify</th>
										<th width="65" title="Remove" class="icons" align="center">Remove</th>
									</tr>
								</thead>
								<tbody>
								<%
									for (int i=0; i<deptList.size(); i++) {
								%>
									<tr>
										<td class="row"><% out.print(deptList.get(i).get(0)); %></td>
										<td><% out.print(deptList.get(i).get(1)); %></td>
										<td class="icons" align="center"><a href="department_users.jsp?department=<% out.print(deptList.get(i).get(0)); %>" class="users"><img src="images/iconPlaceholder.svg" width="17" height="17" title="View all users associated with this department" alt="Users"/></a></td>
										<td class="icons" align="center"><a href="department_users.jsp?department=<% out.print(deptList.get(i).get(0)); %>" class="modify"><img src="images/iconPlaceholder.svg" width="17" height="17" title="Modify department name" alt="Modify"/></a></td>
										<td class="icons" align="center"><a href="department_users.jsp?department=<% out.print(deptList.get(i).get(0)); %>" class="remove"><img src="images/iconPlaceholder.svg" width="17" height="17" title="Remove department" alt="Remove"/></a></td>
									</tr>
								<%
									}
								%>
								</tbody>
							</table>
						</div>
					</fieldset>
				</div>
			</article>
			<article>
				<h4></h4>
				<fieldset>
				<% if (usersession.isSuper()) { %>
					<div class="actionButtons">
						<button type="button" name="button" id="addDepartment" class="button" title="Click here to add a new department" onclick="window.location.href='add_department.jsp'">Add department</button>
					</div>
				<% } %>
				</fieldset>
			</article>
		</form>
	</section>
	<jsp:include page="footer.jsp"/>
</div>
</body>
</html>