<%@page import="db.DBConnection"%>
<%@page import="sql.User"%>
<%@page import="sql.Meeting"%>
<%@page import="sql.Lecture"%>
<%@page import="java.util.*"%>
<%@page import="helper.MyBoolean"%>
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
	if (userId.equals("")) {
		response.sendRedirect("index.jsp?error=Please log in");
		return;
	}
	if (dbaccess.getFlagStatus() == false) {
		response.sendRedirect("index.jsp?error=Database connection error");
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
	HashMap<String, Integer> userSettings = new HashMap<String, Integer>();
	HashMap<String, Integer> meetingSettings = new HashMap<String, Integer>();
	HashMap<String, Integer> roleMask = new HashMap<String, Integer>();
	userSettings = usersession.getUserSettingsMask();
	meetingSettings = usersession.getUserMeetingSettingsMask();
	roleMask = usersession.getRoleMask();
	int nickName = roleMask.get("nickname");
	
    String startMonthNumber=null;
    String endMonthNumber=null;
    endMonthNumber = getMonthNumber(request.getParameter("dropdownMonthEnds"));
    startMonthNumber = getMonthNumber(request.getParameter("dropdownMonthStarts"));        
    String title = request.getParameter("eventTitle");
    String inidatetime = request.getParameter("dropdownYearStarts").concat("-").concat(startMonthNumber).concat("-").concat(request.getParameter("dropdownDayStarts")).concat(" ").concat(request.getParameter("startTime")).concat(".0");
    String duration = request.getParameter("eventDuration");
    String description = request.getParameter("eventDescription");
    String eventType = request.getParameter("dropdownEventType");
    String c_id = request.getParameter("courseCode").split(" ")[0];
    String sc_id = request.getParameter("courseCode").split(" ")[1];
    String sc_semesterid =request.getParameter("courseCode").split(" ")[2];
    String spec = null;
	
    //daily weekly recurrence
	String recurrence = request.getParameter("dropdownRecurrence"); // daily,weekly,monthly
	String repeatEvery = request.getParameter("repeatsEvery"); // daily or weekly is chosen, repeat interval
	String endType = request.getParameter("dropdownEnds"); // on specified date or after number of occurrences
	String numberOfOccurrences = request.getParameter("occurrences"); // if after number of occurrences is chosen, times of repeating
	String repeatEndDate = request.getParameter("dropdownYearEnds").concat("-").concat(endMonthNumber).concat("-").concat(request.getParameter("dropdownDayEnds")); // if on specified date is chosen, specified end date
    
	// weekly recurrence, weekday selected	
	String weekString = request.getParameter("weekString");
	
	//monthly recurrence

	String dropdownOccursBy = request.getParameter("dropdownOccursBy");
	String dropdownDayoftheMonth = request.getParameter("dropdownDayoftheMonth"); // when occurs by "day of the month"
    String selectedDayofWeek =  request.getParameter("selectedDayofWeek");
	
	//get proper event "spec" pattern
	if (recurrence.equals("Only once")){
        System.out.println("Only once");
        spec="1";       
    }
    else if(recurrence.equals("Daily")){
        System.out.println("Daily");
        if(endType.equals("After # of occurrence(s)")){
            spec = "2;1;".concat(numberOfOccurrences).concat(";").concat(repeatEvery);
        }
        else{
            spec = "2;2;".concat(repeatEndDate).concat(repeatEvery);
        }
        System.out.println("Daily spec: ".concat(spec));
    }
    else if(recurrence.equals("Weekly")){
        System.out.println("Weekly");
         if(endType.equals("After # of occurrence(s)")){
            spec = "3;1;".concat(numberOfOccurrences).concat(";").concat(repeatEvery).concat(";").concat(weekString);
        }
         else{
            spec = "3;2;".concat(repeatEndDate).concat(";").concat(repeatEvery).concat(";").concat(weekString);
         }
         System.out.println("Week spec: ".concat(spec));
    }
    else{
        System.out.println("Monthly");
        if(dropdownOccursBy.equals("Day of the month")){                  
             spec = "4;1;".concat(numberOfOccurrences).concat(";").concat(repeatEvery).concat(";").concat(dropdownDayoftheMonth);                    
        }
        else{
            spec = "4;2;".concat(numberOfOccurrences).concat(";").concat(repeatEvery).concat(";").concat(selectedDayofWeek);    
        }
        System.out.println("Monthly spec: ".concat(spec));
    }	
	if(eventType.equals("Meeting")){   //create a meeting event
    	System.out.println("Create a meeting");
		
	    meeting.createMeetingSchedule(title, inidatetime, spec, duration, description, userId);
    }
    else{ //creating a lecture event
    	System.out.println("create a lecture");
        lecture.createLectureSchedule(c_id, sc_id, sc_semesterid, inidatetime, spec, duration, description);

    }
	
%>

<%  
    response.sendRedirect("calendar.jsp?message=event created"); 
%>
