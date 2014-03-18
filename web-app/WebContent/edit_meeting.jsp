<%@page import="db.DBConnection"%>
<%@page import="sql.*"%>
<%@page import="java.util.*"%>
<%@page import="helper.*"%>
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<!doctype html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Edit Meeting</title>
<link rel="shortcut icon" href="http://www.senecacollege.ca/favicon.ico">
<link rel="stylesheet" type="text/css" media="all" href="css/fonts.css">
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/style.css">
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.core.css">
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.theme.css">
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.timepicker.css">
<script type="text/javascript" src="js/jquery-1.9.1.js"></script>
<script type="text/javascript" src="js/modernizr.custom.79639.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.position.js"></script>
<script type="text/javascript" src="js/ui/jquery.timepicker.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.stepper.js"></script>
<script type="text/javascript" src="js/jquery.validate.min.js"></script>
<script type="text/javascript" src="js/additional-methods.min.js"></script>
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
    String message = request.getParameter("message");
    String successMessage = request.getParameter("successMessage");
    if (message == null || message == "null") {
        message="";
    }
    if (successMessage == null) {
        successMessage="";
    }
    String m_id = request.getParameter("m_id");
    String ms_id = request.getParameter("ms_id");
    if (m_id==null || ms_id==null) {
    	elog.writeLog("[edit_meeting:] " + "null m_id or ms_id /n");
        response.sendRedirect("calendar.jsp?message=Please do not mess with the URL");
        return;
    }
    m_id = Validation.prepare(m_id);
    ms_id = Validation.prepare(ms_id);
    if (!(Validation.checkMId(m_id) && Validation.checkMsId(ms_id))) {
    	elog.writeLog("[edit_meeting:] " + Validation.getErrMsg() +" /n");
        response.sendRedirect("calendar.jsp?message=" + Validation.getErrMsg());
        return;
    }
    User user = new User(dbaccess);
    Meeting meeting = new Meeting(dbaccess);
    MyBoolean myBool = new MyBoolean();    
    if (!meeting.isMeeting(myBool, ms_id, m_id)) {
        message = meeting.getErrMsg("EM01");
        elog.writeLog("[edit_meeting:] " + message +" /n");
        response.sendRedirect("logout.jsp?message=" + message);
        return;   
    }
    if (!myBool.get_value()) {
        elog.writeLog("[edit_meeting:] " + " username: "+ userId + " tried to access this page, permission denied" +" /n");       
        response.sendRedirect("calendar.jsp?message=You do not permission to access that page");
        return;
    }
    if (!user.isMeetingCreator(myBool, ms_id, userId)) {
        message = user.getErrMsg("EM02");
        elog.writeLog("[edit_meeting:] " + message +" /n");
        response.sendRedirect("logout.jsp?message=" + message);
        return;   
    }
    if (!myBool.get_value()) {
        elog.writeLog("[edit_meeting:] " + " username: "+ userId + " tried to access this page, permission denied" +" /n");               
        response.sendRedirect("calendar.jsp?message=You do not permission to access that page");
        return;
    }
    // End page validation
    
    boolean edited = false;
    boolean editError = false;

    String startTime = request.getParameter("startTime");
    if (startTime!=null) {
        if (!Validation.checkStartTime(startTime)) {
            message += Validation.getErrMsg();
            editError = true;
        } else {
            if (!meeting.updateMeetingTime(1, ms_id, m_id, startTime)) {
                message += user.getErrMsg("EM03");
                elog.writeLog("[edit_meeting:] " + message +" /n");
                response.sendRedirect("logout.jsp?message=" + message);
                return;  
            } else {
                edited = true;
            }
        }
    }
    
    String duration = request.getParameter("eventDuration");
    if (duration!=null) {
        if (!Validation.checkDuration(duration)) {
            message += "<br />" + Validation.getErrMsg();
            editError = true;
        } else {
            if (!meeting.updateMeetingDuration(1, ms_id, m_id, duration)) {
                message += user.getErrMsg("EM04");
                elog.writeLog("[edit_meeting:] " + message +" /n");
                response.sendRedirect("logout.jsp?message=" + message);
                return;  
            } else {
                edited = true;
            }
        }
    }
    
    String description = request.getParameter("description");
    if (description!=null) {
        if (!Validation.checkDescription(description)) {
            message += "<br />" + Validation.getErrMsg();
            editError = false;
        } else {
            if (!meeting.setMeetingDescription(ms_id, m_id, description)) {
                message += user.getErrMsg("EM05");
                elog.writeLog("[edit_meeting:] " + message +" /n");
                response.sendRedirect("logout.jsp?message=" + message);
                return;  
            } else {
                edited = true;
            }
        }
    }
    
    if (edited) {
	    String cancelEvent = request.getParameter("cancelEventBox");
	    if (cancelEvent!=null) {
	        if (!meeting.setMeetingIsCancel(ms_id, m_id, true)) {
	            message += user.getErrMsg("EM06");
	            elog.writeLog("[edit_meeting:] " + message +" /n");
	            response.sendRedirect("logout.jsp?message=" + message);
	            return;  
	        }
	    } else {
	        if (!meeting.setMeetingIsCancel(ms_id, m_id, false)) {
                message += user.getErrMsg("EM07");
                elog.writeLog("[edit_meeting:] " + message +" /n");
                response.sendRedirect("logout.jsp?message=" + message);
                return;  
            } 
	    }
    }
    if(edited){
        String allowRecording = request.getParameter("allowRecording");
        HashMap<String, Integer> map = new HashMap<String, Integer>();
        if(allowRecording==null){
          map.put(Settings.meeting_setting[0], 0);
        }else{
          map.put(Settings.meeting_setting[0], 1);
        }
        map.put(Settings.meeting_setting[1], 0);
        map.put(Settings.meeting_setting[2], 0);
        map.put(Settings.meeting_setting[3], 0);
        map.put(Settings.meeting_setting[4], 0);
        if(!meeting.setMeetingSetting(map,ms_id,m_id)){
        	response.sendRedirect("logout.jsp?message=Fail to change meeting setting");
        	return;
        }
    }
    if (edited && !editError) {
    	successMessage = "Event Details Updated";
        response.sendRedirect("view_event.jsp?ms_id=" + ms_id + "&m_id=" + m_id + "&successMessage=" + successMessage);
        return;  
    }
    
    ArrayList<ArrayList<String>> event = new ArrayList<ArrayList<String>>();
    if (!meeting.getMeetingInfo(event, ms_id, m_id)) {
        message = meeting.getErrMsg("EM08");
        elog.writeLog("[edit_meeting:] " + message +" /n");
        response.sendRedirect("logout.jsp?message=" + message);
        return;   
    }    
    
    ArrayList<ArrayList<String>> eventSchedule = new ArrayList<ArrayList<String>>();
    if (!meeting.getMeetingScheduleInfo(eventSchedule, ms_id)) {
        message = meeting.getErrMsg("EM09");
        elog.writeLog("[edit_meeting:] " + message +" /n");
        response.sendRedirect("logout.jsp?message=" + message);
        return;   
    }
    HashMap<String, Integer> isRecordedResult = new HashMap<String, Integer>();
    meeting.getMeetingSetting(isRecordedResult, ms_id, m_id);
    boolean check1 = event.get(0).get(4).equals("1") ? true : false;
    
