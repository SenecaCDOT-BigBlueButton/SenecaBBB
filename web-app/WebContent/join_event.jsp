<%@page import="sql.*"%>
<%@page import="java.util.*"%>
<%@page import="helper.*"%>
<%@page import="config.*"%>
<%@page import="java.util.Timer"%>
<%@page import="java.util.TimerTask"%>
<%@ include file="bbb_api.jsp"%> 
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<%
String userId = usersession.getUserId();
GetExceptionLog elog = new GetExceptionLog();
if (userId.equals("")) {
    elog.writeLog("[join_event:] " + "unauthenticated user tried to access this page /n");
    response.sendRedirect("index.jsp?message=Please log in");
    return;
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
String modPwd="";
String viewerPwd="";
String username="";
String meetingID="";
String eventCreator="";
String c_id,sc_id,sc_semesterid;
String action=request.getParameter("joinEventButton");
String eventType = request.getParameter("eventType");
String eventId = request.getParameter("eventId");
String eventScheduleId = request.getParameter("eventScheduleId");
String terminateEvent = request.getParameter("endMeeting");
user.getNickName(nickNameResult, userId);
username = nickNameResult.get(0).get(0);
String isRecorded="false";
MyBoolean isAttendee = new MyBoolean();
MyBoolean isCreator = new MyBoolean();
MyBoolean isGuest = new MyBoolean();
MyBoolean isEvent = new MyBoolean();
MyBoolean isGuestTeaching = new MyBoolean();
if(eventType !=null && eventType.equals("Meeting")){
     meeting.isMeeting(isEvent, eventScheduleId, eventId);
     if(!isEvent.get_value()){
         response.sendRedirect("index.jsp?message=Invalid meeting schedule or meeting information!");
         return;
     }
     user.isMeetingAttendee(isAttendee, eventScheduleId, userId);
     user.isMeetingCreator(isCreator, eventScheduleId, userId);
     user.isMeetingGuest(isGuest, eventScheduleId, eventId, userId);
     if(!(isAttendee.get_value() ||isCreator.get_value()||isGuest.get_value())){
         response.sendRedirect("index.jsp?message=You are not the meeting creator or attendee!");
         return;
     }
     meeting.getMeetingModPass(modPassResult, eventScheduleId, eventId);
     meeting.getMeetingUserPass(viewerPassResult, eventScheduleId, eventId);
     meeting.getMeetingScheduleInfo(eventTitleResult, eventScheduleId);
     meeting.getMeetingSetting(isRecordedResult, eventScheduleId, eventId);
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
    user.isGuestTeaching(isGuestTeaching, eventScheduleId, eventId, userId);
    user.isLectureStudent(isAttendee, c_id, sc_id, sc_semesterid, userId);
    if(!(isAttendee.get_value() ||isCreator.get_value()||isGuestTeaching.get_value())){
        response.sendRedirect("index.jsp?message=You are not the teacher or student of the lecture!");
        return;
    }
    if(isRecordedResult.get("isRecorded")==1){
        isRecorded="true";
    }else{
        isRecorded="false";
    }
    modPwd=modPassResult.get(0).get(0);
    viewerPwd=viewerPassResult.get(0).get(0);
    lecture.getLectureProfessor(creatorResult, c_id, sc_id, sc_semesterid);
    eventCreator=creatorResult.get(0).get(0); 
    meetingID = "bbbmanEvent-lecture-" + eventCreator + "-" + eventScheduleId + "-" + eventId;

}else{
    response.sendRedirect("calendar.jsp?message=Start or join event fail");
    return;
 }

if(terminateEvent !=null){
    endMeeting(meetingID,modPwd);
    if(eventType.equals("Lecture"))
        response.sendRedirect("view_event.jsp?ls_id="+eventScheduleId+"&l_id="+ eventId +"&successMessage=Lecture Terminated!");
    else
        response.sendRedirect("view_event.jsp?ms_id="+eventScheduleId+"&m_id="+ eventId +"&successMessage=Meeting Terminated!");
    return;
}

String logOutUrl="leaveMeeting.jsp";

String welcome = "Welcome to Seneca BigBlueButton Web Conferencing System!";
String joinURL;
String isMeetingRunning = isMeetingRunning(meetingID);
Map<String,String> metadata=new HashMap<String,String>();

 //moderator creates the meeting if meeting is not running
if(isMeetingRunning.equals("false") && action.equals("create")){
    metadata.put("title", meetingID);
    metadata.put("type", eventType);
    metadata.put("logoutURL", Config.getProperty("domain")+logOutUrl);
    joinURL = getJoinURL(username,meetingID,isRecorded, welcome, modPwd, viewerPwd, metadata, null);
    response.sendRedirect(joinURL);
    return;
}
else{
    if(action.equals("joinAsMod")){
        joinURL = getJoinMeetingURL(username, meetingID, modPwd);
        response.sendRedirect(joinURL);
        return;
    }else if(action.equals("joinAsViewer")){
        if(isMeetingRunning.equals("false")){
            String err = "Event not started yet or it has already ended.";
            response.sendRedirect(logOutUrl + "&message=" + err);
            return;
        }else{
            joinURL = getJoinURLViewer(username, meetingID, viewerPwd);
            response.sendRedirect(joinURL);
        }
        }else{
            response.sendRedirect("calendar.jsp?message=Fail to join event!");
        }
}
%>