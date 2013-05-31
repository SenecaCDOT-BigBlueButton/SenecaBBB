<%@ page contentType="text/html; charset=iso-8859-1" language="java"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
    <head>
        <link rel='stylesheet' type='text/css' href='css/calendar_layout.css' />
        <link rel='stylesheet' type='text/css' href='fullcalendar/fullcalendar.css' />
        <link rel='stylesheet' type='text/css' href='fullcalendar/fullcalendar.print.css' media='print' />
        <script type='text/javascript' src='jquery/jquery-1.8.1.min.js'></script>
        <script type='text/javascript' src='jquery/jquery-ui-1.8.23.custom.min.js'></script>
        <script type='text/javascript' src='fullcalendar/fullcalendar.min.js'></script>
        <script type='text/javascript' src='fullcalendar/date.js'></script>
        <script type='text/javascript'>
            <% String type = (String) session.getAttribute("iUserType");%>
            var user = "<%=type%>";
            function create(date) {
                if (date === undefined)
                    date = "";
                if (user == "student" || user == "employee" || user == "guest")
                    window.location.replace("event_details2.jsp?create=true&date=" + date);
                else
                    window.location.replace("event_details.jsp?create=true&date=" + date);
            }
            $(document).ready(function() {

                var date = new Date();
                var d = date.getDate();
                var m = date.getMonth();
                var y = date.getFullYear();
                var weekday = new Array(7);
                weekday[0] = "Sunday";
                weekday[1] = "Monday";
                weekday[2] = "Tuesday";
                weekday[3] = "Wednesday";
                weekday[4] = "Thursday";
                weekday[5] = "Friday";
                weekday[6] = "Saturday";


                $('#calendar').fullCalendar({
                    header: {
                        left: 'prev,next today',
                        center: 'title',
                        right: 'month,agendaWeek,agendaDay'
                    },
                    eventClick: function(calEvent, jsEvent, view) {
                        var todayStart = new Date(Date.today());
                        var todayEnd = new Date(Date.today().add(1).day())
                        if (calEvent.start.between(todayStart, todayEnd))
                        {
                                window.location.href = calEvent.event+"true";
                        }
                        else
                            window.location.href = calEvent.event + "false";
                    },
                    dayClick: function(date, allDay, jsEvent, view) {

                       create(date);

                        // change the day's background color just for fun
                        $(this).css('background-color', 'red');

                    },
                    editable: true
                });

                if (user == "student" || user == "professor" || user == "admin" || user == "superadmin")
                {
                    $('#calendar').fullCalendar('addEventSource',
                            function(start, end, callback) {
                                // When requested, dynamically generate virtual
                                // events for every monday and wednesday.
                                var events = [];

                                for (loop = start.getTime();
                                        loop <= end.getTime();
                                        loop = loop + (24 * 60 * 60 * 1000)) {

                                    var test_date = new Date(loop);

                                    if (test_date.is().monday()) {
                                        // we're in Moday, create the event
                                        events.push({
                                            editable: false,
                                            title: 'Lecture',
                                            start: new Date(test_date.getFullYear(), test_date.getMonth(), test_date.getDate(), 15, 20),
                                            allDay: false,
                                            link: "http://www.google.ca",
                                            event: "event_details.jsp?date=" + new Date(test_date.getFullYear(), test_date.getMonth(), test_date.getDate(), 15, 20) + "&link=www.yahoo.ca&start=",
                                            color: 'blue'
                                        });
                                    }
                                } // for loop

                                // return events generated
                                callback(events);
                            }
                    );
                }
                var events = [];
                events.push({
                    title: 'Meeting 1',
                    start: new Date(y, m, d, 16, 0),
                    end: new Date(y, m, d, 17, 0),
                    allDay: false,
                    color: 'black',
                    event: "event_details2.jsp?date=" + new Date(y, m, d, 16, 0) + "&day=" + weekday[new Date(y, m, d, 16, 0).getDay()] + "&name=" + "Meeting 1" + "&link=www.yahoo.ca&start=",
                    link: "http://www.google.ca"
                });
                events.push({
                    title: 'Meeting 2',
                    start: new Date(y, m, d + 2, 17, 0),
                    end: new Date(y, m, d + 2, 18, 0),
                    allDay: false,
                    color: 'black',
                    event: "event_details2.jsp?date=" + new Date(y, m, d + 2, 17, 0) + "&day=" + weekday[new Date(y, m, d + 2, 17, 0).getDay()] + "&name=" + "Meeting 2" + "&link=www.yahoo.ca&start=",
                    link: "http://www.google.ca"
                });

                if (user == "student" || user == "admin" || user == "superadmin")
                {
                    $('#calendar').fullCalendar('renderEvent', events[0], true);
                    $('#calendar').fullCalendar('renderEvent', events[1], true);
                }
                function run() {
                    var d = $('#calendar').fullCalendar('getDate');
                    alert("The current date of the calendar is " + d);
                }
            });
        </script>
        <style type='text/css'>
            #calendar {
                width: 900px;
                margin: 0 auto;
            }

        </style>
    </head>
    <body>
        <div id="header">
            <h1>Calendar</h1>
            <p id="layoutdims">
                <%
                    String name = (String) session.getAttribute("sUserName");
                    out.write("<strong>" + name + "</strong>");
                %>
                View type: 
                <select name="view">
                    <option value="calendar">Calendar</option>
                    <option value="grid">Grid</option>
                </select>
                <%
                    out.write("You are a <strong>" + type + "</strong>");
                %>
            </p>
        </div>
        <div class="colmask leftmenu">
            <div class="colleft">
                <div class="col1">
                    <input type="button" onclick="create()" value="Create Event"/> 
                    <div id='calendar'></div>
                </div>
                <div class="col2">
                    <a href ="settings.jsp">User Settings</a><br/><br/>
                    <%
                        String level = (String) session.getAttribute("iUserType");
                        if (level.equals("professor")) {
                            out.write("<a href =\"class_settings.jsp\">Class Settings</a><br><br>");
                        }
                        if (level.equals("admin") || level.equals("superadmin")) {
                            out.write("<a href =\"manage_professors.jsp\">Manage Professors</a><br><br>");
                            out.write("<a href =\"manage_users.jsp\">Manage Users</a><br><br>");
                        }
                    %>
                    <a href="index.jsp?error=Logged out"><strong>Log out</strong></a>
                </div>
            </div>
        </div>
        <div id="footer">
            This is the footer
        </div>
        <button type="button" id="my-button" class="my-button" onclick="run()">Date range</button>       
    </body>
</html>
