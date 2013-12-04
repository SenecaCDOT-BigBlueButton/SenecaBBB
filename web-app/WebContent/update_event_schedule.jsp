<%@page import="db.DBConnection"%>
<%@page import="sql.User"%>
<%@page import="sql.Meeting"%>
<%@page import="sql.Lecture"%>
<%@page import="java.util.*"%>
<%@page import="helper.*"%>
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />

<%! 
//convert month string to month number
public static String getMonthNumber(String month) {
    String monthNumber = null;
    if(month.toLowerCase().compareTo("january")==0)      
        monthNumber = "01";
    if(month.toLowerCase().compareTo("february")==0)      
        monthNumber = "02";
    if(month.toLowerCase().compareTo("march")==0)      
        monthNumber = "03";
    if(month.toLowerCase().compareTo("april")==0)      
        monthNumber = "04";
    if(month.toLowerCase().compareTo("may")==0)      
        monthNumber = "05";
    if(month.toLowerCase().compareTo("june")==0)      
        monthNumber = "06";
    if(month.toLowerCase().compareTo("july")==0)      
        monthNumber = "07";
    if(month.toLowerCase().compareTo("august")==0)      
        monthNumber = "08";
    if(month.toLowerCase().compareTo("september")==0)      
        monthNumber = "09";
    if(month.toLowerCase().compareTo("october")==0)      
        monthNumber = "10";
    if(month.toLowerCase().compareTo("november")==0)      
        monthNumber = "11";
    if(month.toLowerCase().compareTo("december")==0)      
        monthNumber = "12";
    return monthNumber;
}

%>

