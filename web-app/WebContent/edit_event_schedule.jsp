<%@page import="db.DBConnection"%>
<%@page import="sql.*"%>
<%@page import="helper.*"%>
<%@page import="java.util.*"%>
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<!doctype html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>Seneca | Edit Event Schedule</title>
	<link rel="icon" href="http://www.cssreset.com/favicon.png">
	<link rel="stylesheet" type="text/css" media="all" href="css/fonts.css">
	<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/style.css">
	<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.core.css">
	<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.theme.css">
	<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.datepicker.css">
	<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.timepicker.css">
	<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.selectmenu.css">
	<script type="text/javascript" src="http://code.jquery.com/jquery-1.9.1.js"></script>
	<script type="text/javascript" src="js/modernizr.custom.79639.js"></script>
	<script type="text/javascript" src="js/ui/jquery.ui.core.js"></script>
	<script type="text/javascript" src="js/ui/jquery.ui.widget.js"></script>
	<script type="text/javascript" src="js/ui/jquery.ui.position.js"></script>
	<script type="text/javascript" src="js/ui/jquery.ui.selectmenu.js"></script>
	<script type="text/javascript" src="js/ui/jquery.ui.datepicker.js"></script>
	<script type="text/javascript" src="js/ui/jquery.timepicker.js"></script>
	<script type="text/javascript" src="js/ui/jquery.ui.stepper.js"></script>
	<script type="text/javascript" src="js/componentController.js"></script>
	<script type="text/javascript" src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.11.1/jquery.validate.min.js"></script>
	<script type="text/javascript" src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.11.1/additional-methods.min.js"></script>

<%    
    String message = request.getParameter("message");
	String ms_id = request.getParameter("ms_id");
	String ls_id = request.getParameter("ls_id");
	String m_id = request.getParameter("m_id");
	String l_id = request.getParameter("l_id");
	ArrayList<ArrayList<String>> result = new ArrayList<ArrayList<String>>(); 
	ArrayList<ArrayList<String>> lectureProfessor = new ArrayList<ArrayList<String>>();
	Boolean isProfessor = false;
	Boolean isSuper = false;
    String userId = usersession.getUserId();
	isProfessor=usersession.isProfessor();
	isSuper =usersession.isSuper();
    Section section = new Section(dbaccess);
    Meeting meeting = new Meeting(dbaccess);
    Lecture lecture = new Lecture(dbaccess);  
	User user = new User(dbaccess);
	MyBoolean myBool = new MyBoolean(); 
	Boolean isMeeting = false;
	Boolean isLecture = false;
	String courseInfo = "";
	String startDate ="";
	String startTime ="";
	String duration = "";
	String recurrence = "";
	String repeatEvery = "";
	String endsYear ="";
	String endsMonth ="";
	String endsDay ="";
	String occurences ="";
	String endDate ="";
	String weeklyString ="";
	String dayOfMonth = "";
	String firstOccurDayOfWeek = "";
	String allProfessorforLecture ="";
	int numberOfProfessor=0;
	
	
	
	//Start page validation
    if (userId.equals("")) {
        response.sendRedirect("index.jsp?error=Please log in");
        return;
    }
	//only event creator and super admin have permission to edit event schedule
    if(!(ms_id.equals("null")||ms_id.equals(null))){
	    if (!meeting.isMeeting(myBool, ms_id, m_id)) {
	        message = "Could not verify meeting status (ms_id: " + ms_id + ", m_id: " + m_id + ")" + meeting.getErrMsg("AA01");
	        response.sendRedirect("canlendar.jsp?message=" + message);
	        return;   
	    }
	    if (!(user.isMeetingCreator(myBool, ms_id, userId)||isSuper)) {
	        message = "Could not verify meeting status (ms_id: " + ms_id + ", m_id: " + m_id + ")" + user.getErrMsg("AA02");
	        response.sendRedirect("canlendar.jsp?message=" + message);
	        return;   
	    }
	    isMeeting = true;
    }
    if(!(ls_id.equals("null")||ls_id.equals(null))){
   	    if (!lecture.isLecture(myBool, ls_id, l_id)) {
   	        message = lecture.getErrMsg("ALG01");
   	        response.sendRedirect("canlendar.jsp?message=" + message);
   	        return;   
   	    }
   	    if (!(user.isTeaching(myBool, ls_id, userId) || isSuper)) {
   	        message = user.getErrMsg("ALG02");
   	        response.sendRedirect("canlendar.jsp?message=" + message);
   	        return;   
   	    }
   	    isLecture=true;
    }
    
    if (message == null || message == "null") {
        message="";
    }
    //End page validation
          
    if(isMeeting){
    	meeting.getMeetingScheduleInfo(result, ms_id);  	
    	if(!(userId.equals(result.get(0).get(5)) || isSuper)){
    		response.sendRedirect("calendar.jsp?message=You don't have permission to edit this event schedule!");
    	}
    	for(int i=0;i<result.get(0).size();i++)
    	    System.out.println(result.get(0).get(i));
    }
    if(isLecture){
        lecture.getLectureScheduleInfo(result, ls_id);          
        lecture.getLectureProfessor(lectureProfessor, result.get(0).get(1), result.get(0).get(2), result.get(0).get(3));
        for(int j=0;j<lectureProfessor.size();j++){
        	numberOfProfessor += 1;
        	allProfessorforLecture=allProfessorforLecture.concat(lectureProfessor.get(j).get(0)).concat(" ");
        }
        if(isSuper){
            courseInfo = allProfessorforLecture.concat(result.get(0).get(1)).concat(" ").concat(result.get(0).get(2)).concat(" ").concat(result.get(0).get(3));
        }else{
        	courseInfo = result.get(0).get(1).concat(" ").concat(result.get(0).get(2)).concat(" ").concat(result.get(0).get(3));
        }
        System.out.println(courseInfo);
    }

    ArrayList<ArrayList<String>> professor = new ArrayList<ArrayList<String>>();
    HashMap<String, Integer> userSettings = new HashMap<String, Integer>();
    HashMap<String, Integer> meetingSettings = new HashMap<String, Integer>();
    HashMap<String, Integer> roleMask = new HashMap<String, Integer>();
    userSettings = usersession.getUserSettingsMask();
    meetingSettings = usersession.getUserMeetingSettingsMask();
    roleMask = usersession.getRoleMask();
    if(isProfessor)
        lecture.getProfessorCourse(professor,userId);
    if(isSuper)
        lecture.getAllProfessorCourse(professor);
