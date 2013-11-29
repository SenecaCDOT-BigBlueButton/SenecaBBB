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
<title>Seneca | View Event Schedule</title>
<link rel="icon" href="http://www.cssreset.com/favicon.png">
<link rel="stylesheet" type="text/css" media="all" href="css/fonts.css">
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/style.css">
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.core.css">
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.theme.css">
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.datepicker.css">
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.selectmenu.css">
<link rel='stylesheet' type="text/css" href='fullcalendar-1.6.3/fullcalendar/fullcalendar.css'>
<script type="text/javascript" src="http://code.jquery.com/jquery-1.9.1.js"></script>
<script type="text/javascript" src='fullcalendar-1.6.3/fullcalendar/fullcalendar.js'></script>
<script type="text/javascript" src="js/modernizr.custom.79639.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.position.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.selectmenu.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.stepper.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.dataTable.js"></script>
<script type="text/javascript" src="js/componentController.js"></script>
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
    boolean validFlag; 
    MyBoolean myBool = new MyBoolean();
    // Denotes the relationship between the session user and current event being viewed:
    //  (1) the session user created this meeting
    //  (2) the session user is scheduled to attend this meeting
    //  (6) the session user is a guest in this meeting
    //  (3) the session user is teaching this lecture
    //  (4) the session user is guest teaching this lecture
    //  (5) the session user is a student in this lecture session
    int status = 0;
    String ms_id = request.getParameter("ms_id");
    String ls_id = request.getParameter("ls_id");
    String m_id = request.getParameter("m_id");
    String l_id = request.getParameter("l_id");
    if (!(ms_id==null)) {
        ms_id = Validation.prepare(ms_id);
        validFlag = Validation.checkMsId(ms_id);
        if (!validFlag) {
            response.sendRedirect("calendar.jsp?message=" + Validation.getErrMsg());
            return;
        }
        if (!user.isMeetingCreator(myBool, ms_id, userId)) {
            message = user.getErrMsg("VES01");
            response.sendRedirect("logout.jsp?message=" + message);
            return;   
        }
        if (myBool.get_value()) {
            status = 1;
        }
        if (status == 0) {
            if (!user.isMeetingAttendee(myBool, ms_id, userId)) {
                message = user.getErrMsg("VES02");
                response.sendRedirect("logout.jsp?message=" + message);
                return;   
            }
            if (myBool.get_value()) {
                status = 2;
            }
        }
        if (status==0) {
            response.sendRedirect("calendar.jsp?message=You do not permission to access that page");
            return;
        }
    } else if (!(ls_id==null)) {
        ls_id = Validation.prepare(ls_id);
        validFlag = Validation.checkLsId(ls_id);
        if (!validFlag) {
            response.sendRedirect("calendar.jsp?message=" + Validation.getErrMsg());
            return;
        }
        if (!user.isTeaching(myBool, ls_id, userId)) {
            message = user.getErrMsg("VES03");
            response.sendRedirect("logout.jsp?message=" + message);
            return;   
        }
        if (myBool.get_value()) {
            status = 3;
        }
        if (status == 0) {
            if (!user.isLectureStudent(myBool, ls_id, userId)) {
                message = user.getErrMsg("VES04");
                response.sendRedirect("logout.jsp?message=" + message);
                return;   
            }
            if (myBool.get_value()) {
                status = 5;
            }
        }
        if (status==0) {
            response.sendRedirect("calendar.jsp?message=You do not permission to access that page");
            return;
        }
    } else {
        response.sendRedirect("calendar.jsp?message=Please do not mess with the URL");
        return;
    }
    // End page validation
    ArrayList<ArrayList<String>> eventResult = new ArrayList<ArrayList<String>>();
    ArrayList<ArrayList<String>> eventSResult = new ArrayList<ArrayList<String>>();
    ArrayList<ArrayList<String>> eventAttendee = new ArrayList<ArrayList<String>>();
    String type = "";
    if (status == 1 || status == 2) {
        if (!meeting.getMeetingInfo(eventResult, ms_id)) {
            message = meeting.getErrMsg("VES05");
            response.sendRedirect("logout.jsp?message=" + message);
            return;   
        }
        if (!meeting.getMeetingScheduleInfo(eventSResult, ms_id)) {
            message = meeting.getErrMsg("VES06");
            response.sendRedirect("logout.jsp?message=" + message);
            return;   
        }
        if (status==1) {
            if (!meeting.getMeetingAttendee(eventAttendee, ms_id)) {
                message = meeting.getErrMsg("VES07");
                response.sendRedirect("logout.jsp?message=" + message);
                return;   
            }
        }
    } else {
        if (!lecture.getLectureInfo(eventResult, ls_id)) {
            message = lecture.getErrMsg("VES08");
            response.sendRedirect("logout.jsp?message=" + message);
            return;   
        }
        if (!lecture.getLectureScheduleInfo(eventSResult, ls_id)) {
            message = lecture.getErrMsg("VES09");
            response.sendRedirect("logout.jsp?message=" + message);
            return;   
        }
        if (status==3) {
            if (!section.getStudent(eventAttendee, ls_id)) {
                message = lecture.getErrMsg("VES10");
                response.sendRedirect("logout.jsp?message=" + message);
                return;   
            }
        }
    }
    int i;
