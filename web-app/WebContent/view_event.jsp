<%@page import="db.DBConnection"%>
<%@page import="sql.User"%>
<%@page import="sql.Meeting"%>
<%@page import="sql.Lecture"%>
<%@page import="java.util.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="helper.MyBoolean"%>
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<!doctype html>
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Seneca | View Event</title>
<link rel="icon" href="http://www.cssreset.com/favicon.png">
<link rel="stylesheet" type="text/css" media="all" href="css/fonts.css">
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/style.css">
<script type="text/javascript" src="http://code.jquery.com/jquery-1.9.1.js"></script>
<script type="text/javascript" src="js/modernizr.custom.79639.js"></script>
<script type="text/javascript" src="js/componentController.js"></script>
<%
    //Start page val_idation
    String userId = usersession.getUserId();
    if (userId.equals("")) {
        response.sendRedirect("index.jsp?error=Please log in");
        return;
    }
    if (dbaccess.getFlagStatus() == false) {
        response.sendRedirect("index.jsp?error=Database connection error");
        return;
    } //End page val_idation
    
    String message = request.getParameter("message");
    if (message == null || message == "null") {
        message="";
    }

    // When user click on specific event in calender.jsp page, m_id,ms_id, or l_id, ls_id will be passed through url
    // in view_event.jsp, I simply get the parameters in order to access database
    int m_id=0;
    int ms_id=0;
    int l_id=0;
    int ls_id=0;
    if(request.getParameter("m_id")!=null && request.getParameter("ms_id")!=null){
	     m_id = Integer.parseInt(request.getParameter("m_id"));
	     ms_id = Integer.parseInt(request.getParameter("ms_id"));
	}
    if(request.getParameter("l_id")!=null && request.getParameter("ls_id")!=null){
         l_id = Integer.parseInt(request.getParameter("l_id"));
         ls_id = Integer.parseInt(request.getParameter("ls_id"));
    }

    Boolean isMeeting=false;
    if (m_id != 0 && ms_id != 0){
    	isMeeting = true;
    }
    
    //  For testing purpose, will modify after get m_id, ms_id,l_id,and ls_id form calendar.jsp
    //  if (isMeeting){
    String meetingDescription="";
    String meetingPresentation="";
    String meetingDateTime="";
    String meetingDuration="";
    String meetingCreators="";
    String meetingSchedule="";
    String lectureDescription="";
    String lecturePresentation="";
    String lectureDateTime="";
    String lectureDuration="";
    String lectureSchedule="";
    ArrayList<ArrayList<String>>  mAttendees= new ArrayList<ArrayList<String> >();
    ArrayList<ArrayList<String>>  mCreator= new ArrayList<ArrayList<String> >();
    ArrayList<ArrayList<String>>  mDescription= new ArrayList<ArrayList<String> >();
    ArrayList<ArrayList<String>>  mDuriation= new ArrayList<ArrayList<String> >();
    ArrayList<ArrayList<String>>  mInitialDateTime= new ArrayList<ArrayList<String> >();
    ArrayList<ArrayList<String>>  mPresentation= new ArrayList<ArrayList<String> >();
    ArrayList<ArrayList<String>>  mSchedule= new ArrayList<ArrayList<String> >();
    ArrayList<ArrayList<String>>  lAttendance= new ArrayList<ArrayList<String> >();
    ArrayList<ArrayList<String>>  lCreator= new ArrayList<ArrayList<String> >();
    ArrayList<ArrayList<String>>  lDescription= new ArrayList<ArrayList<String> >();
    ArrayList<ArrayList<String>>  lDuriation= new ArrayList<ArrayList<String> >();
    ArrayList<ArrayList<String>>  lInitialDateTime= new ArrayList<ArrayList<String> >();
    ArrayList<ArrayList<String>>  lPresentation= new ArrayList<ArrayList<String> >();
    ArrayList<ArrayList<String>>  lSchedule= new ArrayList<ArrayList<String> >();
    ArrayList<String> meetingAttendees = new ArrayList<String>();
    
    Date currentTime = new Date();
    SimpleDateFormat df=new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");     
    if (isMeeting){
	    Meeting meeting = new Meeting(dbaccess);   
	    meeting.getMeetingDescription(mDescription,ms_id,m_id);
	    meeting.getMeetingPresentation(mPresentation,ms_id,m_id);
	    meeting.getMeetingInitialDatetime(mInitialDateTime,ms_id,m_id);
	    meeting.getMeetingDuration(mDuriation,ms_id,m_id);
	    meeting.getMeetingAttendee(mAttendees,ms_id);
	    meeting.getMeetingCreators(mCreator,ms_id);
	    meeting.getMeetingScheduleInfo(mSchedule,ms_id);	    
	    meetingDescription = mDescription.get(0).get(0);
	    meetingPresentation = mPresentation.get(0).get(0);
	    meetingDateTime = mInitialDateTime.get(0).get(0);
	    meetingDuration = mDuriation.get(0).get(0);
	    meetingCreators = mCreator.get(0).get(0);
	    meetingAttendees = mAttendees.get(0); 
	  //Compare event time with current time
	    if (currentTime.after(df.parse(meetingDateTime))){
	        System.out.println("Display meeting attendance and show a link to video record file");//ToDo
	    }
	    else{
	    	System.out.println("display potential meeting attendees and guests");
	    }
    }
	else {   
        Lecture lecture = new Lecture(dbaccess);
	    lecture.getLectureDescription(lDescription,ls_id,l_id);
	    lecture.getLecturePresentation(lPresentation,ls_id,l_id);
	    lecture.getLectureScheduleInfo(lSchedule,ls_id);
	    lecture.getLectureInitialDatetime(lInitialDateTime,ls_id,l_id);
	    lecture.getLectureDuration(lDuriation, ls_id,l_id);
	    lecture.getLectureAttendance(lAttendance, ls_id,l_id);       
	    lectureDescription = lDescription.get(0).get(0);
	    lecturePresentation = lPresentation.get(0).get(0);
	    lectureDateTime = lInitialDateTime.get(0).get(0);
	    lectureDuration = lDuriation.get(0).get(0);
	  //Compare event time with current time
	    if (currentTime.after(df.parse(lectureDateTime))){
	        System.out.println("Display lecture attendance and show a link to video record file");//ToDo
        }
       else{
            System.out.println("display lecture potential students and guests");
        }
	}
           

