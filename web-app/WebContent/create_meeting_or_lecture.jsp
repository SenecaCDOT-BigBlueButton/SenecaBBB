<%@page import="db.DBConnection"%>
<%@page import="sql.User"%>
<%@page import="sql.Meeting"%>
<%@page import="sql.Lecture"%>
<%@page import="java.util.*"%>
<%@page import="helper.MyBoolean"%>
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<!doctype html>
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Seneca | Template</title>
<link rel="icon" href="http://www.cssreset.com/favicon.png">
<link rel="stylesheet" type="text/css" media="all" href="css/fonts.css">
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/style.css">
<script type="text/javascript" src="http://code.jquery.com/jquery-1.9.1.js"></script>
<script type="text/javascript" src="js/modernizr.custom.79639.js"></script>
<script type="text/javascript" src="js/componentController.js"></script>
<%
    //Start page validation
    String userId = usersession.getUserId();
	User user = new User(dbaccess);
	Meeting meeting = new Meeting(dbaccess);
	Lecture lecture = new Lecture(dbaccess);
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
    
 
    MyBoolean prof = new MyBoolean();
    HashMap<String, Integer> userSettings = new HashMap<String, Integer>();
    HashMap<String, Integer> meetingSettings = new HashMap<String, Integer>();
    HashMap<String, Integer> roleMask = new HashMap<String, Integer>();
    userSettings = usersession.getUserSettingsMask();
    meetingSettings = usersession.getUserMeetingSettingsMask();
    roleMask = usersession.getRoleMask();
    int nickName = roleMask.get("nickname");
    String ms_title = request.getParameter("eventTitle");
    String ms_inidatetime =  request.getParameter("startDate");
    String ms_duration = request.getParameter("duration");
    String m_description = request.getParameter("eventDescription");
    System.out.println("===============");
    System.out.println(userId);
    System.out.println(ms_title);
    System.out.println(ms_inidatetime);
    System.out.println(ms_duration);
    System.out.println(m_description);
    System.out.println("===============");
    
    //daily weekly recurrence
    String recurrence = request.getParameter("dropdownRecurrence"); // daily,weekly,monthly
    String repeatEvery = request.getParameter("repeatsEvery"); // daily or weekly is chosen, repeat interval
    String endType = request.getParameter("dropdownEnds"); // on specified date or after number of occurrences
    String numberOfOccurrences = request.getParameter("occurrences"); // if after number of occurrences is chosen, times of repeating
    String repeatEndDate = request.getParameter("endDate"); // if on specified date is chosen, specified end date
    
    // weekly recurrence, weekday selected  
    String weekString = request.getParameter("weekString");
    
    //monthly recurrence
    String spec = "1";
   
    String dropdownOccursBy = request.getParameter("dropdownOccursBy");
    String dropdownDayoftheMonth = request.getParameter("dropdownDayoftheMonth"); // when occurs by "day of the month"
    String selectedDayofWeek =  request.getParameter("selectedDayofWeek");
    String inidatetime=request.getParameter("startDate");
    meeting.createMeetingSchedule(ms_title, ms_inidatetime, spec, ms_duration, m_description, userId);
    
%>
</head>
<body>
<div id="page">
    <jsp:include page="header.jsp"/>
    <jsp:include page="menu.jsp"/>
    <section>
        <header> 
            <!-- BREADCRUMB -->
            <p><a href="calendar.jsp" tabindex="13">home</a> » <a href="#" tabindex="14">page name</a></p>
            <!-- PAGE NAME -->
            <h1>Page Name</h1>
            <!-- WARNING MESSAGES -->
            <div class="warningMessage"><%=message %></div>
        </header>
        <form>
            <article>
                <header>
                    <h2>Section Title</h2>
                    <img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content"/>
                </header>
                <div class="content">
                    <fieldset>
                    </fieldset>
                </div>
            </article>
        </form>
    </section>
    <jsp:include page="footer.jsp"/>
</div>
</body>
</html>