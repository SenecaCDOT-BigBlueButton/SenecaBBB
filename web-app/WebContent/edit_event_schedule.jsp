<%@page import="db.DBConnection"%>
<%@page import="sql.*"%>
<%@page import="helper.*"%>
<%@page import="java.util.*"%>
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SenecaBBB | Edit Event Schedule</title>
    <link rel="shortcut icon" href="http://www.senecacollege.ca/favicon.ico">
    <link rel="stylesheet" type="text/css" media="all" href="css/fonts.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/style.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.core.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.theme.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.timepicker.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.datepicker.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.selectmenu.css">
    <script type="text/javascript" src="js/jquery-1.9.1.js"></script>
    <script type="text/javascript" src="js/modernizr.custom.79639.js"></script>
    <script type="text/javascript" src="js/ui/jquery.ui.core.js"></script>
    <script type="text/javascript" src="js/ui/jquery.ui.widget.js"></script>
    <script type="text/javascript" src="js/ui/jquery.ui.position.js"></script>
    <script type="text/javascript" src="js/ui/jquery.ui.selectmenu.js"></script>
    <script type="text/javascript" src="js/ui/jquery.timepicker.js"></script>
    <script type="text/javascript" src="js/ui/jquery.ui.stepper.js"></script>
    <script type="text/javascript" src="js/ui/jquery.ui.datepicker.js"></script>
    <script type="text/javascript" src="js/componentController.js"></script>
    <script type="text/javascript" src="js/jquery.validate.min.js"></script>
    <script type="text/javascript" src="js/additional-methods.min.js"></script>

    <%
    String message = request.getParameter("message");
    GetExceptionLog elog = new GetExceptionLog();
    String successMessage = request.getParameter("successMessage");
    if (message == null || message == "null") {
        message="";
    }
    if (successMessage == null) {
        successMessage="";
    }
    String ms_id = request.getParameter("ms_id");
    String ls_id = request.getParameter("ls_id");
    String m_id = request.getParameter("m_id");
    String l_id = request.getParameter("l_id");
    Boolean isMeeting = false;
    Boolean isLecture = false;
    Boolean isProfessor = false;
    Boolean isSuper = false;
    isProfessor=usersession.isProfessor();
    isSuper =usersession.isSuper();
    Section section = new Section(dbaccess);
    String userId = usersession.getUserId();
    Meeting meeting = new Meeting(dbaccess);
    Lecture lecture = new Lecture(dbaccess); 
    User user = new User(dbaccess);
    MyBoolean myBool = new MyBoolean(); 
    
    //Start page validation
    if (userId.equals("")) {
        session.setAttribute("redirecturl", request.getRequestURI()+(request.getQueryString()!=null?"?"+request.getQueryString():""));
        response.sendRedirect("index.jsp?error=Please log in");
        return;
    }
    //only event creator and super admin have permission to edit event schedule
    if(!(ms_id==null||ms_id.equals(""))){
        if (!meeting.isMeeting(myBool, ms_id, m_id)) {
            message = "Could not verify meeting status (ms_id: " + ms_id + ", m_id: " + m_id + ")" + meeting.getErrMsg("AA01");
            elog.writeLog("[edit_event_schedule:] " + message +" /n");
            response.sendRedirect("canlendar.jsp?message=" + message);
            return;
        }
        if (!(user.isMeetingCreator(myBool, ms_id, userId)||isSuper)) {
            message = "Could not verify meeting status (ms_id: " + ms_id + ", m_id: " + m_id + ")" + user.getErrMsg("AA02");
            elog.writeLog("[edit_event_schedule:] " + message +" /n");
            response.sendRedirect("canlendar.jsp?message=" + message);
            return;
        }
        isMeeting = true;
    }
    if(!(ls_id==null||ls_id.equals(""))){
        if (!lecture.isLecture(myBool, ls_id, l_id)) {
            message = lecture.getErrMsg("ALG01");
            elog.writeLog("[edit_event_schedule:] " + message +" /n");
            response.sendRedirect("canlendar.jsp?message=" + message);
            return;
        }
        if (!(user.isTeaching(myBool, ls_id, userId) || isSuper)) {
            message = user.getErrMsg("ALG02");
            elog.writeLog("[edit_event_schedule:] " + message +" /n");
            response.sendRedirect("canlendar.jsp?message=" + message);
            return;
        }
        isLecture=true;
    }
    

    //End page validation
    
    ArrayList<ArrayList<String>> result = new ArrayList<ArrayList<String>>(); 
    ArrayList<ArrayList<String>> lectureProfessor = new ArrayList<ArrayList<String>>();
    ArrayList<ArrayList<String>> descriptionResult = new ArrayList<ArrayList<String>>();
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
    String weeklyString ="abcdefg";
    String dayOfMonth = "";
    String firstOccurDayOfWeek = "";
    String allProfessorforLecture ="";
    String eventDescription ="";

    if(isMeeting){
        try{
           meeting.getMeetingScheduleInfo(result, ms_id);  	
           meeting.getMeetingDescription(descriptionResult, ms_id);
        }catch(Exception e){
           elog.writeLog("[edit_event_schedule:] " + e.getMessage() +"-"+ e.getStackTrace()+" /n");
        }
    }
    if(isLecture){
        //show the professor name,course,section, and semester information to super admin in course information field 
        //if the user is professor, only show course,section, and semester information
        try{
            lecture.getLectureScheduleInfo(result, ls_id);   
            lecture.getLectureDescription(descriptionResult, ls_id);
            lecture.getLectureProfessor(lectureProfessor, result.get(0).get(1), result.get(0).get(2), result.get(0).get(3));
            for(int j=0;j<lectureProfessor.size();j++){       	
                allProfessorforLecture=allProfessorforLecture.concat(lectureProfessor.get(j).get(0)).concat(" ");
            }
            if(isSuper){
                courseInfo = allProfessorforLecture.concat(result.get(0).get(1)).concat(" ").concat(result.get(0).get(2)).concat(" ").concat(result.get(0).get(3));
            }else{
                courseInfo = result.get(0).get(1).concat(" ").concat(result.get(0).get(2)).concat(" ").concat(result.get(0).get(3));
            }
        }catch(Exception e){
            elog.writeLog("[edit_event_schedule:] " + e.getMessage() +"-"+ e.getStackTrace()+" /n");
        }
    }

    ArrayList<ArrayList<String>> professor = new ArrayList<ArrayList<String>>();
    HashMap<String, Integer> userSettings = new HashMap<String, Integer>();
    HashMap<String, Integer> meetingSettings = new HashMap<String, Integer>();
    HashMap<String, Integer> roleMask = new HashMap<String, Integer>();
    userSettings = usersession.getUserSettingsMask();
    meetingSettings = usersession.getUserMeetingSettingsMask();
    roleMask = usersession.getRoleMask();
    eventDescription = descriptionResult.get(0).get(0);
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
    startDate= isMeeting? result.get(0).get(2).split(" ")[0]: result.get(0).get(4).split(" ")[0];
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

        $("#dropdownEventType").selectmenu({'refresh': true});
        $("#Recurrence").selectmenu({'refresh': true});
        $("#courseCode").selectmenu({'refresh': true});
        $('#startTime').timepicker({ 'scrollDefaultNow': true });


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
                dateFormat: "yy-mm-dd",
                showOn: "button",
                buttonText:"",
                minDate: 0,
                maxDate: "+1Y",
                showOtherMonths: true,
                selectOtherMonths: true,
                onSelect:function(dateText){
                    var startDate = new Date(dateText);
                    $("#dropdownDayStarts").val(startDate.getUTCDate());
                    $("#dropdownMonthStarts").val(month[startDate.getUTCMonth()]);
                    $("#dropdownYearStarts").val(startDate.getUTCFullYear());
                    populateMonthStarts($("#dropdownMonthStarts").val());
                    populateMonthEnds($("#dropdownMonthStarts").val());
                    $("#dropdownDayStarts").selectmenu({'refresh': true});
                    $("#dropdownMonthStarts").selectmenu({'refresh': true});
                    $("#dropdownYearStarts").selectmenu({'refresh': true});
                   
                }
            <% if(startDate.equals("")) out.write(""); else out.write(",defaultDate: "+"\""+ startDate+"\"");%>
            
            };
            var datePickerEnds = {
                dateFormat: "yy-mm-dd",
                showOn: "button",
                buttonText:"",
                minDate: 0,
                maxDate: "+1Y",
                showOtherMonths: true,
                selectOtherMonths: true,
                onSelect:function(dateText){
                    var endDate = new Date(dateText);
                    $("#dropdownDayEnds").val(endDate.getUTCDate());
                    $("#dropdownMonthEnds").val(month[endDate.getUTCMonth()]);
                    $("#dropdownYearEnds").val(endDate.getUTCFullYear());
                    populateMonthEnds($("#dropdownMonthEnds").val());
                    $("#dropdownDayEnds").selectmenu({'refresh': true});
                    $("#dropdownMonthEnds").selectmenu({'refresh': true});
                    $("#dropdownYearEnds").selectmenu({'refresh': true});
                   
                }
            <% if(endsYear.equals("")|| endsMonth.equals("") || endsDay.equals("")) out.write(""); else out.write(",defaultDate:"+"\""+ endsYear+"-"+endsMonth+"-"+endsDay+"\"");%>
            
            };
            $("#datePickerStarts").datepicker(datePickerStarts);
            $("#datePickerEnds").datepicker(datePickerEnds);
        });

    });

