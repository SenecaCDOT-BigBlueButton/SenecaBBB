<%@page import="db.DBConnection"%>
<%@page import="sql.User"%>
<%@page import="sql.Section"%>
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
    <title>SenecaBBB | Subjects</title>
    <link rel="shortcut icon" href="http://www.senecacollege.ca/favicon.ico">
    <link rel="stylesheet" type="text/css" media="all" href="css/fonts.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/style.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.core.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.theme.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.selectmenu.css">
    <script type="text/javascript" src="js/jquery-1.9.1.js"></script>
    <script type="text/javascript" src="js/modernizr.custom.79639.js"></script>
    <script type="text/javascript" src="js/ui/jquery.ui.core.js"></script>
    <script type="text/javascript" src="js/ui/jquery.ui.widget.js"></script>
    <script type="text/javascript" src="js/ui/jquery.ui.position.js"></script>
    <script type="text/javascript" src="js/ui/jquery.ui.selectmenu.js"></script>
    <script type="text/javascript" src="js/ui/jquery.ui.stepper.js"></script>
    <script type="text/javascript" src="js/ui/jquery.ui.dataTable.js"></script>
    
    <%
    //Start page validation
    String userId = usersession.getUserId();
    GetExceptionLog elog = new GetExceptionLog();
    if (userId.equals("")) {
        session.setAttribute("redirecturl", request.getRequestURI()+(request.getQueryString()!=null?"?"+request.getQueryString():""));
        response.sendRedirect("index.jsp?message=Please log in");
        return;
    }
    if (!(usersession.isDepartmentAdmin() || usersession.isSuper())) {
        elog.writeLog("[subjects:] " + " username: "+ userId + " tried to access this page, permission denied" +" /n");
        response.sendRedirect("calendar.jsp?message=You don't have permission to access that page!");
        return;
    }
    if (dbaccess.getFlagStatus() == false) {
        elog.writeLog("[subjects:] " + "database connection error /n");
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
    Section section = new Section(dbaccess);
    ArrayList<HashMap<String,String>> allCourse = new ArrayList<HashMap<String,String>>();
    ArrayList<HashMap<String,String>> sectionInfo = new ArrayList<HashMap<String,String>>();
    ArrayList<HashMap<String,String>> courseProfessor = new ArrayList<HashMap<String,String>>();
    MyBoolean prof = new MyBoolean();
    HashMap<String, Integer> userSettings = new HashMap<String, Integer>();
    HashMap<String, Integer> meetingSettings = new HashMap<String, Integer>();
    HashMap<String, Integer> roleMask = new HashMap<String, Integer>();
    userSettings = usersession.getUserSettingsMask();
    meetingSettings = usersession.getUserMeetingSettingsMask();
    roleMask = usersession.getRoleMask();
    
    section.getSectionInfo(sectionInfo);
    section.getCourse(allCourse);
    %>
    <script type="text/javascript">
        //Table
        $(screen).ready(function() {
            /* Subjects List*/
            $('#subjectsList').dataTable({
                "sPaginationType": "full_numbers",
                "aoColumnDefs": [{ "bSortable": false, "aTargets":[5]}], 
                "bRetrieve": true,
                "bDestroy": true
                });
            $.fn.dataTableExt.sErrMode = 'throw';
            $('.dataTables_filter input').attr("placeholder", "Filter entries");
            $(".remove").click(function(){
                return window.confirm("Are you sure to remove this item?");
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
            <p>
                <a href="calendar.jsp" tabindex="13">home</a> » 
                <a href="subjects.jsp" tabindex="14">subjects</a>
            </p>
            <!-- PAGE NAME -->
            <h1>Subjects</h1>
            <!-- WARNING MESSAGES -->
            <div class="warningMessage"><%=message %></div>
            <div class="successMessage"><%=successMessage %></div> 
        </header>
        <form>
            <article>
                <header>
                    <h2>Subject and Professor</h2>
                    <img class="expandContent" width="9" height="6" src="${pageContext.servletContext.contextPath}/${initParam.ImagesDirectory}/arrowDown.svg" title="Click here to collapse/expand content"/>
                </header>
                <div class="content">
                    <div class="actionButtons">
                        <button type="button" name="button" id="viewCourse" class="button" title="Click here to view all courses" onclick="window.location.href='manage_course.jsp'">Manage Subjects</button>
                        <button type="button" name="button" id="viewProfessor" class="button" title="Click here to view all Professors" onclick="window.location.href='manage_professor.jsp'">Manage Professors</button>    
                        <button type="button" name="button" id="addSection" class="button" title="Click here to add a new section" onclick="window.location.href='create_section.jsp'">Add Section</button>                  
                    </div>
                </div>
            </article>
            <article>
                <header>
                    <h2>Section Created</h2>
                    <img class="expandContent" width="9" height="6" src="${pageContext.servletContext.contextPath}/${initParam.ImagesDirectory}/arrowDown.svg" title="Click here to collapse/expand content"/>
                </header>
                <div class="content">
                    <fieldset>
                        <div class="tableComponent">
                            <table id="subjectsList" border="0" cellpadding="0" cellspacing="0">
                                <thead>
                                    <tr>
                                        <th width="100" class="firstColumn" tabindex="16" title="Username">Subject ID<span></span></th>
                                        <th  width="100" title="Name">Section<span></span></th>
                                        <th  width="100" title="E-mail">Semester<span></span></th>
                                        <th  width="120" title="User type">Department<span></span></th>
                                        <th  title="Department">Subject Name<span></span></th>
                                        <th  width="65" title="Remove" class="icons" align="center">Remove</th>
                                    </tr>
                                </thead>
                                <tbody>
                                <% 
                                for(int i=0; i<sectionInfo.size();i++){
                                    section.getProfessor(courseProfessor,sectionInfo.get(i).get("c_id"),sectionInfo.get(i).get("sc_id"),sectionInfo.get(i).get("sc_semesterid"));
                                %>
                                    <tr>
                                        <td class="row"><%= sectionInfo.get(i).get("c_id") %></td>
                                        <td ><%= sectionInfo.get(i).get("sc_id") %></td>
                                        <td ><%= sectionInfo.get(i).get("sc_semesterid") %></td>
                                        <td ><%= sectionInfo.get(i).get("c_name") %></td>
                                        <td ><%= sectionInfo.get(i).get("d_name") %></td>
                                        <td  align="center">
                                            <a onclick="savePageOffset()" 
                                               href="persist_section.jsp?courseCode=<%= sectionInfo.get(i).get("c_id") %>&courseSection=<%= sectionInfo.get(i).get("sc_id") %>&semesterID=<%= sectionInfo.get(i).get("sc_semesterid") %>&toDel=1" 
                                               class="remove">
                                                <img src="${pageContext.servletContext.contextPath}/${initParam.ImagesDirectory}/iconPlaceholder.svg" width="17" height="17" title="Remove Subject" alt="Remove"/>
                                            </a>
                                        </td>
                                    </tr>
                                <% } %>
                                </tbody>
                            </table>
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