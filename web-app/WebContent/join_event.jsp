<%@page import="sql.*"%>
<%@page import="java.util.*"%>
<%@page import="helper.*"%>
<%@ include file="bbb_api.jsp"%> 
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<%
 String userId = usersession.getUserId();
 if (userId.equals("")) {
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
 ArrayList<ArrayList<String>> mResult = new ArrayList<ArrayList<String>>();
 HashMap<String, Integer> isRecordedResult = new HashMap<String, Integer>();
 String modPwd="";
 String viewerPwd="";
 String username="";
 String eventTitle="";
 String c_id,sc_id,sc_semesterid;
 String action=request.getParameter("joinEventButton");
 String eventType = request.getParameter("eventType");
 String eventId = request.getParameter("eventId");
 String eventScheduleId = request.getParameter("eventScheduleId");
 user.getNickName(nickNameResult, userId);
 username = nickNameResult.get(0).get(0);
 String isRecorded="false";
 if(eventType.equals("Meeting")){
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
     eventTitle="Meeting-".concat(eventId).concat("-").concat(eventScheduleId);
 }else if (eventType.equals("Lecture")){
     lecture.getLectureModPass(modPassResult, eventScheduleId, eventId);
     lecture.getLectureUserPass(viewerPassResult, eventScheduleId, eventId);
     lecture.getLectureScheduleInfo(eventTitleResult, eventScheduleId);
     c_id=eventTitleResult.get(0).get(1);
     sc_id=eventTitleResult.get(0).get(2);
     sc_semesterid=eventTitleResult.get(0).get(3);
     lecture.getLectureSetting(isRecordedResult, c_id, sc_id, sc_semesterid);
     if(isRecordedResult.get("isRecorded")==1){
         isRecorded="true";
     }else{
         isRecorded="false";
     }
     modPwd=modPassResult.get(0).get(0);
     viewerPwd=viewerPassResult.get(0).get(0);
     eventTitle="Lecture-".concat(eventId).concat("-").concat(eventScheduleId);
 }else{
	 response.sendRedirect("calendar.jsp?message=Create or Join event fail");
 }

 String logOutUrl="";
 if(eventType.equals("Meeting")){
     logOutUrl = "http://localhost:1550/SenecaBBB/view_event.jsp?ms_id=" + eventScheduleId + "&m_id=" + eventId +"&eventName="+ eventTitle;   
 }
 if(eventType.equals("Lecture")){
     logOutUrl = "http://localhost:1550/SenecaBBB/view_event.jsp?ls_id=" + eventScheduleId + "&l_id=" + eventId +"&eventName="+ eventTitle;
 }

 String welcome = "Welcome to Seneca BigBlueButton Web Conferencing System!";
 String joinURL;
 String isMeetingRunning = isMeetingRunning(eventTitle);
 if(isMeetingRunning.equals("false") && action.equals("create")){
     Map<String,String> metadata=new HashMap<String,String>();    
     metadata.put("title", eventTitle);     
     metadata.put("type", eventType);
     metadata.put("logoutURL", logOutUrl);
     joinURL = getJoinURL(username,eventTitle,isRecorded, welcome, modPwd, viewerPwd, metadata, null);
     response.sendRedirect(joinURL);
 }else{
	 if(action.equals("create")){
		 joinURL = getJoinMeetingURL(username, eventTitle, modPwd);
		 response.sendRedirect(joinURL);
	 }else if(action.equals("join")){
		 if(isMeetingRunning.equals("false")){
			 String err = "event not start yet";
			 response.sendRedirect(logOutUrl + "&message=" + err);
		 }else{
		     joinURL = getJoinURLViewer(username, eventTitle, viewerPwd);
		     response.sendRedirect(joinURL);
		 }
	 }else{
		 response.sendRedirect("calendar.jsp?message=fail to join event!!!!");
	 }
 }
 %>