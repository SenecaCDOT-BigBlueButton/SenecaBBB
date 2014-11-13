<%@page import="db.DBConnection"%>
<%@ page import="java.util.*, javax.mail.*, javax.mail.internet.*" %> 
<%@page import="sql.Admin"%>
<%@page import="sql.User"%>
<%@page import="config.Config"%>
<%@page import="helper.*"%>
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<%
//Start page validation
String userId = usersession.getUserId();
GetExceptionLog elog = new GetExceptionLog();
String message = request.getParameter("message");
String successMessage = request.getParameter("successMessage");
String guestemail = "";
guestemail = request.getParameter("guestemail");
String[] emails = guestemail.trim().split(",");
String meetingId = "";
if (message == null || message == "null") {
    message="";
}
if (successMessage == null) {
    successMessage="";
}
HashMap<String, Integer> roleMask = usersession.getRoleMask();
if (userId.equals("")) {
    session.setAttribute("redirecturl", request.getRequestURI()+(request.getQueryString()!=null?"?"+request.getQueryString():""));
    response.sendRedirect("index.jsp?message=Please log in");
    return;
}
if(!(usersession.isSuper()||usersession.getUserLevel().equals("employee")||roleMask.get("guestAccountCreation") == 0)) {
    elog.writeLog("[email:] " + " username: "+ userId + " tried to access this page, permission denied" +" /n");       
    response.sendRedirect("calendar.jsp?message=You do not have permission to access that page");
    return;
}
if (dbaccess.getFlagStatus() == false) {
    elog.writeLog("[email:] " + "database connection error /n");
    response.sendRedirect("index.jsp?message=Database connection error");
    return;
}//End page validation
String viewerJoinURL = "";
String subject = "";
String to = "";
String key = "";
String bu_id = "";
String messageText = "";
String link = "";
String eventTime = request.getParameter("meetingTime");
Email sendToGuest = new Email();
if(!guestemail.equals("")){
    meetingId = session.getAttribute("meetingId").toString();
    viewerJoinURL = Config.getProperty("domain")+"/guestLogin.jsp?meetingId=" + meetingId;
    subject = "BigBlueButton Meeting Invitation"; 
    messageText = "<p>Dear Guest User:</p><p>You are invited to join an event in BigBlueButton web conferencing system." 
                   + "<p>Please visit the following link to join the conference:</p>"+ viewerJoinURL 
                   + "<p>Event start date and time (ISO 8601): " + eventTime;
    for(int i = 0; i< emails.length;i++){
        if(!sendToGuest.send(emails[i], subject, messageText)){
            message=message + "Fail to send email to "+ emails[i] + ";";
        }else{
            successMessage=successMessage + "Email sent to "+ emails[i] + ";";
        }
    }
    if(message.equals("")){
        response.sendRedirect("calendar.jsp?successMessage=" + successMessage);
    }else{
        response.sendRedirect("calendar.jsp?message=" + message);
    }
}else{
   to = session.getAttribute("email").toString();
   subject = "SenecaBBB Guest Account Activation"; 
   key = session.getAttribute("key").toString();
   bu_id = session.getAttribute("bu_id").toString();  
   link = Config.getProperty("domain")+"SenecaBBB/guest_setup.jsp?&key=" + key + "&user=" + bu_id;
   messageText = "<p>Dear Guest User:</p><p>You are invited to join an event in our web conferencing system. A guest account is created for you.</p><p> Your user name is: <strong>" 
                   + bu_id + "</strong></p><p> Please visit the following link to activate your account:</p>"+ link; 
   if(sendToGuest.send(to, subject, messageText)){
       successMessage="Email sent";
       response.sendRedirect("calendar.jsp?successMessage="+ successMessage);
   }else{
       message="Fail to send email to " + to;
       response.sendRedirect("calendar.jsp?message="+ message);
   }          
}

%>