%>
<script type="text/javascript">
/* TABLE */
$(screen).ready(function() {
    /* CURRENT EVENT */
    $('#currentEvent').dataTable({"sPaginationType": "full_numbers"});
    $('#currentEvent').dataTable({"aoColumnDefs": [{ "bSortable": false, "aTargets":[5]}], "bRetrieve": true, "bDestroy": true});
    $('#tbAttendee').dataTable({"sPaginationType": "full_numbers"});
    $('#tbAttendee').dataTable({"aoColumnDefs": [{ "bSortable": false, "aTargets":[5]}], "bRetrieve": true, "bDestroy": true});
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
            <p><a href="calendar.jsp" tabindex="13">home</a> » <p>
            <!-- PAGE NAME -->
            <h1>View Event Schedule</h1>
            <a href="help_viewEventSchedule.jsp" target="_blank">help</a> 
            <br />
            <!-- WARNING MESSAGES -->
            <div class="warningMessage"><%=message %></div>
            <div class="successMessage"><%=successMessage %></div>
        </header>
        <form action="persist_user_settings.jsp" method="get">
            <article>
                <header>
                    <h2>Event Schedule</h2>
                    <img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content"/>
                </header>
                <div class="content">
                    <fieldset>
                        <div id="currentEventDiv" class="tableComponent">
                            <table id="currentEventS" border="0" cellpadding="0" cellspacing="0">
                                <thead>
                                    <tr>
                                    <% if (status==1 || status==2) { %>
                                        <th class="firstColumn" tabindex="16">Title<span></span></th>
                                        <th>Starting From<span></span></th>
                                        <th>Duration<span></span></th>
                                        <th>Creator<span></span></th>
                                    <% } else { %>
                                        <th class="firstColumn" tabindex="16">Course<span></span></th>
                                        <th>Section<span></span></th>
                                        <th>Semester<span></span></th>
                                        <th>Starting From<span></span></th>
                                        <th>Duration<span></span></th>
                                    <% } %>
                                    <% if (status==1 || status==3) { %>
                                        <th width="65" title="Modify" class="icons" align="center">Modify</th>
                                    <% } %>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                    <% if (status==1 || status==2) { %>
                                        <td class="row"><%= eventSResult.get(0).get(1) %></td>
                                        <td><%= eventSResult.get(0).get(2).substring(0, 19) %></td>
                                        <td><%= eventSResult.get(0).get(4) %> Minutes</td>
                                        <td><%= eventSResult.get(0).get(5) %></td>
                                    <% } else { %>
                                        <td class="row"><%= eventSResult.get(0).get(1) %></td>
                                        <td><%= eventSResult.get(0).get(2) %></td>
                                        <td><%= eventSResult.get(0).get(3) %></td>
                                        <td><%= eventSResult.get(0).get(4).substring(0, 19) %></td>
                                        <td><%= eventSResult.get(0).get(6) %> Minutes</td>
                                    <% } %>
                                    <% if (status==1) { %>
                                        <td class="icons" align="center">
                                            <a href="edit_event_schedule.jsp?ms_id=<%= ms_id %>&m_id=1" class="modify">
                                            <img src="images/iconPlaceholder.svg" width="17" height="17" title="Modify meeting schedule" alt="Modify"/>
                                        </a></td>
                                    <% } else if (status==3) { %>
                                        <td class="icons" align="center">
                                            <a href="edit_event_schedule.jsp?ls_id=<%= ls_id %>&l_id=1" class="modify">
                                            <img src="images/iconPlaceholder.svg" width="17" height="17" title="Modify lecture schedule" alt="Modify"/>
                                        </a></td>
                                    <% } %>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </fieldset>
                </div>
            </article>
            <article>
                <header>
                    <h2>Event List</h2>
                </header>
                <div class="content">
                    <fieldset>
                        <div id="currentEventDiv" class="tableComponent">
                            <table id="currentEvent" border="0" cellpadding="0" cellspacing="0">
                                <thead>
                                    <tr>
                                        <th class="firstColumn" tabindex="16" title="StartingDate">Date<span></span></th>
                                        <th title="StartingTime">Time<span></span></th>
                                        <th title="duration">Duration<span></span></th>
                                        <th title="isCancel">Cancelled<span></span></th>
                                        <th width="300" title="description">Description<span></span></th>
                                        <th title="Details" class="icons" align="center">Details</th>
                                        <% if (status==1 || status==3) { %>
                                        <th width="65" title="Modify" class="icons" align="center">Modify</th>
                                        <% } %>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (i=0; i<eventResult.size(); i++) { %>
                                    <tr>
                                        <td><%= eventResult.get(i).get(2).substring(0, 10) %></td>
                                        <td><%= eventResult.get(i).get(2).substring(11, 19) %></td>
                                        <td><%= eventResult.get(i).get(3) %> Minutes</td>
                                        <td><%= (eventResult.get(i).get(4).equals("1")) ? "Yes" : "" %></td>
                                        <td><%= eventResult.get(i).get(5) %></td>
                                        <% if (status==1 || status==2) { %>
                                            <td class="icons" align="center">
                                                <a href="view_event.jsp?ms_id=<%= ms_id %>&m_id=<%= eventResult.get(i).get(1) %>" class="view">
                                                <img src="images/iconPlaceholder.svg" width="17" height="17" title="View event" alt="View_Event"/>
                                                </a></td>
                                        <% } else { %>
                                            <td class="icons" align="center">
                                                <a href="view_event.jsp?ls_id=<%= ls_id %>&l_id=<%= eventResult.get(i).get(1) %>" class="view">
                                                <img src="images/iconPlaceholder.svg" width="17" height="17" title="View event" alt="View_Event"/>
                                                </a></td>
                                        <% } %>
                                        <% if (status==1) { %>
                                            <td class="icons" align="center">
                                                <a href="edit_meeting.jsp?ms_id=<%= ms_id %>&m_id=<%= eventResult.get(i).get(1) %>" class="modify">
                                                <img src="images/iconPlaceholder.svg" width="17" height="17" title="Modify meeting" alt="Modify"/>
                                            </a></td>
                                        <% } else if (status==3) { %>
                                            <td class="icons" align="center">
                                                <a href="edit_lecture.jsp?ls_id=<%= ls_id %>&l_id=<%= eventResult.get(i).get(1) %>" class="modify">
                                                <img src="images/iconPlaceholder.svg" width="17" height="17" title="Modify lecture" alt="Modify"/>
                                            </a></td>
                                        <% } %>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </fieldset>
                </div>
            </article>
            <% if (status==1 || status==3) { %>
            <article>
                <header id="expandAttendee">
                <% if (status==1) { %>
                    <h2>Attendee List</h2>
                <% } else { %>
                    <h2>Student List</h2>
                <% } %>
                    <img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content"/>
                </header>
                <div class="content">
                    <fieldset>
                        <div id="currentEventDiv" class="tableComponent">
                            <table id="tbAttendee" border="0" cellpadding="0" cellspacing="0">
                                <thead>
                                    <tr>
                                        <th class="firstColumn" tabindex="16">Id<span></span></th>
                                        <th>Nick Name<span></span></th>
                                        <th><%= (status==1) ? "Moderator" : "Banned" %><span></span></th>
                                    </tr>
                                </thead>
                                <tbody>
                                <% for (i=0; i<eventAttendee.size(); i++) { %>
                                    <tr>
                                    <% if (status==1) { %>
                                        <td class="row"><%= eventAttendee.get(i).get(0) %></td>
                                        <td><%= eventAttendee.get(i).get(3) %></td>
                                        <td><%= eventAttendee.get(i).get(2).equals("1") ? "Yes" : "" %></td>
                                    <% } else { %>
                                        <td class="row"><%= eventAttendee.get(i).get(0) %></td>
                                        <td><%= eventAttendee.get(i).get(5) %></td>
                                        <td><%= eventAttendee.get(i).get(4).equals("1") ? "Yes" : "" %></td>
                                    <% } %>
                                    </tr>
                                <% } %>
                                </tbody>
                            </table>
                        </div>
                    </fieldset>
                    <br /><hr /><br />
                    <div class="component">
                        <div class="buttons">
                        <% if (status==1) { %>
                            <button type="button" name="button" id="addAttendee" class="button" title="Click here to add Attendee" 
                                onclick="window.location.href='add_attendee.jsp?ms_id=<%= ms_id %>&m_id=<%= m_id %>'">Manage Attendee List</button>
                        <% } else if (status==3) { %>
                            <button type="button" name="button" id="addStudent" class="button" title="Click here to add Student" 
                                onclick="window.location.href='add_student.jsp?ls_id=<%= ls_id %>&l_id=<%= l_id %>'">Manage Student List</button>
                        <% } %>
                          </div>
                       </div>
                </div>
            </article>
            <% } %>
        </form>
    </section>
    <jsp:include page="footer.jsp"/>
</div>
</body>
</html>