%>

<script type="text/javascript">   
    function searchUser(){
        var xmlhttp;
        if (window.XMLHttpRequest)
        {// code for IE7+, Firefox, Chrome, Opera, Safari
          xmlhttp=new XMLHttpRequest();
        }
        else
        {// code for IE6, IE5
          xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
        }
        xmlhttp.onreadystatechange=function()
        {
          if (xmlhttp.readyState==4 && xmlhttp.status==200)
          {
              var json = xmlhttp.responseText;
              obj = JSON.parse(json);
            document.getElementById("responseDiv").innerHTML=xmlhttp.responseText;
          }
        }
        userName = document.getElementById("searchBoxAddAttendee").value;
        xmlhttp.open("GET","search.jsp?userName=" + userName,true);
        xmlhttp.send();
    }
    $(document).ready(function() { 
        <%if (meetingSettings.get("isRecorded")==0){%>
            $(".checkbox .box:eq(3)").next(".checkmark").toggle();
            $(".checkbox .box:eq(3)").attr("aria-checked", "false");
            $(".checkbox .box:eq(3)").siblings().last().prop("checked", false);
        <%}%>
        $("#dropdownDayStarts").selectmenu({'refresh': true});
        $("#dropdownMonthStarts").selectmenu({'refresh': true});
        $("#dropdownYearStarts").selectmenu({'refresh': true});
        $("#dropdownDayEnds").selectmenu({'refresh': true});
        $("#dropdownMonthEnds").selectmenu({'refresh': true});
        $("#dropdownYearEnds").selectmenu({'refresh': true});
        $("#dropdownEventType").selectmenu({'refresh': true});
        $("#Recurrence").selectmenu({'refresh': true});
        $("#courseCode").selectmenu({'refresh': true});
        $('#startTime').timepicker({ 'scrollDefaultNow': true });
    });

    //Date picker
    $(function(){
        var month = new Array(12);
        month[0]="January";
        month[1]="February";
        month[2]="March";
        month[3]="April";
        month[4]="May";
        month[5]="June";
        month[6]="July";
        month[7]="August";
        month[8]="September";
        month[9]="October";
        month[10]="November";
        month[11]="December";
        
        var datePickerStarts = {
            showOn: "button",
            buttonText:"",
            minDate: 0,
            maxDate: "+1Y",
            onSelect:function(dateText){
                var startDate = new Date(dateText);
                $("#dropdownDayStarts").val(startDate.getUTCDate());
                $("#dropdownMonthStarts").val(month[startDate.getUTCMonth()]);
                $("#dropdownYearStarts").val(startDate.getUTCFullYear());

            }
        };
        var datePickerEnds = {
            showOn: "button",
            buttonText:"",
            minDate: 0,
            maxDate: "+1Y",
            onSelect:function(dateText){
                var endDate = new Date(dateText);
                $("#dropdownDayEnds").val(endDate.getUTCDate());
                $("#dropdownMonthEnds").val(month[endDate.getUTCMonth()]);
                $("#dropdownYearEnds").val(endDate.getUTCFullYear());

            }
        };
        $("#datePickerStarts").datepicker(datePickerStarts);
        $("#datePickerEnds").datepicker(datePickerEnds);
       
    });

    
