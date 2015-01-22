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
    <title>SenecaBBB | Help: Create Event</title>
    <link rel="shortcut icon" href="http://www.senecacollege.ca/favicon.ico">
    <link rel="stylesheet" type="text/css" media="all" href="${pageContext.servletContext.contextPath}/${initParam.CSSDirectory}/fonts.css">
    <link rel="stylesheet" type="text/css" media="all" href="${pageContext.servletContext.contextPath}/${initParam.CSSDirectory}/themes/base/style.css">
    <link rel="stylesheet" type="text/css" media="all" href="${pageContext.servletContext.contextPath}/${initParam.CSSDirectory}/themes/base/jquery.ui.core.css">
    <link rel="stylesheet" type="text/css" media="all" href="${pageContext.servletContext.contextPath}/${initParam.CSSDirectory}/themes/base/jquery.ui.theme.css">
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/jquery-1.9.1.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/ui/jquery.ui.core.js"></script>

    <%
    //Start page validation
    String userId = usersession.getUserId();
    if (userId.equals("")) {
        response.sendRedirect("index.jsp?message=Please log in");
        return;
    }
    String message = request.getParameter("message");
    String successMessage = request.getParameter("successMessage");
    if (message == null || message == "null") {
        message = "";
    }
    if (successMessage == null) {
        successMessage = "";
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
                <h1>Help Page: Create/Edit Event</h1>
                <br />
                <!-- WARNING MESSAGES -->
                <div class="warningMessage"><%=message %></div>
                <div class="successMessage"><%=successMessage %></div> 
            </header>
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
                            <li><b>Only once:</b> single event that occurs only once.</li>
                            <li><b>Daily:</b> all events happen in a single fixed interval</li>
                            <li><b>Weekly:</b> events will happen by day of the week, mutiple days of week possible</li>
                            <li><b>Monthly:</b> events will happen by day of the month, multiple days of month NOT possible</li> 
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
                            <li>Choose START DATE and START TIME, note that the start datetime must be later than current datetime.</li>
                            <li>Enter EVENT DURATION in minutes (positive interger only).</li>
                            <li>Choose the Daily option in the RECURRENCE dropdown list.</li>
                            <li>Enter the interval between events in the REPEATS EVERY field (positive integer only).<br />
                                Example: Enter the number 2 means the event repeats every 2 days.</li>
                            <li>Choose when this schedule ends, there are 2 options:
                                <ol>
                                    <li><b>After # of occurrence(s):</b> schedule stops after a fixed number of events have occurred.<br />
                                        You must enter the number of events (positive integer) in the OCCURRENCES field.</li>
                                    <li><b>On specified date:</b> schedule will run until a date is reached.<br />
                                        You must enter the schedule termination date in the END DATE field.</li>
                                </ol>
                            </li>
                        </ol>
                    </fieldset>
                </div>
            </article>
            <article>
                <div class="content">
                    <fieldset>
                    <hr />
                        <h2>Tutorial: Create weekly schedule</h2>
                        <ol>
                            <li>Choose START DATE and START TIME, note that the start datetime must be later than current datetime.</li>
                            <li>Enter EVENT DURATION in minutes (positive interger only).</li>
                            <li>Choose the Weekly option in the RECURRENCE dropdown list.</li>
                            <li>In the REPEATS EVERY field, enter the interval between events (positive integer only).<br />
                                Example: Enter the number 2 means that an event repeats every 2 weeks.</li>
                            <li>Select the day(s) of the week by clicking on the corresponding icons, selected icons will be appear in grey.</li>
                            <li>Choose when this schedule ends, there are 3 options:
                                <ol>
                                    <li><b>After # of occurrence(s):</b> schedule stops after a fixed number of events have occurred.<br />
                                        You must enter the number of events (positive integer) in the OCCURRENCES field.<br />
                                        Note that this counts the total number of events.</li>
                                    <li><b>On specified date:</b> schedule will run until a date is reached.<br />
                                        You must enter the schedule termination date in the END DATE field.</li>
                                    <li><b>After # of occurrence(s):</b> schedule stops after a fixed number of event weeks have occurred.<br />
                                        You must enter the number of events (positive integer) in the OCCURRENCES field.<br />
                                        Note that this only counts the number of event weeks (weeks with no event do not count).</li>  
                                </ol>
                            </li>
                        </ol>
                    </fieldset>
                </div>
            </article>
            <article>
                <div class="content">
                    <fieldset>
                    <hr />
                        <h2>Tutorial: Create monthly schedule</h2>
                        <ol>
                            <li>Choose START DATE and START TIME, note that the start datetime must be later than current datetime.</li>
                            <li>Enter EVENT DURATION in minutes (positive interger only).</li>
                            <li>Choose the Monthly option in the RECURRENCE dropdown list.</li>
                            <li>In the REPEATS EVERY field, enter the interval between events (positive integer only).<br />
                                Example: Enter the number 2 means that an event repeats every 2 months.</li>
                            <li>In the OCCURS BY field, there are 2 options:
                                <ol>
                                    <li><b>Day of the month:</b> events occur on a fixed date each month, 
                                        if the selected day do not exist in a month (29th, 30th, or 31th), 
                                        then the event will occur on the last day of month).</li>
                                    <li><b>First occurrence of the day of the week:</b> events will occur each month on the first occurrence of the selected day of week.<br />
                                        Example: select Monday means event occurs on the first Monday of the scheduled months.</li>
                                </ol>
                            </li>
                            <li>In the OCCURRENCES field, enter the total number of events.</li>
                        </ol>
                    </fieldset>
                </div>
            </article>
        </section>
        <jsp:include page="footer.jsp"/>
    </div>
</body>
</html>
