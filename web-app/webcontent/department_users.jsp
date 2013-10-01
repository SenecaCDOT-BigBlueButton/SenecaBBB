<%@page import="db.DBConnection"%>
<%@page import="sql.User"%>
<%@page import="sql.Department"%>
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
<title>Seneca | Department Users</title>
<link rel="icon" href="http://www.cssreset.com/favicon.png">
<link rel="stylesheet" type="text/css" media="all" href="css/fonts.css">
<link rel="stylesheet" type="text/css" media="all"
	href="css/themes/base/style.css">
<link rel="stylesheet" type="text/css" media="all"
	href="css/themes/base/jquery.ui.core.css">
<link rel="stylesheet" type="text/css" media="all"
	href="css/themes/base/jquery.ui.theme.css">
<link rel="stylesheet" type="text/css" media="all"
	href="css/themes/base/jquery.ui.selectmenu.css">
<script type="text/javascript"
	src="http://code.jquery.com/jquery-1.9.1.js"></script>
<script type="text/javascript" src="js/modernizr.custom.79639.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.position.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.selectmenu.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.dataTable.js"></script>
<script type="text/javascript" src="js/componentController.js"></script>
<%
	boolean validFlag; 
	User user = new User(dbaccess);
	Department dept = new Department(dbaccess);
	MyBoolean myBool = new MyBoolean();
	String message;
	String adminStatus = "";
	//Start page validation
	String userId = usersession.getUserId();
	if (userId.equals("")) {
		response.sendRedirect("index.jsp?message=Please log in");
		return;
	}
	String d_code = request.getParameter("DeptCode");
	if (d_code==null) {
	    response.sendRedirect("departments.jsp?message=Please do not mess with the URL");
	    return;
	}
	d_code = Validation.prepare(d_code);
	if (!Validation.checkDeptCode(d_code)) {
	    response.sendRedirect("departments.jsp?message=" + Validation.getErrMsg());
	    return;
	}
	if (!dept.isDepartment(myBool, d_code)) {
	    message = "Could not verify department status: "  + d_code + dept.getErrMsg("DU01");
	    response.sendRedirect("logout.jsp?message=" + message);
	    return;   
	}
	if (!myBool.get_value()) {
	    response.sendRedirect("departments.jsp?message=Department with that code does not exist");
	    return;
	}
	if (!usersession.isSuper()) {
	    if (!user.isDepartmentAdmin(myBool, usersession.getUserId(), d_code)) {
	        message = "Could not verify department admin status for: " + usersession.getUserId() + dept.getErrMsg("DU02");
	        response.sendRedirect("logout.jsp?message=" + message);
		    return;   
		}
	    if (!myBool.get_value()) {
		    response.sendRedirect("departments.jsp?message=You do not have permission to access that page");
		    return;
		}	
	}	
	//End page validation
	
	message = request.getParameter("message");
	if (message == null || message == "null") {
		message = "";
	}
	
	ArrayList<ArrayList<String>> deptUserList = new ArrayList<ArrayList<String>>();
	if (!dept.getDepartmentUser(deptUserList, d_code)) {
	    message = "Could not verify department user list" + dept.getErrMsg("DU03");
        response.sendRedirect("logout.jsp?message=" + message);
        return;
	}
	
%>
<script type="text/javascript">
	$(screen).ready(function() {
		/* TABLE */
		$('#tableName').dataTable({
			"sPaginationType" : "full_numbers"
		});
		$('#tableName').dataTable({
			"aoColumnDefs" : [ {
				"bSortable" : false,
				"aTargets" : [ 5 ]
			} ],
			"bRetrieve" : true,
			"bDestroy" : true
		});
		$.fn.dataTableExt.sErrMode = 'throw';
		$('.dataTables_filter input').attr("placeholder", "Filter entries");
	});
	$(function() {
		$('select').selectmenu();
	});
