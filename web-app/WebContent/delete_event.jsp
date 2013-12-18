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
<title>Seneca | Delete Event</title>
<link rel="icon" href="http://www.cssreset.com/favicon.png">
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
<script type="text/javascript" src="js/componentController.js"></script>
<%
    //Start page validation
    String userId = usersession.getUserId();
    GetExceptionLog elog = new GetExceptionLog();
    if (userId.equals("")) {
    	session.setAttribute("redirecturl", request.getRequestURI()+(request.getQueryString()!=null?"?"+request.getQueryString():""));
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
    boolean validFlag; 
    MyBoolean myBool = new MyBoolean();
    String m_id = request.getParameter("m_id");
    String ms_id = request.getParameter("ms_id");
    String l_id = request.getParameter("l_id");
    String ls_id = request.getParameter("ls_id");
    if (!(m_id==null || ms_id==null)) {
        m_id = Validation.prepare(m_id);
        ms_id = Validation.prepare(ms_id);
        validFlag = Validation.checkMId(m_id) && Validation.checkMsId(ms_id);
        if (!validFlag) {
        	elog.writeLog("[delete_event:] " + Validation.getErrMsg() +"/n");
            response.sendRedirect("calendar.jsp?message=" + Validation.getErrMsg());
            return;
        }
        if (!meeting.isMeeting(myBool, ms_id, m_id)) {
            message = "Could not verify meeting status (ms_id: " + ms_id + ", m_id: " + m_id + ")" + user.getErrMsg("DE01");
            elog.writeLog("[delete_event:] " + message +"/n");
            response.sendRedirect("logout.jsp?message=" + message);
            return;   
        }
        if (!myBool.get_value()) {
        	elog.writeLog("[delete_event:] " + "username: " + userId +" permission denied" +"/n");
            response.sendRedirect("calendar.jsp?message=You do not have permission to access that page");
            return;
        }
        if (!user.isMeetingCreator(myBool, ms_id, userId)) {
            message = "Could not verify meeting status (ms_id: " + ms_id + ", m_id: " + m_id + ")" + user.getErrMsg("DE02");
            elog.writeLog("[delete_event:] " + message +"/n");
            response.sendRedirect("logout.jsp?message=" + message);
            return;   
        }
        if (!myBool.get_value()) {
        	elog.writeLog("[delete_event:] " + "username: " + userId +" permission denied" +"/n");
            response.sendRedirect("calendar.jsp?message=You do not permission to access that page");
        }
    } else if (!(l_id==null || ls_id==null)) {
        l_id = Validation.prepare(l_id);
        ls_id = Validation.prepare(ls_id);
        validFlag = Validation.checkLId(l_id) && Validation.checkLsId(ls_id);
        if (!validFlag) {
        	elog.writeLog("[delete_event:] " + Validation.getErrMsg() +"/n");
            response.sendRedirect("calendar.jsp?message=" + Validation.getErrMsg());
            return;
        }
        if (!lecture.isLecture(myBool, ls_id, l_id)) {
            message = "Could not verify lecture status (ls_id: " + ls_id + ", l_id: " + l_id + ")" + user.getErrMsg("DE03");
            elog.writeLog("[delete_event:] " + message +"/n");
            response.sendRedirect("logout.jsp?message=" + message);
            return;   
        }
        if (!myBool.get_value()) {
        	elog.writeLog("[delete_event:] " + "username: " + userId +" permission denied" +"/n");
            response.sendRedirect("calendar.jsp?message=You do not permission to access that page");
            return;
        }
        if (!user.isTeaching(myBool, ls_id, userId)) {
            message = "Could not verify meeting status (ls_id: " + ls_id + ", l_id: " + l_id + ")" + user.getErrMsg("DE04");
            elog.writeLog("[delete_event:] " + message +"/n");
            response.sendRedirect("logout.jsp?message=" + message);
            return;   
        }
        if (!myBool.get_value()) {
        	elog.writeLog("[delete_event:] " + "username: " + userId +" permission denied" +"/n");
            response.sendRedirect("calendar.jsp?message=You do not permission to access that page");
        }
    } else {
    	elog.writeLog("[delete_event:] " + "try to delete event without providing valid m_id,ms_id or l_id, ls_id " +"/n");
        response.sendRedirect("calendar.jsp?message=Please do not mess with the URL");
        return;
    }
    // End page validation
    
    String remove = request.getParameter("remove");
    if (remove != null) {
        if (ms_id!=null) {
            if (!meeting.removeMeetingSchedule(ms_id)) {
                message = user.getErrMsg("DE05");
                elog.writeLog("[delete_event:] " + message +"/n");
                response.sendRedirect("logout.jsp?message=" + message);
                return;   
            } else {
                response.sendRedirect("calendar.jsp?successMessage=schedule removed");
                return;
            }
        } else {
            if (!lecture.removeLectureSchedule(ls_id)) {
                message = user.getErrMsg("DE06");
                elog.writeLog("[delete_event:] " + message +"/n");
                response.sendRedirect("logout.jsp?message=" + message);
                return;   
            } else {
                response.sendRedirect("calendar.jsp?successMessage=schedule removed");
                return;
            }
        }
    }
       
    ArrayList<ArrayList<String>> eventSResult = new ArrayList<ArrayList<String>>();
    String type = "";
    if (ms_id!=null) {
        if (!meeting.getMeetingScheduleInfo(eventSResult, ms_id)) {
            message = meeting.getErrMsg("DE05");
            elog.writeLog("[delete_event:] " + message +"/n");
            response.sendRedirect("logout.jsp?message=" + message);
            return;   
        }
    } else {
        if (!lecture.getLectureScheduleInfo(eventSResult, ls_id)) {
            message = lecture.getErrMsg("DE06");
            elog.writeLog("[delete_event:] " + message +"/n");
            response.sendRedirect("logout.jsp?message=" + message);
            return;   
        }
    }
    message = "WARNING:<br />You are about to delete this schedule<br />Schedule with past events cannot be fully erased";
%>
<script type="text/javascript">
/* TABLE */
$(screen).ready(function() {
    /* CURRENT EVENT */
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
            <h1>Delete Event Schedule</h1>
            <br />
	        <!-- MESSAGES -->
	        <div class="warningMessage"><%=message %></div>
	        <div class="successMessage"><%=successMessage %></div> 
	    </header>
        <form action="delete_event.jsp" method="get">
            <article>
                <header>
                    <h2>Event Schedule</h2>
                    <img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content"/>
                </header>
                <div class="content">
                    <% if (ms_id!=null) { %>
                        <input type="hidden" name="ms_id" id="ms_id" value="<%= ms_id %>">
                        <input type="hidden" name="m_id" id="m_id" value="<%= m_id %>">
                        <input type="hidden" name="remove" id="remove" value="1">
                    <% } else { %>
                        <input type="hidden" name="ls_id" id="ls_id" value="<%= ls_id %>">
                        <input type="hidden" name="l_id" id="l_id" value="<%= l_id %>">
                        <input type="hidden" name="remove" id="remove" value="1">
                     <% } %>   
                    <fieldset>
                        <div id="currentEventDiv" class="tableComponent">
                            <table id="currentEventS" border="0" cellpadding="0" cellspacing="0">
                                <thead>
                                    <tr>
                                    <% if (ms_id!=null) { %> 
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
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                    <% if (ms_id!=null) { %>
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
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </fieldset>
                </div>
            </article>
            <article>
            <h4></h4>
        <fieldset>
          <div class="buttons">
            <button type="submit" class="button" title="Click here to delete schedule">Delete Schedule</button>
            <% if (ms_id!=null) { %>                              
            <button type="button" name="button" id="cancel"  class="button" title="Click here to cancel" onclick="window.location.href='view_event_schedule.jsp?ms_id=<%= ms_id %>&m_id=<%= m_id %>'">Cancel</button>
            <% } else { %>
            <button type="button" name="button" id="cancel"  class="button" title="Click here to cancel" onclick="window.location.href='view_event_schedule.jsp?ls_id=<%= ls_id %>&l_id=<%= l_id %>'">Cancel</button>
            <% } %>
          </div>
        </fieldset>
      </article>
        </form>
    </section>
    <jsp:include page="footer.jsp"/>
</div>
</body>
</html>
