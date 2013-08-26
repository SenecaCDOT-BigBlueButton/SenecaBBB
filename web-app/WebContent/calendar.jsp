<%@page import="db.DBConnection"%>
<%@page import="sql.User"%>
<%@page import="java.util.*"%>
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<!doctype html>
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Seneca | Change Settings</title>
<link rel="shortcut icon" href="http://www.cssreset.com/favicon.png" />
<!--<link href="css/themes/base/style.css" rel="stylesheet" type="text/css" media="screen and (min-width:1280px)">-->
<link href="css/themes/base/style.css" rel="stylesheet" type="text/css" media="all">
<link href="css/fonts.css" rel="stylesheet" type="text/css" media="all">
<script type="text/javascript" src="http://code.jquery.com/jquery-1.9.1.js"></script>
<script type="text/javascript" src="js/modernizr.custom.79639.js"></script>
<script type="text/javascript" src="js/component.js"></script>
<script type="text/javascript" src="js/componentStepper.js"></script>
 <script type='text/javascript'>
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
                            window.location.href = calEvent.event + "true";
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
            });
            function run() {
                var d = $('#calendar').fullCalendar('getDate');
                alert("The current date of the calendar is " + d + user);
            }
</script>
</head>
<body>
<div id="page">
  <jsp:include page="header.jsp"/>
  <jsp:include page="menu.jsp"/>
   <div id='calendar'></div>
  <jsp:include page="footer.jsp"/>
</div>
</body>
</html>