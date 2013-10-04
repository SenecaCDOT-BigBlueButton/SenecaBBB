<%@page import="sql.Section"%>
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
	
	Section section = new Section(dbaccess);
	
	String selectedclass = request.getParameter("class");
	String [] classparts;
	int profSettings;
	ArrayList<ArrayList<String>> profList = new ArrayList<ArrayList<String>>();
	if (selectedclass != null) {
		// split string on '-'
		classparts = selectedclass.split("-");
		if (classparts.length != 3) {
			response.sendRedirect("classSettings.jsp?message=The class is malformed");
		}
		// look up the class in db
		section.getProfessor(profList, classparts[0], classparts[1], classparts[2]);
		System.out.println(profList.size());
		// see if logged user has rights
		boolean isProfessor = false;
		for (int i=0; i<profList.size(); ++i) {
			if (profList.get(i).get(3) == usersession.getUserId()) {
				isProfessor = true;
				profSettings = Integer.parseInt(profList.get(i).get(2));
			}
		}
		
		if (!isProfessor) {
			response.sendRedirect("index.jsp?error=You aren't a professor for that class");
			return;
		}
	}
	
	ArrayList<ArrayList<String>> listofclasses = new ArrayList<ArrayList<String>>();
	if (usersession.isSuper())
		section.getClasses(listofclasses); // get every class
	else if (usersession.isProfessor())
		section.getClasses(listofclasses, usersession.getUserId()); // get only your classes
	
	
%>
	<script type='text/javascript'>
		$(function(){
			$('select').selectmenu({
				change: function (e, object) {
					window.location.href = "classSettings.jsp?class="+object.value;
				}
			});
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
			<p><a href="calendar.jsp" tabindex="13">home</a> » <a href="classSettings.jsp" tabindex="14">class settings</a></p>
			<!-- PAGE NAME -->
			<h1>Class Settings</h1>
			<!-- WARNING MESSAGES -->
			<div class="warningMessage"><%=message %></div>
		</header>
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
				<% if (classparts.length == 3) { %>
				<div class="component">
					<div class="checkbox" title="Meetings you created."> <span class="box" role="checkbox" <%= (check1 ? "aria-checked='true'" : "aria-checked='false'") %> tabindex="17" aria-labelledby="filterOption1"></span>
						<label class="checkmark" <%= (check1 ? "" : "style='display:none'") %>></label>
						<label class="text" id="filterOption1">Meetings you created.</label>
						<input type="checkbox" name="filterOption1box" <%= (check1 ? "checked='checked'" : "") %> aria-disabled="true" />
					</div>
				</div>
				<% } %>
			</fieldset>
			</div>
			</article>
		</form>
	</section>
	<jsp:include page="footer.jsp"/>
</div>
</body>
</html>