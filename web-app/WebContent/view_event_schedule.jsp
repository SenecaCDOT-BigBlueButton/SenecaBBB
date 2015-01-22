<%@page import="sql.*"%>
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
    <title>SenecaBBB | View Event Schedule</title>
    <link rel="shortcut icon" href="http://www.senecacollege.ca/favicon.ico">
    <link rel="stylesheet" type="text/css" media="all" href="css/fonts.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/style.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.core.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.theme.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.datepicker.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.selectmenu.css">
    <link rel='stylesheet' type="text/css" href='fullcalendar-1.6.3/fullcalendar/fullcalendar.css'>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/jquery-1.9.1.js"></script>
    <script type="text/javascript" src='fullcalendar-1.6.3/fullcalendar/fullcalendar.js'></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/modernizr.custom.79639.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/ui/jquery.ui.core.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/ui/jquery.ui.widget.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/ui/jquery.ui.position.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/ui/jquery.ui.selectmenu.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/ui/jquery.ui.stepper.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/ui/jquery.ui.dataTable.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/componentController.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/moment.js"></script>

    <%
    //Start page validation
    String userId = usersession.getUserId();
    GetExceptionLog elog = new GetExceptionLog();
    if (userId.equals("")) {
        session.setAttribute("redirecturl",request.getRequestURI() + (request.getQueryString() != null ? "?" + request.getQueryString() : ""));
        response.sendRedirect("index.jsp?message=Please log in");
        return;
    }
    String message = request.getParameter("message");
    String successMessage = request.getParameter("successMessage");
    if (message == null || message == "null") {
        message = "";
    }
    if (successMessage == null) {
        successMessage = "";
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
    Boolean isMeetingEvent = false;
    Boolean isLectureEvent = false;
    if (ms_id != null) {
        ms_id = Validation.prepare(ms_id);
        validFlag = Validation.checkMsId(ms_id);
        if (!validFlag) {
            elog.writeLog("[view_event_schedule:] " + Validation.getErrMsg() + " /n");
            response.sendRedirect("calendar.jsp?message=" + Validation.getErrMsg());
            return;
        }
        isMeetingEvent = true;
        if (!user.isMeetingCreator(myBool, ms_id, userId)) {
            message = user.getErrMsg("VES01");
            elog.writeLog("[view_event_schedule:] " + message + " /n");
            response.sendRedirect("logout.jsp?message=" + message);
            return;
        }
        if (myBool.get_value()) {
            status = 1;
        }
        if (status == 0) {
            if (!user.isMeetingAttendee(myBool, ms_id, userId)) {
                message = user.getErrMsg("VES02");
                elog.writeLog("[view_event_schedule:] " + message + " /n");
                response.sendRedirect("logout.jsp?message=" + message);
                return;
            }
            if (myBool.get_value()) {
                status = 2;
            }
        }
        if (status == 0) {
            response.sendRedirect("calendar.jsp?message=You do not permission to access that page");
            return;
        }
    } else if (ls_id != null) {
        ls_id = Validation.prepare(ls_id);
        validFlag = Validation.checkLsId(ls_id);
        if (!validFlag) {
            elog.writeLog("[view_event_schedule:] " + Validation.getErrMsg() + " /n");
            response.sendRedirect("calendar.jsp?message=" + Validation.getErrMsg());
            return;
        }
        isLectureEvent = true;
        if (!user.isTeaching(myBool, ls_id, userId)) {
            message = user.getErrMsg("VES03");
            elog.writeLog("[view_event_schedule:] " + message + " /n");
            response.sendRedirect("logout.jsp?message=" + message);
            return;
        }
        if (myBool.get_value()) {
            status = 3;
        }
        if (status == 0) {
            if (!user.isLectureStudent(myBool, ls_id, userId)) {
                message = user.getErrMsg("VES04");
                elog.writeLog("[view_event_schedule:] " + message + " /n");
                response.sendRedirect("logout.jsp?message=" + message);
                return;
            }
            if (myBool.get_value()) {
                status = 5;
            }
        }
        if (status == 0) {
            elog.writeLog("[view_event_schedule:] " + " username: " + userId + " tried to access this page, permission denied" + " /n");
            response.sendRedirect("calendar.jsp?message=You do not permission to access that page");
            return;
        }
    } else {
        elog.writeLog("[view_event_schedule:] " + "ls_id or ms_is is null" + " /n");
        response.sendRedirect("calendar.jsp?message=Please do not mess with the URL");
        return;
    }
    // End page validation
    ArrayList<HashMap<String, String>> meetingResult = new ArrayList<HashMap<String, String>>();
    ArrayList<HashMap<String, String>> meetingScheduleResult = new ArrayList<HashMap<String, String>>();
    ArrayList<HashMap<String, String>> lectureResult = new ArrayList<HashMap<String, String>>();
    ArrayList<HashMap<String, String>> lectureScheduleResult = new ArrayList<HashMap<String, String>>();
    ArrayList<HashMap<String, String>> meetingAttendee = new ArrayList<HashMap<String, String>>();
    ArrayList<HashMap<String, String>> lectureAttendee = new ArrayList<HashMap<String, String>>();
    String type = "";
    if (status == 1 || status == 2) {
        if (!meeting.getMeetingInfo(meetingResult, ms_id)) {
            message = meeting.getErrMsg("VES05");
            elog.writeLog("[view_event_schedule:] " + message + " /n");
            response.sendRedirect("logout.jsp?message=" + message);
            return;
        }
        if (!meeting.getMeetingScheduleInfo(meetingScheduleResult,ms_id)) {
            message = meeting.getErrMsg("VES06");
            elog.writeLog("[view_event_schedule:] " + message + " /n");
            response.sendRedirect("logout.jsp?message=" + message);
            return;
        }
        if (status == 1) {
            if (!meeting.getMeetingAttendee(meetingAttendee, ms_id)) {
                message = meeting.getErrMsg("VES07");
                elog.writeLog("[view_event_schedule:] " + message + " /n");
                response.sendRedirect("logout.jsp?message=" + message);
                return;
            }
        }
    } else {
        if (!lecture.getLectureInfo(lectureResult, ls_id)) {
            message = lecture.getErrMsg("VES08");
            elog.writeLog("[view_event_schedule:] " + message + " /n");
            response.sendRedirect("logout.jsp?message=" + message);
            return;
        }
        if (!lecture.getLectureScheduleInfo(lectureScheduleResult,ls_id)) {
            message = lecture.getErrMsg("VES09");
            elog.writeLog("[view_event_schedule:] " + message + " /n");
            response.sendRedirect("logout.jsp?message=" + message);
            return;
        }
        if (status == 3) {
            if (!section.getStudent(lectureAttendee, ls_id)) {
                message = lecture.getErrMsg("VES10");
                elog.writeLog("[view_event_schedule:] " + message + " /n");
                response.sendRedirect("logout.jsp?message=" + message);
                return;
            }
        }
    }
    %>
    <script type="text/javascript">
        /* TABLE */
        $(screen).ready(function() {
            /* CURRENT EVENT */
            $('#currentEvent').dataTable({
                "sPaginationType": "full_numbers",
                "aoColumnDefs": [{ "bSortable": false, "aTargets":[5,6]}], 
                "bRetrieve": true, 
                "bDestroy": true
                });
            
            $('#tbAttendee').dataTable({
                "sPaginationType": "full_numbers",
                "aoColumnDefs": [{ "bSortable": false, "aTargets":[2]}], 
                "bRetrieve": true, 
                "bDestroy": true
                });
            $.fn.dataTableExt.sErrMode = 'throw';
            $('.dataTables_filter input').attr("placeholder", "Filter entries");
            $("#help").attr({href:"help_viewEventSchedule.jsp" ,target:"_blank"});
        });
        /* SELECT BOX */
        $(function(){
            $('select').selectmenu();
        });
        //Convert UTC to user local time
        function toUserLocalTime(utcTime){
            var startMoment = moment.utc(utcTime).local().format("YYYY-MM-DD HH:mm:SS");
            return startMoment;
        }

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
                <br />
                <!-- WARNING MESSAGES -->
                <div class="warningMessage"><%=message %></div>
                <div class="successMessage"><%=successMessage %></div>
            </header>
                <article>
                    <header>
                        <h2>Event Schedule</h2>
                        <img class="expandContent" width="9" height="6" src="${pageContext.servletContext.contextPath}/${initParam.ImagesDirectory}/arrowDown.svg" title="Click here to collapse/expand content"/>
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
                                            <td class="row"><%= meetingScheduleResult.get(0).get("ms_title") %></td>
                                            <td id="eventStartDateTime"><script>document.write(toUserLocalTime("<%= meetingScheduleResult.get(0).get("ms_inidatetime").substring(0, 19) %>"));</script></td>
                                            <td><span id="scheduleDuration"><%= meetingScheduleResult.get(0).get("ms_duration") %></span> Minutes</td>
                                            <td><%= meetingScheduleResult.get(0).get("bu_id") %></td>
                                        <% } else { %>
                                            <td class="row"><%= lectureScheduleResult.get(0).get("c_id") %></td>
                                            <td><%= lectureScheduleResult.get(0).get("sc_id") %></td>
                                            <td><%= lectureScheduleResult.get(0).get("sc_semesterid") %></td>
                                            <td id="eventStartDateTime"><script>document.write(toUserLocalTime("<%= lectureScheduleResult.get(0).get("ls_inidatetime").substring(0, 19) %>"));</script></td>
                                            <td><span id="scheduleDuration"><%= lectureScheduleResult.get(0).get("ls_duration") %></span> Minutes</td>
                                            
                                        <% } %>
                                        <% if (status==1) { %>
                                            <td class="icons" align="center">
                                                <a href="edit_event_schedule.jsp?ms_id=<%= ms_id %>&m_id=1" class="modify">
                                                    <img src="${pageContext.servletContext.contextPath}/${initParam.ImagesDirectory}/iconPlaceholder.svg" width="17" height="17" title="Modify meeting schedule" alt="Modify"/>
                                                </a>
                                            </td>
                                        <% } else if (status==3) { %>
                                            <td class="icons" align="center">
                                                <a href="edit_event_schedule.jsp?ls_id=<%= ls_id %>&l_id=1" class="modify">
                                                    <img src="${pageContext.servletContext.contextPath}/${initParam.ImagesDirectory}/iconPlaceholder.svg" width="17" height="17" title="Modify lecture schedule" alt="Modify"/>
                                                </a>
                                            </td>
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
                                    <tbody id="eventlistrows">
                                    
                                    <% if(isMeetingEvent){ 
                                        for (int i = 0; i < meetingResult.size(); i++) {%>
                                        <tr>
                                            <td id="currentEventStartLocalDate-<%= i %>" class="row">
                                               <script>document.write(toUserLocalTime("<%= meetingResult.get(i).get("m_inidatetime").substring(0, 19) %>").substring(0,10));</script>
                                            </td>
                                            <td id="currentEventStartLocalTime-<%= i %>">
                                               <script>document.write(toUserLocalTime("<%= meetingResult.get(i).get("m_inidatetime").substring(0, 19) %>").substring(11,19));</script>
                                            </td>
                                            <td><%= meetingResult.get(i).get("m_duration") %> Minutes</td>
                                            <td><%= (meetingResult.get(i).get("m_iscancel").equals("1")) ? "Yes" : "" %></td>
                                            <td><%= meetingResult.get(i).get("m_description") %></td>
                                            <td class="icons" align="center">
                                                <a href="view_event.jsp?ms_id=<%= ms_id %>&m_id=<%= meetingResult.get(i).get("m_id") %>" class="view">
                                                    <img src="${pageContext.servletContext.contextPath}/${initParam.ImagesDirectory}/iconPlaceholder.svg" width="17" height="17" title="View event" alt="View_Event"/>
                                                </a>
                                            </td>
                                            <% if (status == 1) { %>
                                            <td class="icons" align="center">
                                                <a href="edit_meeting.jsp?ms_id=<%= ms_id %>&m_id=<%= meetingResult.get(i).get("m_id") %>" class="modify">
                                                    <img src="${pageContext.servletContext.contextPath}/${initParam.ImagesDirectory}/iconPlaceholder.svg" width="17" height="17" title="Modify meeting" alt="Modify"/>
                                                </a>
                                            </td>
                                            <% } %>
                                        </tr>
                                    <% } 
                                    } else if(isLectureEvent){ 
                                        for (int j = 0; j < lectureResult.size(); j++) {%>
                                        <tr>
                                            <td id="currentEventStartLocalDate-<%= j %>" class="row">
                                               <script>document.write(toUserLocalTime("<%= lectureResult.get(j).get("l_inidatetime").substring(0, 19) %>").substring(0,10));</script>
                                            </td>
                                            <td id="currentEventStartLocalTime-<%= j %>">
                                               <script>document.write(toUserLocalTime("<%= lectureResult.get(j).get("l_inidatetime").substring(0, 19) %>").substring(11,19));</script>
                                            </td>
                                            <td><%= lectureResult.get(j).get("l_duration") %> Minutes</td>
                                            <td><%= (lectureResult.get(j).get("l_iscancel").equals("1")) ? "Yes" : "" %></td>
                                            <td><%= lectureResult.get(j).get("l_description") %></td>
                                            <td class="icons" align="center">
                                                <a href="view_event.jsp?ls_id=<%= ls_id %>&l_id=<%= lectureResult.get(j).get("l_id") %>" class="view">
                                                    <img src="${pageContext.servletContext.contextPath}/${initParam.ImagesDirectory}/iconPlaceholder.svg" width="17" height="17" title="View event" alt="View_Event"/>
                                                </a>
                                            </td>
                                            <% if (status == 3) { %>
                                            <td class="icons" align="center">
                                                <a href="edit_lecture.jsp?ls_id=<%= ls_id %>&l_id=<%= lectureResult.get(j).get("l_id") %>" class="modify">
                                                    <img src="${pageContext.servletContext.contextPath}/${initParam.ImagesDirectory}/iconPlaceholder.svg" width="17" height="17" title="Modify lecture" alt="Modify"/>
                                                </a>
                                            </td>
                                            <% } %>
                                        </tr>
                                        <% } }%>
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
                        <img class="expandContent" width="9" height="6" src="${pageContext.servletContext.contextPath}/${initParam.ImagesDirectory}/arrowDown.svg" title="Click here to collapse/expand content"/>
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
                                    
                                    <% if(isMeetingEvent){
                                        for (int k = 0; k < meetingAttendee.size(); k++) { %>
                                        <tr>
                                            <td class="row"><%= meetingAttendee.get(k).get("bu_id") %></td>
                                            <td><%= meetingAttendee.get(k).get("bu_nick") %></td>
                                            <td><%= meetingAttendee.get(k).get("ma_ismod").equals("1") ? "Yes" : "" %></td>
                                        </tr>
                                    <% } } 
                                    else if(isLectureEvent) {%>
                                    <% for (int k = 0; k < lectureAttendee.size(); k++) { %>
                                        <tr>
                                            <td class="row"><%= lectureAttendee.get(k).get("bu_id") %></td>
                                            <td><%= lectureAttendee.get(k).get("bu_nick") %></td>
                                            <td><%= lectureAttendee.get(k).get("s_isbanned").equals("1") ? "Yes" : "" %></td>
                                        </tr>
                                    <% }} %>
                                    </tbody>
                                </table>
                            </div>
                        </fieldset>
                        <br /><hr /><br />
                        <div class="component">
                            <div class="buttons">
                            <% if (status==1) { %>
                                <button type="button" name="button" id="addAttendee" class="manageAttendeeBtn" title="Click here to add Attendee" 
                                        onclick="window.location.href='add_attendee.jsp?ms_id=<%= ms_id %>&m_id=<%= m_id %>'">
                                   Manage Attendee List
                                </button>
                            <% } else if (status==3) { %>
                                <button type="button" name="button" id="addStudent" class="manageAttendeeBtn" title="Click here to add Student" 
                                        onclick="window.location.href='add_student.jsp?ls_id=<%= ls_id %>&l_id=<%= l_id %>'">
                                    Manage Student List
                                </button>
                            <% } %>
                             </div>
                        </div>
                    </div>
                </article>
                <% } %>
        </section>
        <jsp:include page="footer.jsp"/>
    </div>
</body>
</html>
