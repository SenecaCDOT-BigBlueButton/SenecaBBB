<%@page import="db.DBConnection"%>
<%@page import="sql.*"%>
<%@page import="java.util.*"%>
<%@page import="helper.*"%>
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="ldap" class="ldap.LDAPAuthenticate" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<!doctype html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Seneca | Quick Meeting</title>
<link rel="icon" href="http://www.cssreset.com/favicon.png">
<link rel="stylesheet" type="text/css" media="all" href="css/fonts.css">
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/style.css">
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.core.css">
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.theme.css">
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.timepicker.css">
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.selectmenu.css">
<script type="text/javascript" src="http://code.jquery.com/jquery-1.9.1.js"></script>
<script type="text/javascript" src="js/modernizr.custom.79639.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.position.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.selectmenu.js"></script>
<script type="text/javascript" src="js/ui/jquery.timepicker.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.stepper.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.dataTable.js"></script>
<script type="text/javascript" src="js/componentController.js"></script>
<script type="text/javascript" src="js/checkboxController.js"></script>
<script type="text/javascript" src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.11.1/jquery.validate.min.js"></script>
<script type="text/javascript" src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.11.1/additional-methods.min.js"></script>
<%@ include file="search.jsp" %>
<%
    //Start page validation
    String userId = usersession.getUserId();
    GetExceptionLog elog = new GetExceptionLog();
    if (userId.equals("")) {
        elog.writeLog("[create_quick_meeting:] " + "unauthenticated user tried to access this page /n");
        response.sendRedirect("index.jsp?message=Please log in");
        return;
    }
    if (dbaccess.getFlagStatus() == false) {
        elog.writeLog("[create_quick_meeting:] " + "Database connection error /n");
        response.sendRedirect("index.jsp?error=Database connection error");
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
    HashMap<String, Integer> userSettings = new HashMap<String, Integer>();
    HashMap<String, Integer> meetingSettings = new HashMap<String, Integer>();
    HashMap<String, Integer> roleMask = new HashMap<String, Integer>();
    userSettings = usersession.getUserSettingsMask();
    meetingSettings = usersession.getUserMeetingSettingsMask();
  
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
        $('#startTime').timepicker({ 'scrollDefaultNow': true });
    });
    /* SELECT BOX */
    $(function(){
        $('select').selectmenu();
    });
</script>

<body>
<div id="page">
  <jsp:include page="header.jsp"/>
  <jsp:include page="menu.jsp"/>
    <section>
      <header>
          <p><a href="calendar.jsp" tabindex="13">home</a> » create quick meeting</p>
          <h1>Create Quick Meeting</h1>
          <!-- MESSAGES -->
          <div class="warningMessage"><%=message %></div>
          <div class="successMessage"><%=successMessage %></div> 
      </header>
      <form method="get" action="persist_event.jsp" id="eventForm">
      <article>
        <header>
          <h2>Meeting Details</h2>
          <img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content" alt="Arrow"/></header>
        <div class="content">
          <fieldset>
            <div class="component">
              <label for="eventTitle" class="label">Meeting Title:</label>
              <input name="eventTitle" id="eventTitle" class="input" tabindex="15" title="Event title" type="text" autofocus>
            </div>
            <div class="component" style="z-index: 2;">
              <div class="checkbox" title="Allow event recording."> <span class="box" role="checkbox" aria-checked="true" tabindex="20" aria-labelledby="eventSetting4"></span>
                <label class="checkmark"></label>
                <label class="text" id="eventSetting4">Allow event recording.</label>
                <input type="checkbox" name="eventSetting4box" checked="checked" aria-disabled="true">
              </div>
            </div>
            <div class="component" style="display:none">
              <input id="dropdownRecurrence" name="dropdownRecurrence"  type="text"  value="Only once"/>   
              <input id="eventDescription" name="eventDescription"  type="text"  value="Quick Meeting"/>  
              <input id="dropdownEventType" name="dropdownEventType"  type="text"  value="Meeting"/>   
              <input id="fromquickmeeting" name="fromquickmeeting"  type="text"  value="fromquickmeeting"/>         
            </div>
            <div class="component" >
              <label for="startTime" class="label">Start Time:</label> 
              <input id="startTime" name="startTime"  type="text"  class="input"  tabindex="24" title="Start Time" placeholder="pick start time" autofocus/>            
            </div>
            <div class="component" >
              <label for="eventDuration" class="label">Duration:</label> 
              <input id="eventDuration" name="eventDuration"  type="text"  class="input"  tabindex="25" title="Event Duration"  placeholder="minutes" required autofocus/>            
            </div>
            <div class="component" id="startsOn"  style="display:none;">
              <label for="dropdownMonthStarts" class="label">Date:</label>
              <select  name="dropdownYearStarts" id="dropdownYearStarts" title="Year" tabindex="23" style="width: 120px; ">
              </select>
              <select  name="dropdownDayStarts" id="dropdownDayStarts" title="Day" tabindex="22" role="listbox" style="width: 110px;">
              </select>
              <select  name="dropdownMonthStarts" id="dropdownMonthStarts" title="Month" tabindex="21" role="listbox" style="width: 163px; ">
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
          </fieldset>
        </div>
      </article>
      <article>
        <h4></h4>
        <fieldset>
          <div class="buttons">
            <button type="submit" name="submit" id="save" class="button" title="Click here to save inserted data">Create</button>
            <button type="button" name="button" id="cancel"  class="button" title="Click here to cancel" onclick="window.location.href='calendar.jsp'">Cancel</button>
          </div>
        </fieldset>
      </article>
    </form>
   </section>
   <script>    
   // form validation, edit the regular expression pattern and error messages to meet your needs
   
       $(document).ready(function(){
            $("#help").attr({href:"help_createEvent.jsp" ,
                             target:"_blank"});
            $('#eventForm').validate({
                validateOnBlur : true,
                rules: {
                    eventTitle: {
                       required: true,
                       pattern: /^[- a-zA-Z0-9]+$/
                   },
                   startTime:{
                       required: true,
                       pattern: /^\s*[0-2][0-9]:[0-5][0-9]:[0-5][0-9]\s*$/
                   },
                   eventDuration:{
                       required: true,
                       range:[1,999]
                       
                   }                  
                },
                messages: {
                    eventTitle: { 
                        pattern:"Please enter a valid Title.",
                        required:"Title is required"
                    },
                    startTime:"Please enter a valid Time Format",
                    eventDuration:"Please enter a valid Number",
                }
            });

           
        });
  </script>
  <jsp:include page="footer.jsp"/>
</div>
</body>