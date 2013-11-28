<%@page import="db.DBConnection"%>
<%@page import="sql.*"%>
<%@page import="java.util.*"%>
<%@page import="helper.*"%>
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<!doctype html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Edit Lecture</title>
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
<script type="text/javascript" src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.11.1/jquery.validate.min.js"></script>
<script type="text/javascript" src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.11.1/additional-methods.min.js"></script>

<%
    //Start page validation
    String userId = usersession.getUserId();
    if (userId.equals("")) {
        response.sendRedirect("index.jsp?message=Please log in");
        return;
    }
    String message = request.getParameter("message");
    if (message == null || message == "null") {
        message = "";
    }
    String l_id = request.getParameter("l_id");
    String ls_id = request.getParameter("ls_id");
    if (l_id==null || ls_id==null) {
        response.sendRedirect("calendar.jsp?message=Please do not mess with the URL");
        return;
    }
    l_id = Validation.prepare(l_id);
    ls_id = Validation.prepare(ls_id);
    if (!(Validation.checkLId(l_id) && Validation.checkLsId(ls_id))) {
        response.sendRedirect("calendar.jsp?message=" + Validation.getErrMsg());
        return;
    }
    User user = new User(dbaccess);
    Lecture lecture = new Lecture(dbaccess);
    MyBoolean myBool = new MyBoolean();    
    if (!lecture.isLecture(myBool, ls_id, l_id)) {
        message = lecture.getErrMsg("EL01");
        response.sendRedirect("logout.jsp?message=" + message);
        return;   
    }
    if (!myBool.get_value()) {
        response.sendRedirect("calendar.jsp?message=You do not permission to access that page");
        return;
    }
    if (!user.isTeaching(myBool, ls_id, userId)) {
        message = user.getErrMsg("EL02");
        response.sendRedirect("logout.jsp?message=" + message);
        return;   
    }
    if (!myBool.get_value()) {
        if (!user.isGuestTeaching(myBool, ls_id, l_id, userId)) {
            message = user.getErrMsg("EL03");
            response.sendRedirect("logout.jsp?message=" + message);
            return;   
        }
        if (!myBool.get_value()) {
            response.sendRedirect("calendar.jsp?message=You do not permission to access that page");
            return;
        }
    }
    // End page validation
    
    boolean edited = false;
    boolean editError = false;
    String startTime = request.getParameter("startTime");
    if (startTime!=null) {
        if (!Validation.checkStartTime(startTime)) {
            message += Validation.getErrMsg();
            editError = true;
        } else {
            if (!lecture.updateLectureTime(1, ls_id, l_id, startTime)) {
                message += user.getErrMsg("EL04");
                response.sendRedirect("logout.jsp?message=" + message);
                return;  
            } else {
                edited = true;
            }
        }
    }
    
    String duration = request.getParameter("eventDuration");
    if (duration!=null) {
        if (!Validation.checkDuration(duration)) {
            message += "<br />" + Validation.getErrMsg();
            editError = true;
        } else {
            if (!lecture.updateLectureDuration(1, ls_id, l_id, duration)) {
                message += user.getErrMsg("EL05");
                response.sendRedirect("logout.jsp?message=" + message);
                return;  
            } else {
                edited = true;
            }
        }
    }
    
    String description = request.getParameter("description");
    if (description!=null) {
        if (!Validation.checkDescription(description)) {
            message += "<br />" + Validation.getErrMsg();
            editError = false;
        } else {
            if (!lecture.setLectureDescription(ls_id, l_id, description)) {
                message += user.getErrMsg("EL06");
                response.sendRedirect("logout.jsp?message=" + message);
                return;  
            } else {
                edited = true;
            }
        }
    }
    
    if (edited) {
	    String cancelEvent = request.getParameter("cancelEventBox");
	    if (cancelEvent!=null && cancelEvent.equals("on")) {
	        if (!lecture.setLectureIsCancel(ls_id, l_id, true)) {
	            message += user.getErrMsg("EL07");
	            response.sendRedirect("logout.jsp?message=" + message);
	            return;  
	        }
	    } else if (cancelEvent==null) {
	        if (!lecture.setLectureIsCancel(ls_id, l_id, false)) {
                message += user.getErrMsg("EL08");
                response.sendRedirect("logout.jsp?message=" + message);
                return;  
            } 
	    }
    }
    
    if (edited && !editError) {
        message = "Event Details Updated";
        response.sendRedirect("view_event.jsp?ls_id=" + ls_id + "&l_id=" + l_id + "&message=" + message);
        return;  
    }
    
    ArrayList<ArrayList<String>> event = new ArrayList<ArrayList<String>>();
    if (!lecture.getLectureInfo(event, ls_id, l_id)) {
        message = lecture.getErrMsg("EL09");
        response.sendRedirect("logout.jsp?message=" + message);
        return;   
    }    
    
    ArrayList<ArrayList<String>> eventSchedule = new ArrayList<ArrayList<String>>();
    if (!lecture.getLectureScheduleInfo(eventSchedule, ls_id)) {
        message = lecture.getErrMsg("EL10");
        response.sendRedirect("logout.jsp?message=" + message);
        return;   
    }
    
    boolean check1 = event.get(0).get(4).equals("1") ? true : false;
%>

