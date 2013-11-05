<%@page import="sql.Section"%>
<%@page import="java.util.*"%>
<%@page import="helper.MyBoolean"%>
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<jsp:useBean id="ldap" class="ldap.LDAPAuthenticate" scope="session" />
<!doctype html>
<html lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html" charset="utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Seneca | Class Settings</title>
	<link rel="icon" href="http://www.cssreset.com/favicon.png">
	<link rel="stylesheet" type="text/css" media="all" href="css/fonts.css">
	<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/style.css">
	<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.core.css">
	<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.theme.css">
	<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.selectmenu.css">
	<script type="text/javascript" src="http://code.jquery.com/jquery-1.9.1.js"></script>
	<script type="text/javascript" src="js/modernizr.custom.79639.js"></script>
	<script type="text/javascript" src="js/ui/jquery.ui.core.js"></script>
	<script type="text/javascript" src="js/ui/jquery.ui.widget.js"></script>
	<script type="text/javascript" src="js/ui/jquery.ui.position.js"></script>
	<script type="text/javascript" src="js/ui/jquery.ui.selectmenu.js"></script>
	<script type="text/javascript" src="js/ui/jquery.ui.stepper.js"></script>
	<script type="text/javascript" src="js/ui/jquery.ui.dataTable.js"></script>
	<script type="text/javascript" src="js/componentController.js"></script>
	
	<jsp:include page="search.jsp"/>
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
	if (!usersession.isProfessor() && !usersession.isSuper()) {
		response.sendRedirect("calendar.jsp?message=You don't have permissions to view that page.");
		return;
	}
	
	//End page validation
	
	String message = request.getParameter("message");
	if (message == null || message == "null") {
		message="";
	}
	
	Section section = new Section(dbaccess);
	
	String selectedclass = request.getParameter("class");
	String [] classparts = {};
	boolean isProfessor = false;
	int profSettings = 0;
	ArrayList<ArrayList<String>> profList = new ArrayList<ArrayList<String>>();
	if (selectedclass != null) {
		// split string on '-'
		classparts = selectedclass.split("-");
		if (classparts.length != 3) {
			message="The class is malformed";
		} else {
			// look up the class in db
			section.getProfessor(profList, classparts[0], classparts[1], classparts[2]);
			System.out.println(profList.size());
			// see if logged user has rights
			for (int i=0; i<profList.size(); ++i) {
				if (profList.get(i).get(3) == usersession.getUserId()) {
					isProfessor = true;
					profSettings = Integer.parseInt(profList.get(i).get(2));
				}
			}
			
			if (!isProfessor && !usersession.isSuper()) {
				message = "Class information could not be retrieved";
				classparts = new String[0];
			}
		}
	}
	
	ArrayList<ArrayList<String>> listofclasses = new ArrayList<ArrayList<String>>();
	if (usersession.isSuper())
		section.getClasses(listofclasses); // get every class
	else if (usersession.isProfessor())
		section.getClasses(listofclasses, usersession.getUserId()); // get only your classes
		
	if (listofclasses.size() < 0)
		message = "There are no classes to show";
%>
	<script type='text/javascript'>
		$(function(){
			$('select').selectmenu({
				change: function (e, object) {
					window.location.href = "class_settings.jsp?class="+object.value;
				}
			});
		});
		
		var promptForStudent = function () {
			var userId = prompt("Enter a student id", "Search");
			if (userId && userId != "") {
				window.location.href = "class_settings.jsp?class=<%= selectedclass %>&userId="+userId;
			}
		}
	</script>
</head>
<body>
<div id="page">
	<jsp:include page="header.jsp"/>
	<jsp:include page="menu.jsp"/>
	<section>
		<header> 
			<!-- BREADCRUMB -->
			<p><a href="calendar.jsp" tabindex="13">home</a> » <a href="class_settings.jsp" tabindex="14">class settings</a></p>
			<!-- PAGE NAME -->
			<h1>Class Settings</h1>
			<!-- WARNING MESSAGES -->
			<div class="warningMessage"><%=message %></div>
		</header>
		<% if (listofclasses.size() > 0) { %>
		<form>
		<article>
			<div class="content">
			<fieldset>
				<div class="component">
					<label for="classSel" class="label">Class:</label>
					<select name="class" id="classSel" title="Class select box. Use the alt key in combination 
						with the arrow keys to select an option." tabindex="1" role="listbox" style="width: 402px">
						<option role='option' selected disabled>Choose a class</option>
						<% 
						for (int i=0; i < listofclasses.size(); ++i) {
							String fullclass = listofclasses.get(i).get(0) + "-" + listofclasses.get(i).get(1) + "-" + listofclasses.get(i).get(2);
							out.println("<option role='option' " + (fullclass.equals(selectedclass)?"selected":"") +">" + fullclass + "</option>");
						}
						%>
					</select>
				</div>
				<% 
				if (classparts.length == 3 ) {
					String addStudent = request.getParameter("userId");
					if (addStudent && addStudent=)
					
					ArrayList<ArrayList<String>> students = new ArrayList<ArrayList<String>>();
					section.getStudent(students, classparts[0], classparts[1], classparts[2]);
					if (isProfessor) {
				%>
					<div class="component">
						<div class="checkbox" title="Meetings you created."> <span class="box" role="checkbox" <%= (profSettings==1 ? "aria-checked='true'" : "aria-checked='false'") %> tabindex="17" aria-labelledby="recorded"></span>
							<label class="checkmark" <%= (profSettings==1 ? "" : "style='display:none'") %>></label>
							<label class="text" id="recorded">Recorded lectures</label>
							<input type="checkbox" name="recordedBox" <%= (profSettings==1 ? "checked='checked'" : "") %> aria-disabled="true" />
						</div>
					</div>
					<% } %>
					<br />
					<br />
					<header id="expandAttendee">
						<h2>Student List</h2>
						<img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content"/>
					</header>
					<div class="content">
						<fieldset>
						    <% if (students.size() == 0) { %>
						        No students have been added.
						    <% } else { %>
							<div id="currentEventDiv" class="tableComponent">
								<table id="tbAttendee" border="0" cellpadding="0" cellspacing="0">
									<thead>
										<tr>
										<th class="firstColumn" tabindex="16">Id<span></span></th>
										<th>Banned<span></span></th>
										</tr>
									</thead>
									<tbody>
										<% for (int i=0; i<students.size(); i++) { %>
										<tr>
											<td class="row"><%= students.get(i).get(0) %></td>
											<td><%= students.get(i).get(4).equals("1") ? "Yes" : "" %></td>
										</tr>
										<% } %>
									</tbody>
								</table>
							</div>
							<% } %>
						</fieldset>
						<br /><hr /><br />
						<div class="component">
							<div class="buttons">
								<button type="button" name="button" id="addStudent" class="button" title="Click here to add Student" onclick="promptForStudent();" >Add Student</button>
							</div>
						</div>
					</div>
				<% } %>
			</fieldset>
			</div>
			</article>
		</form>
		<% } %>
	</section>
	<jsp:include page="footer.jsp"/>
</div>
</body>
</html>