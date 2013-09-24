<%@page import="db.DBConnection"%>
<%@page import="sql.User"%>
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
	//Start page validation
	String userId = usersession.getUserId();
	if (userId.equals("")) {
		response.sendRedirect("index.jsp?message=Please log in");
		return;
	}
	//End page validation

	String message = request.getParameter("message");
	if (message == null || message == "null") {
		message = "";
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
											<!-- First field -->
											<th width="100" class="firstColumn" tabindex="15"
												title="First field">First field<span>
													<!-- Sorting arrow -->
											</span></th>
											<!-- Field with expandable width -->
											<th title="Name" title="Field with expandable width">Field
												with expandable width<span>
													<!-- Sorting arrow -->
											</span>
											</th>
											<!-- Regular field -->
											<th width="230" title="Regular field">Regular field<span>
													<!-- Sorting arrow -->
											</span></th>
											<!-- Action field -->
											<th width="65" title="Action" class="icons" align="center">Action</th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td class="row">First field</td>
											<td>Field with expandable width</td>
											<td>Regular field</td>
											<td class="icons" align="center"><a href="#" class="add"><img
													src="images/iconPlaceholder.svg" width="17" height="17"
													title="Action description" alt="Action" /></a></td>
										</tr>
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