<% 
    //Start page validation
    String userId = usersession.getUserId();
    GetExceptionLog elog = new GetExceptionLog();
    Boolean isProfessor = false;
    Boolean isSuper = false;
    isProfessor=usersession.isProfessor();
    isSuper =usersession.isSuper();
    if (userId.equals("")) {
    	elog.writeLog("[update_event_schedule:] " + "unauthenticated user tried to access this page /n");
        response.sendRedirect("index.jsp?message=Please log in");
        return;
    }
    if (dbaccess.getFlagStatus() == false) {
    	elog.writeLog("[update_event_schedule:] " + "database connection error /n");
        response.sendRedirect("index.jsp?message=Database connection error");
        return;
    } //End page validation
    
    String message = request.getParameter("message");
    String successMessage = request.getParameter("successMessage");
    if (message == null || message == "null") {
        message="";
    }
    if (successMessage == null) {
        successMessage="";
    }   
    User user = new User(dbaccess);
    Meeting meeting = new Meeting(dbaccess);
    Lecture lecture = new Lecture(dbaccess);
    MyBoolean prof = new MyBoolean();
    HashMap<String, Integer> userSettings = new HashMap<String, Integer>();
    HashMap<String, Integer> meetingSettings = new HashMap<String, Integer>();
    HashMap<String, Integer> roleMask = new HashMap<String, Integer>();
    userSettings = usersession.getUserSettingsMask();
    meetingSettings = usersession.getUserMeetingSettingsMask();
    roleMask = usersession.getRoleMask();
    String startMonthNumber = request.getParameter("dropdownMonthStarts");
    String endMonthNumber = request.getParameter("dropdownMonthEnds");
    if(startMonthNumber!=null){
    	startMonthNumber=getMonthNumber(startMonthNumber);
    }
    if(endMonthNumber!=null){
    	endMonthNumber=getMonthNumber(endMonthNumber);
    }
    String eventId = request.getParameter("eventScheduleId");
    String e_Id = request.getParameter("eventId");
    String eventDescription = request.getParameter("eventDescription");
    String title = request.getParameter("eventTitle");
    String eventType = request.getParameter("eventType");  
    String duration = request.getParameter("eventDuration");
    String inidatetime = request.getParameter("dropdownYearStarts").concat("-").concat(startMonthNumber).concat("-").concat(request.getParameter("dropdownDayStarts")).concat(" ").concat(request.getParameter("startTime")).concat(".0");
    if (!(Validation.checkStartDateTime(inidatetime))) {
        if (eventType.equals("Meeting")) {
            response.sendRedirect("edit_event_schedule.jsp?ms_id=" + eventId + "&m_id=" + e_Id + "&message=" + Validation.getErrMsg());
            return;
        } else {
            response.sendRedirect("edit_event_schedule.jsp?ls_id=" + eventId + "&l_id=" + e_Id + "&message=" + Validation.getErrMsg());
            return;
        }
    }
    String c_id=null;
    String sc_id=null;
    String sc_semesterid=null;
    if(isProfessor && eventType.equals("Lecture")){
         c_id = request.getParameter("courseInfo").split(" ")[0];
         sc_id = request.getParameter("courseInfo").split(" ")[1];
         sc_semesterid =request.getParameter("courseInfo").split(" ")[2];
    }
    if(isSuper && eventType.equals("Lecture")){
         c_id = request.getParameter("courseInfo").split(" ")[1];
         sc_id = request.getParameter("courseInfo").split(" ")[2];
         sc_semesterid =request.getParameter("courseInfo").split(" ")[3];
    }
    
    String spec = null;
    
    //daily weekly recurrence
    String recurrence = request.getParameter("Recurrence"); // daily,weekly,monthly
    String repeatEvery = request.getParameter("repeatsInterval"); // daily or weekly is chosen, repeat interval
    String endType = request.getParameter("ends"); // on specified date or after number of occurrences
    String numberOfOccurrences = request.getParameter("numberOfOccurrences"); // if after number of occurrences is chosen, times of repeating
    String repeatEndDate = request.getParameter("dropdownYearEnds").concat("-").concat(endMonthNumber).concat("-").concat(request.getParameter("dropdownDayEnds")); // if on specified date is chosen, specified end date
    
    // weekly recurrence, weekday selected  
    String weekString = request.getParameter("weekString");
    
    //monthly recurrence

    String occursBy = request.getParameter("occursBy");
    String dayoftheMonth = request.getParameter("dayoftheMonth"); // when occurs by "day of the month"
    String selectedDayofWeek =  request.getParameter("selectedDayofWeek"); // sunday is 0, saturday is 6
    
    //get proper event "spec" pattern
    if (recurrence.equals("Only once")){
        spec="1";       
    }
    else if(recurrence.equals("Daily")){
        if(endType.equals("After # of occurrence(s)")){
            spec = "2;1;".concat(numberOfOccurrences).concat(";").concat(repeatEvery);
        }
        else{
            spec = "2;2;".concat(repeatEndDate).concat(";").concat(repeatEvery);
        }
    }
    else if(recurrence.equals("Weekly")){
         if(endType.equals("After # of occurrence(s)")){
            spec = "3;1;".concat(numberOfOccurrences).concat(";").concat(repeatEvery).concat(";").concat(weekString);
        }else if(endType.equals("After # of week(s)")){
            spec = "3;2;".concat(numberOfOccurrences).concat(";").concat(repeatEvery).concat(";").concat(weekString);
        }
         else{
            spec = "3;3;".concat(repeatEndDate).concat(";").concat(repeatEvery).concat(";").concat(weekString);
         }
    }
    else{
        if(occursBy.equals("Day of the month")){                  
             spec = "4;1;".concat(numberOfOccurrences).concat(";").concat(repeatEvery).concat(";").concat(dayoftheMonth);                    
        }
        else{
            spec = "4;2;".concat(numberOfOccurrences).concat(";").concat(repeatEvery).concat(";").concat(selectedDayofWeek);    
        }
    }   
    if(eventType.equals("Meeting")){   //update a meeting schedule      
       if( meeting.updateMeetingSchedule(eventId, inidatetime, spec, eventDescription)){
           if(meeting.updateMeetingDuration(3, eventId, "1", duration)){
               response.sendRedirect("calendar.jsp?successMessage=meeting updated successfully"); 
               return;
           }else{
               response.sendRedirect("calendar.jsp?message=update fail"); 
               return;
           }
       }
       
    }
    else{ //update a lecture schedule
        if(lecture.updateLectureSchedule(eventId, inidatetime, spec, eventDescription)){
            if(lecture.updateLectureDuration(3, eventId, "1", duration)){
                response.sendRedirect("calendar.jsp?successMessage=lecture updated successfully"); 
                return;
            }else{
                response.sendRedirect("calendar.jsp?message=update fail");  
            } 
        }
    }
    
%>

