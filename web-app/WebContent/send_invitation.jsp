<%@page import="sql.*"%>
<%@page import="java.util.*"%>
<%@page import="helper.*"%>
<%@page import="config.*"%>
<%@page import="hash.EncryptDecrypt"%>
<%@ include file="bbb_api.jsp"%> 
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<%
    //Start page validation
    String userId = usersession.getUserId();
    GetExceptionLog elog = new GetExceptionLog();
    HashMap<String, Integer> roleMask = usersession.getRoleMask();
    if (userId.equals("")) {
        session.setAttribute("redirecturl",request.getRequestURI() + (request.getQueryString()!=null?"?" + request.getQueryString():""));
        response.sendRedirect("index.jsp?message=Please log in");
        return;
    }
    if(!(usersession.isSuper()||usersession.getUserLevel().equals("employee")||roleMask.get("guestAccountCreation") == 0)) {
        elog.writeLog("[send_invitation:] " + " username: "+ userId + " tried to access this page, permission denied" + " /n");        
        response.sendRedirect("calendar.jsp?message=You do not have permission to access that page");
        return;
    }
    if (dbaccess.getFlagStatus() == false) {
        elog.writeLog("[send_invitation:] " + "database connection error /n");
        response.sendRedirect("index.jsp?message=Database connection error");
        return;
    }//End page validation
    
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
    User user = new User(dbaccess);
    ArrayList<HashMap<String,String>> nickNameResult = new ArrayList<HashMap<String,String>>();
    ArrayList<HashMap<String,String>> modPassResult = new ArrayList<HashMap<String,String>>();
    ArrayList<HashMap<String,String>> viewerPassResult = new ArrayList<HashMap<String,String>>();
    ArrayList<HashMap<String,String>> eventTitleResult = new ArrayList<HashMap<String,String>>();
    ArrayList<HashMap<String,String>> creatorResult = new ArrayList<HashMap<String,String>>();
    ArrayList<HashMap<String,String>> mResult = new ArrayList<HashMap<String,String>>();
    HashMap<String, Integer> isRecordedResult = new HashMap<String, Integer>();
    ArrayList<HashMap<String,String>> eventInfo = new ArrayList<HashMap<String,String>>();
    String modPwd = "";
    String viewerPwd = "";
    String username = "";
    String meetingID = "";
    String eventCreator = "";
    String c_id,sc_id,sc_semesterid;
    String eventStartTime = "";
    String eventType = request.getParameter("eventType");
    String eventId = request.getParameter("eventId");
    String eventScheduleId = request.getParameter("eventScheduleId");
    user.getNickName(nickNameResult, userId);
    username = nickNameResult.get(0).get("bu_nick");
    String isRecorded = "false";
    MyBoolean isCreator = new MyBoolean();
    MyBoolean isEvent = new MyBoolean();
    if(eventType !=null && eventType.equals("Meeting")){
         meeting.isMeeting(isEvent, eventScheduleId, eventId);
         if(!isEvent.get_value()){
             response.sendRedirect("index.jsp?message=Invalid meeting schedule or meeting information!");
             return;
         }
         user.isMeetingCreator(isCreator, eventScheduleId, userId);
         if(!isCreator.get_value()){
             response.sendRedirect("index.jsp?message=You are not the meeting creator or attendee!");
             return;
         }
         meeting.getMeetingModPass(modPassResult, eventScheduleId, eventId);
         meeting.getMeetingUserPass(viewerPassResult, eventScheduleId, eventId);
         meeting.getMeetingScheduleInfo(eventTitleResult, eventScheduleId);
         meeting.getMeetingSetting(isRecordedResult, eventScheduleId, eventId);
         meeting.getMeetingInfo(eventInfo,eventScheduleId,eventId);
         eventStartTime = eventInfo.get(0).get("m_inidatetime");
         if(isRecordedResult.get("isRecorded")==1){
             isRecorded = "true";
         }else{
             isRecorded = "false";
         }
         modPwd = modPassResult.get(0).get("m_modpass");
         viewerPwd = viewerPassResult.get(0).get("m_userpass");
         meeting.getMeetingCreators(creatorResult, eventScheduleId);
         eventCreator = creatorResult.get(0).get("bu_id");
         meetingID = "bbbmanEvent-meeting-" + eventCreator + "-" + eventScheduleId + "-" + eventId;
    
    }else if (eventType !=null && eventType.equals("Lecture")){
        lecture.isLecture(isEvent,eventScheduleId, eventId);
        if(!isEvent.get_value()){
            response.sendRedirect("index.jsp?message=Invalid lecture schedule or lecture information!");
            return;
        }
        lecture.getLectureModPass(modPassResult, eventScheduleId, eventId);
        lecture.getLectureUserPass(viewerPassResult, eventScheduleId, eventId);
        lecture.getLectureScheduleInfo(eventTitleResult, eventScheduleId);
        c_id = eventTitleResult.get(0).get("c_id");
        sc_id = eventTitleResult.get(0).get("sc_id");
        sc_semesterid = eventTitleResult.get(0).get("sc_semesterid");
        lecture.getLectureSetting(isRecordedResult, c_id, sc_id, sc_semesterid);
        user.isTeaching(isCreator, eventScheduleId, userId);
        if(!isCreator.get_value()){
            response.sendRedirect("index.jsp?message=You are not the teacher or student of the lecture!");
            return;
        }
        if(isRecordedResult.get("isRecorded")==1){
            isRecorded = "true";
        }else{
            isRecorded = "false";
        }
        lecture.getLectureInfo(eventInfo, eventScheduleId, eventId);
        eventStartTime = eventInfo.get(0).get("l_inidatetime");
        modPwd = modPassResult.get(0).get("l_modpass");
        viewerPwd = viewerPassResult.get(0).get("l_userpass");
        lecture.getLectureProfessor(creatorResult, c_id, sc_id, sc_semesterid);
        eventCreator = creatorResult.get(0).get("bu_id"); 
        meetingID = "bbbmanEvent-lecture-" + eventCreator + "-" + eventScheduleId + "-" + eventId;
    
    }else{
        response.sendRedirect("calendar.jsp?message=Invalid Event Information!");
        return;
    }
    
    //Encrypt meetingID and Viewer Password before send to guest
    final String strToEncrypt = meetingID + "-" + viewerPwd;
    final String securitykey = Config.getProperty("securitykey");
    EncryptDecrypt encrypt = new EncryptDecrypt();
    encrypt.setKey(securitykey);
    encrypt.encrypt(strToEncrypt.trim());
    session.setAttribute("meetingId", encrypt.getEncryptedString());
    eventStartTime = eventStartTime.substring(0,19);
    //session.setAttribute("meetingTime", eventStartTime);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SenecaBBB | Send Event URL</title>
    <link rel="shortcut icon" href="http://www.senecacollege.ca/favicon.ico">
    <link rel="stylesheet" type="text/css" media="all" href="css/fonts.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/style.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.core.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.theme.css">
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/jquery-1.9.1.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/modernizr.custom.79639.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/ui/jquery.ui.core.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/ui/jquery.ui.widget.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/ui/jquery.ui.position.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/ui/jquery.ui.stepper.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/jquery.validate.min.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/additional-methods.min.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/moment.js"></script>
</head>
<body>
    <div id="page">
        <jsp:include page="header.jsp"/>
        <jsp:include page="menu.jsp"/>
        <section>
            <header>
                <p>
                    <a href="calendar.jsp" tabindex="13">home</a>  » 
                    <a href="invite_guest.jsp" tabindex="14">Send Event URL</a>
                </p>
                <h1>Send Event URL</h1>
                <!-- WARNING MESSAGES -->
                <div class="warningMessage"><%= message %></div>
                <div class="successMessage"><%= successMessage %></div> 
            </header>
            <form name="guestaccuntinfo" id="guestaccuntinfo"  method="get" action="email.jsp" onsubmit="return toLocal()">
                <article>
                    <header>
                        <h2>Guests Information</h2>
                    </header>
                    <fieldset>
                        <div class="component">
                            <p>Please enter valid emails separated by commas! A BigBlueButton Web Conference Url and event scheduled date time would be sent to your guests!
                            </p>
                        </div>
                        <div class="component">
                            <input type="text" name="guestemail" id="guestemail" class="input guestemails" tabindex="17" title="Email">
                            <input type="text" name="meetingTime" id="meetingTime" hidden=hidden value="<%= eventStartTime %>">                       
                        </div>
                    </fieldset>
                </article>
                <article>
                    <fieldset>
                        <div class="buttons">
                            <button type="submit" name="submit" id="save" class="button" title="Click here to create account">Send URL</button>
                        </div>
                    </fieldset>
                </article>
            </form>

        </section>
        <script>
          //convert UTC to user local time before form submitted
            function toLocalTime(utcTime){
                var startMoment = moment.utc(utcTime).local().format();
                return startMoment;
            }   
            function toLocal(){
                var utcStartTime = $("#meetingTime").val();
                $("#meetingTime").val(toLocalTime(utcStartTime));
                return true;
            }
            
            // form validation, edit the regular expression pattern and error messages to meet your needs
            $(document).ready(function(){                
                //add method to validate multiple emails in textbox
                jQuery.validator.addMethod("multiple_emails", function (value, element) {                    
                    if (this.optional(element)) {
                        return true;
                    }
                    var emails = value.split(','),
                    valid = true;      
                    for (var i = 0, limit = emails.length; i < limit; i++) {
                        value = emails[i];
                        valid = valid && jQuery.validator.methods.email.call(this, value, element);
                    }
                    return valid;
                });
                $('#guestaccuntinfo').validate({
                    validateOnBlur : true,
                    rules: {
                        guestemail:{
                            required: true,
                            multiple_emails: true
                        }
                    },
                    messages: {
                        guestemail:{
                            required: "Please enter guest email address",
                            multiple_emails: "Invalid email format"
                        }
                    }
                });
            });
        </script>
        <jsp:include page="footer.jsp"/>
    </div>
</body>
</html>