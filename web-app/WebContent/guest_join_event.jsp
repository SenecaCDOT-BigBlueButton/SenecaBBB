<%@page import="config.*"%>
<%@page import="hash.EncryptDecrypt"%>
<%@ include file="bbb_api.jsp"%> 
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<%
    String username = request.getParameter("SenecaGuestLogin");
    String encryptedId = session.getAttribute("guestmeetingId").toString();
    EncryptDecrypt decrypt = new EncryptDecrypt();
    decrypt.setKey(Config.getProperty("securitykey"));
    decrypt.decrypt(encryptedId.trim());
    String decryptedMeetingInfo = decrypt.getDecryptedString();
    String meetingId = decryptedMeetingInfo.substring(0,decryptedMeetingInfo.length() - 5);
    String viewerPwd = decryptedMeetingInfo.substring(decryptedMeetingInfo.length() - 4,decryptedMeetingInfo.length());
    String isMeetingRunning = isMeetingRunning(meetingId);
    
    if (isMeetingRunning.equals("false")) {
        response.sendRedirect("guest_login.jsp?meetingId=" + encryptedId + "&message=Event not started yet or it has already ended!");
    } else {
        response.sendRedirect(getJoinURLViewer(username, meetingId,viewerPwd));
    }
%>