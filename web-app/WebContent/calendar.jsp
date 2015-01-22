<%@page import="sql.User"%>
<%@page import="sql.Meeting"%>
<%@page import="sql.Lecture"%>
<%@page import="java.util.ArrayList" %>
<%@page import="java.util.HashMap" %>
<%@page import="helper.*"%>
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SenecaBBB | Event Calendar</title>
    <link rel="shortcut icon" href="http://www.senecacollege.ca/favicon.ico">
    <link rel="stylesheet" type="text/css" media="all" href="css/fonts.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/style.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.core.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.theme.css">
    <link rel='stylesheet' type="text/css" href='fullcalendar-1.6.3/fullcalendar/fullcalendar.css'>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/jquery-1.9.1.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/ui/jquery-ui.js"></script>
    <script type="text/javascript" src='fullcalendar-1.6.3/fullcalendar/fullcalendar.js'></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/modernizr.custom.79639.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/ui/jquery.ui.core.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/ui/jquery.ui.widget.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/ui/jquery.ui.position.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/checkboxController.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/moment.js"></script>
    
    <%
    String message = request.getParameter("message");
    String successMessage = request.getParameter("successMessage");
    String welcomeMessage = request.getParameter("welcomeMessage");
    GetExceptionLog elog = new GetExceptionLog();
    String lectureJSON = "";
    String meetingJSON = "";
    String totalEventJSON = "";
    if (message == null || message == "null") {
        message="";
    }
    if (successMessage == null) {
        successMessage="";
    }
    if (welcomeMessage == null) {
        welcomeMessage="";
    }
    
    boolean check1 = true, check2 = true, check3 = true, check4 = true;
    if (request.getParameter("filtering") != null) {
        check1 = request.getParameter("filterOption1box") != null;
        check2 = request.getParameter("filterOption2box") != null;
        check3 = request.getParameter("filterOption3box") != null;
        check4 = request.getParameter("filterOption4box") != null;
    }
    
    ArrayList<HashMap<String, String>> result = new ArrayList<HashMap<String, String>>();
    Meeting meet = new Meeting(dbaccess);
    dbaccess.resetFlag();
    if (!meet.getMeetingsForUser(result, usersession.getUserId(), check1, check3)) {
        message = meet.getErrMsg("CAL01");
        elog.writeLog("[calendar:] " + message +"/n");
        response.sendRedirect("logout.jsp?message=" + message);
        return;
    }
    meetingJSON = meetingDBToJSON(result);
    Lecture lect = new Lecture(dbaccess);
    dbaccess.resetFlag();
    if (!lect.getLecturesForUser(result, usersession.getUserId(), check2, check4)) {
        message = meet.getErrMsg("CAL02");
        elog.writeLog("[calendar:] " + message +"/n");
        response.sendRedirect("logout.jsp?message=" + message);
        return;
    }
    lectureJSON = lectureDBToJSON(result);
    if(!lectureJSON.isEmpty() && !meetingJSON.isEmpty())
    {
        totalEventJSON=lectureJSON.concat(",").concat(meetingJSON);
    }
    else
    {
        totalEventJSON = meetingJSON + lectureJSON;
    }
    %>
