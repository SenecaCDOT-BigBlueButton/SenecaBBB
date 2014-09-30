<%@page import="sql.*"%>
<%@page import="helper.*"%>
<%@page import="config.*"%>
<%@page import="ldap.LDAPAuthenticate" %>
<%@page import="db.DBAccess" %>
<%@page import="java.util.HashMap" %>
<%@page import="java.util.ArrayList" %>

<%!
public boolean sendNotification(DBAccess dbaccess, LDAPAuthenticate ldap, String bu_id,String event, String ms_id, String m_id,String sender ) {
    if (dbaccess.getFlagStatus() == false) {
        return false;
    } else {
        if (bu_id == "") {
            return false;
        }
        else {
            ArrayList<HashMap<String, String>> timeResult = new ArrayList<HashMap<String, String>>(); 
            ArrayList<HashMap<String, String>> searchEmailResult = new ArrayList<HashMap<String, String>>();
            ArrayList<HashMap<String, String>> scheduleResult = new ArrayList<HashMap<String, String>>();
            MyBoolean mybool = new MyBoolean();
            MyBoolean isNonLdap = new MyBoolean();
            User2 user = new User2(dbaccess);
            
            Email email = new Email();
            String attendeeEmail;
            String domain = Config.getProperty("domain");
            String emailSubject ="BigBlueButton Event Notification";
            String eventStartTime=null;  
            String eventTitle = null;
            String emailText = null;
            user.isnonLDAP(isNonLdap, bu_id);
            String accountText = isNonLdap.get_value()?"Guest id: "+bu_id : "Seneca College user account";
            if(event != null && event.equals("meeting")){
                 Meeting2 meeting = new Meeting2(dbaccess);
                 meeting.getMeetingScheduleInfo(scheduleResult, ms_id);
                 eventTitle = scheduleResult.get(0).get("ms_title");
                 if(m_id !=""){
                     meeting.getMeetingInfo(timeResult, ms_id, m_id);
                     eventStartTime = timeResult.get(0).get("m_inidatetime");
                 }
                 else{
                     eventStartTime = scheduleResult.get(0).get("ms_inidatetime");
                 }
                 
                 emailText = "<p>Hello:</p>"
                                 + "<p>You are invited by <strong>" + sender + "</strong> to join a meeting in Seneca BigBlueButton web conferencing system.</p>"                                    
                                 + "<p> Please use your "+  accountText + " to login and to join the meeting at: " + domain + "</p>"
                                 + "<p> Meeting Title: <strong>"+ eventTitle + " </strong></p>"
                                 + "<p> Meeting Initial Date and Time: <strong>"+ eventStartTime + " </strong></p>"
                                 + "<p>This is an automated message, please don't reply.</p>"
                                 +"<p><p></p><p></p>Thank you,<p></p>"; 
            }else if(event != null && event.equals("lecture")){
                Lecture2 lecture = new Lecture2(dbaccess);
                lecture.getLectureScheduleInfo(scheduleResult, ms_id);
                if(m_id !=""){
                    lecture.getLectureInfo(timeResult, ms_id, m_id);
                    eventStartTime = timeResult.get(0).get("l_inidatetime");
                }
                else{
                    eventStartTime = scheduleResult.get(0).get("ls_inidatetime");
                }
                 emailText = "<p>Hello:</p>"
                        + "<p>You are added to a class section by professor <strong>" + sender + "</strong> in Seneca BigBlueButton web conferencing system.</p>"                                    
                        + "<p> Please use your "+  accountText + " to login and to join the meeting at: " + domain + "</p>"
                        + "<p> Course: <strong>"+ scheduleResult.get(0).get("c_id") + " </strong></p>"
                        + "<p> Section: <strong>"+ scheduleResult.get(0).get("sc_id") + " </strong></p>"
                        + "<p> Semester: <strong>"+ scheduleResult.get(0).get("sc_semesterid") + " </strong></p>"
                        + "<p> Class Initial Date and Time: <strong>"+ eventStartTime + " </strong></p>"
                        + "<p>This is an automated message, please don't reply.</p>"
                        +"<p><p></p><p></p>Thank you,<p></p>"; 
            }

            if(isNonLdap.get_value()){
                user.getNonLdapUserEmail(searchEmailResult,bu_id);
                attendeeEmail = searchEmailResult.get(0).get("nu_email");
            }else if( bu_id.indexOf('.')>0){
                attendeeEmail = bu_id.concat("@senecacollege.ca");
            }else{
                attendeeEmail = bu_id.concat("@myseneca.ca");
            }
            email.send(attendeeEmail, emailSubject, emailText);
            return mybool.get_value();
        }
    }
}
%>