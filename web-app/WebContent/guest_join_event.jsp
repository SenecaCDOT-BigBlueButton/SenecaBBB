<%@page import="sql.*"%>
<%@page import="java.util.*"%>
<%@page import="helper.*"%>
<%@page import="config.*"%>
<%@page import="java.util.Timer"%>
<%@page import="java.util.TimerTask"%>
<%@page import="hash.EncryptDecrypt"%>
<%@page import="config.*"%>
<%@ include file="bbb_api.jsp"%> 
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<%
String username = request.getParameter("SenecaGuestLogin");
String encryptedId = session.getAttribute("guestmeetingId").toString();
EncryptDecrypt.setKey(Config.getProperty("securitykey"));
EncryptDecrypt.decrypt(encryptedId.trim());
String decryptedMeetingInfo = EncryptDecrypt.getDecryptedString();
String meetingId = decryptedMeetingInfo.substring(0, decryptedMeetingInfo.length()-5);
String viewerPwd = decryptedMeetingInfo.substring(decryptedMeetingInfo.length()-4, decryptedMeetingInfo.length());
String isMeetingRunning = isMeetingRunning(meetingId);

if(isMeetingRunning.equals("false")){
    String err = "Event not started yet or it has already ended!";
    response.sendRedirect("guestLogin.jsp?meetingId="+ encryptedId +"&message=" + err);
    return;
}
else{
    String joinURL = getJoinURLViewer(username, meetingId, viewerPwd);
    response.sendRedirect(joinURL);
    return;
}
%>