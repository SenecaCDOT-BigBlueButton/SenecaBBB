<%@page import="sql.*"%>
<%@page import="java.util.*"%>
<%@page import="helper.*"%>
<%@page import="java.text.*"%>
<%@page import="java.util.concurrent.TimeUnit"%>
<%@ include file="bbb_api.jsp"%> 
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<!doctype html>
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Seneca | View Event</title>
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
    GetExceptionLog elog = new GetExceptionLog();
    String url = null;
    String eventTitle = request.getParameter("eventName"); 
    String storedEventId="";
    if (userId.equals("")) {
    	elog.writeLog("[view_event:] " + "unauthenticated user tried to access this page /n");
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
    String m_id = request.getParameter("m_id");
    String ms_id = request.getParameter("ms_id");
    String l_id = request.getParameter("l_id");
    String ls_id = request.getParameter("ls_id");
    if (!(m_id==null || ms_id==null)) {
        m_id = Validation.prepare(m_id);
        ms_id = Validation.prepare(ms_id);
        validFlag = Validation.checkMId(m_id) && Validation.checkMsId(ms_id);
        if (!validFlag) {
        	elog.writeLog("[view_event:] " + Validation.getErrMsg() +"/n");
            response.sendRedirect("calendar.jsp?message=" + Validation.getErrMsg());
            return;
        }
        if (!meeting.isMeeting(myBool, ms_id, m_id)) {
            message = "Could not verify meeting status (ms_id: " + ms_id + ", m_id: " + m_id + ")" + user.getErrMsg("VE00-1");
            elog.writeLog("[view_event:] " + message +"/n");
            response.sendRedirect("logout.jsp?message=" + message);
            return;   
        }
        if (!myBool.get_value()) {
        	elog.writeLog("[view_event:] " + " username: "+ userId + " tried to access ms_id: "+ ms_id +", permission denied" +" /n"); 
            response.sendRedirect("calendar.jsp?message=You do not permission to access that page");
            return;
        }
        if (!user.isMeetingCreator(myBool, ms_id, userId)) {
            message = "Could not verify meeting status (ms_id: " + ms_id + ", m_id: " + m_id + ")" + user.getErrMsg("VE01");
            elog.writeLog("[view_event:] " + message +"/n");
            response.sendRedirect("logout.jsp?message=" + message);
            return;   
        }
        if (myBool.get_value()) {
            status = 1;
        }
        if (status == 0) {
            if (!user.isMeetingAttendee(myBool, ms_id, userId)) {
                message = "Could not verify meeting status (ms_id: " + ms_id + ", m_id: " + m_id + ")" + user.getErrMsg("VE02");
                elog.writeLog("[view_event:] " + message +"/n");
                response.sendRedirect("logout.jsp?message=" + message);
                return;   
            }
            if (myBool.get_value()) {
                status = 2;
            }
        }
        if (status == 0) {
            if (!user.isMeetingGuest(myBool, ms_id, m_id, userId)) {
                message = "Could not verify meeting status (ms_id: " + ms_id + ", m_id: " + m_id + ")" + user.getErrMsg("VE02-2");
                elog.writeLog("[view_event:] " + message +"/n");
                response.sendRedirect("logout.jsp?message=" + message);
                return;   
            }
            if (myBool.get_value()) {
                status = 6;
            }
        }
        if (status==0) {
            elog.writeLog("[view_event:] " + " username: "+ userId + " tried to access ms_id: "+ ms_id +", permission denied" +" /n");             
            response.sendRedirect("calendar.jsp?message=You do not permission to access that page");
            return;
        }
        
    } else if (!(l_id==null || ls_id==null)) {
        l_id = Validation.prepare(l_id);
        ls_id = Validation.prepare(ls_id);
        validFlag = Validation.checkLId(l_id) && Validation.checkLsId(ls_id);
        if (!validFlag) {
        	elog.writeLog("[view_event:] " + Validation.getErrMsg() +"/n");
            response.sendRedirect("calendar.jsp?message=" + Validation.getErrMsg());
            return;
        }
        if (!lecture.isLecture(myBool, ls_id, l_id)) {
            message = "Could not verify lecture status (ls_id: " + ls_id + ", l_id: " + l_id + ")" + user.getErrMsg("VE00-2");
            elog.writeLog("[view_event:] " + message +"/n");
            response.sendRedirect("logout.jsp?message=" + message);
            return;   
        }
        if (!myBool.get_value()) {
            elog.writeLog("[view_event:] " + " username: "+ userId + " tried to access ls_id: "+ ls_id +", permission denied" +" /n");                         
            response.sendRedirect("calendar.jsp?message=You do not permission to access that page");
            return;
        }
        if (!user.isTeaching(myBool, ls_id, userId)) {
            message = "Could not verify meeting status (ls_id: " + ls_id + ", l_id: " + l_id + ")" + user.getErrMsg("VE03");
            elog.writeLog("[view_event:] " + message +"/n");
            response.sendRedirect("logout.jsp?message=" + message);
            return;   
        }
        if (myBool.get_value()) {
            status = 3;
        }
        if (status == 0) {
            if (!user.isGuestTeaching(myBool, ls_id, l_id, userId)) {
                message =  "Could not verify lecture status (ls_id: " + ls_id + ", l_id: " + l_id + ")" + user.getErrMsg("VE04");
                elog.writeLog("[view_event:] " + message +"/n");
                response.sendRedirect("logout.jsp?message=" + message);
                return;   
            }
            if (myBool.get_value()) {
                status = 4;
            }
        }
        if (status == 0) {
            if (!user.isLectureStudent(myBool, ls_id, userId)) {
                message =  "Could not verify lecture status (ls_id: " + ls_id + ", l_id: " + l_id + ")" + user.getErrMsg("VE05");
                elog.writeLog("[view_event:] " + message +"/n");
                response.sendRedirect("logout.jsp?message=" + message);
                return;   
            }
            if (myBool.get_value()) {
                status = 5;
            }
        }
        if (status==0) {
            elog.writeLog("[view_event:] " + " username: "+ userId + " tried to access ls_id: "+ ls_id +", permission denied" +" /n");            
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
    ArrayList<ArrayList<String>> eventGuest = new ArrayList<ArrayList<String>>();
    ArrayList<ArrayList<String>> eventAttendance = new ArrayList<ArrayList<String>>();
    ArrayList<ArrayList<String>> eventPresentation = new ArrayList<ArrayList<String>>();
    String type = "";
    if (status == 1 || status == 2 || status == 6) {
        if (!meeting.getMeetingInfo(eventResult, ms_id, m_id)) {
            message = meeting.getErrMsg("VE05");
            elog.writeLog("[view_event:] " + message +"/n");
            response.sendRedirect("logout.jsp?message=" + message);
            return;   
        }
        if (!meeting.getMeetingScheduleInfo(eventSResult, ms_id)) {
            message = meeting.getErrMsg("VE06");
            elog.writeLog("[view_event:] " + message +"/n");
            response.sendRedirect("logout.jsp?message=" + message);
            return;   
        }
        if (!meeting.getMeetingPresentation(eventPresentation, ms_id, m_id)) {
            message = meeting.getErrMsg("VE07");
            elog.writeLog("[view_event:] " + message +"/n");
            response.sendRedirect("logout.jsp?message=" + message);
            return;   
        }
        if (status == 1) {
            type = "Meeting (C)";
            if (!meeting.getMeetingAttendee(eventAttendee, ms_id)) {
                message = meeting.getErrMsg("VE08");
                elog.writeLog("[view_event:] " + message +"/n");
                response.sendRedirect("logout.jsp?message=" + message);
                return;   
            }
            if (!meeting.getMeetingGuest(eventGuest, ms_id, m_id)) {
                message = meeting.getErrMsg("VE09");
                elog.writeLog("[view_event:] " + message +"/n");
                response.sendRedirect("logout.jsp?message=" + message);
                return;   
            }
            if (!meeting.getMeetingAttendance(eventAttendance, ms_id, m_id)) {
                message = meeting.getErrMsg("VE10");
                elog.writeLog("[view_event:] " + message +"/n");
                response.sendRedirect("logout.jsp?message=" + message);
                return;   
            }
        } else {
            type = (status == 2) ? "Meeting (A)" : "Meeting (G)";
        }
    } else {
        if (!lecture.getLectureInfo(eventResult, ls_id, l_id)) {
            message = lecture.getErrMsg("VE11");
            elog.writeLog("[view_event:] " + message +"/n");
            response.sendRedirect("logout.jsp?message=" + message);
            return;   
        }
        if (!lecture.getLectureScheduleInfo(eventSResult, ls_id)) {
            message = lecture.getErrMsg("VE12");
            elog.writeLog("[view_event:] " + message +"/n");
            response.sendRedirect("logout.jsp?message=" + message);
            return;   
        }
        if (!lecture.getLecturePresentation(eventPresentation, ls_id, l_id)) {
            message = lecture.getErrMsg("VE13");
            elog.writeLog("[view_event:] " + message +"/n");
            response.sendRedirect("logout.jsp?message=" + message);
            return;   
        }
        if (status == 3 || status == 4) {
            type = (status == 3) ? "Lecture (T)" : "Lecture (G)";
            if (!section.getStudent(eventAttendee, ls_id)) {
                message = lecture.getErrMsg("VE14");
                elog.writeLog("[view_event:] " + message +"/n");
                response.sendRedirect("logout.jsp?message=" + message);
                return;   
            }
            if (!lecture.getLectureGuest(eventGuest, ls_id, l_id)) {
                message = lecture.getErrMsg("VE15");
                elog.writeLog("[view_event:] " + message +"/n");
                response.sendRedirect("logout.jsp?message=" + message);
                return;   
            }
            if (!lecture.getLectureAttendance(eventAttendance, ls_id, l_id)) {
                message = lecture.getErrMsg("VE16");
                elog.writeLog("[view_event:] " + message +"/n");
                response.sendRedirect("logout.jsp?message=" + message);
                return;   
            }
        } else {
            type = "Lecture (S)";
        }
    }
        
    String isCancel = (eventResult.get(0).get(4).equals("1")) ? "Yes" : "";
    ArrayList<ArrayList<String>> creatorResult = new ArrayList<ArrayList<String>>();
    ArrayList<ArrayList<String>> lectureResult = new ArrayList<ArrayList<String>>();
    ArrayList<ArrayList<String>> startTimeResult = new ArrayList<ArrayList<String>>();
    ArrayList<ArrayList<String>> durationResult = new ArrayList<ArrayList<String>>();
    String startDate="";
    String startTime="";
    String eventCreator="null";
    String duration="";
    String c_id,sc_id,sc_semesterid;
    MyBoolean isEventCreator = new MyBoolean();
    MyBoolean isEventAttendee = new MyBoolean();
    MyBoolean isEventGuest = new MyBoolean();
    int i = 0;   
    if(!isCancel.equals("Yes")){
    	if (!(m_id==null || ms_id==null)) {            
    		user.isMeetingCreator(isEventCreator, ms_id, userId);
    	    user.isMeetingAttendee(isEventAttendee, ms_id, userId);
    	    user.isMeetingGuest(isEventGuest, ms_id, m_id, userId);
    		meeting.getMeetingCreators(creatorResult, ms_id);
    		meeting.getMeetingInitialDatetime(startTimeResult, ms_id, m_id);
    		meeting.getMeetingDuration(durationResult, ms_id, m_id);
    		duration = durationResult.get(0).get(0);
    		startTime = startTimeResult.get(0).get(0).split(" ")[1].substring(0, 8);
    		startDate = startTimeResult.get(0).get(0).split(" ")[0];
    		eventCreator=creatorResult.get(0).get(0);  	
    		storedEventId = "Meeting-".concat(m_id).concat("-").concat(ms_id);
    	}
        if (!(l_id==null || ls_id==null)) {
            user.isTeaching(isEventCreator, ls_id, userId);            
            user.isLectureStudent(isEventAttendee, ls_id, userId);         
            user.isGuestTeaching(isEventGuest, ls_id, l_id, userId);
            lecture.getLectureScheduleInfo(lectureResult,ls_id);
            lecture.getLectureInitialDatetime(startTimeResult, ls_id, l_id);
            lecture.getLectureDuration(durationResult, ls_id, l_id);
            c_id=lectureResult.get(0).get(1);
            sc_id=lectureResult.get(0).get(2);
            sc_semesterid=lectureResult.get(0).get(3);
            duration = durationResult.get(0).get(0);
            startTime = startTimeResult.get(0).get(0).split(" ")[1].substring(0, 8);
            startDate = startTimeResult.get(0).get(0).split(" ")[0];
            lecture.getLectureProfessor(creatorResult, c_id, sc_id, sc_semesterid);
            eventCreator=creatorResult.get(0).get(0); 
            storedEventId = "Lecture-".concat(l_id).concat("-").concat(ls_id);
        }
    }

%>
<script type="text/javascript">
/* TABLE */
	$(screen).ready(function() {
	    /* CURRENT EVENT */
	   // $('#currentEvent').dataTable({"sPaginationType": "full_numbers"});
	   // $('#currentEvent').dataTable({"aoColumnDefs": [{ "bSortable": false, "aTargets":[5]}], "bRetrieve": true, "bDestroy": true});    
	  //  $('#currentEventS').dataTable({"sPaginationType": "full_numbers"});
	  //  $('#currentEventS').dataTable({"aoColumnDefs": [{ "bSortable": false, "aTargets":[5]}], "bRetrieve": true, "bDestroy": true});      
	    $('#tbAttendee').dataTable({"sPaginationType": "full_numbers"});
	    $('#tbAttendee').dataTable({"aoColumnDefs": [{ "bSortable": false, "aTargets":[5]}], "bRetrieve": true, "bDestroy": true});
	    $('#tbGuest').dataTable({"sPaginationType": "full_numbers"});
	    $('#tbGuest').dataTable({"aoColumnDefs": [{ "bSortable": false, "aTargets":[5]}], "bRetrieve": true, "bDestroy": true});
	    $('#tbAttendance').dataTable({"sPaginationType": "full_numbers"});
	    $('#tbAttendance').dataTable({"aoColumnDefs": [{ "bSortable": false, "aTargets":[5]}], "bRetrieve": true, "bDestroy": true});
	    $('#tbPresentation').dataTable({"sPaginationType": "full_numbers"});
	    $('#tbPresentation').dataTable({"aoColumnDefs": [{ "bSortable": false, "aTargets":[5]}], "bRetrieve": true, "bDestroy": true});
	    $('#legend').dataTable({"sPaginationType": "full_numbers"});
	    $('#legend').dataTable({"aoColumnDefs": [{ "bSortable": false, "aTargets":[5]}], "bRetrieve": true, "bDestroy": true});       
	    $.fn.dataTableExt.sErrMode = "throw";
	    $('.dataTables_filter input').attr("placeholder", "Filter entries");
	});
	/* SELECT BOX */
	$(function(){
	    $('select').selectmenu();
	});

</script>
</head>
<body>
<div id="page">
    <jsp:include page="header.jsp"/>
    <jsp:include page="menu.jsp"/>
    <script type="text/javascript">
	    $(document).ready(function() {
	        //Hide some tables on load
	        $('#legendExpand').click();
	        $('#expandAttendee').click();
	        $('#expandGuest').click();
	        $('#expandAttendance').click();
	        $('#expandPresentation').click();
	        $("#help").attr({href:"help_viewEvent.jsp" ,
                             target:"_blank"});
	        $("#EventButton").click(function(){
	        	var alertMessage;
	        	<% if (isEventCreator.get_value()){%>
	        	alertMessage = "Please note that you can create this event 15 minutes before the schedule start time only!";
	        	<%}else{%>
	        	alertMessage ="Event not start yet or event end";
	        	<%}%>
	        	alert(alertMessage);
	        });
	    });
    </script>
    <section>
        <header>
            <p><a href="calendar.jsp" tabindex="13">home</a> » </p>
            <h1>Current Event</h1>
            <div class="warningMessage"><%=message %></div>
            <div class="successMessage"><%=successMessage %></div> 
        </header>
        <% if(isEventCreator.get_value() || isEventAttendee.get_value() || isEventGuest.get_value()){ %>
	        <form name="joinEvent" id="joinEvent" method="get" action="join_event.jsp?&eventId=<%= (m_id==null)? l_id:m_id %>&eventSchduleId=<%= (ms_id==null)? ls_id:ms_id %>&eventType=<%= (m_id==null)? "Lecture":"Meeting" %>">
	            <article>
	                <header>
                    <h2>Manage Event</h2>
                    <img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content"/>
                   </header>
	                <div class="content">                      
	                        <% 	                          	                           
	                           if(eventTitle !=null){                        	   
                                   url = getRecordings(eventTitle);  
	                           }else{
	                        	   url = getRecordings(storedEventId);
	                           } %>
	                        <div class="component" style="display:none">
                                <label for="eventType" class="label">Event Type:</label>
                                <input type="text" name="eventType" id="eventType" class="input" readonly tabindex="3"  value="<%= (m_id==null)? "Lecture":"Meeting" %>" 
                                 title="event id" >
                                <label for="eventId" class="label">Event ID:</label>
                                <input type="text" name="eventId" id="eventId" class="input" readonly tabindex="3"  value="<%= (m_id==null)? l_id:m_id %>" 
                                 title="event id" >
                                <label for="eventScheduleId" class="label">Schedule ID:</label>
                                <input type="text" name="eventScheduleId" id="eventScheduleId" class="input" readonly tabindex="3"  value="<%= (ms_id==null)? ls_id:ms_id %>" 
                                 title="event id" >
	                        </div>                          
                            <div class="actionButtons">  
                             <% Boolean startEvent = false;
                                String expectStartTime = startTimeResult.get(0).get(0).substring(0,19);
                                Date now = new Date();
                                DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                                Date expectStart = dateFormat.parse(expectStartTime);		                 
		                        long timediff = expectStart.getTime() - now.getTime();
		                        long diffMinutes = TimeUnit.MILLISECONDS.toMinutes(timediff);
		                        long eventDuration = (long)Integer.valueOf(duration);
		                        if(diffMinutes<=15 &&diffMinutes>-eventDuration){
		                        	startEvent = true;
		                        }
		                        if(startEvent){
                             %>                      
                                    <button type="submit" name="joinEventButton" id="joinEventButton" class="button" value="<%= isEventCreator.get_value()? "create":"join"  %>" title="Click here to go to the event" >
                                    <% if(isEventCreator.get_value()){ out.print("Create");} else {out.print("Join");} if(m_id==null){out.print(" Lecture");} else out.print(" Meeting"); %></button>

                            <% }else{ %>  
                                    <button style="background-color:grey" type="button" name="EventButton" id="EventButton" class="button" value="<%= isEventCreator.get_value()? "create":"join"  %>" title="Click here to go to the event" >
                                    <% if(isEventCreator.get_value()){ out.print("Create");} else {out.print("Join");} if(m_id==null){out.print(" Lecture");} else out.print(" Meeting"); %></button>
                            <%} %> 

		                        <% if (status==1) { %>
		                            <button type="button" name="button" id="addAttendee" class="button" title="Click here to add Attendee" 
		                                onclick="window.location.href='add_attendee.jsp?ms_id=<%= ms_id %>&m_id=<%= m_id %>'">Manage Attendee</button>
		                            <button type="button" name="button" id="addMGuest" class="button" title="Click here to add Meeting Guest" 
                                        onclick="window.location.href='add_mguest.jsp?ms_id=<%= ms_id %>&m_id=<%= m_id %>'">Manage Guest</button>
                                    <button type="button" name="button" id="addMPresentation" class="button" title="Click here to add Meeting Presentation" 
                                        onclick="window.location.href='add_mpresentation.jsp?ms_id=<%= ms_id %>&m_id=<%= m_id %>'">Manage Presentation</button>                           
		                        <% } else if (status==3) { %>
		                            <button type="button" name="button" id="addStudent" class="button" title="Click here to add Student" 
		                                onclick="window.location.href='add_student.jsp?ls_id=<%= ls_id %>&l_id=<%= l_id %>'">Manage Student</button>
		                            <button type="button" name="button" id="addLGuest" class="button" title="Click here to add Lecture Guest" 
                                        onclick="window.location.href='add_lguest.jsp?ls_id=<%= ls_id %>&l_id=<%= l_id %>'">Manage Guest</button>  
                                    <button type="button" name="button" id="addLGuest" class="button" title="Click here to add Lecture Presentation" 
                                        onclick="window.location.href='add_lpresentation.jsp?ls_id=<%= ls_id %>&l_id=<%= l_id %>'">Manage Presentation</button>                                                          
		                        <% } %>
		                    </div>
	                </div>
	            </article>
	        </form>                                       
       <% } %>
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
                                    <% if (status==1 || status==2 || status==6) { %>
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
                                    <% if (status==1 || status==2 || status==3 || status==5) { %>
                                        <th width="65" title="Details" class="icons" align="center">Details</th>
                                    <% } %>
                                    <% if (status==1 || status==3) { %>
                                        <th width="65" title="Modify" class="icons" align="center">Modify</th>
                                    <% } %>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                    <% if (status==1 || status==2 || status==6) { %>
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
                                    <% if (status==1 || status==2) { %>
                                        <td class="icons" align="center">
                                            <a href="view_event_schedule.jsp?ms_id=<%= ms_id %>&m_id=<%= m_id %>" class="view">
                                            <img src="images/iconPlaceholder.svg" width="17" height="17" title="View event schedule" alt="View_Event"/>
                                            </a></td>
                                    <% } else if (status==3 || status==5) { %>
                                        <td class="icons" align="center">
                                            <a href="view_event_schedule.jsp?ls_id=<%= ls_id %>&l_id=<%= l_id %>" class="view">
                                            <img src="images/iconPlaceholder.svg" width="17" height="17" title="View event schedule" alt="View_Event"/>
                                            </a></td>
                                    <% } %>
                                    <% if (status==1) { %>
                                        <td class="icons" align="center">
                                            <a href="edit_event_schedule.jsp?ms_id=<%= ms_id %>&m_id=<%= m_id %>" class="modify">
                                            <img src="images/iconPlaceholder.svg" width="17" height="17" title="Modify meeting schedule" alt="Modify"/>
                                        </a></td>
                                    <% } else if (status==3) { %>
                                        <td class="icons" align="center">
                                            <a href="edit_event_schedule.jsp?ls_id=<%= ls_id %>&l_id=<%= l_id %>" class="modify">
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
                    <h2>Current Event</h2>
                </header>
                <div class="content">
                    <fieldset>
                        <div id="currentEventDiv" class="tableComponent">
                            <table id="currentEvent" border="0" cellpadding="0" cellspacing="0">
                                <thead>
                                    <tr>
                                        <th class="firstColumn" tabindex="16" title="Type">Type<span></span></th>
                                        <th title="StartingDate">Date<span></span></th>
                                        <th title="StartingTime">Time<span></span></th>
                                        <th title="duration">Duration<span></span></th>
                                        <th title="isCancel">Cancelled<span></span></th>
                                        <th width="200" title="description">Description<span></span></th>
                                        <% if (status==1 || status==3 || status==4) { %>
                                        <th width="65" title="Modify" class="icons" align="center">Modify</th>
                                        
                                        <% } %>
                                        <th width="100" title="recording">Recording<span></span></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td class="row"><%= type %></td>
                                        <td><%= eventResult.get(0).get(2).substring(0, 10) %></td>
                                        <td><%= eventResult.get(0).get(2).substring(11, 19) %></td>
                                        <td><%= eventResult.get(0).get(3) %> Minutes</td>
                                        <td><%= isCancel %></td>
                                        <td><%= eventResult.get(0).get(5) %></td>
                                        <% if (status==1) { %>
                                            <td class="icons" align="center">
                                                <a href="edit_meeting.jsp?ms_id=<%= ms_id %>&m_id=<%= m_id %>" class="modify">
                                                <img src="images/iconPlaceholder.svg" width="17" height="17" title="Modify meeting" alt="Modify"/>
                                            </a></td>
                                        <% } else if (status==3 || status==4) { %>
                                            <td class="icons" align="center">
                                                <a href="edit_lecture.jsp?ls_id=<%= ls_id %>&l_id=<%= l_id %>" class="modify">
                                                <img src="images/iconPlaceholder.svg" width="17" height="17" title="Modify lecture" alt="Modify"/>
                                            </a></td>
                                        <% } %>
                                        <td> <% if(url !=null && url !="") for(int j=0;j<url.split(" ").length;j++) {%>
                                             <a <%  out.print("href=" +url.split(" ")[j]);  %> style="color:blue" target="_blank">                    
                                                <%  out.print("view recording "+ (j+1)); %>                      
                                             </a></br> <% } else  out.print("Not Available"); %> 
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </fieldset>
                </div>
            </article>
            <% if (status==1 || status==3 || status==4) { %>
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
                    <br />

                </div>
            </article>
            <% } %>
            <% if (status==1 || status==3 || status==4) { %>
            <article>
                <header id="expandGuest">
                    <h2>Guest List</h2>
                    <img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content"/>
                </header>
                <div class="content">

                    <fieldset>
                        <div id="currentEventDiv" class="tableComponent">
                            <table id="tbGuest" border="0" cellpadding="0" cellspacing="0">
                                <thead>
                                    <tr>
                                        <th class="firstColumn" tabindex="16">Id<span></span></th>
                                        <th>Nick Name<span></span></th>
                                        <th>Moderator<span></span></th>
                                    </tr>
                                </thead>
                                <tbody>
                                <% for (i=0; i<eventGuest.size(); i++) { %>
                                    <tr>
                                        <td class="row"><%= eventGuest.get(i).get(0) %></td>
                                        <td><%= eventGuest.get(i).get(2) %></td>
                                        <td><%= eventGuest.get(i).get(1).equals("1") ? "Yes" : "" %></td>
                                    </tr>
                                <% } %>
                                </tbody>
                            </table>
                        </div>
                    </fieldset>
                    <br />
                </div>
            </article>
            <% } %>
            <% if (status==1 || status==3 || status==4) { %>
            <article>
                <header id="expandAttendance">
                    <h2>Attendance List</h2>
                    <img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content"/>
                </header>
                <div class="content">
                    <fieldset>
                        <div id="currentEventDiv" class="tableComponent">
                            <table id="tbAttendance" border="0" cellpadding="0" cellspacing="0">
                                <thead>
                                    <tr>
                                        <th class="firstColumn" tabindex="16">Id<span></span></th>
                                        <th>Nick Name<span></span></th>
                                    </tr>
                                </thead>
                                <tbody>
                                <% for (i=0; i<eventAttendance.size(); i++) { %>
                                    <tr>
                                        <td class="row"><%= eventAttendance.get(i).get(0) %></td>
                                        <td><%= eventAttendance.get(i).get(2) %></td>
                                    </tr>
                                <% } %>
                                </tbody>
                            </table>
                        </div>
                    </fieldset>
                </div>
            </article>
            <% } %>
            <article>
                <header id="expandPresentation">
                    <h2>Presentation List</h2>
                    <img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content"/>
                </header>
                <div class="content">

                    <fieldset>
                        <div id="currentEventDiv" class="tableComponent">
                            <table id="tbPresentation" border="0" cellpadding="0" cellspacing="0">
                                <thead>
                                    <tr>
                                        <th class="firstColumn" tabindex="16">Presentation Title<span></span></th>
                                    </tr>
                                </thead>
                                <tbody>
                                <% for (i=0; i<eventPresentation.size(); i++) { %>
                                    <tr>
                                        <td class="row"><%= eventPresentation.get(i).get(0) %></td>
                                    </tr>
                                <% } %>
                                </tbody>
                            </table>
                        </div>
                    </fieldset>
                    <br />
                </div>
            </article>
            <article>
                <header id="legendExpand">
                            <h2>Legend</h2>
                            <img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content" alt="Arrow"/>
                </header>
                <div class="content">
                    <fieldset>
                        <div class="tableComponent">
                            <table id="legend" border="0" cellpadding="0" cellspacing="0">
                                <thead>
                                    <tr>
                                        <th class="firstColumn" tabindex="16" title="Type">Type<span></span></th>
                                        <th title="legendDescription">Description<span></span></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td class="row">Meeting (C)</td>
                                        <td>You created this meeting</td>
                                    </tr>
                                    <tr>
                                        <td class="row">Meeting (G)</td>
                                        <td>You are invited as a guest to this meeting</td>
                                    </tr>
                                    <tr>
                                        <td class="row">Meeting (A)</td>
                                        <td>You are invited to this meeting</td>
                                    </tr>
                                    <tr>
                                        <td class="row">Lecture (T)</td>
                                        <td>You are teaching this lecture</td>
                                    </tr>
                                    <tr>
                                        <td class="row">Lecture (G)</td>
                                        <td>You are a guest in this lecture</td>
                                    </tr>
                                    <tr>
                                        <td class="row">Lecture (S)</td>
                                        <td>You are a student in this lecture</td>
                                    </tr>
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

