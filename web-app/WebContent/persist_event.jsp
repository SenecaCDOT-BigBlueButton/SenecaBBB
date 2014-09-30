<%@page import="db.DBConnection"%>
<%@page import="sql.User"%>
<%@page import="sql.Meeting"%>
<%@page import="sql.Lecture"%>
<%@page import="java.util.*"%>
<%@page import="helper.*"%>
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />

<% 
//Start page validation
String userId = usersession.getUserId();
GetExceptionLog elog = new GetExceptionLog();
Boolean isProfessor = false;
Boolean isSuper = false;
isProfessor=usersession.isProfessor();
isSuper =usersession.isSuper();
if (userId.equals("")) {
    session.setAttribute("redirecturl", request.getRequestURI()+(request.getQueryString()!=null?"?"+request.getQueryString():""));
    response.sendRedirect("index.jsp?message=Please log in");
    return;
}
if (dbaccess.getFlagStatus() == false) {
    elog.writeLog("[persist_event:] " + "database connection error /n");
    response.sendRedirect("index.jsp?message=Database connection error");
    return;
} //End page validation

String message = request.getParameter("message");
if (message == null || message == "null") {
    message="";
}

User user = new User(dbaccess);
Meeting meeting = new Meeting(dbaccess);
Lecture lecture = new Lecture(dbaccess);
MyBoolean prof = new MyBoolean();
ArrayList<ArrayList<String>> latestCreatedSchedule = new ArrayList<ArrayList<String>>();
ArrayList<ArrayList<String>> latestCreatedMeeting = new ArrayList<ArrayList<String>>();
HashMap<String, Integer> userSettings = new HashMap<String, Integer>();
HashMap<String, Integer> meetingSettings = new HashMap<String, Integer>();
HashMap<String, Integer> roleMask = new HashMap<String, Integer>();
userSettings = usersession.getUserSettingsMask();
meetingSettings = usersession.getUserMeetingSettingsMask();
roleMask = usersession.getRoleMask();

String fromquickmeeting = request.getParameter("fromquickmeeting");
String startMonthNumber="";
String endMonthNumber="";
String title = "";
String inidatetime ="";
String description ="";
String eventType ="";
String duration ="";
String c_id="";
String sc_id="";
String sc_semesterid="";
String repeatEndDate = "";
String recurrence ="";
String repeatEvery ="";
String endType="";
String numberOfOccurrences ="";
String weekString ="";
String dropdownOccursBy ="";
String dropdownDayoftheMonth="";
String selectedDayofWeek ="";
String spec = "";
title = request.getParameter("eventTitle");
duration = request.getParameter("eventDuration");

