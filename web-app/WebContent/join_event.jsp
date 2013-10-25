<%@page import="sql.*"%>
<%@page import="java.util.*"%>
<%@page import="helper.*"%>
<%@ include file="bbb_api.jsp"%> 
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<%

 Meeting meeting = new Meeting(dbaccess);
 Lecture lecture = new Lecture(dbaccess);
 String action=request.getParameter("joinEventButton");
 String eventType = session.getAttribute("eventType").toString();
 String eventId = session.getAttribute("eventId").toString();
 String eventScheduleId = session.getAttribute("eventScheduleId").toString();
 String username = session.getAttribute("username").toString();
 String modPwd =  session.getAttribute("modPwd").toString();
 String viewerPwd =  session.getAttribute("viewerPwd").toString();
 String logOutUrl="";
 String moderator="";
 String eventName="";
 if(eventType.equals("Meeting")){
	 eventName = eventId.concat("Meeting").concat(eventScheduleId);
	 moderator =  session.getAttribute("meetingCreator").toString();
	 logOutUrl = "http://localhost:1550/SenecaBBB/view_event.jsp?ms_id=" + eventScheduleId + "&m_id=" + eventId +"&eventName="+ eventName;	 
	 System.out.println(logOutUrl);
 }
 if(eventType.equals("Lecture")){
     eventName = eventId.concat("Lecture").concat(eventScheduleId);
     moderator =  session.getAttribute("lectureProfessor").toString();
     logOutUrl = "http://localhost:1550/SenecaBBB/view_event.jsp?ls_id=" + eventScheduleId + "&l_id=" + eventId +"&eventName="+ eventName;
     System.out.println(logOutUrl);
 }
 ArrayList<ArrayList<String>> modResult = new ArrayList<ArrayList<String>>();
 ArrayList<ArrayList<String>> viewerResult = new ArrayList<ArrayList<String>>();
 
 String welcome = "Welcome to SenecaBBB Demo!";
 System.out.println(eventName);
 System.out.println(eventType);
 System.out.println(username);
 System.out.println(modPwd);
 System.out.println(viewerPwd);

 String isMeetingRunning = isMeetingRunning(eventId).substring(0);
 System.out.println(isMeetingRunning);
 if(isMeetingRunning.equals("false") && action.equals("Create")){
	 String meeting_ID = createMeeting(eventName, welcome, modPwd, viewerPwd, 70001, logOutUrl);
	 String joinURL = getJoinMeetingURL(moderator, eventName, modPwd);
	 System.out.println(meeting_ID);
	 System.out.println(joinURL+ "line 32");
	 response.sendRedirect(joinURL);
 }else{
	 String joinURL = getJoinMeetingURL(username, eventName, viewerPwd);
	 System.out.println(joinURL+ "line 35");
	 response.sendRedirect(joinURL);
 }
 
// 
// String joinURL = getJoinMeetingURL("Gary", eventId, "5913");
// response.sendRedirect(joinURL);
 %>