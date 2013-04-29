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

            $(document).ready(function() {

                var date = new Date();
                var d = date.getDate();
                var m = date.getMonth();
                var y = date.getFullYear();

                $('#calendar').fullCalendar({
                    header: {
                        left: 'prev,next today',
                        center: 'title',
                        right: 'month,agendaWeek,agendaDay'
                    },
                    eventClick: function(calEvent, jsEvent, view) {
                        alert(calEvent.custom);
                    },
                    editable: true,
                    events: [
                        // some original fullCalendar examples
                        {
                            title: 'First event',
                            start: new Date(y, m, d, 15, 0),
                            end: new Date(y, m, d, 16, 0),
                            allDay: false,
                            custom: "First meeting of multiple",
                            color: 'black'
                        },
                        {
                            title: 'Second event',
                            start: new Date(y, m, d, 16, 0),
                            end: new Date(y, m, d, 17, 0),
                            allDay: false,
                            color: 'black',
                            custom: "Second meeting of multiple"
                        },
                        {
                            title: 'Third event',
                            start: new Date(y, m, d, 17, 0),
                            end: new Date(y, m, d, 18, 0),
                            allDay: false,
                            color: 'black',
                            custom: "Final meeting of multiple"
                        },
                        {
                            title: 'Click for google',
                            start: new Date(y, m, d - 3, 17, 30),
                            allDay: false,
                            custom: "Sending you to Google",
                            url: 'http://google.ca/',
                            color: 'red'
                        }
                    ]
                });

                // adding a every monday and wednesday events:
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
                                        title: 'I hate mondays - Garfield',
                                        start: new Date(test_date.getFullYear(), test_date.getMonth(), test_date.getDate(), 15, 20),
                                        allDay: false,
                                        custom: "Some custom information"
                                    });
                                }

                                if (test_date.is().wednesday()) {
                                    // we're in Wednesday, create the Wednesday event
                                    events.push({
                                        editable: false,
                                        title: 'It\'s the middle of the week!',
                                        start: new Date(test_date.getFullYear(), test_date.getMonth(), test_date.getDate(), 9, 50),
                                        allDay: false,
                                        custom: "Some more custom information",
                                        color: 'green'
                                    });
                                }
                            } // for loop

                            // return events generated
                            callback(events);
                        }
                );
            });
            // adding a every monday and wednesday events:
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
                                    title: 'I hate mondays - Garfield',
                                    start: test_date
                                });
                            }

                            if (test_date.is().wednesday()) {
                                // we're in Wednesday, create the Wednesday event
                                events.push({
                                    title: 'It\'s the middle of the week!',
                                    start: test_date
                                });
                            }
                        } // for loop

                        // return events generated
                        callback(events);
                    }
            );
            function run(){
    var d = $('#calendar').fullCalendar('getDate');
    alert("The current date of the calendar is " + d);
            }
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
                View type: 
                <select name="view">
                    <option value="calendar">Calendar</option>
                    <option value="grid">Grid</option>
                </select>
                <%
                    String type = (String) session.getAttribute("iUserLevel");
                    out.write("You are a <strong>" + type + "</strong>");
                %>
            </p>
        </div>
        <div class="colmask leftmenu">
            <div class="colleft">
                <div class="col1">
                    <div id='calendar'></div>
                </div>
                <div class="col2">
                    <a href ="settings.jsp">User Settings</a><br/><br/>
                    <%
                        String level = (String) session.getAttribute("iUserType");
                        if (level.equals("professor") || level.equals("admin")) {
                            out.write("<a href =\"class_settings.jsp\">Class Settings</a><br><br>");
                        }
                        if (level.equals("admin")) {
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
             <button type="button" id="my-button" class="my-button" onclick="run()">Click Me!</button>       
    </body>
</html>
