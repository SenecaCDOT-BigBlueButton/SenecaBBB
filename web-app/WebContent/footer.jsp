<%@page import="config.Config"%>
<footer>
    <nav id="footerMenu">
      <ul>
        <li><a href="calendar.jsp" title="Click here to go to the home page">Home</a></li>
        <li>|</li>
        <li><a href="contactUs.jsp" title="Click here to enter in contact with us">Contact Us</a></li>
        <li>|</li>
        <li><a href="help.jsp" title="Click here to obtain help information">Help</a></li>
      </ul>
    </nav>
    <div id="copyright">
        <p style="font-size:16px;">Version: <%= Config.getProperty("version") %></p>
        <p>Copyright © 2013 - Seneca College of Applied Arts and Technology</p>
    </div>
  </footer>