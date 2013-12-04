<%@page import="db.DBConnection"%>
<%@page import="sql.User"%>
<%@page import="sql.Meeting"%>
<%@page import="sql.Lecture"%>
<%@page import="java.util.*"%>
<%@page import="helper.*"%>
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<!doctype html>
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Seneca | User Schedule</title>
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
<script type="text/javascript" >
//Table
$(screen).ready(function() {
    /* Meetings List */
    $('#meetingsList').dataTable({"sPaginationType": "full_numbers"});
    $('#meetingsList').dataTable({"aoColumnDefs": [{ "bSortable": false, "aTargets":[5]}], "bRetrieve": true, "bDestroy": true});    
    /* Lectures List */
    $('#lectureList').dataTable({"sPaginationType": "full_numbers"});
    $('#lectureList').dataTable({"aoColumnDefs": [{ "bSortable": false, "aTargets":[5]}], "bRetrieve": true, "bDestroy": true});
    $.fn.dataTableExt.sErrMode = 'throw';
    $('.dataTables_filter input').attr("placeholder", "Filter entries");
});
/* SELECT BOX */
$(function(){
    $('select').selectmenu();
});
</script>
<%
    //Start page validation
    String userId = usersession.getUserId();
    GetExceptionLog elog = new GetExceptionLog();
    if (userId.equals("")) {
    	elog.writeLog("[view_schedule:] " + "unauthenticated user tried to access this page /n");
        response.sendRedirect("index.jsp?message=Please log in");
        return;
    }
    if (!usersession.isSuper()) {
    	elog.writeLog("[view_schedule:] " + " username: "+ userId + " tried to access this page, permission denied" +" /n");
        response.sendRedirect("calendar.jsp?message=You don't have permission to access that page!");
        return;
    }
    if (dbaccess.getFlagStatus() == false) {
    	elog.writeLog("[view_schedule:] " + "database connection error /n");
        response.sendRedirect("index.jsp?message=Database connection error");
        return;
    } //End page validation
    
    String message = request.getParameter("message");
    String successMessage = request.getParameter("successMessage");
    if (message == null || message == "null") {
        message="";
    }
    if (successMessage == null) {
        successMessage="";
    }
   
    User user = new User(dbaccess);
    MyBoolean prof = new MyBoolean();
    HashMap<String, Integer> userSettings = new HashMap<String, Integer>();
    HashMap<String, Integer> meetingSettings = new HashMap<String, Integer>();
    HashMap<String, Integer> roleMask = new HashMap<String, Integer>();
    userSettings = usersession.getUserSettingsMask();
    meetingSettings = usersession.getUserMeetingSettingsMask();
    roleMask = usersession.getRoleMask();
    
    //get all events schedule for specified userID
    String userID = request.getParameter("id");   
    ArrayList<ArrayList<String>> meetingResult = new ArrayList<ArrayList<String>>();
    ArrayList<ArrayList<String>> lectureResult = new ArrayList<ArrayList<String>>();
    Meeting meet = new Meeting(dbaccess);
    dbaccess.resetFlag();  
    meet.getMeetingsForUser(meetingResult, userID, true, true);
    Lecture lect = new Lecture(dbaccess);
    dbaccess.resetFlag();
    lect.getLecturesForUser(lectureResult, userID, true, true);
%>
</head>
<body>
<div id="page">
    <jsp:include page="header.jsp"/>
    <jsp:include page="menu.jsp"/>
    <section>
        <header> 
            <!-- BREADCRUMB -->
            <p><a href="calendar.jsp" tabindex="13">home</a> » <a href="manage_users.jsp" tabindex="14">manage users</a>» <a href="view_schedule.jsp" tabindex="15">view user schedule</a></p>
            <!-- PAGE NAME -->
            <h1>User Schedule</h1>
            <div style="text-align:right"><%= "User ID: "+ userID %></div>
            <!-- WARNING MESSAGES -->
            <div class="warningMessage"><%=message %></div>
            <div class="successMessage"><%=successMessage %></div> 
        </header>
        <form>
            <article>
                <header>
                    <h2>Meeting Schedule</h2>
                    <img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content"/>
                </header>
                <div class="content">
                    <fieldset>
                      <div class="component">
                            <div class="tableComponent">
                                <table id="meetingsList" border="0" cellpadding="0" cellspacing="0">
                                    <thead>
                                      <tr>
                                        <th width="50" class="firstColumn" tabindex="16" title="ms_id">MsID<span></span></th>
                                        <th width="40" tabindex="17" title="mid">MID<span></span></th>                                      
                                        <th width="80" title="Start" tabindex="18">Start<span></span></th>
                                        <th width="60" title="Duration" tabindex="19">Duration<span></span></th>
                                        <th width="50" title="isCancelled" tabindex="20">Cancel<span></span></th>
                                        <th title="Description" tabindex="21">Description<span></span></th>
                                        <th width="50" title="m_modpass" tabindex="22">mpass<span></span></th>
                                        <th width="50" title="m_userpass" tabindex="23">upass<span></span></th>
                                        <th width="80" title="m_setting" tabindex="24">setting<span></span></th>
                                        <th title="meeting_title" tabindex="25">Meeting Title<span></span></th>                                                                                                                 
                                      </tr>
                                    </thead>
                                    <tbody>
                                    <% for(int i=0;i<meetingResult.size();i++){%>
                                      <tr><% for(int j=0;j<meetingResult.get(i).size();j++){%><td <% if(j==0) out.println("class='row'"); %>><%= meetingResult.get(i).get(j) %></td><% } %></tr><%}%>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </fieldset>
                </div>
            </article>
            <article>
                <header>
                    <h2>Leture Schedule</h2>
                    <img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content"/>
                </header>
                <div class="content">
                    <fieldset>
                       <div class="component">
                            <div class="tableComponent">
                                <table id="lectureList" border="0" cellpadding="0" cellspacing="0">
                                    <thead>
                                      <tr>
                                        <th width="50" class="firstColumn" tabindex="28" title="ls_id">LsID<span></span></th>
                                        <th width="40" tabindex="29" title="lid">LID<span></span></th>                                      
                                        <th  title="Start" tabindex="30">Start Time<span></span></th>
                                        <th width="80" title="Duration" tabindex="31">Duration<span></span></th>
                                        <th width="80" title="isCancelled" tabindex="32">Cancel<span></span></th>
                                        <th width="60" title="Description" tabindex="33">Desc<span></span></th>
                                        <th width="80" title="l_modpass" tabindex="34">lmpass<span></span></th>
                                        <th width="80" title="l_userpass" tabindex="35">lupass<span></span></th>
                                        <th width="80" title="course" tabindex="36">Course<span></span></th>
                                        <th width="80" title="lecture_title" tabindex="37">Section<span></span></th>   
                                        <th width="80" title="semesterId" tabindex="37">Semester<span></span></th>                                                                                                               
                                      </tr>
                                    </thead>
                                    <tbody>
                                    <% for(int i=0;i<lectureResult.size();i++){%>
                                      <tr><% for(int j=0;j<lectureResult.get(i).size();j++){%><td <% if(j==0) out.println("class='row'"); %>><%= lectureResult.get(i).get(j) %></td><% } %></tr><%}%>
                                    </tbody>
                                </table>
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