</script>
<script type="text/javascript">
   weekString = "0000000";
   $(document).ready(function() {   
       $('#week button').click(function(e) {
           var target = $(e.target);
           var weekday = target.text();
           if (weekday=='Sun')
               index=0;
           if (weekday=='Mon')
               index=1;
           if (weekday=='Tue')
               index=2;
           if (weekday=='Wed')
               index=3;
           if (weekday=='Thu')
               index=4;
           if (weekday=='Fri')
               index=5;
           if (weekday=='Sat')
               index=6;
           if(weekString.charAt(index)=='0'){
               weekString=weekString.substr(0,index) + 1 + weekString.substr(index+1);              
           }
           else{
               weekString=weekString.substr(0,index) + 0 + weekString.substr(index+1);
           }
           $("#weekString").attr("value", weekString);
                 
        });
       $("#selectDayoftheWeek button").click(function(e){
           var target = $(e.target);
           var weekday = target.text();
           if (weekday=='Sun')
               weekDayNumber=0;
           if (weekday=='Mon')
               weekDayNumber=1;
           if (weekday=='Tue')
               weekDayNumber=2;
           if (weekday=='Wed')
               weekDayNumber=3;
           if (weekday=='Thu')
               weekDayNumber=4;
           if (weekday=='Fri')
               weekDayNumber=5;
           if (weekday=='Sat')
               weekDayNumber=6;
           $("#selectedDayofWeek").attr('value',weekDayNumber);
       });
      
   });
    
