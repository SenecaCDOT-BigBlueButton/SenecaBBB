<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<aside>
  <nav>
    <ul>
      <div class="menu">
        <li id="home"><a href="calendar.jsp" tabindex="5" title="Click here to go to the home screen">Home</a></li>
      </div>
      <div class="menu">
        <li id="createEvent"><a href="createEvent.jsp" tabindex="6" title="Click here to create a new event">Create Event</a></li>
      </div>
      <% 
        if (usersession.isSuper()){
	        out.write("<div class=\"menu\"><li id=\"manageUsers\"><a href=\"manage_users.jsp\" tabindex=\"7\" title=\"Click here to manage users\">Manage Users</a></li></div>");
	        out.write("<div class=\"menu\"><li id=\"departments\"><a href=\"departments.jsp\" tabindex=\"8\" title=\"Click here to manage departments\">Departments</a></li></div>");
	        out.write("<div class=\"menu\"><li id=\"systemSettings\"><a href=\"systemSettings.jsp\" tabindex=\"12\" title=\"Click here to manage system settings\">System Settings</a></li></div>");
        	out.write("<div class=\"menu\"><li id=\"subjects\"><a href=\"subjects.jsp\" tabindex=\"10\" title=\"Click here to manage subjects\">Subjects</a></li></div>");
        }
        if (usersession.isDepartmentAdmin()){
        	out.write("<div class=\"menu\"><li id=\"departmentUsers\"><a href=\"departmentUsers.jsp\" tabindex=\"9\" title=\"Click here to manage department users\">Department Users</a></li></div>");	
        }
        if (usersession.isProfessor()){
        	out.write("<div class=\"menu\"><li id=\"classSettings\"><a href=\"classSettings.jsp\" tabindex=\"11\" title=\"Click here to manage class settings\">Class Settings</a></li></div>");
        }
        %>
    </ul>
  </nav>
</aside>