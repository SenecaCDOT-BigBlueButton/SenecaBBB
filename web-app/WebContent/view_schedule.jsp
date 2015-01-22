<%@page import="db.DBConnection"%>
<%@page import="sql.User"%>
<%@page import="sql.Meeting"%>
<%@page import="sql.Lecture"%>
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
    <title>SenecaBBB | User Schedule</title>
    <link rel="shortcut icon" href="http://www.senecacollege.ca/favicon.ico">
    <link rel="stylesheet" type="text/css" media="all" href="css/fonts.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/style.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.core.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.theme.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.selectmenu.css">
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/jquery-1.9.1.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/modernizr.custom.79639.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/ui/jquery.ui.core.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/ui/jquery.ui.widget.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/ui/jquery.ui.position.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/ui/jquery.ui.selectmenu.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/ui/jquery.ui.stepper.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/ui/jquery.ui.dataTable.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/moment.js"></script>
    <%
    //Start page validation
    String userId = usersession.getUserId();
    GetExceptionLog elog = new GetExceptionLog();
    if (userId.equals("")) {
        session.setAttribute("redirecturl", request.getRequestURI() + (request.getQueryString()!=null?"?" + request.getQueryString():""));
        response.sendRedirect("index.jsp?message=Please log in");
        return;
    }
    if (!usersession.isSuper()) {
        elog.writeLog("[view_schedule:] " + " username: "+ userId + " tried to access this page, permission denied" + " /n");
        response.sendRedirect("calendar.jsp?message=You don't have permission to access that page!");
        return;
    }
    if (dbaccess.getFlagStatus() == false) {
        elog.writeLog("[view_schedule:] " + "database connection error /n");
        response.sendRedirect("index.jsp?message=Database connection error");
        return;
    } //End page validation
    
    String message = request.getParameter("message");
    String successMessage = request.getParameter("successMessage");
    if (message == null || message == "null") {
        message = "";
    }
    if (successMessage == null) {
        successMessage = "";
    }
           
    User user = new User(dbaccess);
    MyBoolean prof = new MyBoolean();
    HashMap<String, Integer> userSettings = new HashMap<String, Integer>();
    HashMap<String, Integer> meetingSettings = new HashMap<String, Integer>();
    HashMap<String, Integer> roleMask = new HashMap<String, Integer>();
    userSettings = usersession.getUserSettingsMask();
    meetingSettings = usersession.getUserMeetingSettingsMask();
    roleMask = usersession.getRoleMask();
    
    //get all events schedule for specified userID
    String userID = request.getParameter("id");   
    ArrayList<HashMap<String,String>> meetingResult = new ArrayList<HashMap<String,String>>();
    ArrayList<HashMap<String,String>> lectureResult = new ArrayList<HashMap<String,String>>();
    Meeting meet = new Meeting(dbaccess);
    dbaccess.resetFlag();  
    meet.getMeetingsForUser(meetingResult, userID, true, true);
    Lecture lect = new Lecture(dbaccess);
    dbaccess.resetFlag();
    lect.getLecturesForUser(lectureResult, userID, true, true);
    %>
    <script type="text/javascript" >
        //Table
        $(screen).ready(function() {
            /* Meetings List */
            $('#meetingsList').dataTable({
                "sPaginationType": "full_numbers",
                "aoColumnDefs": [{ "bSortable": false, "aTargets":[4]}], 
                "bRetrieve": true, 
                "bDestroy": true
                });
            
            /* Lectures List */
            $('#lectureList').dataTable({
                "sPaginationType": "full_numbers",
                "aoColumnDefs": [{ "bSortable": false, "aTargets":[6]}], 
                "bRetrieve": true, 
                "bDestroy": true
                });
            
            $.fn.dataTableExt.sErrMode = 'throw';
            $('.dataTables_filter input').attr("placeholder", "Filter entries");
        });
        
        /* SELECT BOX */
        $(function(){
            $('select').selectmenu();
        });
        
        //convert UTC to user's local time
        function toUserLocalTime(utcTime){
            var startMoment = moment.utc(utcTime).local().format("YYYY-MM-DD HH:mm:SS");
            return startMoment;
        }
    </script>
