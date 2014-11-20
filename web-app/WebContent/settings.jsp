<%@page import="db.DBConnection"%>
<%@page import="sql.User"%>
<%@page import="java.util.*"%>
<%@page import="helper.*"%>
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SenecaBBB | Settings</title>
    <link rel="shortcut icon" href="http://www.senecacollege.ca/favicon.ico">
    <link rel="stylesheet" type="text/css" media="all" href="css/fonts.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/style.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.core.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.theme.css">
    <script type="text/javascript" src="js/jquery-1.9.1.js"></script>
    <script type="text/javascript" src="js/modernizr.custom.79639.js"></script>
    <script type="text/javascript" src="js/ui/jquery.ui.core.js"></script>
    <script type="text/javascript" src="js/ui/jquery.ui.widget.js"></script>
    <script type="text/javascript" src="js/ui/jquery.ui.position.js"></script>
    <script type="text/javascript" src="js/ui/jquery.ui.stepper.js"></script>
    <script type="text/javascript" src="js/checkboxController.js"></script>

    <%
    //Start page validation
    String userId = usersession.getUserId();
    GetExceptionLog elog = new GetExceptionLog();
    if (userId.equals("")) {
        session.setAttribute("redirecturl", request.getRequestURI()+(request.getQueryString()!=null?"?"+request.getQueryString():""));
        response.sendRedirect("index.jsp?message=Please log in");
        return;
    }
    if (dbaccess.getFlagStatus() == false) {
        elog.writeLog("[settings:] " + "database connection error /n");
        response.sendRedirect("index.jsp?message=Database connection error");
        return;
    } //End page validation

    String message = request.getParameter("message");
    String successMessage = request.getParameter("successMessage");
    if (message == null || message == "null") {
        message = "";
    }
    if (successMessage == null) {
        successMessage = "";
    }
    
    User user = new User(dbaccess);
    MyBoolean prof = new MyBoolean();
    HashMap<String, Integer> userSettings = new HashMap<String, Integer>();
    HashMap<String, Integer> meetingSettings = new HashMap<String, Integer>();
    HashMap<String, Integer> roleMask = new HashMap<String, Integer>();	
    ArrayList<HashMap<String,String>> roleInfoResult = new ArrayList<HashMap<String,String>>();
    userSettings = usersession.getUserSettingsMask();	
    meetingSettings = usersession.getUserMeetingSettingsMask();
    roleMask = usersession.getRoleMask();
    user.getRoleInfo(roleInfoResult, userId);
    String nickName = "";
    Boolean flag = false;
    if(usersession.isSuper()||usersession.isProfessor()|| usersession.isDepartmentAdmin() || roleInfoResult.get(0).get("pr_name").equals("employee")){
        flag = true;
    }
    nickName = usersession.getNick();
    %>
    <script type="text/javascript">
        $(document).ready(function() {
            <%if (meetingSettings.get("isRecorded")==0){%>
                $(".checkbox .box:eq(0)").next(".checkmark").toggle();
                $(".checkbox .box:eq(0)").attr("aria-checked", "false");
                $(".checkbox .box:eq(0)").siblings().last().prop("checked", false);
            <%}%>
        });
    </script>
</head>
<body>
    <div id="page">
        <jsp:include page="header.jsp"/>
        <jsp:include page="menu.jsp"/>
        <section>
            <header>
                <p><a href="calendar.jsp" tabindex="13">home</a> » <a href="settings.jsp" tabindex="14">settings</a></p>
                <h1>Settings</h1>
                <div class="warningMessage"><%= message %></div>
                <div class="successMessage"><%= successMessage %></div>
            </header>
            <form action="persist_user_settings.jsp" method="get">
                <article>
                    <header>
                        <h2>User Settings</h2>
                        <img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content"/>
                    </header>
                    <div class="content">
                        <fieldset>
                            <%if (nickName != null) { %>
                            <div class="component">
                                <label for="nickname" class="label">Nickname:</label>
                                <input type="text" name="nickname" id="nickname" class="input" tabindex="15" title="Nickname" value=<%= nickName %> <% if(!flag) out.print("readonly='readonly'");%>>
                            </div>
                            <% } if (!usersession.isLDAP()) { %>
                            <div class="component">
                                <div class="buttons">
                                    <button type="button" name="button" id="changePassword" class="button" title="Click here to change your password" onclick="window.location.href='edit_password.jsp'">Change your password</button>
                                </div>
                            </div>
                            <%}%>
                            <div class="component">
                                <div class="checkbox" title="Allow event recording"> <span class="box" role="checkbox" aria-checked="true" tabindex="21" aria-labelledby="eventSetting4"></span>
                                    <label class="checkmark"></label>
                                    <label class="text" id="eventSetting4">Allow event recording</label>
                                    <input type="checkbox" name="eventSetting4box" checked="checked">
                                </div>
                            </div>
                            <div class="component">		
                                <div class="actionButtons" style="margin-left:220px">
                                    <button type="submit" name="submit" id="save" class="button" title="Click here to save inserted data">Save</button>
                                    <button type="button" name="button" id="cancel" class="button" title="Click here to cancel" onclick="window.location.href='calendar.jsp'">Cancel</button>
                                </div>
                            </div>
                        </fieldset>
                    </div>
                </article>
            </form>
        </section>
        <jsp:include page="footer.jsp"/>
    </div>
</body>
</html>