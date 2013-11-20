<%@page import="sql.*"%>
<%@page import="java.util.*"%>
<%@page import="helper.*"%>
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<!doctype html>
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Seneca | Help: Create Event</title>
<link rel="icon" href="http://www.cssreset.com/favicon.png">
<link rel="stylesheet" type="text/css" media="all" href="css/fonts.css">
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/style.css">
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.core.css">
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.theme.css">
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.datepicker.css">
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.selectmenu.css">
<link rel='stylesheet' type="text/css" href='fullcalendar-1.6.3/fullcalendar/fullcalendar.css'>
<script type="text/javascript" src="http://code.jquery.com/jquery-1.9.1.js"></script>
<script type="text/javascript" src='fullcalendar-1.6.3/fullcalendar/fullcalendar.js'></script>
<script type="text/javascript" src="js/modernizr.custom.79639.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.position.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.selectmenu.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.stepper.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.dataTable.js"></script>
<script type="text/javascript" src="js/componentController.js"></script>
<%
    //Start page validation
    String userId = usersession.getUserId();
    if (userId.equals("")) {
        response.sendRedirect("index.jsp?message=Please log in");
        return;
    }
    String message = request.getParameter("message");
    if (message == null) {
        message="";
    }
    //End page validation
%>
<script type="text/javascript">
/* TABLE */
$(screen).ready(function() {
    /* CURRENT EVENT */
    //$('#currentEvent').dataTable({"sPaginationType": "full_numbers"});
    //$('#currentEvent').dataTable({"aoColumnDefs": [{ "bSortable": false, "aTargets":[5]}], "bRetrieve": true, "bDestroy": true});
    //$('#tbAttendee').dataTable({"sPaginationType": "full_numbers"});
    //$('#tbAttendee').dataTable({"aoColumnDefs": [{ "bSortable": false, "aTargets":[5]}], "bRetrieve": true, "bDestroy": true});
    //$.fn.dataTableExt.sErrMode = 'throw';
    $('.dataTables_filter input').attr("placeholder", "Filter entries");
});
/* SELECT BOX */
$(function(){
    $('select').selectmenu();
});
$(document).ready(function() {
    //Hide some tables on load
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
            <h1>Help Page: View Event</h1>
            <br />
            <!-- WARNING MESSAGES -->
            <div class="warningMessage"><%=message %></div>
        </header>
        <form action="persist_user_settings.jsp" method="post">
        <article>
            <div class="content">
                <fieldset>
                <hr />
                    <h2>What is the difference between event and event schedule?</h2>
                    <ol>
                        <li>Every event belongs to an event schedule, even if the event occurs only once.</li>
                    </ol>
                </fieldset>
            </div>
        </article>
         <article>
            <div class="content">
                <fieldset>
                <hr />
                    <h2>What schedule options are available?</h2>
                    <ol>
                        <li>Only once: single event that occurs only once.</li>
                        <li>Daily: all events happen in a single fixed interval</li>
                        <li>Weekly: events will happen by day of the week, mutiple days of week possible</li>
                        <li>Monthly: events will happen by day of the month, multiple days of month NOT possible</li> 
                    </ol>
                </fieldset>
            </div>
        </article>
        <article>
            <div class="content">
                <fieldset>
                <hr />
                    <h2>Tutorial: Create daily schedule</h2>
                    <ol>
                        <li>Check the DATE and TIME fields in the Current Event table, conference session is available 10 minutes before event time<br />
                            and lasts for the duration specified in the Current Event (NOT the Event Schedule) table.</li>
                        <li>When video session becomes available, a "Create Event" link will appear above the Event Schedule table,<br />
                            click on the link to start the conference session.</li>
                        <li>You can only create a conference session if you are the creator or professor of the current event.<br />
                            Check the TYPE field in Current Event table to determine your role.</li>
                    </ol>
                </fieldset>
            </div>
        </article>
        <article>
            <div class="content">
                <fieldset>
                <hr />
                    <h2>What is the Current Event Type?</h2>
                    <ol>
                        <li>Event can be a meeting or lecture.<br />
                        <li>For meeting event, there are 3 subtypes:
                                <ol>
                                    <li>Meeting (C): You are the creator of this meeting event</li>
                                    <li>Meeting (A): You are invited to attend all events in the current meeting schedule</li>
                                    <li>Meeting (G): You are invited to attend the current event as a guest</li>
                                </ol>
                        </li>
                        <li>For lecture event, there are 3 subtypes:
                                <ol>
                                    <li>Lecture (T): You are scheduled to teach this session</li>
                                    <li>Lecture (S): You are a student and should attend all sessions in the current lecture schedule</li>
                                    <li>Lecture (G): You are invited to attend the current event as a guest</li>
                                </ol>
                        </li>
                        <li>The above information is also available in the Legend table on the bottom of the View Event page.</li>
                    </ol>
                </fieldset>
            </div>
        </article>
        <article>
            <div class="content">
                <fieldset>
                <hr />
                    <h2>What is Recording?</h2>
                    <ol>
                        <li>BiGBlueButton allows video recording of sessions.<br />
                        <li>If there were recordings made of the selected event, you will find links to them on View_Event page after the session ended.</li>
                    </ol>
                </fieldset>
            </div>
        </article>
        </form>
    </section>
    <jsp:include page="footer.jsp"/>
</div>
</body>
</html>
