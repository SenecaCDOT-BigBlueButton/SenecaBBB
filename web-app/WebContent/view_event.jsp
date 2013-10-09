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
<title>Seneca | View Event</title>
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
	if (message == null || message == "null") {
		message="";
	}
	User user = new User(dbaccess);
	Meeting meeting = new Meeting(dbaccess);
	Lecture lecture = new Lecture(dbaccess);
	Section section = new Section(dbaccess);
	boolean validFlag; 
	MyBoolean myBool = new MyBoolean();
	// Denotes the relationship between the session user and current event being viewed:
	//	(1) the session user created this meeting
	//  (2) the session user is scheduled to attend this meeting
	//  (3) the session user is teaching or guest teaching this lecture
	//  (4) the session user is a student in this lecture session
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
			response.sendRedirect("calendar.jsp?message=" + Validation.getErrMsg());
			return;
		}
	    if (!meeting.isMeeting(myBool, ms_id, m_id)) {
		    message = "Could not verify meeting status (ms_id: " + ms_id + ", m_id: " + m_id + ")" + user.getErrMsg("VE00-1");
		    response.sendRedirect("logout.jsp?message=" + message);
			return;   
		}
	    if (!myBool.get_value()) {
			response.sendRedirect("calendar.jsp?message=You do not permission to access that page");
			return;
		}
		if (!user.isMeetingCreator(myBool, ms_id, userId)) {
		    message = "Could not verify meeting status (ms_id: " + ms_id + ", m_id: " + m_id + ")" + user.getErrMsg("VE01");
		    response.sendRedirect("logout.jsp?message=" + message);
			return;   
		}
		if (myBool.get_value()) {
			status = 1;
		}
		if (status == 0) {
		    if (!user.isMeetingAttendee(myBool, ms_id, userId)) {
		        message = "Could not verify meeting status (ms_id: " + ms_id + ", m_id: " + m_id + ")" + user.getErrMsg("VE02");
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
			    response.sendRedirect("logout.jsp?message=" + message);
				return;   
			}
			if (myBool.get_value()) {
				status = 6;
			}
		}
		if (status==0) {
			response.sendRedirect("calendar.jsp?message=You do not permission to access that page");
			return;
		}
	} else if (!(l_id==null || ls_id==null)) {
	    l_id = Validation.prepare(l_id);
	    ls_id = Validation.prepare(ls_id);
	    validFlag = Validation.checkLId(l_id) && Validation.checkLsId(ls_id);
	    if (!validFlag) {
			response.sendRedirect("calendar.jsp?message=" + Validation.getErrMsg());
			return;
		}
	    if (!lecture.isLecture(myBool, ls_id, l_id)) {
		    message = "Could not verify lecture status (ls_id: " + ls_id + ", l_id: " + l_id + ")" + user.getErrMsg("VE00-2");
		    response.sendRedirect("logout.jsp?message=" + message);
			return;   
		}
	    if (!myBool.get_value()) {
			response.sendRedirect("calendar.jsp?message=You do not permission to access that page");
			return;
		}
		if (!user.isTeaching(myBool, ls_id, userId)) {
		    message = "Could not verify meeting status (ls_id: " + ls_id + ", l_id: " + l_id + ")" + user.getErrMsg("VE03");
		    response.sendRedirect("logout.jsp?message=" + message);
			return;   
		}
		if (myBool.get_value()) {
			status = 3;
		}
		if (status == 0) {
		    if (!user.isGuestTeaching(myBool, ls_id, l_id, userId)) {
		        message =  "Could not verify lecture status (ls_id: " + ls_id + ", l_id: " + l_id + ")" + user.getErrMsg("VE04");
			    response.sendRedirect("logout.jsp?message=" + message);
				return;   
			}
			if (myBool.get_value()) {
				status = 4;
			}
		}
		if (status == 0) {
		    if (!user.isLectureStudent(myBool, ls_id, l_id, userId)) {
			    message =  "Could not verify lecture status (ls_id: " + ls_id + ", l_id: " + l_id + ")" + user.getErrMsg("VE05");
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
	ArrayList<ArrayList<String>> eventGuest = new ArrayList<ArrayList<String>>();
	ArrayList<ArrayList<String>> eventAttendance = new ArrayList<ArrayList<String>>();
	String type = "";
	if (status == 1) {
	    type = "Meeting (C)";
	    if (!meeting.getMeetingInfo(eventResult, ms_id, m_id)) {
	        message = meeting.getErrMsg("VE05");
	        response.sendRedirect("logout.jsp?message=" + message);
			return;   
	    }
	    if (!meeting.getMeetingScheduleInfo(eventSResult, ms_id)) {
	        message = meeting.getErrMsg("VE06");
	        response.sendRedirect("logout.jsp?message=" + message);
			return;   
	    }
	    if (!meeting.getMeetingAttendee(eventAttendee, ms_id)) {
	        message = meeting.getErrMsg("VE07");
	        response.sendRedirect("logout.jsp?message=" + message);
			return;   
	    }
	    if (!meeting.getMeetingGuest(eventGuest, ms_id, m_id)) {
	        message = meeting.getErrMsg("VE07");
	        response.sendRedirect("logout.jsp?message=" + message);
			return;   
	    }
	    if (!meeting.getMeetingAttendance(eventAttendance, ms_id, m_id)) {
	        message = meeting.getErrMsg("VE08");
	        response.sendRedirect("logout.jsp?message=" + message);
			return;   
	    }
	} else if (status == 2 || status == 6) {
	    type = (status == 2) ? "Meeting (A)" : "Meeting (G)";
	    if (!meeting.getMeetingInfo(eventResult, ms_id, m_id)) {
	        message = meeting.getErrMsg("VE09");
	        response.sendRedirect("logout.jsp?message=" + message);
			return;   
	    }
	    if (!meeting.getMeetingScheduleInfo(eventSResult, ms_id)) {
	        message = meeting.getErrMsg("VE10");
	        response.sendRedirect("logout.jsp?message=" + message);
			return;   
	    }
	} else if (status == 3 || status == 4) {
	    type = (status == 3) ? "Lecture (T)" : "Lecture (G)";
	    if (!lecture.getLectureInfo(eventResult, ls_id, l_id)) {
	        message = lecture.getErrMsg("VE11");
	        response.sendRedirect("logout.jsp?message=" + message);
			return;   
	    }
	    if (!lecture.getLectureScheduleInfo(eventSResult, ls_id)) {
	        message = lecture.getErrMsg("VE12");
	        response.sendRedirect("logout.jsp?message=" + message);
			return;   
	    }
	    if (!section.getStudent(eventAttendee, ls_id)) {
	        message = lecture.getErrMsg("VE13");
	        response.sendRedirect("logout.jsp?message=" + message);
			return;   
	    }
	    if (!lecture.getLectureGuest(eventGuest, ls_id, l_id)) {
	        message = lecture.getErrMsg("VE14");
	        response.sendRedirect("logout.jsp?message=" + message);
			return;   
	    }
	    if (!lecture.getLectureAttendance(eventAttendance, ls_id, l_id)) {
	        message = lecture.getErrMsg("VE15");
	        response.sendRedirect("logout.jsp?message=" + message);
			return;   
	    }
	} else if (status == 5) {
	    type = "Lecture (S)";
	    if (!lecture.getLectureInfo(eventResult, ls_id, l_id)) {
	        message = lecture.getErrMsg("VE16");
	        response.sendRedirect("logout.jsp?message=" + message);
			return;   
	    }
	    if (!lecture.getLectureScheduleInfo(eventSResult, ls_id)) {
	        message = lecture.getErrMsg("VE17");
	        response.sendRedirect("logout.jsp?message=" + message);
			return;   
	    }
	}
	String isCancel = (eventResult.get(0).get(4).equals("1")) ? "Yes" : "";
	int i = 0;		                        
%>
<script type="text/javascript">
/* TABLE */
$(screen).ready(function() {
	/* CURRENT EVENT */
	$('#tbAttendee').dataTable({"sPaginationType": "full_numbers"});
	$('#tbAttendee').dataTable({"aoColumnDefs": [{ "bSortable": false, "aTargets":[5]}], "bRetrieve": true, "bDestroy": true});
	$('#tbGuest').dataTable({"sPaginationType": "full_numbers"});
	$('#tbGuest').dataTable({"aoColumnDefs": [{ "bSortable": false, "aTargets":[5]}], "bRetrieve": true, "bDestroy": true});
	$('#tbAttendance').dataTable({"sPaginationType": "full_numbers"});
	$('#tbAttendance').dataTable({"aoColumnDefs": [{ "bSortable": false, "aTargets":[5]}], "bRetrieve": true, "bDestroy": true});
	$.fn.dataTableExt.sErrMode = 'throw';
	$('.dataTables_filter input').attr("placeholder", "Filter entries");
});
/* SELECT BOX */
$(function(){
	$('select').selectmenu();
});
$(document).ready(function() {
	//Hide some tables on load
	$('#legendExpand').click();
	$('#expandAttendee').click();
	$('#expandGuest').click();
	$('#expandAttendance').click();
});
</script>
</head>
<body>
<div id="page">
	<jsp:include page="header.jsp"/>
	<jsp:include page="menu.jsp"/>
	<section>
		<header>
			<p><a href="calendar.jsp" tabindex="13">home</a> » <a href="view_event.jsp" tabindex="14">viewEvent</a></p>
			<h1>Current Event</h1>
			<div class="warningMessage"><%=message %></div>
		</header>
		<form action="persist_user_settings.jsp" method="get">
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
										<th width="80" class="firstColumn" tabindex="16" title="Type">Type<span></span></th>
										<th width="135" title="StartingTime">Starting Time<span></span></th>
										<th width="100" title="duration">Duration (Min)<span></span></th>
										<th width="130" title="isCancel">Event Cancelled<span></span></th>
										<th title="description">Description<span></span></th>
										<% if (status==1 || status==3 || status==4) { %>
										<th width="65" title="Modify" class="icons" align="center">Modify</th>
										<% } %>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td class="row"><%= type %></td>
										<td><%= eventResult.get(0).get(2) %></td>
										<td><%= eventResult.get(0).get(3) %></td>
										<td><%= isCancel %></td>
										<td><%= eventResult.get(0).get(5) %></td>
										<% if (status==1 || status==3 || status==4) { %>
										<td class="icons" align="center"><a href="" class="modify"><img src="images/iconPlaceholder.svg" width="17" height="17" title="Modify department name" alt="Modify"/></a></td>
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
										<th>Starting Time<span></span></th>
										<th>Duration (Min)<span></span></th>
										<th>Creator<span></span></th>
									<% } else { %>
										<th class="firstColumn" tabindex="16">Course<span></span></th>
										<th>Section<span></span></th>
										<th>Semester<span></span></th>
										<th>Starting Time<span></span></th>
										<th>Duration<span></span></th>
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
										<td><%= eventSResult.get(0).get(2) %></td>
										<td><%= eventSResult.get(0).get(4) %></td>
										<td><%= eventSResult.get(0).get(5) %></td>
									<% } else { %>
										<td class="row"><%= eventSResult.get(0).get(1) %></td>
										<td><%= eventSResult.get(0).get(2) %></td>
										<td><%= eventSResult.get(0).get(3) %></td>
										<td><%= eventSResult.get(0).get(4) %></td>
										<td><%= eventSResult.get(0).get(6) %></td>
									<% } %>
									<% if (status==1 || status==3) { %>
										<td class="icons" align="center"><a href="" class="modify"><img src="images/iconPlaceholder.svg" width="17" height="17" title="Modify department name" alt="Modify"/></a></td>
									<% } %>
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
					<h2>Meeting Attendee List</h2>
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
					<br /><hr /><br />
					<div class="component">
						<div class="buttons">
						<% if (status==1) { %>
							<button type="button" name="button" id="addMGuest" class="button" title="Click here to add Meeting Guest" 
								onclick="window.location.href='add_mguest.jsp?ms_id=<%= ms_id %>&m_id=<%= m_id %>'">Manage Guest List</button>
						<% } else if (status==3) { %>
							<button type="button" name="button" id="addLGuest" class="button" title="Click here to add Lecture Guest" 
								onclick="window.location.href='add_lguest.jsp?ls_id=<%= ls_id %>&l_id=<%= l_id %>'">Manage Guest List</button>
						<% } %>
	              		</div>
               		</div>
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
				<header id="legendExpand">
							<h2>Legend</h2>
							<img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content" alt="Arrow"/>
				</header>
				<div class="content">
					<fieldset>
						<div class="tableComponent">
							<table border="0" cellpadding="0" cellspacing="0">
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