</head>
<body>
    <div id="page">
        <jsp:include page="header.jsp"/>
        <jsp:include page="menu.jsp"/>
        <script>
            $(screen).ready(function(){
                // make the filter options hidden once the page has loaded
                $('#filterOptions').click();
            });
            var allEventJson = [<%= totalEventJSON %>];
            for(var i=0; i<allEventJson.length;i++){
                allEventJson[i].start = moment.utc(allEventJson[i].start).toDate();
                allEventJson[i].end = moment(allEventJson[i].start).add(allEventJson[i].end,'minutes').toDate();
            }
            $(document).ready(function() {
                $('#fullcalendar').fullCalendar({
                    header: {
                        left: 'prev,next today',
                        center: 'title',
                        right: 'month,agendaWeek,agendaDay'
                    },
                    editable: false,
                    allDayDefault: false,
                    events: allEventJson
                });
            });
        </script>
        <section>
            <header>
                <p><a href="calendar.jsp" tabindex="13">home</a> » </p>
                <h1>Calendar</h1>
                <!-- MESSAGES -->
                <div class="warningMessage"><%=message %></div>
                <div class="successMessage"><%=successMessage %></div>
                <div class="welcomeMessage"><%=welcomeMessage %></div>
            </header>
            <form>
                <article>
                    <header id="filterOptions">
                        <h2>Filter Options</h2>
                        <img class="expandContent" width="9" height="6" src="${pageContext.servletContext.contextPath}/${initParam.ImagesDirectory}/arrowDown.svg" title="Click here to collapse/expand content" alt="Arrow"/>
                    </header>
                <div class="content">
                    <fieldset>
                        <div class="component">
                            <div class="checkbox" title="Meetings you created."> <span class="box" role="checkbox" <%= (check1 ? "aria-checked='true'" : "aria-checked='false'") %> tabindex="17" aria-labelledby="filterOption1"></span>
                                <label class="checkmark" <%= (check1 ? "" : "style='display:none'") %>></label>
                                <label class="text" id="filterOption1">Meetings you created.</label>
                                <input type="checkbox" name="filterOption1box" <%= (check1 ? "checked='checked'" : "") %> aria-disabled="true" />
                            </div>
                        </div>
                        <div class="component">
                            <div class="checkbox" title="Lectures you created."> <span class="box" role="checkbox" <%= (check2 ? "aria-checked='true'" : "aria-checked='false'") %> tabindex="18" aria-labelledby="filterOption2"></span>
                                <label class="checkmark" <%= (check2 ? "" : "style='display:none'") %>></label>
                                <label class="text" id="filterOption2">Lectures you created.</label>
                                <input type="checkbox" name="filterOption2box" <%= (check2 ? "checked='checked'" : "") %> aria-disabled="true">
                            </div>
                        </div>
                        <div class="component">
                            <div class="checkbox" title="Meetings you were invited to attend."> <span class="box" role="checkbox" <%= (check3 ? "aria-checked='true'" : "aria-checked='false'") %> tabindex="19" aria-labelledby="filterOption3"></span>
                                <label class="checkmark" <%= (check3 ? "" : "style='display:none'") %>></label>
                                <label class="text" id="filterOption3">Meetings you were invited to attend.</label>
                                <input type="checkbox" name="filterOption3box" <%= (check3 ? "checked='checked'" : "") %> aria-disabled="true">
                            </div>
                        </div>
                        <div class="component">
                            <div class="checkbox" title="Lectures you were invited to attend."> <span class="box" role="checkbox" <%= (check4 ? "aria-checked='true'" : "aria-checked='false'") %> tabindex="20" aria-labelledby="filterOption4"></span>
                                <label class="checkmark" <%= (check4 ? "" : "style='display:none'") %>></label>
                                <label class="text" id="filterOption4">Lectures you were invited to attend.</label>
                                <input type="checkbox" name="filterOption4box" <%= (check4 ? "checked='checked'" : "") %> aria-disabled="true">
                            </div>
                        </div>
                        <input type="hidden" name="filtering" />
                    </fieldset>
                    <fieldset>
                        <div class="buttons">
                            <button type="submit" name="submit" id="save" class="button" title="Click here to submit filter options">Filter</button>
                        </div>
                    </fieldset>
                </div>
                </article>
            </form>
            <div class="content">
                <div class="component">
                    <div id="fullcalendar"></div>
                </div>
            </div>
        </section>
        <jsp:include page="footer.jsp"/>
    </div>
</body>
</html>

<%!
public String meetingDBToJSON(ArrayList<HashMap<String,String>> results) {
    String converted = "";
    for (int i = 0; i < results.size(); ++i) {
        if (i > 0){
            converted += ",";
        }
        converted += "{id: " + results.get(i).get("ms_id") + ", title: '" + results.get(i).get("ms_title") + "',start: '" + results.get(i).get("m_inidatetime") + "',end: '" + results.get(i).get("m_duration") + "', url:'view_event.jsp?ms_id="+results.get(i).get("ms_id")+"&m_id="+results.get(i).get("m_id")+"'}";
    }
    return converted;
}

//     (0)ls_id (1)l_id (2)l_inidatetime (3)l_duration (4)l_iscancel (5)l_description (6)l_modpass (7)l_userpass (8)c_name (9)sc_id
public String lectureDBToJSON(ArrayList<HashMap<String,String>> results) {
    String converted = "";
    for (int i = 0; i < results.size(); ++i) {
        if (i > 0){
            converted += ",";
        }
        converted += "{id: " + results.get(i).get("ls_id") + ",title: '" + results.get(i).get("c_id") + results.get(i).get("sc_id") + "',start: '" + results.get(i).get("l_inidatetime") + "',end: '" + results.get(i).get("l_duration") + "',url:'view_event.jsp?ls_id=" + results.get(i).get("ls_id")+"&l_id="+results.get(i).get("l_id")+"'}";
    }
    return converted;
}
%>
