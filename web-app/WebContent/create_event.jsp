<%@page import="db.DBConnection"%>
<%@page import="sql.*"%>
<%@page import="java.util.*"%>
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<!doctype html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Seneca | Create Event</title>
<link rel="icon" href="http://www.cssreset.com/favicon.png">
<link rel="stylesheet" type="text/css" media="all" href="css/fonts.css">
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/style.css">
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.core.css">
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.theme.css">
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.datepicker.css">
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.timepicker.css">
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.selectmenu.css">
<link rel='stylesheet' type="text/css" href='fullcalendar-1.6.3/fullcalendar/fullcalendar.css'>
<script type="text/javascript" src="http://code.jquery.com/jquery-1.9.1.js"></script>
<script type="text/javascript" src="js/modernizr.custom.79639.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.position.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.selectmenu.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.datepicker.js"></script>
<script type="text/javascript" src="js/ui/jquery.timepicker.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.stepper.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.dataTable.js"></script>
<script type="text/javascript" src="js/componentController.js"></script>
<script type="text/javascript" src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.11.1/jquery.validate.min.js"></script>
<script type="text/javascript" src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.11.1/additional-methods.min.js"></script>

<%
	//Start page validation
	String userId = usersession.getUserId();
    Boolean isProfessor = false;
    Boolean isSuper = false;
    isProfessor=usersession.isProfessor();
    isSuper =usersession.isSuper();
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
    Section section = new Section(dbaccess);
    Meeting meeting = new Meeting(dbaccess);
    Lecture lecture = new Lecture(dbaccess);
    ArrayList<ArrayList<String>> professor = new ArrayList<ArrayList<String>>();
	HashMap<String, Integer> userSettings = new HashMap<String, Integer>();
	HashMap<String, Integer> meetingSettings = new HashMap<String, Integer>();
	HashMap<String, Integer> roleMask = new HashMap<String, Integer>();
	userSettings = usersession.getUserSettingsMask();
	meetingSettings = usersession.getUserMeetingSettingsMask();
	roleMask = usersession.getRoleMask();
	if(isProfessor && !isSuper)
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
		<%if (meetingSettings.get("isPrivateChatEnabled")==0){%>
			$(".checkbox .box:eq(0)").next(".checkmark").toggle();
			$(".checkbox .box:eq(0)").attr("aria-checked", "false");
			$(".checkbox .box:eq(0)").siblings().last().prop("checked", false);
		<%}%>	
		<%if (meetingSettings.get("isViewerWebcamEnabled")==0){%>
			$(".checkbox .box:eq(1)").next(".checkmark").toggle();
			$(".checkbox .box:eq(1)").attr("aria-checked", "false");
			$(".checkbox .box:eq(1)").siblings().last().prop("checked", false);
		<%}%>	
		<%if (meetingSettings.get("isMultiWhiteboard")==0){%>
			$(".checkbox .box:eq(2)").next(".checkmark").toggle();
			$(".checkbox .box:eq(2)").attr("aria-checked", "false");
			$(".checkbox .box:eq(2)").siblings().last().prop("checked", false);
		<%}%>	
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
        $("#dropdownRecurrence").selectmenu({'refresh': true});
        $("#courseCode").selectmenu({'refresh': true});
        $('#startTime').timepicker({ 'scrollDefaultNow': true });
	});
