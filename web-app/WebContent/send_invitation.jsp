<%@page import="sql.*"%>
<%@page import="java.util.*"%>
<%@page import="helper.*"%>
<%@page import="config.*"%>
<%@page import="java.util.Timer"%>
<%@page import="java.util.TimerTask"%>
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
    session.setAttribute("redirecturl", request.getRequestURI()+(request.getQueryString()!=null?"?"+request.getQueryString():""));
    response.sendRedirect("index.jsp?message=Please log in");
    return;
}
if(!(usersession.isSuper()||usersession.getUserLevel().equals("employee")||roleMask.get("guestAccountCreation") == 0)) {
    elog.writeLog("[send_invitation:] " + " username: "+ userId + " tried to access this page, permission denied" +" /n");        
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
    message="";
}
if (successMessage == null) {
    successMessage="";
}

Meeting meeting = new Meeting(dbaccess);
Lecture lecture = new Lecture(dbaccess);
User user = new User(dbaccess);
ArrayList<ArrayList<String>> nickNameResult = new ArrayList<ArrayList<String>>();
ArrayList<ArrayList<String>> modPassResult = new ArrayList<ArrayList<String>>();
ArrayList<ArrayList<String>> viewerPassResult = new ArrayList<ArrayList<String>>();
ArrayList<ArrayList<String>> eventTitleResult = new ArrayList<ArrayList<String>>();
ArrayList<ArrayList<String>> creatorResult = new ArrayList<ArrayList<String>>();
ArrayList<ArrayList<String>> mResult = new ArrayList<ArrayList<String>>();
HashMap<String, Integer> isRecordedResult = new HashMap<String, Integer>();
ArrayList<ArrayList<String>> eventInfo = new ArrayList<ArrayList<String>>();
String modPwd="";
String viewerPwd="";
String username="";
String meetingID="";
String eventCreator="";
String c_id,sc_id,sc_semesterid;
String eventStartTime = "";
String eventType = request.getParameter("eventType");
String eventId = request.getParameter("eventId");
String eventScheduleId = request.getParameter("eventScheduleId");
user.getNickName(nickNameResult, userId);
username = nickNameResult.get(0).get(0);
String isRecorded="false";
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
     eventStartTime = eventInfo.get(0).get(2);
     if(isRecordedResult.get("isRecorded")==1){
         isRecorded="true";
     }else{
         isRecorded="false";
     }
     modPwd=modPassResult.get(0).get(0);
     viewerPwd=viewerPassResult.get(0).get(0);
     meeting.getMeetingCreators(creatorResult, eventScheduleId);
     eventCreator=creatorResult.get(0).get(0);
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
    c_id=eventTitleResult.get(0).get(1);
    sc_id=eventTitleResult.get(0).get(2);
    sc_semesterid=eventTitleResult.get(0).get(3);
    lecture.getLectureSetting(isRecordedResult, c_id, sc_id, sc_semesterid);
    user.isTeaching(isCreator, eventScheduleId, userId);
    if(!isCreator.get_value()){
        response.sendRedirect("index.jsp?message=You are not the teacher or student of the lecture!");
        return;
    }
    if(isRecordedResult.get("isRecorded")==1){
        isRecorded="true";
    }else{
        isRecorded="false";
    }
    lecture.getLectureInfo(eventInfo, eventScheduleId, eventId);
    eventStartTime = eventInfo.get(0).get(2);
    modPwd=modPassResult.get(0).get(0);
    viewerPwd=viewerPassResult.get(0).get(0);
    lecture.getLectureProfessor(creatorResult, c_id, sc_id, sc_semesterid);
    eventCreator=creatorResult.get(0).get(0); 
    meetingID = "bbbmanEvent-lecture-" + eventCreator + "-" + eventScheduleId + "-" + eventId;

}else{
    response.sendRedirect("calendar.jsp?message=Invalid Event Information!");
    return;
}
final String strToEncrypt = meetingID +"-"+ viewerPwd ;
final String strPssword = Config.getProperty("securitykey");
EncryptDecrypt.setKey(strPssword);
EncryptDecrypt.encrypt(strToEncrypt.trim());
final String strToDecrypt = EncryptDecrypt.getEncryptedString();
EncryptDecrypt.decrypt(strToDecrypt.trim());
session.setAttribute("meetingId", EncryptDecrypt.getEncryptedString());
session.setAttribute("meetingTime", eventStartTime);
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
    <script type="text/javascript" src="js/jquery-1.9.1.js"></script>
    <script type="text/javascript" src="js/modernizr.custom.79639.js"></script>
    <script type="text/javascript" src="js/ui/jquery.ui.core.js"></script>
    <script type="text/javascript" src="js/ui/jquery.ui.widget.js"></script>
    <script type="text/javascript" src="js/ui/jquery.ui.position.js"></script>
    <script type="text/javascript" src="js/ui/jquery.ui.stepper.js"></script>
    <script type="text/javascript" src="js/jquery.validate.min.js"></script>
    <script type="text/javascript" src="js/additional-methods.min.js"></script>
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
                <div class="successMessage"><%=successMessage %></div> 
            </header>
            <form name="guestaccuntinfo" id="guestaccuntinfo"  method="get" action="email.jsp">
                <article>
                    <header>
                        <h2>Guests Information</h2>
                    </header>
                    <fieldset>
                        <div class="component">
                            <p>Please enter valid emails separated by comma! A BigBlueButton conference Url would be sent to your guests!
                            </p>
                        </div>
                        <div class="component">
                            <label for="email" class="label">Guest emails:</label>
                            <input type="text" name="guestemail" id="guestemail" class="input guestemails" tabindex="17" title="Email">
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
           // form validation, edit the regular expression pattern and error messages to meet your needs
//            $(document).ready(function(){
//                 $('#guestaccuntinfo').validate({
//                     validateOnBlur : true,
//                     rules: {
//                         email:{
//                             required: true
//                         }
//                     },
//                     messages: {
//                         email:{
//                             required: "Please enter guest email address",
//                             email: "Please enter a valid email address"
//                         }
//                     }
//                 });
//             });
        </script>
        <jsp:include page="footer.jsp"/>
    </div>
</body>
</html>