</script>
<body>
<div id="page">
  <jsp:include page="header.jsp"/>
  <jsp:include page="menu.jsp"/>
    <section>
      <header>
        <p><a href="calendar.jsp" tabindex="13">home</a> » edit event schedule</p>
        <h1>Edit Event Schedule</h1>
      </header>
       <form method="get" action="persist_event.jsp" id="eventForm">
      <article>
        <header>
          <h2>Event Details</h2>
          <img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content" alt="Arrow"/></header>
        <div class="content">
          <fieldset>
            <div class="component">
              <label for="eventScheduleId" class="label">Schedule ID:</label>
              <input name="eventScheduleId" id="eventScheduleId" class="input" tabindex="14" title="Event Schedule ID" type="text" value="<%= isMeeting? ms_id:ls_id %>" readonly>
            </div>
            <% if(isMeeting){ %>
            <div class="component">
              <label for="eventTitle" class="label">Event Title:</label>
              <input name="eventTitle" id="eventTitle" class="input" tabindex="15" title="Event title" type="text" value="<%= result.get(0).get(1) %>" autofocus>
            </div><%} %>
            <div class="component">
              <label for="eventType" class="label">Event type:</label>
              <input name="eventType" id="eventType" class="input" tabindex="16" title="Event Type" type="text" value="<% if(isMeeting){ out.print("Meeting");} else {out.print("Lecture"); }%>" readonly>
            </div>
            <% if (isLecture){%>
            <div class="component" >
              <label for="courseInfo" class="label">Course Information:</label>
              <input name="courseInfo" id="courseInfo" class="input" tabindex="17" title="course information" type="text" value="<%= courseInfo %>" readonly>        
            </div>
            <% }%> 
          </fieldset>
        </div>
      </article>
      <article>
        <header>
          <h2>Schedule Options</h2>
          <img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content" alt="Arrow"/></header>
        <div class="content">
          <fieldset>
            <div class="component" id="startsOn" style="display:none">
              <label for="dropdownMonthStarts" class="label">Start Date:</label>
              <div class="datePicker" title="Choose a date">
                <input name="datePickerStarts" id="datePickerStarts" class="datePicker" aria-disabled="true"  aria-hidden="true" aria-readonly="true" readonly>                 
              </div>
              <select name="dropdownYearStarts" id="dropdownYearStarts" title="Year" tabindex="23" style="width: 100px">
              </select>
              <select name="dropdownDayStarts" id="dropdownDayStarts" title="Day" tabindex="22" role="listbox" style="width: 100px">
              </select>
              <select name="dropdownMonthStarts" id="dropdownMonthStarts" title="Month" tabindex="21" role="listbox" style="width: 143px">
                <option role="option" value="January">January</option>
                <option role="option">February</option>
                <option role="option">March</option>
                <option role="option">April</option>
                <option role="option">May</option>
                <option role="option">June</option>
                <option role="option">July</option>
                <option role="option">August</option>
                <option role="option">September</option>
                <option role="option">October</option>
                <option role="option">November</option>
                <option role="option">December</option>
              </select>             
            </div>
            <div class="component" >
              <label for="startDate" class="label">Start Date:</label> 
              <input id="startDate" name="startDate"  type="text"  class="input"  tabindex="24" title="Start Date" value="<%= isMeeting? result.get(0).get(2).split(" ")[0]: result.get(0).get(4).split(" ")[0] %>" readonly/>            
            </div>
            <div class="component" >
              <label for="startTime" class="label">Start Time:</label> 
              <input id="startTime" name="startTime"  type="text"  class="input"  tabindex="24" title="Start Time" value="<%= isMeeting? result.get(0).get(2).split(" ")[1].substring(0,8): result.get(0).get(4).split(" ")[1].substring(0,8) %>" autofocus/>            
            </div>
            <div class="component" >
              <label for="eventDuration" class="label">Event Duration:</label> 
              <input id="eventDuration" name="eventDuration"  type="text"  class="input"  tabindex="25" title="Event Duration"  value="<%=  isMeeting? result.get(0).get(4): result.get(0).get(6)%>" required autofocus/>            
            </div>
            <%
            //working on ls_spec or ms_spec
            String spec = null;
            spec = isMeeting? result.get(0).get(3): result.get(0).get(5);
            if(!spec.equals("1")){
            	//recurrence daily
            	if(spec.split(";")[0].equals("2")){
            		//repeat for a number of times
            		if(spec.split(";")[1].equals("1")){
            			repeatEvery = spec.split(";")[3];
            			occurences = spec.split(";")[2];
            		}
            		//repeat until a certain date
                    if(spec.split(";")[1].equals("2")){
                    	repeatEvery = spec.split(";")[3];
                    	endsYear = spec.split(";")[2].split("-")[0];
                    	endsMonth = spec.split(";")[2].split("-")[1];
                    	endsDay = spec.split(";")[2].split("-")[2];                  	
                    }
            	}
                //recurrence weekly
                if(spec.split(";")[0].equals("3")){
                    //repeat for a number of times
                    if(spec.split(";")[1].equals("1")){
                    	repeatEvery = spec.split(";")[3];
                    	occurences = spec.split(";")[2];
                    	weeklyString = spec.split(";")[4];
                    }
                    //repeat for a number of weeks
                    if(spec.split(";")[1].equals("2")){
                    	repeatEvery = spec.split(";")[3];
                    	occurences = spec.split(";")[2];
                    	weeklyString = spec.split(";")[4];
                    }
                    //repeat until end date is reached
                    if(spec.split(";")[1].equals("3")){
                    	repeatEvery = spec.split(";")[3];
                    	weeklyString = spec.split(";")[4];
                        endsYear = spec.split(";")[2].split("-")[0];
                        endsMonth = spec.split(";")[2].split("-")[1];
                        endsDay = spec.split(";")[2].split("-")[2];  
                    }
                }
                //recurrence monthly
                if(spec.split(";")[0].equals("4")){
                    //repeat on same day each month
                    if(spec.split(";")[1].equals("1")){
                    	repeatEvery = spec.split(";")[3];
                    	occurences = spec.split(";")[2];
                    	dayOfMonth = spec.split(";")[4];
                    }
                    //repeat the first occurrence of day-of-week in a month
                    if(spec.split(";")[1].equals("2")){
                        repeatEvery = spec.split(";")[3];
                        occurences = spec.split(";")[2];
                        firstOccurDayOfWeek= spec.split(";")[4];                        
                    }
                }
            }
            %>
            <div class="component">
              <label for="Recurrence" class="label">Recurrence:</label>
              <select name="Recurrence" id="Recurrence" title="Recurrence" tabindex="24" role="listbox" style="width: 402px">
                <option role="option" <% if(spec.equals("1")) out.print("selected=selected");%>>Only once</option>
                <option role="option" <% if(spec.charAt(0)=='2') out.print("selected=selected");%>>Daily</option>
                <option role="option" <% if(spec.charAt(0)=='3') out.print("selected=selected");%>>Weekly</option>
                <option role="option" <% if(spec.charAt(0)=='4') out.print("selected=selected");%>>Monthly</option>
              </select>            
            </div>
            <div style="display: none;" id="selectRepeatsEvery" class="component">
              <label for="repeatsInterval" class="label">Repeats every:</label>
              <input name="repeatsInterval" id="repeatsInterval" class="input" tabindex="25" title="Repeats Interval"  value="<% if(!(spec.charAt(0)=='1')){
            		  out.print(repeatEvery);
              } %>" type="number">
            </div>
            <div class="component" id="selectOccursBy">
              <label for="occursBy" class="label">Occurs by:</label>
              <select name="occursBy" id="occursBy" title="Occurs by" tabindex="26" role="listbox" style="width: 402px">
                <option role="option" <% if(!dayOfMonth.equals("")){out.print("selected=selected");} %>>Day of the month</option>
                <option role="option" <% if(!firstOccurDayOfWeek.equals("")){out.print("selected=selected");} %>>First occurrence of the day of the week</option>
              </select>
            </div>
            <div id="selectDayoftheMonth" class="component">
              <label for="dayoftheMonth" class="label">Day of the month:</label>
              <select name="dayoftheMonth" id="dayoftheMonth" title="Day of the month" tabindex="27" role="listbox" style="width: 402px">
                <option role="option" value="1" <% if(dayOfMonth.equals("1")){out.print("selected=selected");} %>>1st</option>
                <option role="option" value="2" <% if(dayOfMonth.equals("2")){out.print("selected=selected");} %>>2nd</option>
                <option role="option" value="3" <% if(dayOfMonth.equals("3")){out.print("selected=selected");} %>>3rd</option>
                <option role="option" value="4" <% if(dayOfMonth.equals("4")){out.print("selected=selected");} %>>4th</option>
                <option role="option" value="5" <% if(dayOfMonth.equals("5")){out.print("selected=selected");} %>>5th</option>
                <option role="option" value="6" <% if(dayOfMonth.equals("6")){out.print("selected=selected");} %>>6th</option>
                <option role="option" value="7" <% if(dayOfMonth.equals("7")){out.print("selected=selected");} %>>7th</option>
                <option role="option" value="8" <% if(dayOfMonth.equals("8")){out.print("selected=selected");} %>>8th</option>
                <option role="option" value="9" <% if(dayOfMonth.equals("9")){out.print("selected=selected");} %>>9th</option>
                <option role="option" value="10" <% if(dayOfMonth.equals("10")){out.print("selected=selected");} %>>10th</option>
                <option role="option" value="11" <% if(dayOfMonth.equals("11")){out.print("selected=selected");} %>>11th</option>
                <option role="option" value="12" <% if(dayOfMonth.equals("12")){out.print("selected=selected");} %>>12th</option>
                <option role="option" value="13" <% if(dayOfMonth.equals("13")){out.print("selected=selected");} %>>13th</option>
                <option role="option" value="14" <% if(dayOfMonth.equals("14")){out.print("selected=selected");} %>>14th</option>
                <option role="option" value="15" <% if(dayOfMonth.equals("15")){out.print("selected=selected");} %>>15th</option>
                <option role="option" value="16" <% if(dayOfMonth.equals("16")){out.print("selected=selected");} %>>16th</option>
                <option role="option" value="17" <% if(dayOfMonth.equals("17")){out.print("selected=selected");} %>>17th</option>
                <option role="option" value="18" <% if(dayOfMonth.equals("18")){out.print("selected=selected");} %>>18th</option>
                <option role="option" value="19" <% if(dayOfMonth.equals("19")){out.print("selected=selected");} %>>19th</option>
                <option role="option" value="20" <% if(dayOfMonth.equals("20")){out.print("selected=selected");} %>>20th</option>
                <option role="option" value="21" <% if(dayOfMonth.equals("21")){out.print("selected=selected");} %>>21st</option>
                <option role="option" value="22" <% if(dayOfMonth.equals("22")){out.print("selected=selected");} %>>22nd</option>
                <option role="option" value="23" <% if(dayOfMonth.equals("23")){out.print("selected=selected");} %>>23rd</option>
                <option role="option" value="24" <% if(dayOfMonth.equals("24")){out.print("selected=selected");} %>>24th</option>
                <option role="option" value="25" <% if(dayOfMonth.equals("25")){out.print("selected=selected");} %>>25th</option>
                <option role="option" value="26" <% if(dayOfMonth.equals("26")){out.print("selected=selected");} %>>26th</option>
                <option role="option" value="27" <% if(dayOfMonth.equals("27")){out.print("selected=selected");} %>>27th</option>
                <option role="option" value="28" <% if(dayOfMonth.equals("28")){out.print("selected=selected");} %>>28th</option>
                <option role="option" value="29" <% if(dayOfMonth.equals("29")){out.print("selected=selected");} %>>29th</option>
                <option role="option" value="30" <% if(dayOfMonth.equals("30")){out.print("selected=selected");} %>>30th</option>
                <option role="option" value="31" <% if(dayOfMonth.equals("31")){out.print("selected=selected");} %>>31st</option>
             
              </select>
            </div>
 
            <div id="week" class="component" role="group">
              <button type="button" name="Sunday" id="Sunday" class="weekday" title="Sunday" role="checkbox" aria-checked="false" tabindex="28">Sun</button>
              <button type="button" name="Monday" id="Monday" class="weekday" title="Monday" role="checkbox" aria-checked="false" aria-label="" tabindex="29">Mon</button>
              <button type="button" name="Tuesday" id="Tuesday" class="weekday" title="Tuesday" role="checkbox" aria-checked="false" tabindex="30">Tue</button>
              <button type="button" name="Wednesday" id="Wednesday" class="weekday" title="Wednesday" role="checkbox" aria-checked="false" tabindex="31">Wed</button>
              <button type="button" name="Thursday" id="Thursday" class="weekday" title="Thursday" role="checkbox" aria-checked="false" tabindex="32">Thu</button>
              <button type="button" name="Friday" id="Friday" class="weekday" title="Friday" role="checkbox" aria-checked="false" tabindex="33">Fri</button>
              <button type="button" name="Saturday" id="Saturday" class="weekday" title="Saturday" role="checkbox" aria-checked="false" tabindex="34">Sat</button>
              <input type="hidden" name="weekString" id="weekString" >
            </div>
     

            <div id="selectDayoftheWeek" class="component" role="radiogroup">
              <button type="button" name="Sunday" id="Sunday" class="weekday" value="Sun" title="Sunday" role="radio" aria-checked="false" aria-label="Sunday" tabindex="28">Sun</button>
              <button type="button" name="Monday" class="weekday" value="Mon" title="Monday" role="radio" aria-checked="false" aria-label="" tabindex="29">Mon</button>
              <button type="button" name="Tuesday" class="weekday" value="Tue" title="Tuesday" role="radio" aria-checked="false" tabindex="30">Tue</button>
              <button type="button" name="Wednesday" class="weekday" value="Wed" title="Wednesday" role="radio" aria-checked="false" tabindex="31">Wed</button>
              <button type="button" name="Thursday" class="weekday" value="Thu" title="Thursday" role="radio" aria-checked="false" tabindex="32">Thu</button>
              <button type="button" name="Friday" class="weekday" value="Fri" title="Friday" role="radio" aria-checked="false" tabindex="33">Fri</button>
              <button type="button" name="Saturday" class="weekday" value="Sat" title="Saturday" role="radio" aria-checked="false" tabindex="34">Sat</button>
              <input type="hidden" name="selectedDayofWeek" id="selectedDayofWeek" >
            </div>
            <div id="selectEnds" class="component">
              <label for="ends" class="label">Ends:</label>
              <select name="ends" id="ends" title="Ends" tabindex="22" role="listbox" style="width: 402px">
                <option role="option" 
                <% 
	                if(!(spec.charAt(0)=='1')){
	                	if(spec.split(";")[0].equals("2") && spec.split(";")[1].equals("1")){
	                		out.print("selected=selected");
	                	}
	                    if(spec.split(";")[0].equals("3") && (spec.split(";")[1].equals("1") ||spec.split(";")[1].equals("2"))){
	                        out.print("selected=selected");
	                    }                   
	                } 
                %>
                >After # of occurrence(s)</option>
                <option role="option"
                <% 
                    if(!(spec.charAt(0)=='1')){
                        if(spec.split(";")[0].equals("2") && spec.split(";")[1].equals("2")){
                            out.print("selected=selected");
                        }
                        if(spec.split(";")[0].equals("3") && spec.split(";")[1].equals("3")){
                            out.print("selected=selected");
                        }                   
                    } 
                %>
                >On specified date</option>
              </select>
            </div>
            <div id="occurrencesNumber" class="component">
              <label for="numberOfOccurrences" class="label">Occurrences:</label>
              <input type="number" name="numberOfOccurrences" id="numberOfOccurrences" class="input" tabindex="36" title="Occurrences"  placeholder="# of occurrences" min="1" value="<%= occurences%>"/>
            </div>
            <div id="occurrenceEnds" class="component">
              <label for="dropdownMonthEnds" class="label">Date:</label>
              <div class="datePicker" title="Choose a date" style="display:none">
                <input name="datePickerEnds" id="datePickerEnds" class="datePicker" aria-disabled="true"  aria-hidden="true" aria-readonly="true" readonly>
              </div>
              <select name="yearEnds" id="yearEnds" title="Year" tabindex="23" role="listbox" style="width: 100px">
                <option role="option" <% if(endsYear.equals("2013")){out.print("selected=selected");} %>>2013</option>
                <option role="option" <% if(endsYear.equals("2014")){out.print("selected=selected");} %>>2014</option>
                <option role="option" <% if(endsYear.equals("2015")){out.print("selected=selected");} %>>2015</option>
              </select>
              <select name="dayEnds" id="dayEnds" title="Day" tabindex="22" role="listbox" style="width: 100px">
                <option role="option" value="1" <% if(endsDay.equals("01")){out.print("selected=selected");} %>>1st</option>
                <option role="option" value="2" <% if(endsDay.equals("02")){out.print("selected=selected");} %>>2nd</option>
                <option role="option" value="3" <% if(endsDay.equals("03")){out.print("selected=selected");} %>>3rd</option>
                <option role="option" value="4" <% if(endsDay.equals("04")){out.print("selected=selected");} %>>4th</option>
                <option role="option" value="5" <% if(endsDay.equals("05")){out.print("selected=selected");} %>>5th</option>
                <option role="option" value="6" <% if(endsDay.equals("06")){out.print("selected=selected");} %>>6th</option>
                <option role="option" value="7" <% if(endsDay.equals("07")){out.print("selected=selected");} %>>7th</option>
                <option role="option" value="8" <% if(endsDay.equals("08")){out.print("selected=selected");} %>>8th</option>
                <option role="option" value="9" <% if(endsDay.equals("09")){out.print("selected=selected");} %>>9th</option>
                <option role="option" value="10" <% if(endsDay.equals("10")){out.print("selected=selected");} %>>10th</option>
                <option role="option" value="11" <% if(endsDay.equals("11")){out.print("selected=selected");} %>>11th</option>
                <option role="option" value="12" <% if(endsDay.equals("12")){out.print("selected=selected");} %>>12th</option>
                <option role="option" value="13" <% if(endsDay.equals("13")){out.print("selected=selected");} %>>13th</option>
                <option role="option" value="14" <% if(endsDay.equals("14")){out.print("selected=selected");} %>>14th</option>
                <option role="option" value="15" <% if(endsDay.equals("15")){out.print("selected=selected");} %>>15th</option>
                <option role="option" value="16" <% if(endsDay.equals("16")){out.print("selected=selected");} %>>16th</option>
                <option role="option" value="17" <% if(endsDay.equals("17")){out.print("selected=selected");} %>>17th</option>
                <option role="option" value="18" <% if(endsDay.equals("18")){out.print("selected=selected");} %>>18th</option>
                <option role="option" value="19" <% if(endsDay.equals("19")){out.print("selected=selected");} %>>19th</option>
                <option role="option" value="20" <% if(endsDay.equals("20")){out.print("selected=selected");} %>>20th</option>
                <option role="option" value="21" <% if(endsDay.equals("21")){out.print("selected=selected");} %>>21st</option>
                <option role="option" value="22" <% if(endsDay.equals("22")){out.print("selected=selected");} %>>22nd</option>
                <option role="option" value="23" <% if(endsDay.equals("23")){out.print("selected=selected");} %>>23rd</option>
                <option role="option" value="24" <% if(endsDay.equals("24")){out.print("selected=selected");} %>>24th</option>
                <option role="option" value="25" <% if(endsDay.equals("25")){out.print("selected=selected");} %>>25th</option>
                <option role="option" value="26" <% if(endsDay.equals("26")){out.print("selected=selected");} %>>26th</option>
                <option role="option" value="27" <% if(endsDay.equals("27")){out.print("selected=selected");} %>>27th</option>
                <option role="option" value="28" <% if(endsDay.equals("28")){out.print("selected=selected");} %>>28th</option>
                <option role="option" value="29" <% if(endsDay.equals("29")){out.print("selected=selected");} %>>29th</option>
                <option role="option" value="30" <% if(endsDay.equals("30")){out.print("selected=selected");} %>>30th</option>
                <option role="option" value="31" <% if(endsDay.equals("31")){out.print("selected=selected");} %>>31st</option>
              </select>
              <select name="monthEnds" id="monthEnds" title="Month" tabindex="21" role="listbox" style="width: 143px">
                <option role="option"   <% if(endsMonth.equals("01")){out.print("selected=selected");} %>>January</option>
                <option role="option" <% if(endsMonth.equals("02")){out.print("selected=selected");} %>>February</option>
                <option role="option" <% if(endsMonth.equals("03")){out.print("selected=selected");} %>>March</option>
                <option role="option" <% if(endsMonth.equals("04")){out.print("selected=selected");} %>>April</option>
                <option role="option" <% if(endsMonth.equals("05")){out.print("selected=selected");} %>>May</option>
                <option role="option" <% if(endsMonth.equals("06")){out.print("selected=selected");} %>>June</option>
                <option role="option" <% if(endsMonth.equals("07")){out.print("selected=selected");} %>>July</option>
                <option role="option" <% if(endsMonth.equals("08")){out.print("selected=selected");} %>>August</option>
                <option role="option" <% if(endsMonth.equals("09")){out.print("selected=selected");} %>>September</option>
                <option role="option" <% if(endsMonth.equals("10")){out.print("selected=selected");} %>>October</option>
                <option role="option" <% if(endsMonth.equals("11")){out.print("selected=selected");} %>>November</option>
                <option role="option" <% if(endsMonth.equals("12")){out.print("selected=selected");} %>>December</option>
              </select>
            </div>
          </fieldset>
        </div>
      </article>

      <article>
        <h4></h4>
        <fieldset>
          <div class="buttons">
            <button type="submit" name="submit" id="save" class="button" title="Click here to save inserted data">Save</button>
             <button type="reset" name="reset" id="reset" class="button" title="Click here to reset">Reset</button>                              
            <button type="button" name="button" id="cancel"  class="button" title="Click here to cancel">Cancel</button>
          </div>
        </fieldset>
      </article>
    </form>
   </section>
   <script>    
   // form validation, edit the regular expression pattern and error messages to meet your needs
       $(document).ready(function(){
            $('#eventForm').validate({
                validateOnBlur : true,
                rules: {
                    eventTitle: {
                       required: true,
                       pattern: /^[- a-zA-Z0-9]+$/
                   },
                   eventDescription:{
                       required: false,
                       pattern: /^[^<>]+$/
                   },
                   startTime:{
                       required: true,
                       pattern: /^\s*[0-2][0-9]:[0-5][0-9]:[0-5][0-9]\s*$/
                   },
                   eventDuration:{
                       required: true,
                       range:[1,999]
                       
                   },
                   repeatsEvery:{
                       required: true,
                       range:[1,100]
                   },
                   occurrences:{
                       required: true,
                       range:[1,100]
                   }
                   
                },
                messages: {
                    eventTitle: { 
                        pattern:"Please enter a valid Title.",
                        required:"Title is required"
                    },
                    eventDescription:"Do not use <> ",
                    startTime:"Please enter a valid Time Format",
                    eventDuration:"Please enter a valid Number",
                    repeatsEvery:"Please enter a valid Number",
                    occurrences:"Please enter a valid Number"
                }
            });
        });
  </script>
  <jsp:include page="footer.jsp"/>
</div>
</body>