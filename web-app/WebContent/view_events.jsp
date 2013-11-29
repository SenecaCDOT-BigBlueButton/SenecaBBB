<%@page import="sql.*"%>
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
<title>Seneca | View Events</title>
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

<%
    //Start page validation
    String userId = usersession.getUserId();
    
    if (userId.equals("")) {
        response.sendRedirect("index.jsp?message=Please log in");
        return;
    }
    String message = request.getParameter("message");
    String successMessage = request.getParameter("successMessage");
    if (message == null || message == "null") {
        message="";
    }
    if (successMessage == null) {
        successMessage="";
    }
    User user = new User(dbaccess);
    Meeting meeting = new Meeting(dbaccess);
    Lecture lecture = new Lecture(dbaccess);
    Section section = new Section(dbaccess);
    int i;
    boolean validFlag; 
    MyBoolean myBool = new MyBoolean();
    // End page validation
    
    ArrayList<ArrayList<String>> meetings = new ArrayList<ArrayList<String>>();
    ArrayList<ArrayList<String>> lectures = new ArrayList<ArrayList<String>>();
    if (!meeting.getMeetingsForUser(meetings, userId, true, true)) {
        message = meeting.getErrMsg("VEVENTS01");
        response.sendRedirect("logout.jsp?message=" + message);
        return;   
    }
    if (!lecture.getLecturesForUser(lectures, userId, true, true)) {
        message = lecture.getErrMsg("VEVENTS02");
        response.sendRedirect("logout.jsp?message=" + message);
        return;   
    }
%>
<script type="text/javascript">
/* TABLE */
$(screen).ready(function() {
    /* CURRENT EVENT */
    $('#tbMeetings').dataTable({"sPaginationType": "full_numbers"});
    $('#tbMeetings').dataTable({"aoColumnDefs": [{ "bSortable": false, "aTargets":[5]}], "bRetrieve": true, "bDestroy": true});
    $('#tbLectures').dataTable({"sPaginationType": "full_numbers"});
    $('#tbLectures').dataTable({"aoColumnDefs": [{ "bSortable": false, "aTargets":[5]}], "bRetrieve": true, "bDestroy": true});
    $.fn.dataTableExt.sErrMode = 'throw';
    $('.dataTables_filter input').attr("placeholder", "Filter entries");
});

/* SELECT BOX */
$(function(){
    $('select').selectmenu();
});
$(document).ready(function() {
    //Hide some tables on load
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
            <p><a href="calendar.jsp" tabindex="13">home</a> »
                <a href="view_events.jsp" tabindex="14">view_events</a> » </p> 
            <!-- PAGE NAME -->
            <h1>View Events</h1>
            <br />
            <!-- WARNING MESSAGES -->
            <div class="warningMessage"><%=message %></div>
            <div class="successMessage"><%=successMessage %></div> 
        </header>
        <form action="persist_user_settings.jsp" method="get">
            <article>
                <header>
                    <h2>Meeting List</h2>
                    <img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content" alt="Arrow"/></header>      
                </header>
                <div class="content">
                    <fieldset>
                        <div id="currentEventDiv" class="tableComponent">
                            <table id="tbMeetings" border="0" cellpadding="0" cellspacing="0">
                                <thead>
                                    <tr>
                                        <th class="firstColumn" tabindex="16" title="StartingDate">Title<span></span></th>
                                        <th title="StartingTime">Date Time<span></span></th>
                                        <th width="85" title="duration">Duration<span></span></th>
                                        <th width="80" title="isCancel">Cancel<span></span></th>
                                        <th width="300" title="description">Description<span></span></th>
                                        <th width="65" title="Details" class="icons" align="center">Details</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (i=0; i<meetings.size(); i++) { %>
<tr><td class="row"><%= meetings.get(i).get(9) %></td><td><%= meetings.get(i).get(2).substring(0, 19) %></td><td><%= meetings.get(i).get(3) %> Minutes</td><td><%= (meetings.get(i).get(4).equals("1")) ? "Yes" : "" %></td><td><%= meetings.get(i).get(5) %></td><td class="icons" align="center"><a href="view_event.jsp?ms_id=<%= meetings.get(i).get(0) %>&m_id=<%= meetings.get(i).get(1) %>" class="view calendarIcon"><img src="images/iconPlaceholder.svg" width="17" height="17" title="View event" alt="View_Event"/></a></td></tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </fieldset>
                </div>
            </article>
            <article>
                <header>
                    <h2>Lecture List</h2>
                    <img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content" alt="Arrow"/></header>      
                </header>
                <div class="content">
                    <fieldset>
                        <div id="currentEventDiv" class="tableComponent">
                            <table id="tbLectures" border="0" cellpadding="0" cellspacing="0">
                                <thead>
                                    <tr>
                                        <th class="firstColumn" tabindex="16" title="StartingDate">Course<span></span></th>
                                        <th title="StartingTime">Date Time<span></span></th>
                                        <th width="85" title="duration">Duration<span></span></th>
                                        <th width="80" title="isCancel">Cancel<span></span></th>
                                        <th width="300" title="description">Description<span></span></th>
                                        <th width="65" title="Details" class="icons" align="center">Details</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (i=0; i<lectures.size(); i++) { %>
<tr><td class="row"><% out.print(lectures.get(i).get(8) + lectures.get(i).get(9) + " (" + lectures.get(i).get(10) + ")"); %></td><td><%= lectures.get(i).get(2).substring(0, 19) %></td><td><%= lectures.get(i).get(3) %> Minutes</td><td><%= (lectures.get(i).get(4).equals("1")) ? "Yes" : "" %></td><td><%= lectures.get(i).get(5) %></td><td class="icons" align="center"><a href="view_event.jsp?ls_id=<%= lectures.get(i).get(0) %>&l_id=<%= lectures.get(i).get(1) %>" class="view calendarIcon"><img src="images/iconPlaceholder.svg" width="17" height="17" title="View event" alt="View_Event"/></a></td></tr><% } %>
                                </tbody>
                            </table>
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
