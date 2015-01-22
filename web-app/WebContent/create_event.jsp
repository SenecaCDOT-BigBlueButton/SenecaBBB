<%@page import="db.DBConnection"%>
<%@page import="sql.*"%>
<%@page import="java.util.*"%>
<%@page import="helper.*"%>
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SenecaBBB | Create Event</title>
    <link rel="shortcut icon" href="http://www.senecacollege.ca/favicon.ico">
    <link rel="stylesheet" type="text/css" media="all" href="css/fonts.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/style.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.core.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.theme.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.datepicker.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.timepicker.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.selectmenu.css">
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/jquery-1.9.1.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/modernizr.custom.79639.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/ui/jquery.ui.core.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/ui/jquery.ui.widget.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/ui/jquery.ui.position.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/ui/jquery.ui.selectmenu.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/ui/jquery.ui.datepicker.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/ui/jquery.timepicker.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/ui/jquery.ui.stepper.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/componentController.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/checkboxController.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/jquery.validate.min.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/additional-methods.min.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/moment.js"></script>
    
    <%
    //Start page validation
    String userId = usersession.getUserId();
    GetExceptionLog elog = new GetExceptionLog();
    Boolean isProfessor = usersession.isProfessor();
    Boolean isSuper = usersession.isSuper();
    if (userId.equals("")) {
        session.setAttribute("redirecturl", request.getRequestURI()+(request.getQueryString()!=null?"?"+request.getQueryString():""));
        response.sendRedirect("index.jsp?message=Please log in");
        return;
    }
    if (dbaccess.getFlagStatus() == false) {
        elog.writeLog("[create_event:] " + "Database connection error /n");
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
    Section section = new Section(dbaccess);
    Meeting meeting = new Meeting(dbaccess);
    Lecture lecture = new Lecture(dbaccess);
    ArrayList<HashMap<String,String>> professor = new ArrayList<HashMap<String,String>>();
    HashMap<String, Integer> userSettings = new HashMap<String, Integer>();
    HashMap<String, Integer> meetingSettings = new HashMap<String, Integer>();
    HashMap<String, Integer> roleMask = new HashMap<String, Integer>();
    userSettings = usersession.getUserSettingsMask();
    meetingSettings = usersession.getUserMeetingSettingsMask();
    roleMask = usersession.getRoleMask();
    if(isSuper){
        lecture.getAllProfessorCourse(professor); 
    }
    else if(isProfessor){
        lecture.getProfessorCourse(professor,userId);
    }
    %>

    <script type="text/javascript">
        $(document).ready(function() {
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
        function toUTC(){
            var startYear = $("#dropdownYearStarts option:selected").text();
            var startMonth = getMonthNumber($("#dropdownMonthStarts option:selected").text());
            var startDay = $("#dropdownDayStarts option:selected").text();
            if(startDay.length ==1){
                startDay = "0" + startDay;
            }
            var startTime = $("#startTime").val();
            
            var utcdayTime = moment(startYear + "-" + startMonth + "-" + startDay + " " + startTime).utc();
            var currentUTCTime = moment.utc();
            if(utcdayTime.isBefore(currentUTCTime)){
                $(".warningMessage").text("Event Start Date&Time must be later than current Date&Time!");
                var notyMsg = noty({text: '<div>'+ $(".warningMessage").text()+' <img  class="notyCloseButton" src="css/themes/base/images/x.png" alt="close" /></div>',
                                    layout:'top',
                                    type:'error'});
                return false;
            }else{
                $("#startUTCDateTime").attr("value",utcdayTime.format("YYYY-MM-DD HH:mm:SS"));
                return true;
            }
        }
        
        function getMonthNumber(month) {
            var monthNumber = "";
            if(month != null && month !== undefined){
                var selectedMon = month.toLowerCase();
                if(selectedMon === "january"){
                    monthNumber = "01";
                }else if(selectedMon === "february"){
                    monthNumber = "02";
                }else if(selectedMon === "march"){
                    monthNumber = "03";
                }else if(selectedMon === "april"){
                    monthNumber = "04";
                }else if(selectedMon === "may"){
                    monthNumber = "05";
                }else if(selectedMon === "june"){
                    monthNumber = "06";
                }else if(selectedMon === "july"){
                    monthNumber = "07";
                }else if(selectedMon === "august"){
                    monthNumber = "08";
                }else if(selectedMon === "september"){
                    monthNumber = "09";
                }else if(selectedMon === "october"){
                    monthNumber = "10";
                }else if(selectedMon === "november"){
                    monthNumber = "11";
                }else if(selectedMon === "december"){
                    monthNumber = "12";
                }
            }
            return monthNumber;
        }
    
    var weekString = "0000000";
    $(document).ready(function(){
        $('#week button').click(function(e) {
            var weekday = $(e.target).text();
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
</head>

<body>
    <div id="page">
        <jsp:include page="header.jsp"/>
        <jsp:include page="menu.jsp"/>
        <section>
            <header>
                <p><a href="calendar.jsp" tabindex="13">home</a> » create event</p>
                <h1>Create Event</h1>
                <!-- MESSAGES -->
                <div class="warningMessage"><%=message %></div>
                <div class="successMessage"><%=successMessage %></div>
            </header>
            <form method="get" action="persist_event.jsp" id="eventForm" onsubmit="return toUTC()">
                <article>
                    <header>
                        <h2>Event Details</h2>
                        <img class="expandContent" width="9" height="6" src="${pageContext.servletContext.contextPath}/${initParam.ImagesDirectory}/arrowDown.svg" title="Click here to collapse/expand content" alt="Arrow"/>
                    </header>
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
                                <input name="eventDescription" id="eventDescription" class="input" tabindex="17" title="Event title"  autofocus />
                            </div>
                            <div class="component" id="lectureCourse">
                                <label for="courseCode" class="label">Course Information:</label>
                                <select name="courseCode" id="courseCode" tabindex="18" title="Course Name" style="width: 402px"  autofocus>
                                    <% 
                                    if(isSuper && !professor.isEmpty()){ 
                                        for(int i=0;i<professor.size();i++){  %>
                                            <option value="<%= professor.get(i).get("bu_id").concat(" ").concat(professor.get(i).get("c_id")).concat(" ").concat(professor.get(i).get("sc_id")).concat(" ").concat(professor.get(i).get("sc_semesterid")) %>" >
                                            <%= professor.get(i).get("bu_id").concat(" ").concat(professor.get(i).get("c_id")).concat(" ").concat(professor.get(i).get("sc_id")).concat(" ").concat(professor.get(i).get("sc_semesterid")) %></option>
                                            <%  
                                        }
                                    }
                                    else if(isProfessor && !professor.isEmpty()){
                                        for(int j=0;j<professor.size();j++){  %>
                                            <option value="<%= professor.get(j).get("c_id").concat(" ").concat(professor.get(j).get("sc_id")).concat(" ").concat(professor.get(j).get("sc_semesterid")) %>" >
                                            <%= professor.get(j).get("c_id").concat(" ").concat(professor.get(j).get("sc_id")).concat(" ").concat(professor.get(j).get("sc_semesterid")) %></option>
                                            <%  
                                        } 
                                    }
                                    else{%>
                                        <option> No subjects in system!</option>
                                    <% } %>               
                                </select>
                            </div>
                        </fieldset>
                    </div>
                </article>
                <article>
                    <header>
                        <h2>Schedule Options</h2>
                        <img class="expandContent" width="9" height="6" src="${pageContext.servletContext.contextPath}/${initParam.ImagesDirectory}/arrowDown.svg" title="Click here to collapse/expand content" alt="Arrow"/>
                    </header>
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
                                <input name="startUTCDateTime" id="startUTCDateTime" hidden="hidden" />
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
                                <input name="repeatsEvery" id="repeatsEvery" class="input" tabindex="25" title="Repeats every"  type="number" min = "1">
                            </div>
                            <div class="component" id="selectOccursBy">
                                <label for="dropdownOccursBy" class="label">Occurs by:</label>
                                <select name="dropdownOccursBy" id="dropdownOccursBy" title="Occurs by" tabindex="26" role="listbox" style="width: 402px">
                                    <option role="option" selected="selected">Day of the month</option>
                                    <option role="option">First occurrence of the day of the week</option>
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
                        </fieldset>
                    </div>
                </article>
                <article>
                    <h4></h4>
                    <fieldset>
                        <div class="buttons">
                            <button type="submit" name="submit" id="save" class="button" title="Click here to save inserted data">Save</button>
                            <button type="button" name="button" id="cancel"  class="button" title="Click here to cancel" onclick="window.location.href='calendar.jsp'">Cancel</button>
                        </div>
                    </fieldset>
                </article>
            </form>
        </section>
        <script>
            // form validation, edit the regular expression pattern and error messages to meet your needs
            $(document).ready(function(){
                $("#help").attr({href:"help_createEvent.jsp",target:"_blank"});
                jQuery.validator.addMethod("timeFormat", function(value, element) {
                    return this.optional(element) || /^\s*(?:(?!24:00:00).)*\s*$/.test(value);
                });
                
                $('#eventForm').validate({
                    validateOnBlur : true,
                    rules: {
                        eventTitle: {
                            required: true,
                            minlength: 3,
                            maxlength: 50,
                            pattern: /^[- a-zA-Z0-9]+$/
                        },
                        eventDescription:{
                            required: false,
                            maxlength: 100,
                            pattern: /^[^<>]+$/
                        },
                        startTime:{
                            required: true,
                            pattern: /^\s*[0-2][0-9]:[0-5][0-9]:[0-5][0-9]\s*$/,
                            timeFormat:true
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
                            required:"Title is required",
                            minlength: "Invalid event title length",
                            maxlength: "Invalid event title length"
                        },
                        startTime:{
                            pattern:"Please enter a valid Time Format",
                            required:"Start time is required",
                            timeFormat:"Accept 00:00:00 ~ 23:59:59 only"
                        },
                            
                        eventDuration:"Please enter a valid Number",
                        repeatsEvery:"Please enter a valid Number",
                        occurrences:"Please enter a valid Number",
                        eventDescription:"Invalid characters"
                    }
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
                            populateMonthStarts($("#dropdownMonthStarts").val());
                            populateMonthEnds($("#dropdownMonthStarts").val());
                            $("#dropdownDayStarts").selectmenu({'refresh': true});
                            $("#dropdownMonthStarts").selectmenu({'refresh': true});
                            $("#dropdownYearStarts").selectmenu({'refresh': true});                          
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
                            populateMonthEnds($("#dropdownMonthEnds").val());
                            $("#dropdownDayEnds").selectmenu({'refresh': true});
                            $("#dropdownMonthEnds").selectmenu({'refresh': true});
                            $("#dropdownYearEnds").selectmenu({'refresh': true});                         
                        }
                    };
                    $("#datePickerStarts").datepicker(datePickerStarts);
                    $("#datePickerEnds").datepicker(datePickerEnds);
                });
            });
       </script>
       <jsp:include page="footer.jsp"/>
    </div>
</body>