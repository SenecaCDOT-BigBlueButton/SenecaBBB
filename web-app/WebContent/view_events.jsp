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
    <title>SenecaBBB | View Events</title>
    <link rel="shortcut icon" href="http://www.senecacollege.ca/favicon.ico">
    <link rel="stylesheet" type="text/css" media="all" href="css/fonts.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/style.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.core.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.theme.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.selectmenu.css">
    <script type="text/javascript" src="js/jquery-1.9.1.js"></script>
    <script type="text/javascript" src="js/modernizr.custom.79639.js"></script>
    <script type="text/javascript" src="js/ui/jquery.ui.core.js"></script>
    <script type="text/javascript" src="js/ui/jquery.ui.widget.js"></script>
    <script type="text/javascript" src="js/ui/jquery.ui.position.js"></script>
    <script type="text/javascript" src="js/ui/jquery.ui.selectmenu.js"></script>
    <script type="text/javascript" src="js/ui/jquery.ui.stepper.js"></script>
    <script type="text/javascript" src="js/ui/jquery.ui.dataTable.js"></script>
    <script type="text/javascript" src="js/moment.js"></script>

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
    
    Meeting meeting = new Meeting(dbaccess);
    Lecture lecture = new Lecture(dbaccess);
    // End page validation

    ArrayList<HashMap<String, String>> meetings = new ArrayList<HashMap<String, String>>();
    ArrayList<HashMap<String, String>> lectures = new ArrayList<HashMap<String, String>>();
    if (!meeting.getMeetingsForUser(meetings, userId, true, true)) {
        message = meeting.getErrMsg("VEVENTS01");
        elog.writeLog("[view_events:] " + message + " /n");
        response.sendRedirect("logout.jsp?message=" + message);
        return;
    }
    
    if (!lecture.getLecturesForUser(lectures, userId, true, true)) {
        message = lecture.getErrMsg("VEVENTS02");
        elog.writeLog("[view_events:] " + message + " /n");
        response.sendRedirect("logout.jsp?message=" + message);
        return;
    }
    
    %>
    <script type="text/javascript">
        /* TABLE */
        $(screen).ready(function() {
            /* CURRENT EVENT */
            $('#tbMeetings').dataTable({
                 "sPaginationType": "full_numbers",
                 "aoColumnDefs": [{ "bSortable": false, "aTargets":[5]}], 
                 "bRetrieve": true, 
                 "bDestroy": true
                 });
            
            $('#tbLectures').dataTable({
                "sPaginationType": "full_numbers",
                "aoColumnDefs": [{ "bSortable": false, "aTargets":[5]}], 
                "bRetrieve": true, 
                "bDestroy": true
                });
            
            $.fn.dataTableExt.sErrMode = 'throw';
            $('.dataTables_filter input').attr("placeholder", "Filter entries");
        });
        
        /* SELECT BOX */
        $(function(){
            $('select').selectmenu();
        });
        //convert UTC to user's local time
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
                <p>
                    <a href="calendar.jsp" tabindex="13">home</a> »
                    <a href="view_events.jsp" tabindex="14">view_events</a> » 
                </p> 
                <!-- PAGE NAME -->
                <h1>View Events</h1>
                <br />
                <!-- WARNING MESSAGES -->
                <div class="warningMessage"><%=message %></div>
                <div class="successMessage"><%=successMessage %></div> 
            </header>
            <article>
                <header>
                    <h2>Meeting List</h2>
                    <img class="expandContent" width="9" height="6" src="${pageContext.servletContext.contextPath}/${initParam.ImagesDirectory}/arrowDown.svg" title="Click here to collapse/expand content" alt="Arrow"/>     
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
                                    <% for (int i = 0; i < meetings.size(); i++) { %>
                                    <tr>
                                        <td class="row"><%= meetings.get(i).get("ms_title") %></td>
                                        <td><script>document.write(toUserLocalTime("<%= meetings.get(i).get("m_inidatetime").substring(0, 19) %>"));</script></td>
                                        <td><%= meetings.get(i).get("m_duration") %> Minutes</td>
                                        <td><%= (meetings.get(i).get("m_iscancel").equals("1")) ? "Yes" : "" %></td>
                                        <td><%= meetings.get(i).get("m_description") %></td>
                                        <td class="icons" align="center">
                                            <a href="view_event.jsp?ms_id=<%= meetings.get(i).get("ms_id") %>&m_id=<%= meetings.get(i).get("m_id") %>" class="view calendarIcon">
                                                <img src="${pageContext.servletContext.contextPath}/${initParam.ImagesDirectory}/iconPlaceholder.svg" width="17" height="17" title="View event" alt="View_Event"/>
                                            </a>
                                        </td>
                                    </tr>
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
                    <img class="expandContent" width="9" height="6" src="${pageContext.servletContext.contextPath}/${initParam.ImagesDirectory}/arrowDown.svg" title="Click here to collapse/expand content" alt="Arrow"/>     
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
                                    <% for (int j = 0; j < lectures.size(); j++) { %>
                                    <tr>
                                        <td class="row"><% out.print(lectures.get(j).get("c_id") + lectures.get(j).get("sc_id") + " (" + lectures.get(j).get("sc_semesterid") + ")"); %></td>
                                        <td><script>document.write(toUserLocalTime("<%= lectures.get(j).get("l_inidatetime").substring(0, 19) %>"));</script></td>
                                        <td><%= lectures.get(j).get("l_duration") %> Minutes</td>
                                        <td><%= (lectures.get(j).get("l_iscancel").equals("1")) ? "Yes" : "" %></td>
                                        <td><%= lectures.get(j).get("l_description") %></td>
                                        <td class="icons" align="center">
                                            <a href="view_event.jsp?ls_id=<%= lectures.get(j).get("ls_id") %>&l_id=<%= lectures.get(j).get("l_id") %>" class="view calendarIcon">
                                                <img src="${pageContext.servletContext.contextPath}/${initParam.ImagesDirectory}/iconPlaceholder.svg" width="17" height="17" title="View event" alt="View_Event"/>
                                            </a>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </fieldset>
                </div>
            </article>
        </section>
        <jsp:include page="footer.jsp"/>
    </div>
</body>
</html>
