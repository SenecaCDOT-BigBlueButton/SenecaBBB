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
    <title>SenecaBBB | Help: View Event Schedule</title>
    <link rel="shortcut icon" href="http://www.senecacollege.ca/favicon.ico">
    <link rel="stylesheet" type="text/css" media="all" href="css/fonts.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/style.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.core.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.theme.css">
    <script type="text/javascript" src="js/jquery-1.9.1.js"></script>
    <script type="text/javascript" src="js/ui/jquery.ui.core.js"></script>
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
                        <h2>How can I add guest or presentation?</h2>
                        <ol>
                            <li>Only attendee/student belongs to the entire event schedule.</li>
                            <li>Guest and presentation are for individual event.
                            <li>Click the DETAILS icon in the Event List table to show an event in details and add guest or presentation there.</li>
                        </ol>
                    </fieldset>
                </div>
            </article>
        </section>
        <jsp:include page="footer.jsp"/>
    </div>
</body>
</html>
