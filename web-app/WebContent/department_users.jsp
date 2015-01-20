<%@page import="db.DBConnection"%>
<%@page import="sql.User"%>
<%@page import="sql.Department"%>
<%@page import="java.util.*"%>
<%@page import="helper.*"%>
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<jsp:useBean id="ldap" class="ldap.LDAPAuthenticate" scope="session" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SenecaBBB | Department Users</title>
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
    <script type="text/javascript" src="js/ui/jquery.ui.dataTable.js"></script>
    <%@ include file="search.jsp" %>
    <%
    //Start page validation
    String userId = usersession.getUserId();
    GetExceptionLog elog = new GetExceptionLog();
    if (userId.equals("")) {
        session.setAttribute("redirecturl",request.getRequestURI() + (request.getQueryString() != null ? "?" + request.getQueryString() : ""));
        response.sendRedirect("index.jsp?message=Please log in");
        return;
    }
    if (!usersession.isSuper() && !usersession.isDepartmentAdmin()) {
        elog.writeLog("[department_users:] " + "username: " + userId + "tried to access this page,permission denied" + " /n");
        response.sendRedirect("departments.jsp?message=You do not have permission to access that page");
        return;
    }//End page validation

    boolean validFlag;
    User user = new User(dbaccess);
    Department dept = new Department(dbaccess);
    MyBoolean myBool = new MyBoolean();
    String message = request.getParameter("message");
    String successMessage = request.getParameter("successMessage");
    if (message == null || message == "null") {
        message = "";
    }
    if (successMessage == null) {
        successMessage = "";
    }
    String adminStatus = "";
    String d_code = request.getParameter("DeptCode");
    if (d_code == null) {
        elog.writeLog("[department_users:] " + " invalid department code " + "/n");
        response.sendRedirect("departments.jsp?message=Please do not mess with the URL");
        return;
    }
    d_code = Validation.prepare(d_code);
    if (!Validation.checkDeptCode(d_code)) {
        elog.writeLog("[department_users:] " + Validation.getErrMsg() + "/n");
        response.sendRedirect("departments.jsp?message=" + Validation.getErrMsg());
        return;
    }
    if (!dept.isDepartment(myBool, d_code)) {
        message = "Could not verify department status: " + d_code + dept.getErrMsg("DU01");
        elog.writeLog("[department_users:] " + message + "/n");
        response.sendRedirect("logout.jsp?message=" + message);
        return;
    }
    if (!myBool.get_value()) {
        elog.writeLog("[department_users:] " + " invalid department code " + "/n");
        response.sendRedirect("departments.jsp?message=Department with that code does not exist");
        return;
    }
    if (!usersession.isSuper()) {
        if (!user.isDepartmentAdmin(myBool, usersession.getUserId(),d_code)) {
            message = "Could not verify department admin status for: " + usersession.getUserId() + dept.getErrMsg("DU02");
            elog.writeLog("[department_users:] " + message + "/n");
            response.sendRedirect("logout.jsp?message=" + message);
            return;
        }
        if (!myBool.get_value()) {
            elog.writeLog("[department_users:] " + "username: " + userId + "tried to access this page,permission denied" + " /n");
            response.sendRedirect("departments.jsp?message=You do not have permission to access that page");
            return;
        }
    }
    //End page validation

    // Start User Search
    boolean searchSucess = false;
    String bu_id = request.getParameter("searchBox");
    if (bu_id != null) {
        bu_id = Validation.prepare(bu_id);
        if (!(Validation.checkBuId(bu_id))) {
            message = Validation.getErrMsg();
        } else {
            if (!user.isDepartmentUser(myBool, bu_id, d_code)) {
                message = user.getErrMsg("DU03");
                elog.writeLog("[department_users:] " + message + "/n");
                response.sendRedirect("logout.jsp?message=" + message);
                return;
            }
            // User already added
            if (myBool.get_value()) {
                message = "User already added";
            } else {
                if (!user.isUser(myBool, bu_id)) {
                    message = user.getErrMsg("DU04");
                    elog.writeLog("[department_users:] " + message + "/n");
                    response.sendRedirect("logout.jsp?message=" + message);
                    return;
                }
                // User already in Database
                if (myBool.get_value()) {
                    searchSucess = true;
                } else {
                    // Found userId in LDAP
                    if (findUser(dbaccess, ldap, bu_id)) {
                        searchSucess = true;
                    } else {
                        message = "User Not Found";
                    }
                }
            }
        }
    }

    // End User Search
    if (searchSucess) {
        if (!dept.createDepartmentUser(bu_id, d_code, false)) {
            message = dept.getErrMsg("DU05");
            elog.writeLog("[department_users:] " + message + "/n");
            response.sendRedirect("logout.jsp?message=" + message);
            return;
        } else {
            successMessage = bu_id + " added to department user list";
        }
    } else {
        String mod = request.getParameter("mod");
        String remove = request.getParameter("remove");
        if (mod != null && usersession.isSuper()) {
            mod = Validation.prepare(mod);
            if (!(Validation.checkBuId(mod))) {
                message = Validation.getErrMsg();
            } else {
                if (!dept.setDepartmentAdmin(mod, d_code)) {
                    message = dept.getErrMsg("DU06");
                    elog.writeLog("[department_users:] " + message + "/n");
                    response.sendRedirect("logout.jsp?message=" + message);
                    return;
                } else {
                    successMessage = "Admin status was updated for user " + mod + " from " + d_code;
                }
            }
        } else if (remove != null) {
            remove = Validation.prepare(remove);
            if (!(Validation.checkBuId(remove))) {
                message = Validation.getErrMsg();
            } else {
                if (!user.isDepartmentAdmin(myBool, remove, d_code)) {
                    message = dept.getErrMsg("DU07");
                    elog.writeLog("[department_users:] " + message + "/n");
                    response.sendRedirect("logout.jsp?message=" + message);
                    return;
                }
                if (myBool.get_value() && !usersession.isSuper()) {
                    message = "You do not have permission to delete that user";
                } else {
                    if (!dept.removeDepartmentUser(remove, d_code)) {
                        message = dept.getErrMsg("DU08");
                        elog.writeLog("[department_users:] " + message + "/n");
                        response.sendRedirect("logout.jsp?message=" + message);
                        return;
                    }else{
                        successMessage="User "+ remove +" from "+d_code+" was removed.";
                    }
                }
            }
        }
    }

    ArrayList<HashMap<String, String>> deptUserList = new ArrayList<HashMap<String, String>>();
    if (!dept.getDepartmentUser(deptUserList, d_code)) {
        message = "Could not verify department user list" + dept.getErrMsg("DU03");
        elog.writeLog("[department_users:] " + message + "/n");
        response.sendRedirect("logout.jsp?message=" + message);
        return;
    }
    %>
    <script type="text/javascript">
        $(screen).ready(function() {
            /* TABLE */
            $('#departmentUsersList').dataTable({
                "sPaginationType" : "full_numbers",
                "aoColumnDefs" : [{"bSortable" : false, "aTargets" : [ 4,5 ]}],
                "bRetrieve" : true,
                "bDestroy" : true
            });
            $.fn.dataTableExt.sErrMode = 'throw';
            $('.dataTables_filter input').attr("placeholder", "Filter entries");
            $(".remove").click(function(){
                return window.confirm("Remove this user from list?");
            });
        });
        $(function() {
            $('select').selectmenu();
        });

    </script>
