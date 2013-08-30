<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<aside>
	<nav>
		<ul>
			<div class="menu">
				<li id="calendar"><a href="calendar.jsp" tabindex="5" title="Click here to see your calendar of events">Calendar</a></li>
			</div>
			<div class="menu">
				<li id="createEvent"><a href="create_event.jsp" tabindex="6" title="Click here to create a new event">Create Event</a></li>
			</div>
			<div class="menu">
				<li id="settings"><a href="settings.jsp" tabindex="7" title="Click here to change your settings">Settings</a></li>
			</div>
			<%
				if (usersession.isSuper()){
					out.write("<div class=\"menu\"><li id=\"manageUsers\"><a href=\"manage_users.jsp\" tabindex=\"8\" title=\"Click here to manage users\">Manage Users</a></li></div>");
					out.write("<div class=\"menu\"><li id=\"departments\"><a href=\"departments.jsp\" tabindex=\"9\" title=\"Click here to manage departments\">Departments</a></li></div>");
					out.write("<div class=\"menu\"><li id=\"systemSettings\"><a href=\"system_settings.jsp\" tabindex=\"13\" title=\"Click here to manage system settings\">System Settings</a></li></div>");
					out.write("<div class=\"menu\"><li id=\"subjects\"><a href=\"subjects.jsp\" tabindex=\"11\" title=\"Click here to manage subjects\">Subjects</a></li></div>");
				}
				if (usersession.isDepartmentAdmin()){
					out.write("<div class=\"menu\"><li id=\"departmentUsers\"><a href=\"department_users.jsp\" tabindex=\"10\" title=\"Click here to manage department users\">Department Users</a></li></div>");	
				}
				if (usersession.isProfessor()){
					out.write("<div class=\"menu\"><li id=\"classSettings\"><a href=\"class_settings.jsp\" tabindex=\"12\" title=\"Click here to manage class settings\">Class Settings</a></li></div>");
				}
			%>
		</ul>
	</nav>
</aside>