<%@page import="db.DBConnection"%>
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<header id="header">
    <a href="calendar.jsp"><img src="images/logo.png" alt="Seneca College of Applied Arts and Technology" tabindex="1" title="Seneca College of Applied Arts and Technology"/>
        <span id="siteDescription">BigBlueButton Conference Manager</span>
    </a>
    <nav>
        <ul>
            <li><a href="logout.jsp?successMessage=Logged out successfully" tabindex="5" title="Logout">Logout</a></li>
            <li class="divisor">|</li>
            <li><a id="help" href="help.jsp" tabindex="4" title="Help" >Help</a> </li>
            <li class="divisor">|</li>
            <li><a href="settings.jsp" tabindex="3" title="User settings">Settings</a></li>
            <li class="divisor">|</li>
            <li><a href="settings.jsp" tabindex="2" title="View user info"><%=usersession.getGivenName() %></a></li>
        </ul>
    </nav>
</header>