</head>
<body>
    <div id="page">
        <jsp:include page="header.jsp" />
        <jsp:include page="menu.jsp" />
        <section>
            <header>
                <!-- BREADCRUMB -->
                <p>
                    <a href="calendar.jsp" tabindex="13">home</a> »
                    <a href="departments.jsp" tabindex="13">departments</a> » 
                    <a href="department_users.jsp" tabindex="14">department users</a>
                </p>
                <!-- PAGE NAME -->
                <h1>Department Users</h1>
                <!-- MESSAGES -->
                <div class="warningMessage"><%=message %></div>
                <div class="successMessage"><%=successMessage %></div>
            </header>
            <form name="DeptUser" method="get" action="department_users.jsp">
                <article>
                    <header>
                      <h2>Add User</h2>
                      <img class="expandContent" width="9" height="6" src="${pageContext.servletContext.contextPath}/${initParam.ImagesDirectory}/arrowDown.svg" title="Click here to collapse/expand content" alt="Arrow"/>
                    </header>
                    <div class="content">
                        <fieldset>
                            <div class="component">
                                <input type="hidden" name="DeptCode" id="DeptCode" value="<%= d_code %>">
                                <label for="searchBoxAddDeptUser" class="label">Search User:</label>
                                    <input type="text" name="searchBox" id="searchBox" class="searchBox" tabindex="37" title="Search user">
                                    <button type="submit" name="search" class="search" tabindex="38" title="Search user"></button><div id="responseDiv"></div>
                            </div>
                        </fieldset>
                    </div>
                </article>
                <article>
                    <header>
                        <h2>Users</h2>
                        <img class="expandContent" width="9" height="6"
                             src="${pageContext.servletContext.contextPath}/${initParam.ImagesDirectory}/arrowDown.svg"
                             title="Click here to collapse/expand content" />
                    </header>
                    <div class="content">
                        <fieldset>
                            <div class="tableComponent">
                                <table id="departmentUsersList" border="0" cellpadding="0" cellspacing="0">
                                    <thead>
                                        <tr>
                                            <!-- Department Code -->
                                            <th width="150" class="firstColumn" tabindex="15"
                                                title="Department Code">Department Code<span><!-- Sorting arrow --></span></th>
                                            <!-- Field with expandable width -->
                                            <th title="Name" title="User Id">User Id<span><!-- Sorting arrow --></span></th>
                                            <!-- Regular field -->
                                            <th title="Nick Name">Nick Name<span><!-- Sorting arrow --></span></th>
                                            <!-- Regular field -->
                                            <th title="Admin Status" align="center">Admin Status<span><!-- Sorting arrow --></span></th>
                                            <!-- Action field -->
                                            <% if (usersession.isSuper()) { %>
                                            <th title="Action" class="icons" align="center">Set Admin Status</th>
                                            <% }  %>
                                            <th width="65" title="Remove" class="icons" align="center">Remove</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    <%
                                        for (int i=0; i<deptUserList.size(); i++) {
                                    %>
                                        <tr>
                                            <td class="row"><%= deptUserList.get(i).get("d_code") %></td>
                                            <td><%= deptUserList.get(i).get("bu_id") %></td>
                                            <td><%= deptUserList.get(i).get("bu_nick") %></td>
                                            <td><%= adminStatus = (deptUserList.get(i).get("ud_isadmin").equals("1")) ? "Yes" : "" %></td>
                                            <% if (usersession.isSuper()) { %>
                                            <td class="icons" align="center">
                                                <a onclick="savePageOffset()" href="department_users.jsp?DeptCode=<%= deptUserList.get(i).get("d_code") %>&mod=<%= deptUserList.get(i).get("bu_id") %>" class="modify" >
                                                    <img src="${pageContext.servletContext.contextPath}/${initParam.ImagesDirectory}/iconPlaceholder.svg" width="17" height="17" title="Modify Mod Status" alt="Modify"/>
                                                </a>
                                            </td>
                                            <% }  %>
                                            <td class="icons" align="center">
                                                <a onclick="savePageOffset()" href="department_users.jsp?DeptCode=<%= deptUserList.get(i).get("d_code") %>&remove=<%= deptUserList.get(i).get("bu_id") %>" class="remove">
                                                    <img src="${pageContext.servletContext.contextPath}/${initParam.ImagesDirectory}/iconPlaceholder.svg" width="17" height="17" title="Remove user" alt="Remove"/>
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
                <br /><hr /><br />
                <article>
                    <div class="component">
                        <div class="buttons">
                            <button type="button" name="button" id="returnButton"  class="button" title="Click here to return to view setting page" 
                                    onclick="window.location.href='departments.jsp'">
                                Return to Department Page
                            </button>
                        </div>
                    </div>
                </article>
            </form>
        </section>
        <jsp:include page="footer.jsp" />
    </div>
</body>
</html>