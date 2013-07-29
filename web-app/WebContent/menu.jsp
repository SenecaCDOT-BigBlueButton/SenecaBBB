<jsp:useBean id="ldap" class="ldap.LDAPAuthenticate" scope="session" />
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<aside>
    <nav>
      <ul>
        <div class="menu">
          <li id="home"><a href="index.html" tabindex="5" title="Click here to go to the home screen">Home</a></li>
        </div>
        <div class="menu">
          <li id="createEvent"><a href="createEvent.html" tabindex="6" title="Click here to create a new event">Create Event</a></li>
        </div>
        <div class="menu">
          <li id="manageUsers"><a href="manageUsers.html" tabindex="7" title="Click here to manage users">Manage Users</a></li>
        </div>
        <div class="menu">
          <li id="departments"><a href="departments.html" tabindex="8" title="Click here to manage departments">Departments</a></li>
        </div>
        <div class="menu">
          <li id="departmentUsers"><a href="departmentUsers.html" tabindex="9" title="Click here to manage department users">Department Users</a></li>
        </div>
        <div class="menu">
          <li id="subjects"><a href="subjects.html" tabindex="10" title="Click here to manage subjects">Subjects</a></li>
        </div>
        <div class="menu">
          <li id="classSettings"><a href="classSettings.html" tabindex="11" title="Click here to manage class settings">Class Settings</a></li>
        </div>
        <div class="menu">
          <li id="systemSettings"><a href="systemSettings.html" tabindex="12" title="Click here to manage system settings">System Settings</a></li>
        </div>
      </ul>
    </nav>
  </aside>