%>

<script type="text/javascript">
/* TABLE */
$(screen).ready(function() {
    $('#startTime').timepicker({ 'scrollDefaultNow': true });    
	<%if (isRecordedResult.get("isRecorded")==0){%>
	$(".checkbox .box:eq(0)").next(".checkmark").toggle();
	$(".checkbox .box:eq(0)").attr("aria-checked", "false");
	$(".checkbox .box:eq(0)").siblings().last().prop("checked", false);
	<%}%>
	
   <%if (!check1){%>
    $(".checkbox .box:eq(1)").next(".checkmark").toggle();
    $(".checkbox .box:eq(1)").attr("aria-checked", "false");
    $(".checkbox .box:eq(1)").siblings().last().prop("checked", false);
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
            <!-- BREADCRUMB -->
            <p><a href="calendar.jsp" tabindex="13">home</a> » 
                <a href="view_event.jsp?ms_id=<%= ms_id %>&m_id=<%= m_id %>" tabindex="14">view_event</a> » 
                <a href="edit_meeting.jsp?ms_id=<%= ms_id %>&m_id=<%= m_id %>" tabindex="15">edit_event</a></p>
            <!-- PAGE NAME -->
            <h1>Meeting Event</h1>
            <br />
            <!-- MESSAGES -->
            <div class="warningMessage"><%=message %></div>
            <div class="successMessage"><%=successMessage %></div> 
        </header>
        <form name="EditMeeting" id="EditMeeting" method="get" action="edit_meeting.jsp">
            <article>
                <header>
                    <h2>Current Event</h2>
                </header>
                <div class="content">
                    <fieldset>
                        <div id="currentEventDiv" class="tableComponent">
                            <table id="tbEvent" border="0" cellpadding="0" cellspacing="0">
                                <thead>
                                    <tr>
                                        <th class="firstColumn" tabindex="16">Title<span></span></th>
                                        <th>Date<span></span></th>
                                        <th>Creator<span></span></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td class="row"><%= eventSchedule.get(0).get(1) %></td>
                                        <td><%= event.get(0).get(2).substring(0, 10) %></td>
                                        <td><%= eventSchedule.get(0).get(5) %></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </fieldset>
                </div>
            </article>
            <article>
                <header>
                    <h2>Edit Form</h2>
                    <img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content"/>
                </header>
                <div class="content">
                    <fieldset>
                        <input type="hidden" name="ms_id" id="ms_id" value="<%= ms_id %>">
                        <input type="hidden" name="m_id" id="m_id" value="<%= m_id %>">  
                        <div class="component" >
                            <label for="startTime" class="label">Start Time:</label> 
                            <input id="startTime" name="startTime"  type="text"  class="input"  value="<%= event.get(0).get(2).substring(11, 19) %>" tabindex="24" title="Start Time" placeholder="pick start time" autofocus/>            
                        </div>
                        <div class="component" >
                            <label for="eventDuration" class="label">Duration:</label> 
                            <input id="eventDuration" name="eventDuration"  type="number"  class="input"  tabindex="25" title="Event Duration"  value="<%= event.get(0).get(3) %>" placeholder="minutes" required autofocus/>            
                        </div>
                        <div class="component" >
                            <label for="description" class="label">Description:</label>
                            <input name="description" id="description" class="input" cols="35" rows="5" title="Description"  value="<%= event.get(0).get(5) %>" autofocus />      
                        </div>
                        <div class="component">
                            <div class="checkbox" title="Allow event recording"> <span class="box" role="checkbox" aria-checked="true" tabindex="21" aria-labelledby="eventSetting4"></span>
                                <label class="checkmark"></label>
                                <label class="text" id="allowRecording">Allow event recording</label>
                                <input type="checkbox" name="allowRecording" checked="checked">
                            </div>
                            
                        </div>
                        
                        <div class="component">
                            <div class="checkbox" title="Cancel Event"> <span class="box" role="checkbox" aria-checked="true" tabindex="22" aria-labelledby="eventSetting5"></span>
                                <label class="checkmark"></label>
                                <label class="text" id="cancelEventBox">Cancel meeting</label>
                                <input type="checkbox" name="cancelEventBox" checked="checked">
                            </div>
                            
                        </div>                                               
                        <div class="component">
                            <div class="buttons">
                               <button type="submit" class="button" title="Click here to save">Save</button>
                               <button type="reset" class="button" title="Click here to reset">Reset</button>
                               <button type="button" class="button" title="Click here to cancel" 
                                onclick="window.location.href='view_event.jsp?ms_id=<%= ms_id %>&m_id=<%= m_id %>'">Cancel</button>
                            </div>
                        </div>
                    </fieldset>
                </div>
            </article>
        </form>
    </section>
    <script>    
   // form validation, edit the regular expression pattern and error messages to meet your needs
   
       $(document).ready(function(){
            $('#EditMeeting').validate({
                validateOnBlur : true,
                rules: {

                	description:{
                       required: false,
                       maxlength: 100,
                       pattern: /^[^<>]+$/
                   },
                   startTime:{
                       required: true,
                       pattern: /^\s*[0-2][0-9]:[0-5][0-9]:[0-5][0-9]\s*$/
                   },
                   eventDuration:{
                       required: true,
                       range:[1,999]
                       
                   },
                   
                },
                messages: {
                    startTime:"Please enter a valid Time Format",
                    eventDuration:"Please enter a valid Number",
                    description:"Invalid characters"
                }
            });
          
        });
  </script>
    <jsp:include page="footer.jsp"/>
</div>
</body>
</html>