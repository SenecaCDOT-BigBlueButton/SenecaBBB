<%@page import="db.DBConnection"%>
<%@page import="sql.User"%>
<%@page import="java.util.*"%>
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<!doctype html>
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Seneca | Change Settings</title>
<link rel="shortcut icon" href="http://www.cssreset.com/favicon.png" />
<!--<link href="css/themes/base/style.css" rel="stylesheet" type="text/css" media="screen and (min-width:1280px)">-->
<link href="css/themes/base/style.css" rel="stylesheet" type="text/css" media="all">
<link href="css/fonts.css" rel="stylesheet" type="text/css" media="all">
<script type="text/javascript" src="http://code.jquery.com/jquery-1.9.1.js"></script>
<script type="text/javascript" src="js/modernizr.custom.79639.js"></script>
<script type="text/javascript" src="js/component.js"></script>
<script type="text/javascript" src="js/componentStepper.js"></script>
<%

User user = new User(dbaccess);
HashMap<String, Integer> userSettings = new HashMap<String, Integer>();
HashMap<String, Integer> meetingSettings = new HashMap<String, Integer>();
HashMap<String, Integer> roleMask = new HashMap<String, Integer>();
userSettings = usersession.getUserSettingsMask();
meetingSettings = usersession.getUserMeetingSettingsMask();
roleMask = usersession.getRoleMask();
//int nickName = roleMask.get("nickname");
%>

</head>
<body>
<div id="page">
  <jsp:include page="header.jsp"/>
  <jsp:include page="menu.jsp"/>

	<div id="myDiv"></div>
  <jsp:include page="footer.jsp"/>
</div>
</body>
</html>