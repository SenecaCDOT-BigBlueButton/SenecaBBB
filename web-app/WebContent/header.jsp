<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<header id="header"><a href="calendar.jsp"><img src="images/logo.png" alt="Seneca College of Applied Arts and Technology" tabindex="1" title="Seneca College of Applied Arts and Technology"/></a>
    <nav>
      <ul>
        <li><a href="logout.jsp?message=Logged out successfully" tabindex="4" title="Logout">Logout</a></li>
        <li class="divisor">|</li>
        <li><a href="settings.jsp" tabindex="3" title="User settings">Settings</a></li>
        <li class="divisor">|</li>
        <li><a href="#" tabindex="2" title="View user info"><%=usersession.getGivenName() %></a></li>
      </ul>
    </nav>
</header>