<script type="text/javascript">
/* TABLE */
$(screen).ready(function() {
    /* CURRENT EVENT */   
 //   $('#tbEvent').dataTable({"sPaginationType": "full_numbers"});
  //  $('#tbEvent').dataTable({"aoColumnDefs": [{ "bSortable": false, "aTargets":[5]}], "bRetrieve": true, "bDestroy": true});        
  //  $.fn.dataTableExt.sErrMode = 'throw';
  //  $('.dataTables_filter input').attr("placeholder", "Filter entries");
    $('#startTime').timepicker({ 'scrollDefaultNow': true });
    
    /* CHECKBOXES */
    $('.checkbox .box').keydown(function() {
        if (event.which == 13){
            event.preventDefault(event);
            $(this).next(".checkmark").toggle();
            $(this).attr("aria-checked", ($(this).attr("aria-checked") === "true" ? "false" : "true"));
            
            if (($(this).siblings().last().is(":checked"))){
                $(this).siblings().last().prop("checked", false);
            } else {
                $(this).siblings().last().prop("checked", true);
            }
        }
    });
    
    $('.checkbox .box').click(function(event) {
        $(this).next(".checkmark").toggle();
        
        if (($(this).attr("aria-checked") === "true")) {
            $(this).attr("aria-checked", "false");
            ($(this).siblings().last())[0].checked = false;
        } else {
            $(this).attr("aria-checked", "true");
            ($(this).siblings().last())[0].checked = true;
        }
    });
    
    $('.checkbox .checkmark').click(function() {
        $(this).toggle();
        
        if (($(this).siblings().first().attr("aria-checked") === "true")) {
            $(this).siblings().first().attr("aria-checked", "false");
            ($(this).siblings().last())[0].checked = false;
        } else {
            $(this).siblings().first().attr("aria-checked", "true");
            ($(this).siblings().last())[0].checked = true;
        }
    });
});
/* SELECT BOX */
$(function(){
    $('select').selectmenu();
});
</script>
</head>

<body>
<div id="page">
    <jsp:include page="header.jsp"/>
    <jsp:include page="menu.jsp"/>
    <section>
        <header> 
            <!-- BREADCRUMB -->
            <p><a href="calendar.jsp" tabindex="13">home</a> » 
                <a href="view_event.jsp?ls_id=<%= ls_id %>&l_id=<%= l_id %>" tabindex="14">view_event</a> » 
                <a href="edit_lecture.jsp?ls_id=<%= ls_id %>&l_id=<%= l_id %>" tabindex="15">edit_event</a></p>
            <!-- PAGE NAME -->
            <h1>Lecture Event</h1>
            <br />
            <!-- WARNING MESSAGES -->
            <div class="warningMessage"><%=message %></div>
        </header>
        <form name="EditLecture" method="get" action="edit_lecture.jsp">
            <article>
                <header>
                    <h2>Current Event</h2>
                </header>
                <div class="content">
                    <fieldset>
                        <div id="currentEventDiv" class="tableComponent">
                            <table id="tbEvent" border="0" cellpadding="0" cellspacing="0">
                                <thead>
                                    <tr>
                                        <th class="firstColumn" tabindex="16" title="Course">Course<span></span></th>
                                        <th title="Section">Section<span></span></th>
                                        <th title="Semester">Semester<span></span></th>
                                        <th title="Date">Date<span></span></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td class="row"><%= eventSchedule.get(0).get(1) %></td>
                                        <td><%= eventSchedule.get(0).get(2) %></td>
                                        <td><%= eventSchedule.get(0).get(3) %></td>
                                        <td><%= event.get(0).get(2).substring(0, 10) %></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </fieldset>
                </div>
            </article>
            <article>
                <header>
                    <h2>Edit Form</h2>
                    <img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content"/>
                </header>
                <div class="content">
                    <fieldset>
                        <input type="hidden" name="ls_id" id="ls_id" value="<%= ls_id %>">
                        <input type="hidden" name="l_id" id="l_id" value="<%= l_id %>">  
                        <div class="component" >
                            <label for="startTime" class="label">Start Time:</label> 
                            <input id="startTime" name="startTime"  type="text"  class="input"  value="<%= event.get(0).get(2).substring(11, 19) %>" tabindex="24" title="Start Time" placeholder="pick start time" autofocus/>            
                        </div>
                        <div class="component" >
                            <label for="eventDuration" class="label">Duration:</label> 
                            <input id="eventDuration" name="eventDuration"  type="number"  class="input"  tabindex="25" title="Event Duration"  value="<%= event.get(0).get(3) %>" placeholder="minutes" required autofocus/>            
                        </div>
                        <div class="component" >
                            <label for="description" class="label">Description:</label>
                            <textarea name="description" id="description" class="input" cols="35" rows="5" title="Description" autofocus><%= event.get(0).get(5) %></textarea>           
                        </div>
                        <div class="component">
                            <div class="checkbox" title="Cancel Event"> <span class="box" role="checkbox" 
                                <%= (check1 ? "aria-checked='true'" : "aria-checked='false'") %> 
                                tabindex="26" arialabelledby="cancelEvent"></span>
                                <label class="checkmark" <%= (check1 ? "" : "style='display:none'") %>></label>
                                <label class="text" id="cancelEvent">Cancel Lecture</label>
                                <input type="checkbox" name="cancelEventBox" <%= (check1 ? "checked='checked'" : "") %> aria-disabled="true"/>
                            </div>
                        </div>
                        <div class="component">
                            <div class="buttons">
                               <button type="submit" class="button" title="Click here to save">Save</button>
                               <button type="reset" class="button" title="Click here to reset">Reset</button>
                               <button type="button" class="button" title="Click here to cancel" 
                                onclick="window.location.href='view_event.jsp?ls_id=<%= ls_id %>&l_id=<%= l_id %>'">Cancel</button>
                            </div>
                        </div>
                    </fieldset>
                </div>
            </article>
        </form>
    </section>
    <jsp:include page="footer.jsp"/>
</div>
</body>
</html>