</head>
<body>
    <div id="page">
        <jsp:include page="header.jsp"/>
        <jsp:include page="menu.jsp"/>
        <section>
            <header> 
                <!-- BREADCRUMB -->
                <p>
                    <a href="calendar.jsp" tabindex="13">home</a> » 
                    <a href="manage_users.jsp" tabindex="14">manage users</a>» 
                    <a href="view_schedule.jsp" tabindex="15">view user schedule</a>
                </p>
                <!-- PAGE NAME -->
                <h1>User Schedule</h1>
                <div style="text-align:right"><%= "User ID: "+ userID %></div>
                <!-- WARNING MESSAGES -->
                <div class="warningMessage"><%=message %></div>
                <div class="successMessage"><%=successMessage %></div> 
            </header>
            <form>
                <article>
                    <header>
                        <h2>Meeting Schedule</h2>
                        <img class="expandContent" width="9" height="6" src="${pageContext.servletContext.contextPath}/${initParam.ImagesDirectory}/arrowDown.svg" title="Click here to collapse/expand content"/>
                    </header>
                    <div class="content">
                        <fieldset>
                            <div class="component">
                                <div class="tableComponent">
                                    <table id="meetingsList" border="0" cellpadding="0" cellspacing="0">
                                        <thead>
                                            <tr>
                                                <th width="200" class="firstColumn" tabindex="16" title="Meeting Title">Meeting Title<span></span></th>
                                                <th width="160" title="Start Time" tabindex="18">Schedule Time<span></span></th>
                                                <th width="80" title="Duration" tabindex="19">Duration<span></span></th>
                                                <th width="80" title="isCancelled" tabindex="20">Is Cancel<span></span></th>
                                                <th title="Description" tabindex="21">Description<span></span></th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% for(int i=0;i<meetingResult.size();i++){%>
                                            <tr>
                                                <td class='row'><%= meetingResult.get(i).get("ms_title") %></td>
                                                <td><script>document.write(toUserLocalTime("<%= meetingResult.get(i).get("m_inidatetime").substring(0,19) %>"));</script></td>
                                                <td><%= meetingResult.get(i).get("m_duration") %></td>
                                                <td><% if (meetingResult.get(i).get("m_iscancel").equals("1")) out.print("Yes");else out.print(""); %></td>
                                                <td><%= meetingResult.get(i).get("m_description") %></td>
                                            </tr>
                                            <%}%>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </fieldset>
                    </div>
                </article>
                <article>
                    <header>
                        <h2>Leture Schedule</h2>
                        <img class="expandContent" width="9" height="6" src="${pageContext.servletContext.contextPath}/${initParam.ImagesDirectory}/arrowDown.svg" title="Click here to collapse/expand content"/>
                    </header>
                    <div class="content">
                        <fieldset>
                            <div class="component">
                                <div class="tableComponent">
                                    <table id="lectureList" border="0" cellpadding="0" cellspacing="0">
                                        <thead>
                                            <tr>
                                                <th width="160" title="course" tabindex="36">Course Name<span></span></th>
                                                <th width="80" title="lecture_title" tabindex="37">Section<span></span></th>   
                                                <th width="80" title="semesterId" tabindex="37">Semester<span></span></th>
                                                <th width="160" title="Start" tabindex="30">Schedule Time<span></span></th>
                                                <th width="80" title="Duration" tabindex="31">Duration<span></span></th>
                                                <th width="80" title="isCancelled" tabindex="32">Is Cancel<span></span></th>
                                                <th title="Description" tabindex="33">Description<span></span></th>                                                                                                               
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% for(int i=0;i<lectureResult.size();i++){%>
                                            <tr>
                                                <td class='row'><%= lectureResult.get(i).get("c_id") %></td>
                                                <td><%= lectureResult.get(i).get("sc_id") %></td>
                                                <td><%= lectureResult.get(i).get("sc_semesterid") %></td>
                                                <td><script>document.write(toUserLocalTime("<%= lectureResult.get(i).get("l_inidatetime").substring(0,19) %>"));</script></td>
                                                <td><%= lectureResult.get(i).get("l_duration") %></td>
                                                <td><% if (lectureResult.get(i).get("l_iscancel").equals("1")) out.print("Yes");else out.print(""); %></td>
                                                <td><%= lectureResult.get(i).get("l_description") %></td>
                                            </tr>
                                            <%}%>
                                        </tbody>
                                    </table>
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