</script>
</head>
<body>
	<div id="page">
		<jsp:include page="header.jsp" />
		<jsp:include page="menu.jsp" />
		<section>
			<header>
				<!-- BREADCRUMB -->
				<p>
					<a href="calendar.jsp" tabindex="13">home</a> » <a
						href="department_users.jsp" tabindex="14">department users</a>
				</p>
				<!-- PAGE NAME -->
				<h1>Department Users</h1>
				<!-- WARNING MESSAGES -->
				<div class="warningMessage"><%=message%></div>
			</header>
			<form>
				<article>
					<header>
						<h2>Users</h2>
						<img class="expandContent" width="9" height="6"
							src="images/arrowDown.svg"
							title="Click here to collapse/expand content" />
					</header>
					<div class="content">
						<fieldset>
							<div class="tableComponent">
								<table id="tableName" border="0" cellpadding="0" cellspacing="0">
									<thead>
										<tr>
											<!-- Department Code -->
											<th width="150" class="firstColumn" tabindex="15"
												title="Department Code">Department Code<span>
													<!-- Sorting arrow -->
											</span></th>
											<!-- Field with expandable width -->
											<th title="Name" title="User Id">User Id<span>
													<!-- Sorting arrow -->
											</span>
											</th>
											<!-- Regular field -->
											<th title="Nick Name">Nick Name<span>
													<!-- Sorting arrow -->
											</span></th>
											</th>
											<!-- Regular field -->
											<th title="Admin Status" align="center">Admin Status<span>
													<!-- Sorting arrow -->
											</span></th>
											<!-- Action field -->
											<% if (usersession.isSuper()) { %>
											<th title="Action" class="icons" align="center">Set Admin Status</th>
											<% }  %>
										</tr>
									</thead>
									<tbody>
									<%
										for (int i=0; i<deptUserList.size(); i++) {
									%>
										<tr>
											<td class="row"><%= deptUserList.get(i).get(1) %></td>
											<td><%= deptUserList.get(i).get(0) %></td>
											<td><%= deptUserList.get(i).get(3) %></td>
											<td><%= adminStatus = (deptUserList.get(i).get(2).equals("1")) ? "Yes" : "" %></td>
											<% if (usersession.isSuper()) { %>
											<td class="icons" align="center"><a href="#" class="<%= (adminStatus.equals("Yes")) ? "remove" : "add" %>"><img
													src="images/iconPlaceholder.svg" width="17" height="17"
													title="Set Admin Status: (+) given admin status (x) remove admin status" alt="Action" /></a></td>
											<% }  %>
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
					<header>
						<h2>Section Title</h2>
						<img class="expandContent" width="9" height="6"
							src="images/arrowDown.svg"
							title="Click here to collapse/expand content" />
					</header>
					<div class="content">
						<fieldset>
							<div class="component">
								<label for="inputId" class="label">Input label:</label> <input
									name="inputName" id="inputId" class="input" tabindex="15"
									title="Input description" type="text">
							</div>
							<div class="component">
								<div class="checkbox" title="Checkbox description">
									<span class="box" role="checkbox" aria-checked="true"
										tabindex="1" aria-labelledby="eventSetting1"></span> <label
										class="checkmark"></label> <label class="text"
										id="eventSetting1">Checkbox description.</label> <input
										type="checkbox" name="eventSetting1box" checked="checked"
										aria-disabled="true">
								</div>
							</div>
							<div class="component">
								<label for="selectboxId" class="label">Select box label:</label>
								<select name="selectboxName" id="selectboxId" title="Select box description. Use the alt key in combination with the arrow keys to select an option" tabindex="1" role="listbox" style="width: 402px">
									<option role="option" selected>Default selected option</option>
									<option role="option">Regular option</option>
								</select>
							</div>
							<div class="component">
								<div class="buttons">
									<button type="button" name="buttonName" id="buttonId"
										class="button" title="Button Description" tabindex="1"
										onclick="window.location.href='#'">Button text</button>
								</div>
							</div>
						</fieldset>
					</div>
				</article>
				<article>
					<h4></h4>
					<fieldset>
						<div class="actionButtons">
							<button type="submit" name="submit" id="save" class="button"
								title="Click here to save inserted data">Save</button>
							<button type="button" name="button" id="cancel" class="button"
								title="Click here to cancel"
								onclick="window.location.href='calendar.jsp'">Cancel</button>
						</div>
					</fieldset>
				</article>
			</form>
		</section>
		<jsp:include page="footer.jsp" />
	</div>
</body>
</html>