</script>
<script type="text/javascript">
    $(document).ready(function() {
       //get the populate weekString from an event spec in database
        var weekString = $('#weekString').val();
        if(weekString === undefined ){
            weekString="0000000";
        }
        $('#weekCheckbox button').click(function(e) {
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
        $("#dayoftheWeek button").click(function(e){
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
        $("#help").attr({href:"help_editEventSchedule.jsp",target:"_blank"});
      
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
                <!-- MESSAGES -->
                <div class="warningMessage"><%=message %></div>
                <div class="successMessage"><%=successMessage %></div> 
            </header>
            <form method="get" action="update_event_schedule.jsp" id="eventForm">
                <article>
                    <header>
                        <h2>Event Details</h2>
                        <img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content" alt="Arrow"/>
                    </header>
                    <div class="content">
                        <fieldset>
                            <div class="component">
                                <input type="hidden" name="eventScheduleId" id="eventScheduleId" value="<%= isMeeting? ms_id:ls_id %>">
                                <input type="hidden" name="eventId" id="eventId" value="<%= isMeeting? m_id:l_id %>">
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
                            <img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content" alt="Arrow"/>
                    </header>
                    <div class="content">
                        <fieldset>
                            <div class="component" id="startsOn">
                                <label for="dropdownMonthStarts" class="label">Start Date:</label>
                                <div class="datePicker" title="Choose a date">
                                    <input name="datePickerStarts" id="datePickerStarts" class="datePicker" aria-disabled="true"  aria-hidden="true" aria-readonly="true">                 
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
                                <label for="startTime" class="label">Start Time:</label> 
                                <input id="startTime" name="startTime"  type="text"  class="input"  tabindex="24" title="Start Time" value="<%= isMeeting? result.get(0).get(2).split(" ")[1].substring(0,8): result.get(0).get(4).split(" ")[1].substring(0,8) %>" autofocus/>            
                            </div>
                            <div class="component" >
                                <label for="eventDuration" class="label">Event Duration:</label> 
                                <input id="eventDuration" name="eventDuration"  type="text"  class="input"  tabindex="25" title="Event Duration"  value="<%=  isMeeting? result.get(0).get(4): result.get(0).get(6)%>" required autofocus/>            
                            </div>

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
                                <input name="repeatsInterval" id="repeatsInterval" class="input" tabindex="25" title="Repeats Interval"  
                                       value="<% if(!(spec.charAt(0)=='1')){ out.print(repeatEvery); } %>" type="number">
                            </div>
                            <div class="component" id="selectOccursBy">
                                <label for="occursBy" class="label">Occurs by:</label>
                                <select name="occursBy" id="occursBy" title="Occurs by" tabindex="26" role="listbox" style="width: 402px">
                                    <option role="option" <% if(!dayOfMonth.equals("")){out.print("selected=selected");} %>>Day of the month</option>
                                    <option role="option" <% if(!firstOccurDayOfWeek.equals("")){out.print("selected=selected");} %>>First occurrence of the day of the week</option>
                                </select>
                            </div>
                            <div id="dayoftheMonthOptions" class="component">
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

                            <div id="weekCheckbox" class="component" role="group">
                                <button type="button" name="Sunday" id="Sunday" <% if(weeklyString.charAt(0)=='0' || weeklyString.charAt(0)=='a'){out.print("class=weekday aria-checked=false");}else{out.print("class='weekday selectedWeekday' aria-checked=true");} %> title="Sunday" role="checkbox"  tabindex="28">Sun</button>
                                <button type="button" name="Monday" id="Monday" <% if(weeklyString.charAt(1)=='0' || weeklyString.charAt(1)=='b'){out.print("class=weekday aria-checked=false");}else{out.print("class='weekday selectedWeekday' aria-checked=true");} %> title="Monday" role="checkbox"  aria-label="" tabindex="29">Mon</button>
                                <button type="button" name="Tuesday" id="Tuesday" <% if(weeklyString.charAt(2)=='0' || weeklyString.charAt(2)=='c'){out.print("class=weekday aria-checked=false");}else{out.print("class='weekday selectedWeekday' aria-checked=true");} %>title="Tuesday" role="checkbox"  tabindex="30">Tue</button>
                                <button type="button" name="Wednesday" id="Wednesday" <% if(weeklyString.charAt(3)=='0' || weeklyString.charAt(3)=='d'){out.print("class=weekday aria-checked=false");}else{out.print("class='weekday selectedWeekday' aria-checked=true");} %> title="Wednesday" role="checkbox" tabindex="31">Wed</button>
                                <button type="button" name="Thursday" id="Thursday" <% if(weeklyString.charAt(4)=='0' || weeklyString.charAt(4)=='e'){out.print("class=weekday aria-checked=false");}else{out.print("class='weekday selectedWeekday' aria-checked=true");} %> title="Thursday" role="checkbox"  tabindex="32">Thu</button>
                                <button type="button" name="Friday" id="Friday" <% if(weeklyString.charAt(5)=='0' || weeklyString.charAt(5)=='f'){out.print("class=weekday aria-checked=false");}else{out.print("class='weekday selectedWeekday' aria-checked=true");} %> title="Friday" role="checkbox"  tabindex="33">Fri</button>
                                <button type="button" name="Saturday" id="Saturday" <% if(weeklyString.charAt(6)=='0' || weeklyString.charAt(6)=='g'){out.print("class=weekday aria-checked=false");}else{out.print("class='weekday selectedWeekday' aria-checked=true");} %> title="Saturday" role="checkbox" tabindex="34">Sat</button>
                                <input type="hidden" name="weekString" id="weekString" value="<%= weeklyString.equals("abcdefg")?"000000":weeklyString %>">
                            </div>
 
                            <div id="dayoftheWeek" class="component" role="radiogroup">
                                <button type="button" name="Sunday" id="Sunday" <% if(!firstOccurDayOfWeek.equals("0")){out.print("class=weekday aria-checked=false");}else{out.print("class='weekday selectedWeekday' aria-checked=true");} %> value="Sun" title="Sunday" role="radio"  aria-label="Sunday" tabindex="28">Sun</button>
                                <button type="button" name="Monday" <% if(!firstOccurDayOfWeek.equals("1")){out.print("class=weekday aria-checked=false");}else{out.print("class='weekday selectedWeekday' aria-checked=true");} %> value="Mon" title="Monday" role="radio"  aria-label="" tabindex="29">Mon</button>
                                <button type="button" name="Tuesday" <% if(!firstOccurDayOfWeek.equals("2")){out.print("class=weekday aria-checked=false");}else{out.print("class='weekday selectedWeekday' aria-checked=true");} %> value="Tue" title="Tuesday" role="radio"  tabindex="30">Tue</button>
                                <button type="button" name="Wednesday" <% if(!firstOccurDayOfWeek.equals("3")){out.print("class=weekday aria-checked=false");}else{out.print("class='weekday selectedWeekday' aria-checked=true");} %> value="Wed" title="Wednesday" role="radio"  tabindex="31">Wed</button>
                                <button type="button" name="Thursday" <% if(!firstOccurDayOfWeek.equals("4")){out.print("class=weekday aria-checked=false");}else{out.print("class='weekday selectedWeekday' aria-checked=true");} %> value="Thu" title="Thursday" role="radio"  tabindex="32">Thu</button>
                                <button type="button" name="Friday" <% if(!firstOccurDayOfWeek.equals("5")){out.print("class=weekday aria-checked=false");}else{out.print("class='weekday selectedWeekday' aria-checked=true");} %> value="Fri" title="Friday" role="radio"  tabindex="33">Fri</button>
                                <button type="button" name="Saturday" <% if(!firstOccurDayOfWeek.equals("6")){out.print("class=weekday aria-checked=false");}else{out.print("class='weekday selectedWeekday' aria-checked=true");} %> value="Sat" title="Saturday" role="radio" tabindex="34">Sat</button>
                                <input type="hidden" name="selectedDayofWeek" id="selectedDayofWeek"  value="<%= firstOccurDayOfWeek %>">
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
                                    %> >After # of occurrence(s)
                                    </option>
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
                                    %> >On specified date
                                    </option>
                                </select>
                            </div>
                            <div id="occurrencesNumber" class="component">
                                <label for="numberOfOccurrences" class="label">Occurrences:</label>
                                <input type="number" name="numberOfOccurrences" id="numberOfOccurrences" class="input" tabindex="36" title="Occurrences"  placeholder="# of occurrences" min="1" value="<%= occurences%>"/>
                            </div>
                            <div id="occurrenceEnds" class="component">
                                <label for="dropdownMonthEnds" class="label">End Date:</label>
                                <div class="datePicker" title="Choose a date">
                                    <input name="datePickerEnds" id="datePickerEnds" class="datePicker" aria-disabled="true"  aria-hidden="true" aria-readonly="true" readonly>
                                </div>
                                <select name="dropdownYearEnds" id="dropdownYearEnds" title="Year" tabindex="23" role="listbox" style="width: 100px">
                                </select>
                                <select name="dropdownDayEnds" id="dropdownDayEnds" title="Day" tabindex="22" role="listbox" style="width: 100px">
                                </select>
                                <select name="dropdownMonthEnds" id="dropdownMonthEnds" title="Month" tabindex="21" role="listbox" style="width: 143px">
                                    <option role="option">January</option>
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
                                <label for="eventDescription" class="label">Description:</label>
                                <input name="eventDescription" id="eventDescription" class="input" cols="35" rows="5" title="Description" value="<%= eventDescription %>" autofocus>     
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
                            <% if (ms_id!=null) { %>                              
                            <button type="button" name="button" id="cancel"  class="button" title="Click here to cancel" onclick="window.location.href='view_event_schedule.jsp?ms_id=<%= ms_id %>&m_id=<%= m_id %>'">Cancel</button>
                            <% } else { %>
                            <button type="button" name="button" id="cancel"  class="button" title="Click here to cancel" onclick="window.location.href='view_event_schedule.jsp?ls_id=<%= ls_id %>&l_id=<%= l_id %>'">Cancel</button>
                            <% } %>
                        </div>
                    </fieldset>
                    <h4></h4>
                    <fieldset>
                        <div class="buttons">
                            <% if (ms_id!=null) { %>
                            <button type="button" name="button" id="delete"  class="button" title="Click here to delete schedule" onclick="window.location.href='delete_event.jsp?ms_id=<%= ms_id %>&m_id=<%= m_id %>'">Delete This Schedule</button>
                            <% } else { %>
                            <button type="button" name="button" id="delete"  class="button" title="Click here to delete schedule" onclick="window.location.href='delete_event.jsp?ls_id=<%= ls_id %>&l_id=<%= l_id %>'">Delete This Schedule</button>
                            <% } %>
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
                           minlength: 3,
                           maxlength: 50,
                           pattern: /^[- a-zA-Z0-9]+$/
                       },
                       startTime:{
                           required: true,
                           pattern: /^\s*[0-2][0-9]:[0-5][0-9]:[0-5][0-9]\s*$/
                       },
                       eventDuration:{
                           required: true,
                           range:[1,999]
                           
                       },
                       repeatsInterval:{
                           required: true,
                           range:[1,100]
                       },
                       numberOfOccurrences:{
                           required: true,
                           range:[1,100]
                       },
                       eventDescription:{
                           required: false,
                           maxlength: 100,
                           pattern: /^[^<>]+$/
                       }
                       
                    },
                    messages: {
                        eventTitle: { 
                            pattern:"Please enter a valid Title.",
                            required:"Title is required",
                            minlength: "Invalid event title length",
                            maxlength: "Invalid event title length"
                        },
                        startTime:"Please enter a valid Time Format",
                        eventDuration:"Please enter a valid Number",
                        repeatsInterval:"Please enter a valid Number",
                        numberOfOccurrences:"Please enter a valid Number",
                        eventDescription:"Invalid characters"
                    }
                });
                //populate event end date 
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
            
                <% if(!endsYear.equals("") && !endsMonth.equals("") && !endsDay.equals("") ){%>
                var endDate = new Date(<%= Integer.parseInt(endsYear) %>,<%= Integer.parseInt(endsMonth)-1 %>,<%= Integer.parseInt(endsDay) %>);
                $("#dropdownDayEnds").val(endDate.getUTCDate());
                $("#dropdownMonthEnds").val(month[endDate.getUTCMonth()]);
                $("#dropdownYearEnds").val(endDate.getUTCFullYear());
                $("#dropdownDayEnds").selectmenu({'refresh': true});
                $("#dropdownMonthEnds").selectmenu({'refresh': true});
                $("#dropdownYearEnds").selectmenu({'refresh': true});
                <%}%>
                var startDate = new Date(<%= Integer.parseInt(startDate.split("-")[0]) %>,<%= Integer.parseInt(startDate.split("-")[1])-1 %>,<%= Integer.parseInt(startDate.split("-")[2]) %>);
                    $("#dropdownDayStarts").val(startDate.getUTCDate());
                    $("#dropdownMonthStarts").val(month[startDate.getUTCMonth()]);
                    $("#dropdownYearStarts").val(startDate.getUTCFullYear());
                    $("#dropdownDayStarts").selectmenu({'refresh': true});
                    $("#dropdownMonthStarts").selectmenu({'refresh': true});
                    $("#dropdownYearStarts").selectmenu({'refresh': true});
                });
        </script>
        <jsp:include page="footer.jsp"/>
    </div>
</body>