if(fromquickmeeting == null){
    endMonthNumber = getMonthNumber(request.getParameter("dropdownMonthEnds"));
    startMonthNumber = getMonthNumber(request.getParameter("dropdownMonthStarts"));  
    eventType = request.getParameter("dropdownEventType");
    description = request.getParameter("eventDescription");
    inidatetime = request.getParameter("dropdownYearStarts").concat("-").concat(startMonthNumber).concat("-").concat(request.getParameter("dropdownDayStarts")).concat(" ").concat(request.getParameter("startTime")).concat(".0");
    repeatEndDate=request.getParameter("dropdownYearEnds").concat("-").concat(endMonthNumber).concat("-").concat(request.getParameter("dropdownDayEnds")); // if on specified date is chosen, specified end date
    
    //daily weekly recurrence
    recurrence = request.getParameter("dropdownRecurrence"); // daily,weekly,monthly
    repeatEvery = request.getParameter("repeatsEvery"); // daily or weekly is chosen, repeat interval
    endType = request.getParameter("dropdownEnds"); // on specified date or after number of occurrences
    numberOfOccurrences = request.getParameter("occurrences"); // if after number of occurrences is chosen, times of repeating
    
    // weekly recurrence, weekday selected  
    weekString = request.getParameter("weekString");
    
    //monthly recurrence
    
    dropdownOccursBy = request.getParameter("dropdownOccursBy");
    dropdownDayoftheMonth = request.getParameter("dropdownDayoftheMonth"); // when occurs by "day of the month"
    selectedDayofWeek =  request.getParameter("selectedDayofWeek"); // sunday is 0, saturday is 6
    
    if(isProfessor && eventType.equals("Lecture")){
        c_id = request.getParameter("courseCode").split(" ")[0];
        sc_id = request.getParameter("courseCode").split(" ")[1];
        sc_semesterid =request.getParameter("courseCode").split(" ")[2];
    }
    if(isSuper && eventType.equals("Lecture")){
        c_id = request.getParameter("courseCode").split(" ")[1];
        sc_id = request.getParameter("courseCode").split(" ")[2];
        sc_semesterid =request.getParameter("courseCode").split(" ")[3];
    }

       
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
        if(dropdownOccursBy.equals("Day of the month")){                  
             spec = "4;1;".concat(numberOfOccurrences).concat(";").concat(repeatEvery).concat(";").concat(dropdownDayoftheMonth);                    
        }
        else{
            spec = "4;2;".concat(numberOfOccurrences).concat(";").concat(repeatEvery).concat(";").concat(selectedDayofWeek);    
        }
    } 
    
    //Validate inidatetime to ensure that it is later than current time
    if (!(Validation.checkStartDateTime(inidatetime))) {
        response.sendRedirect("create_event.jsp?message=" + Validation.getErrMsg());
        return;
    }
   
}else{
    Calendar localCalendar = Calendar.getInstance(TimeZone.getDefault());
    int currentYear = localCalendar.get(Calendar.YEAR);
    int currentDayOfMonth = localCalendar.get(Calendar.MONTH);
    int currentDay = localCalendar.get(Calendar.DATE);
    inidatetime = String.valueOf(currentYear).concat("-")+ String.valueOf(currentDayOfMonth + 1).concat("-")+ String.valueOf(currentDay).concat(" ").concat(request.getParameter("startTime")).concat(".0");
    eventType = "Meeting";
    description ="Quick Meeting";
    recurrence ="Only once"; 
    spec="1"; 
    //Validate inidatetime to ensure that it is later than current time
    if (!(Validation.checkStartDateTime(inidatetime))) {
        response.sendRedirect("quickMeeting.jsp?message=" + Validation.getErrMsg());
        return;
    }
}
      
if(eventType.equals("Meeting")){   //create a meeting event		
    if(meeting.createMeetingSchedule(title, inidatetime, spec, duration, description, userId)){
        if(fromquickmeeting !=null){
            meeting.getLatestCreatedSchduleForUser(latestCreatedSchedule, userId);
            meeting.getMeetingInfo(latestCreatedMeeting, latestCreatedSchedule.get(0).get(0));
            response.sendRedirect("add_attendee.jsp?successMessage= Quick Meeting created, please add attendees to your meeting&m_id="+latestCreatedMeeting.get(0).get(1) + "&ms_id=" + latestCreatedSchedule.get(0).get(0));
        }else{
            response.sendRedirect("calendar.jsp?successMessage=Meeting schedule created"); 
        }
        return;
    }else{
        response.sendRedirect("calendar.jsp?message=Fail to create meeting schedule");
        return;
    }
}else{ //creating a lecture event
    if(lecture.createLectureSchedule(c_id, sc_id, sc_semesterid, inidatetime, spec, duration, description)){
        response.sendRedirect("calendar.jsp?successMessage=Lecture schedule created"); 
        return;
    }else{
        response.sendRedirect("calendar.jsp?message=Fail to create lecture schedule");
    }
}
    
%>

<%! 
//convert month string to month number
public  String getMonthNumber(String month) {
    String monthNumber = "";
    if(month != null){
        if(month.equalsIgnoreCase("january")){
            monthNumber = "01";
        }else if(month.equalsIgnoreCase("february")){
            monthNumber = "02";
        }else if(month.equalsIgnoreCase("march")){
            monthNumber = "03";
        }else if(month.equalsIgnoreCase("april")){
            monthNumber = "04";
        }else if(month.equalsIgnoreCase("may")){
            monthNumber = "05";
        }else if(month.equalsIgnoreCase("june")){
            monthNumber = "06";
        }else if(month.equalsIgnoreCase("july")){
            monthNumber = "07";
        }else if(month.equalsIgnoreCase("august")){
            monthNumber = "08";
        }else if(month.equalsIgnoreCase("september")){
            monthNumber = "09";
        }else if(month.equalsIgnoreCase("october")){
            monthNumber = "10";
        }else if(month.equalsIgnoreCase("november")){
            monthNumber = "11";
        }else if(month.equalsIgnoreCase("december")){
            monthNumber = "12";
        }
    }
    return monthNumber;
}

%>
