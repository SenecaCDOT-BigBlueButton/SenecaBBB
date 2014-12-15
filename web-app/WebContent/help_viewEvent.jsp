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
    <title>SenecaBBB | Help: View Event</title>
    <link rel="shortcut icon" href="http://www.senecacollege.ca/favicon.ico">
    <link rel="stylesheet" type="text/css" media="all" href="css/fonts.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/style.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.core.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.theme.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.datepicker.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.selectmenu.css">
    <link rel='stylesheet' type="text/css" href='fullcalendar-1.6.3/fullcalendar/fullcalendar.css'>
    <script type="text/javascript" src="js/jquery-1.9.1.js"></script>
    <script type="text/javascript" src='fullcalendar-1.6.3/fullcalendar/fullcalendar.js'></script>
    <script type="text/javascript" src="js/modernizr.custom.79639.js"></script>
    <script type="text/javascript" src="js/ui/jquery.ui.core.js"></script>
    <script type="text/javascript" src="js/ui/jquery.ui.widget.js"></script>
    <script type="text/javascript" src="js/ui/jquery.ui.position.js"></script>
    <script type="text/javascript" src="js/ui/jquery.ui.selectmenu.js"></script>
    <script type="text/javascript" src="js/ui/jquery.ui.stepper.js"></script>
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
        message = "";
    }
    //End page validation
    %>

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
                        <h2>What is the Event Schedule?</h2>
                        <ol>
                            <li>Every event belongs to an event schedule, even if the event occurs only once.</li>
                            <li>Event schedule is displayed in the first table, click on the DETAILS icon to see all events in the schedule.</li>
                            <li>Event schedule can be modified by its creator (meeting event) or the professor (lecture event).</li>
                            <li>A MODIFY icon will appear if you are eligible to edit the schedule.</li>
                        </ol>
                    </fieldset>
                </div>
            </article>
            <article>
                <div class="content">
                    <fieldset>
                    <hr />
                        <h2>How can I create a conference session?</h2>
                        <ol>
                            <li>Check the DATE and TIME fields in the Current Event table, conference session is available 10 minutes before event start time<br />
                                and lasts for the duration specified in the Current Event table.</li>
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
                            <li>BigBlueButton allows video recording of sessions.<br />
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