%>

</head>
<body>
<div id="page">
    <jsp:include page="header.jsp"/>
    <jsp:include page="menu.jsp"/>
    <section>
        <header> 
            <!-- BREADCRUMB -->
            <p><a href="calendar.jsp" tabindex="13">home</a> » <a href="#" tabindex="14">view event</a></p>
            <!-- PAGE NAME -->
            <h1>View Event</h1>
            <!-- WARNING MESSAGES -->
            <div class="warningMessage"><%=message %></div>
        </header>
      
            <article>
                <header>
                <h2>Brief Information</h2>                               
                </header>
                <div>    
                  <p>Event Type:<%= isMeeting? "Meeting" : "Lecture" %></p>
                  <p>Event Title: <%= isMeeting? meetingDescription : lectureDescription %></p> 
                  <p>Event Presentation:<%= isMeeting? meetingPresentation : lecturePresentation %></p>
                  <p>Event Date:<%= isMeeting? meetingDateTime : lectureDateTime %></p>
                </div>
            </article>
        <form>
            <article>
                <header>
                    <h2>Schedule Information</h2>
                    <img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content"/>
                </header>
                <div class="content">
                    <fieldset>                  
                       <table border="1">
                           <tr>                      
                               <td><%= isMeeting? "Title" : "Course" %></td>
                               <td><%= isMeeting? "Date&Time" : "Section" %></td>
                               <td><%= isMeeting? "Spec" : "Semestor" %></td>
                               <td><%= isMeeting? "Duration" : "Date&Time" %></td>
                               <td><%= isMeeting? "Creator" : "Spec" %></td>
                               <td><%= isMeeting? "Comment" : "Duration" %></td>
                           </tr>
                           <tr> 
                               <td><%= isMeeting? mSchedule.get(0).get(1) : lSchedule.get(0).get(1) %></td>
                               <td><%= isMeeting? mSchedule.get(0).get(2) : lSchedule.get(0).get(2) %></td>
                               <td><%= isMeeting? mSchedule.get(0).get(3) : lSchedule.get(0).get(3) %></td>
                               <td><%= isMeeting? mSchedule.get(0).get(4) : lSchedule.get(0).get(4) %></td>
                               <td><%= isMeeting? mSchedule.get(0).get(5) : lSchedule.get(0).get(5) %></td>
                               <td><%= isMeeting? "" : lSchedule.get(0).get(6) %></td>
                          </tr>
                       </table>
                    </fieldset>
                </div>
            </article>
        </form>
        <form>
            <article>
                <header>
                    <h2>Event Attendees</h2>
                    <img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content"/>
                </header>
                <div class="content">
                    <fieldset>
                        <%  if (isMeeting) {
	                        	for (int i=0;i<meetingAttendees.size();i++){ %> 
	                        	  <p><%= meetingAttendees.get(i) %></p> 
	                        	<% } %>                  
                        <% } else{ 
                        	for (int i=0;i<lAttendance.size();i++){%> 
                        	      <p><%= lAttendance.get(i).get(0) %> </p>
                        	<% }} %> 
                        
                    </fieldset>                                                
                </div>
            </article>
        </form>
    </section>
    <jsp:include page="footer.jsp"/>
</div>
</body>
</html>