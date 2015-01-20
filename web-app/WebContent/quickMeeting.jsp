<%@page import="db.DBConnection"%>
<%@page import="sql.*"%>
<%@page import="java.util.*"%>
<%@page import="helper.*"%>
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="ldap" class="ldap.LDAPAuthenticate" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SenecaBBB | Quick Meeting</title>
    <link rel="shortcut icon" href="http://www.senecacollege.ca/favicon.ico">
    <link rel="stylesheet" type="text/css" media="all" href="css/fonts.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/style.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.core.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.theme.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.timepicker.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.selectmenu.css">
    <script type="text/javascript" src="js/jquery-1.9.1.js"></script>
    <script type="text/javascript" src="js/modernizr.custom.79639.js"></script>
    <script type="text/javascript" src="js/ui/jquery.ui.core.js"></script>
    <script type="text/javascript" src="js/ui/jquery.ui.widget.js"></script>
    <script type="text/javascript" src="js/ui/jquery.ui.position.js"></script>
    <script type="text/javascript" src="js/ui/jquery.ui.selectmenu.js"></script>
    <script type="text/javascript" src="js/ui/jquery.timepicker.js"></script>
    <script type="text/javascript" src="js/ui/jquery.ui.stepper.js"></script>
    <script type="text/javascript" src="js/componentController.js"></script>
    <script type="text/javascript" src="js/checkboxController.js"></script>
    <script type="text/javascript" src="js/jquery.validate.min.js"></script>
    <script type="text/javascript" src="js/additional-methods.min.js"></script>
    <script type="text/javascript" src="js/moment.js"></script>
    <%@ include file="search.jsp" %>
    <%
    //Start page validation
    String userId = usersession.getUserId();
    GetExceptionLog elog = new GetExceptionLog();
    if (userId.equals("")) {
        session.setAttribute("redirecturl",request.getRequestURI() + (request.getQueryString() != null ? "?" + request.getQueryString() : ""));
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
        message = "";
    }
    if (successMessage == null) {
        successMessage = "";
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
        $(document).ready(function() { 
            $('#startTime').timepicker({ 'scrollDefaultNow': true , 'timeFormat': 'H:i:s'});
        });
        /* SELECT BOX */
        $(function(){
            $('select').selectmenu();
        });
        
        function toUTC(){
            var today = new Date();
            var startYear = today.getFullYear();
            var startMonth = today.getMonth()+1; //getMonth return 0-11, we need 1-12
            var startDay = today.getDate();
            // we need 01,02 ...09
            if(startDay.length == 1){
                startDay = "0" + startDay;
            }           
            if(startMonth.length == 1){
                startDay = "0" + startMonth;
            }        
            var startTime = $("#startTime").val();           
            var utcdayTime = moment(startYear + "-" + startMonth + "-" + startDay + " " + startTime).utc();
            var currentUTCTime = moment.utc();
            //check event start time, it must be later than current time
            if(utcdayTime.isBefore(currentUTCTime)){
                $(".warningMessage").text("Event Start Time must be later than current time!");
                var notyMsg = noty({text: '<div>'+ $(".warningMessage").text()+' <img  class="notyCloseButton" src="css/themes/base/images/x.png" alt="close" /></div>',
                                    layout:'top',
                                    type:'error'});
                return false;
            }else{
                $("#startUTCDateTime").attr("value",utcdayTime.format("YYYY-MM-DD HH:mm:SS"));
                return true;
            }
        }
    </script>
</head>
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
            <form method="get" action="persist_event.jsp?" id="eventForm" onsubmit="return toUTC()">
                <article>
                    <header>
                        <h2>Meeting Details</h2>
                        <img class="expandContent" width="9" height="6" src="${pageContext.servletContext.contextPath}/${initParam.ImagesDirectory}/arrowDown.svg" title="Click here to collapse/expand content" alt="Arrow"/>
                    </header>
                    <div class="content">
                        <fieldset>
                            <div class="component">
                                <label for="eventTitle" class="label">Meeting Title:</label>
                                <input name="eventTitle" id="eventTitle" class="input" tabindex="15" title="Event title" type="text" autofocus>
                            </div>
                            <div class="component" >
                              <label for="startTime" class="label">Start Time:</label> 
                              <input id="fromquickmeeting" name="fromquickmeeting"   type="hidden" value="fromquickmeeting"  /> 
                              <input name="startUTCDateTime" id="startUTCDateTime" hidden="hidden" />
                              <input id="startTime" name="startTime"  type="text"  class="input"  tabindex="24" title="Start Time" placeholder="pick start time" autofocus/>            
                            </div>
                            <div class="component" >
                              <label for="eventDuration" class="label">Duration:</label> 
                              <input id="eventDuration" name="eventDuration"  type="text"  class="input"  tabindex="25" title="Event Duration"  placeholder="minutes" required autofocus/>            
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
                jQuery.validator.addMethod("timeFormat", function(value, element) {
                    return this.optional(element) ||  /^\s*(?:(?!24:00:00).)*\s*$/.test(value);
                });
                $('#eventForm').validate({
                    validateOnBlur : true,
                    rules: {
                        eventTitle: {
                           required: true,
                           pattern: /^[- a-zA-Z0-9]+$/
                       },
                       startTime:{
                           required: true,
                           pattern: /^\s*[0-2][0-9]:[0-5][0-9]:[0-5][0-9]\s*$/,
                           timeFormat:true
                       },
                       eventDuration:{
                           required: true,
                           range:[1,999]                           
                       }
                    },
                    messages: {
                        eventTitle: { 
                            pattern:"Please enter a valid Title.",
                            required:"Meeting Title is required"
                        },
                        startTime:{
                            pattern:"Please enter a valid Time Format",
                            required:"Start time is required",
                            timeFormat:"Accept 00:00:00 ~ 23:59:59 only"
                        },
                        eventDuration:"Number Only",
                    }
                });
            });
       
      </script>
      <jsp:include page="footer.jsp"/>
    </div>
</body>