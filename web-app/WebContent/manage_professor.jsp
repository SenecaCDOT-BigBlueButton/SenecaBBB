<%@page import="db.DBConnection" %>
<%@page import="sql.User" %>
<%@page import="sql.Section" %>
<%@page import="java.util.*" %>
<%@page import="helper.*" %>
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session"/>
<jsp:useBean id="usersession" class="helper.UserSession" scope="session"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SenecaBBB | Professors</title>
    <link rel="shortcut icon" href="http://www.senecacollege.ca/favicon.ico">
    <link rel="stylesheet" type="text/css" media="all" href="${pageContext.servletContext.contextPath}/${initParam.CSSDirectory}/fonts.css">
    <link rel="stylesheet" type="text/css" media="all" href="${pageContext.servletContext.contextPath}/${initParam.CSSDirectory}/themes/base/style.css">
    <link rel="stylesheet" type="text/css" media="all" href="${pageContext.servletContext.contextPath}/${initParam.CSSDirectory}/themes/base/jquery.ui.core.css">
    <link rel="stylesheet" type="text/css" media="all" href="${pageContext.servletContext.contextPath}/${initParam.CSSDirectory}/themes/base/jquery.ui.theme.css">
    <link rel="stylesheet" type="text/css" media="all" href="${pageContext.servletContext.contextPath}/${initParam.CSSDirectory}/themes/base/jquery.ui.selectmenu.css">
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/jquery-1.9.1.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/modernizr.custom.79639.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/ui/jquery.ui.core.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/ui/jquery.ui.widget.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/ui/jquery.ui.position.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/ui/jquery.ui.selectmenu.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/ui/jquery.ui.stepper.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/ui/jquery.ui.dataTable.js"></script>
    <script type="text/javascript">
        //Table
        $(screen).ready(function () {
            /* Professor List */
            $('#professorList').dataTable({
                "sPaginationType": "full_numbers",
                "aoColumnDefs": [{ "bSortable": false, "aTargets": [4]}], 
                "bRetrieve": true, 
                "bDestroy": true
                });
            $.fn.dataTableExt.sErrMode = 'throw';
            $('.dataTables_filter input').attr("placeholder", "Filter entries");
            $(".remove").click(function () {
                return window.confirm("Are you sure to remove this item?");
                ;
            });
        });
        /* SELECT BOX */
        $(function () {
            $('select').selectmenu();
        });
    </script>
    <%
    //Start page validation
    String userId = usersession.getUserId();
    GetExceptionLog elog = new GetExceptionLog();
    if (userId.equals("")) {
        session.setAttribute("redirecturl",request.getRequestURI() + (request.getQueryString() != null ? "?" + request.getQueryString() : ""));
        response.sendRedirect("index.jsp?error=Please log in");
        return;
    }
    if (!(usersession.isDepartmentAdmin() || usersession.isSuper())) {
        elog.writeLog("[manage_professor:] " + " username: " + userId + " tried to access this page, permission denied" + " /n");
        response.sendRedirect("calendar.jsp?message=You don't have permission to access that page");
        return;
    }
    if (dbaccess.getFlagStatus() == false) {
        elog.writeLog("[manage_professor:] " + "database connection error /n");
        response.sendRedirect("index.jsp?error=Database connection error");
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
    ArrayList<HashMap<String, String>> allProfessors = new ArrayList<HashMap<String, String>>();
    MyBoolean prof = new MyBoolean();
    HashMap<String, Integer> userSettings = new HashMap<String, Integer>();
    HashMap<String, Integer> meetingSettings = new HashMap<String, Integer>();
    HashMap<String, Integer> roleMask = new HashMap<String, Integer>();
    userSettings = usersession.getUserSettingsMask();
    meetingSettings = usersession.getUserMeetingSettingsMask();
    roleMask = usersession.getRoleMask();
    section.getProfessor(allProfessors);
    %>

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
                <a href="subjects.jsp" tabindex="14">subjects</a> »
                <a href="manage_professor.jsp" tabindex="14">manage professor</a>
            </p>
            <!-- PAGE NAME -->
            <h1>Professors List</h1>
            <!-- WARNING MESSAGES -->
            <div class="warningMessage"><%= message %></div>
            <div class="successMessage"><%= successMessage %></div>
        </header>
        <form>
            <article>
                <header>
                    <h2>Professors</h2>
                    <img class="expandContent" width="9" height="6" src="${pageContext.servletContext.contextPath}/${initParam.ImagesDirectory}/arrowDown.svg"
                         title="Click here to collapse/expand content"/>
                </header>
                <div class="content">
                    <fieldset>
                        <div class="actionButtons" style="margin-bottom:15px">
                            <button type="button" name="button" id="addProfessor" class="button"
                                    title="Click here to add a professor"
                                    onclick="window.location.href='create_professor.jsp'">Add Professor
                            </button>
                        </div>
                        <% if (usersession.isSuper() || usersession.isDepartmentAdmin()) { %>
                        <div class="tableComponent">
                            <table id="professorList" border="0" cellpadding="0" cellspacing="0">
                                <thead>
                                    <tr>
                                        <th width="100" class="firstColumn" tabindex="16" title="courseid">Professor
                                            ID<span></span></th>
                                        <th width="200" title="coursename">Subject ID<span></span></th>
                                        <th width="200" title="sectionID">Section ID<span></span></th>
                                        <th width="200" title="semesterID">Semester ID<span></span></th>
                                        <th width="65" title="Remove" class="icons" align="center">Remove</th>
                                    </tr>
                                </thead>
                                <tbody>
                                <% for (int j = 0; j < allProfessors.size(); j++) {%>
                                    <tr>
                                        <td class="row"><%= allProfessors.get(j).get("bu_id") %></td>
                                        <td><%= allProfessors.get(j).get("c_id") %></td>
                                        <td><%= allProfessors.get(j).get("sc_id") %></td>
                                        <td><%= allProfessors.get(j).get("sc_semesterid") %></td>
                                        <td align="center">
                                            <a href="persist_professor.jsp?bu_id=<%= allProfessors.get(j).get("bu_id") %>&c_id=<%= allProfessors.get(j).get("c_id") %>&sc_id=<%= allProfessors.get(j).get("sc_id") %>&sc_semesterid=<%= allProfessors.get(j).get("sc_semesterid") %>&toDel=1"
                                               class="remove">
                                               <img src="${pageContext.servletContext.contextPath}/${initParam.ImagesDirectory}/iconPlaceholder.svg" width="17" height="17" title="Remove Professor" alt="Remove"/>
                                            </a>
                                        </td>
                                    </tr>
                                <% } %>
                                </tbody>
                            </table>
                        </div>
                        <% } %>
                    </fieldset>
                </div>
            </article>
        </form>
    </section>
    <jsp:include page="footer.jsp"/>
</div>
</body>
</html>