/*
	//Table
	$(screen).ready(function() {
		// ATTENDEES LIST 
		$('#addAttendee').dataTable({
			"bPaginate": false,
	        "bLengthChange": false,
	        "bFilter": false,
	        "bSort": true,
	        "bInfo": false,
	        "bAutoWidth": false});
		$('#addAttendee').dataTable({"aoColumnDefs": [{ "bSortable": false, "aTargets":[5]}], "bRetrieve": true, "bDestroy": true});
		$.fn.dataTableExt.sErrMode = 'throw';
		$('.dataTables_filter input').attr("placeholder", "Filter entries");
			
		// ATTENDEES LIST 	
		$('#attendeesList').dataTable({"sPaginationType": "full_numbers"});
		$('#attendeesList').dataTable({"aoColumnDefs": [{ "bSortable": false, "aTargets":[5]}], "bRetrieve": true, "bDestroy": true});
		$.fn.dataTableExt.sErrMode = 'throw';
		$('.dataTables_filter input').attr("placeholder", "Filter entries");
		
	});
*/
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
        <p><a href="calendar.jsp" tabindex="13">home</a> » create event</p>
        <h1>Create Event</h1>
      </header>
       <form method="get" action="persist_event.jsp" id="eventForm">
      <article>
        <header>
          <h2>Event Details</h2>
          <img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content" alt="Arrow"/></header>
        <div class="content">
          <fieldset>
          	<div class="component">
              <label for="eventTitle" class="label">Event Title:</label>
              <input name="eventTitle" id="eventTitle" class="input" tabindex="15" title="Event title" type="text" autofocus>
            </div>
            <div class="component">
              <label for="dropdownEventType" class="label">Event type:</label>
              <select name="dropdownEventType" id="dropdownEventType" title="Event type" tabindex="16" style="width: 402px">
                <option value="Meeting" selected="selected">Meeting</option>
                <% if (isProfessor || isSuper) { %> <option value="Lecture">Lecture</option><% } %>
              </select>
            </div>
            <div class="component">
              <label for="eventDescription" class="label">Description:</label>
              <textarea name="eventDescription" id="eventDescription" class="input" tabindex="15" title="Event title"  autofocus></textarea>
            </div>
            <div class="component" id="lectureCourse">
              <label for="courseCode" class="label">Course Information:</label>
              <select name="courseCode" id="courseCode" tabindex="15" title="Course Name" style="width: 402px"  autofocus>
                  <% if(isProfessor && !isSuper){
                	  for(int i=0;i<professor.size();i++){  %>
                          <option value="<%= professor.get(i).get(0).concat(" ").concat(professor.get(i).get(1)).concat(" ").concat(professor.get(i).get(2)) %>" >
                  <%= professor.get(i).get(0).concat(" ").concat(professor.get(i).get(1)).concat(" ").concat(professor.get(i).get(2)) %></option>
                  <% }
                  }
                  else if(isSuper){ 
                      for(int i=0;i<professor.size();i++){  %>
                          <option value="<%= professor.get(i).get(0).concat(" ").concat(professor.get(i).get(1)).concat(" ").concat(professor.get(i).get(2)).concat(" ").concat(professor.get(i).get(3)) %>" >
                          <%= professor.get(i).get(0).concat(" ").concat(professor.get(i).get(1)).concat(" ").concat(professor.get(i).get(2)).concat(" ").concat(professor.get(i).get(3)) %></option>
                    <%}
                  }else{%>
                	  <%=" <option> You don't have any courses yet!</option>"%>
                 <% }%>                 
              </select>
            </div>


            <!-- 
            <div class="component">
              <div class="checkbox" title="Allow microphone sharing."> <span class="box" role="checkbox" aria-checked="true" tabindex="17" aria-labelledby="eventSetting1"></span>
                <label class="checkmark"></label>
                <label class="text" id="eventSetting1">Allow microphone sharing.</label>
                <input type="checkbox" name="eventSetting1box" checked="checked" aria-disabled="true">
              </div>
            </div>
            <div class="component">
              <div class="checkbox" title="Allow camera sharing"> <span class="box" role="checkbox" aria-checked="true" tabindex="18" aria-labelledby="eventSetting2"></span>
                <label class="checkmark"></label>
                <label class="text" id="eventSetting2">Allow camera sharing.</label>
                <input type="checkbox" name="eventSetting2box" checked="checked" aria-disabled="true">
              </div>
            </div>
            <div class="component">
              <div class="checkbox" title="Allow public whiteboard"> <span class="box" role="checkbox" aria-checked="true" tabindex="19" aria-labelledby="eventSetting3"></span>
                <label class="checkmark"></label>
                <label class="text" id="eventSetting3">Allow public whiteboard.</label>
                <input type="checkbox" name="eventSetting3box" checked="checked" aria-disabled="true">
              </div>
            </div>
            -->
            <div class="component" style="z-index: 2;">
              <div class="checkbox" title="Allow event recording."> <span class="box" role="checkbox" aria-checked="true" tabindex="20" aria-labelledby="eventSetting4"></span>
                <label class="checkmark"></label>
                <label class="text" id="eventSetting4">Allow event recording.</label>
                <input type="checkbox" name="eventSetting4box" checked="checked" aria-disabled="true">
              </div>
            </div>
          </fieldset>
        </div>
      </article>
      <article>
        <header>
          <h2>Schedule Options</h2>
          <img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content" alt="Arrow"/></header>
        <div class="content">
          <fieldset>
          	<div class="component" id="startsOn">
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
              <label for="startTime" class="label">Start Time:</label> 
              <input id="startTime" name="startTime"  type="text"  class="input"  tabindex="24" title="Start Time" placeholder="pick start time" autofocus/>            
            </div>
            <div class="component" >
              <label for="eventDuration" class="label">Event Duration:</label> 
              <input id="eventDuration" name="eventDuration"  type="text"  class="input"  tabindex="25" title="Event Duration"  placeholder="minutes" required autofocus/>            
            </div>
            <div class="component">
              <label for="dropdownRecurrence" class="label">Recurrence:</label>
              <select name="dropdownRecurrence" id="dropdownRecurrence" title="Recurrence" tabindex="24" role="listbox" style="width: 402px">
                <option  role="option" selected>Only once</option>
                <option role="option">Daily</option>
                <option role="option">Weekly</option>
                <option role="option">Monthly</option>
              </select>
             
            </div>
            <div style="display: none;" id="selectRepeatsEvery" class="component">
              <label for="repeatsEvery" class="label">Repeats every:</label>
              <input name="repeatsEvery" id="repeatsEvery" class="input" tabindex="25" title="Repeats every"  type="number">
            </div>
            <div class="component" id="selectOccursBy">
              <label for="dropdownOccursBy" class="label">Occurs by:</label>
              <select name="dropdownOccursBy" id="dropdownOccursBy" title="Occurs by" tabindex="26" role="listbox" style="width: 402px">
                <option role="option" selected="selected">Day of the month</option>
                <option role="option">First occurrence of the day of the week</option>
                <!-- 
                <option role="option">Second occurrence of the day of the week</option>
                <option role="option">Third occurrence of the day of the week</option>
                <option role="option">Fourth occurrence of the day of the week</option>
                <option role="option">Last occurrence of the day of the week</option>
                -->
              </select>
            </div>
            <div id="selectDayoftheMonth" class="component">
              <label for="dropdownDayoftheMonth" class="label">Day of the month:</label>
              <select name="dropdownDayoftheMonth" id="dropdownDayoftheMonth" title="Day of the month" tabindex="27" role="listbox" style="width: 402px">
                <option role="option" value="1" selected = "selected">1st</option>
                <option role="option" value="2">2nd</option>
                <option role="option" value="3">3rd</option>
                <option role="option" value="4">4th</option>
                <option role="option" value="5">5th</option>
                <option role="option" value="6">6th</option>
                <option role="option" value="7">7th</option>
                <option role="option" value="8">8th</option>
                <option role="option" value="9">9th</option>
                <option role="option" value="10">10th</option>
                <option role="option" value="11">11th</option>
                <option role="option" value="12">12th</option>
                <option role="option" value="13">13th</option>
                <option role="option" value="14">14th</option>
                <option role="option" value="15">15th</option>
                <option role="option" value="16">16th</option>
                <option role="option" value="17">17th</option>
                <option role="option" value="18">18th</option>
                <option role="option" value="19">19th</option>
                <option role="option" value="20">20th</option>
                <option role="option" value="21">21st</option>
                <option role="option" value="22">22nd</option>
                <option role="option" value="23">23rd</option>
                <option role="option" value="24">24th</option>
                <option role="option" value="25">25th</option>
                <option role="option" value="26">26th</option>
                <option role="option" value="27">27th</option>
                <option role="option" value="28">28th</option>
                <option role="option" value="29">29th</option>
                <option role="option" value="30">30th</option>
                <option role="option" value="31">31st</option>
                <option role="option" value="32">Last day of the month</option>
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
              <label for="dropdownEnds" class="label">Ends:</label>
              <select name="dropdownEnds" id="dropdownEnds" title="Ends" tabindex="22" role="listbox" style="width: 402px">
                <option role="option" selected="selected">After # of occurrence(s)</option>
                <option role="option">On specified date</option>               
              </select>
            </div>
            <div id="occurrencesNumber" class="component">
              <label for="occurrences" class="label">Occurrences:</label>
              <input type="number" name="occurrences" id="occurrences" class="input" tabindex="36" title="Occurrences"  placeholder="# of occurrences" min="1" value="1"/>
            </div>
            <div id="occurrenceEnds" class="component">
              <label for="dropdownMonthEnds" class="label">Date:</label>
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
          </fieldset>
        </div>
      </article>
      <!-- 
      <article>
        <header>
          <h2>Add attendee</h2>
          <img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content" alt="Arrow"/></header>
        <div class="content">
          <fieldset>
            <div class="component">
              <label for="searchBoxAddAttendee" class="label">Search User:</label>
              <button type="button" name="search" class="search" tabindex="38" title="Search user" onclick="searchUser()"></button><div id="responseDiv"></div>
              <input type="text" name="searchBox" id="searchBoxAddAttendee" class="searchBox" tabindex="37" title="Search user">
            </div>
            <div id="tableAddAttendee" class="tableComponent">
              <h4></h4>
              <table id="addAttendee" border="0" cellpadding="0" cellspacing="0">
                <thead>
                  <tr>
                    <th width="100" class="firstColumn" tabindex="16" title="Username">Username<span></span></th>
                    <th title="Name">Name<span></span></th>
                    <th width="230" title="E-mail">E-mail<span></span></th>
                    <th width="85" title="User type">User type<span></span></th>
                    <th width="65" title="Department">Dept.<span></span></th>
                    <th width="65" title="Add" class="icons" align="center">Add</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td class="row">ystallonne</td>
                    <td>Ystallonne Alves</td>
                    <td>ystallonne@seneca.ca</td>
                    <td>Student</td>
                    <td>ITC</td>
                    <td class="icons" align="center"><a href="#" class="add"><img src="images/iconPlaceholder.svg" width="17" height="17" title="Add user to attendees list" alt="Add"/></a></td>
                  </tr>
                </tbody>
              </table>
            </div>
          </fieldset>
        </div>
      </article>
      <article>
        <header>
          <h2>Attendees List</h2>
          <img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content" alt="listbox"/></header>
        <div class="content">
          <fieldset>
            <div class="tableComponent">
              <table id="attendeesList" border="0" cellpadding="0" cellspacing="0">
                <thead>
                  <tr>
                    <th width="100" class="firstColumn" tabindex="16" title="Username">Username<span></span></th>
                    <th title="Name">Name<span></span></th>
                    <th width="230" title="E-mail">E-mail<span></span></th>
                    <th width="85" title="User type">User type<span></span></th>
                    <th width="65" title="Department">Dept.<span></span></th>
                    <th width="65" title="Remove" class="icons" align="center">Remove</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td class="row">ystallonne</td>
                    <td>Ystallonne Alves</td>
                    <td>ystallonne@seneca.ca</td>
                    <td>Student</td>
                    <td>ITC</td>
                    <td class="icons" align="center"><a href="#" class="remove"><img src="images/iconPlaceholder.svg" width="17" height="17" title="Remove user from attendees list" alt="Add"/></a></td>
                  </tr>
                  <tr>
                    <td class="row" title="aberdeenshire">aberdenshire</td>
                    <td>Aberdeenshire City</td>
                    <td>aberdeenshire@myseneca.ca</td>
                    <td>Student</td>
                    <td>ITC</td>
                    <td class="icons" align="center"><a href="#" class="remove"><img src="images/iconPlaceholder.svg" width="17" height="17" title="Remove user from attendees list" alt="Add"/></a></td>
                  </tr>
                  <tr>
                    <td class="row">angus</td>
                    <td>Angus City</td>
                    <td>angus@seneca.ca</td>
                    <td>Student</td>
                    <td>ITC</td>
                    <td class="icons" align="center"><a href="#" class="remove"><img src="images/iconPlaceholder.svg" width="17" height="17" title="Remove user from attendees list" alt="Add"/></a></td>
                  </tr>
                  <tr>
                    <td class="row">argyll</td>
                    <td>Argyll &amp; Bute</td>
                    <td>argyll@myseneca.ca</td>
                    <td>Student</td>
                    <td>ITC</td>
                    <td class="icons" align="center"><a href="#" class="remove"><img src="images/iconPlaceholder.svg" width="17" height="17" title="Remove user from attendees list" alt="Add"/></a></td>
                  </tr>
                  <tr>
                    <td class="row">edinburgh</td>
                    <td>City of Edinburgh</td>
                    <td>edinburgh@myseneca.ca</td>
                    <td>Student</td>
                    <td>ITC</td>
                    <td class="icons" align="center"><a href="#" class="remove"><img src="images/iconPlaceholder.svg" width="17" height="17" title="Remove user from attendees list" alt="Add"/></a></td>
                  </tr>
                  <tr>
                    <td class="row">clackmannanshire</td>
                    <td>Clackmannanshire</td>
                    <td>clackmannanshire@myseneca.ca</td>
                    <td>Student</td>
                    <td>ITC</td>
                    <td class="icons" align="center"><a href="#" class="remove"><img src="images/iconPlaceholder.svg" width="17" height="17" title="Remove user from attendees list" alt="Add"/></a></td>
                  </tr>
                  <tr>
                    <td class="row">Dumfries &amp; Galloway</td>
                    <td>Dumfries &amp; Galloway</td>
                    <td>dumfries@myseneca.ca</td>
                    <td>Professor</td>
                    <td>ITC</td>
                    <td class="icons" align="center"><a href="#" class="remove"><img src="images/iconPlaceholder.svg" width="17" height="17" title="Remove user from attendees list" alt="Add"/></a></td>
                  </tr>
                  <tr>
                    <td class="row">dundee</td>
                    <td>Dundee City</td>
                    <td>dundee@myseneca.ca</td>
                    <td>Student</td>
                    <td>ITC</td>
                    <td class="icons" align="center"><a href="#" class="remove"><img src="images/iconPlaceholder.svg" width="17" height="17" title="Remove user from attendees list" alt="Add"/></a></td>
                  </tr>
                  <tr>
                    <td class="row">east.ayrshire</td>
                    <td>East Ayrshire</td>
                    <td>east.ayrshire@myseneca.ca</td>
                    <td>Student</td>
                    <td>ITC</td>
                    <td class="icons" align="center"><a href="#" class="remove"><img src="images/iconPlaceholder.svg" width="17" height="17" title="Remove user from attendees list" alt="Add"/></a></td>
                  </tr>
                  <tr>
                    <td class="row">Dunbartonshire </td>
                    <td>6,560</td>
                    <td>@myseneca.ca</td>
                    <td>Student</td>
                    <td>ITC</td>
                    <td class="icons" align="center"><a href="#" class="remove"><img src="images/iconPlaceholder.svg" width="17" height="17" title="Remove user from attendees list" alt="Add"/></a></td>
                  </tr>
                  <tr>
                    <td class="row">East Lothian </td>
                    <td>2,985</td>
                    <td>@myseneca.ca</td>
                    <td>Student</td>
                    <td>ITC</td>
                    <td class="icons" align="center"><a href="#" class="remove"><img src="images/iconPlaceholder.svg" width="17" height="17" title="Remove user from attendees list" alt="Add"/></a></td>
                  </tr>
                  <tr>
                    <td class="row">East Renfrewshire </td>
                    <td>5,460</td>
                    <td>@myseneca.ca</td>
                    <td>Student</td>
                    <td>ITC</td>
                    <td class="icons" align="center"><a href="#" class="remove"><img src="images/iconPlaceholder.svg" width="17" height="17" title="Remove user from attendees list" alt="Add"/></a></td>
                  </tr>
                  <tr>
                    <td class="row">Eilean Siar </td>
                    <td>1,295</td>
                    <td>@myseneca.ca</td>
                    <td>Student</td>
                    <td>ITC</td>
                    <td class="icons" align="center"><a href="#" class="remove"><img src="images/iconPlaceholder.svg" width="17" height="17" title="Remove user from attendees list" alt="Add"/></a></td>
                  </tr>
                  <tr>
                    <td class="row">Falkirk </td>
                    <td>4,740</td>
                    <td>@myseneca.ca</td>
                    <td>Student</td>
                    <td>ITC</td>
                    <td class="icons" align="center"><a href="#" class="remove"><img src="images/iconPlaceholder.svg" width="17" height="17" title="Remove user from attendees list" alt="Add"/></a></td>
                  </tr>
                  <tr>
                    <td class="row">Fife </td>
                    <td>14,650</td>
                    <td>fife@myseneca.ca</td>
                    <td>Student</td>
                    <td>ITC</td>
                    <td class="icons" align="center"><a href="#" class="remove"><img src="images/iconPlaceholder.svg" width="17" height="17" title="Remove user from attendees list" alt="Add"/></a></td>
                  </tr>
                  <tr>
                    <td class="row">Glasgow City </td>
                    <td>25,155</td>
                    <td>glashgow@myseneca.ca</td>
                    <td>Student</td>
                    <td>ITC</td>
                    <td class="icons" align="center"><a href="#" class="remove"><img src="images/iconPlaceholder.svg" width="17" height="17" title="Remove user from attendees list" alt="Add"/></a></td>
                  </tr>
                  <tr>
                    <td class="row">Highland </td>
                    <td>8,110</td>
                    <td>highland@myseneca.ca</td>
                    <td>Student</td>
                    <td>ITC</td>
                    <td class="icons" align="center"><a href="#" class="remove"><img src="images/iconPlaceholder.svg" width="17" height="17" title="Remove user from attendees list" alt="Add"/></a></td>
                  </tr>
                  <tr>
                    <td class="row">Inverclyde</td>
                    <td>3,645</td>
                    <td>inverclyde@myseneca.ca</td>
                    <td>Student</td>
                    <td>ITC</td>
                    <td class="icons" align="center"><a href="#" class="remove"><img src="images/iconPlaceholder.svg" width="17" height="17" title="Remove user from attendees list" alt="Add"/></a></td>
                  </tr>
                  <tr>
                    <td class="row">Midlothian </td>
                    <td>2,620</td>
                    <td>midlothian@myseneca.ca</td>
                    <td>Student</td>
                    <td>ITC</td>
                    <td class="icons" align="center"><a href="#" class="remove"><img src="images/iconPlaceholder.svg" width="17" height="17" title="Remove user from attendees list" alt="Add"/></a></td>
                  </tr>
                </tbody>
              </table>
            </div>
          </fieldset>
        </div>
      </article>
      -->
      <article>
        <h4></h4>
        <fieldset>
          <div class="buttons">
            <button type="submit" name="submit" id="save" class="button" title="Click here to save inserted data">Save</button>
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