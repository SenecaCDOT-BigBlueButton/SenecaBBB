<%@page import="db.DBConnection"%>
<%@page import="sql.User"%>
<%@page import="java.util.*"%>
<%@page import="java.lang.Integer"%>
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
    <title>SenecaBBB | Manage Users</title>
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
    <%@ include file="search.jsp" %>
    <script type="text/javascript">       
        //Table
        $(screen).ready(function() {
            /* USERS LIST */    
            $('#usersList').dataTable({
                "sPaginationType": "full_numbers",
                "aoColumnDefs": [{ "bSortable": false, "aTargets":[6,7]}], 
                "bRetrieve": true, 
                "bDestroy": true});
            $.fn.dataTableExt.sErrMode = 'throw';
            $('.dataTables_filter input').attr("placeholder", "Filter entries");
        
        });
        /* SELECT BOX */
        $(function(){
            $('select').selectmenu();
        });
    </script>
    <%
    //Start page validation
    String userId = usersession.getUserId();
    GetExceptionLog elog = new GetExceptionLog();
    if (userId.equals("")) {
        session.setAttribute("redirecturl",request.getRequestURI() + (request.getQueryString() != null ? "?" + request.getQueryString() : ""));
        response.sendRedirect("index.jsp?message=Please log in");
        return;
    }
    if (!usersession.isSuper()) {
        elog.writeLog("[manage_users:] " + " username: " + userId + " tried to access this page, permission denied" + " /n");
        response.sendRedirect("calendar.jsp?message=You don't have permission to access that page!");
        return;
    }
    if (dbaccess.getFlagStatus() == false) {
        elog.writeLog("[manage_users:] " + "database connection error /n");
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
    ArrayList<HashMap<String, String>> allUserInfo = new ArrayList<HashMap<String, String>>();
    user.getUserInfo(allUserInfo);

    // Start User Search
    String bu_id = request.getParameter("searchBox");
    MyBoolean myBool = new MyBoolean();
    if (bu_id != null) {
        bu_id = Validation.prepare(bu_id);
        if (!(Validation.checkBuId(bu_id))) {
            message = Validation.getErrMsg();
        } else {
            user.isUser(myBool, bu_id);
            if (myBool.get_value()) {
                message = "User " + bu_id + " already in database";
                response.sendRedirect("manage_users.jsp?message=" + message);
                return;
            } else {
                // Found userId in LDAP
                if (findUser(dbaccess, ldap, bu_id)) {
                    response.sendRedirect("manage_users.jsp?successMessage=User " + bu_id + " added in database successfully!");
                    return;
                } else {
                    message = "User Not Found";
                }
            }
        }
    }
    // End User Search
    %>
</head>
<body>
    <div id="page">
        <jsp:include page="header.jsp"/>
        <jsp:include page="menu.jsp"/>
        <section>
            <header> 
                <!-- BREADCRUMB -->
                <p><a href="calendar.jsp" tabindex="13">home</a> » <a href="manage_users.jsp" tabindex="14">manage users</a></p>
                <!-- PAGE NAME -->
                <h1>Manage Users</h1>
                <!-- WARNING MESSAGES -->
                <div class="warningMessage" ><%=message %></div>
                <div class="successMessage"><%=successMessage %></div> 
            </header>
            <form>
                <article>
                    <header>
                      <h2>Add Internal User</h2>
                      <img class="expandContent" width="9" height="6" src="${pageContext.servletContext.contextPath}/${initParam.ImagesDirectory}/arrowDown.svg" title="Click here to collapse/expand content" alt="Arrow"/>
                    </header>
                    <div class="content">
                        <fieldset>
                            <div class="component">
                                <label for="searchBoxAddUser" class="label">Add User:</label>
                                    <input type="text" name="searchBox" id="searchBox" class="searchBox" tabindex="37" title="Search user">
                                    <button type="submit" name="search" class="search" tabindex="38" title="Search user"></button><div id="responseDiv"></div>
                            </div>
                        </fieldset>
                    </div>
                </article>
                <article>
                    <header>
                        <h2>All Users Information</h2>
                        <img class="expandContent" width="9" height="6" src="${pageContext.servletContext.contextPath}/${initParam.ImagesDirectory}/arrowDown.svg" title="Click here to collapse/expand content"/>
                    </header>
                    <div class="content">
                        <fieldset>
                            <div class="component">
                                <div class="tableComponent">
                                    <table id="usersList" border="0" cellpadding="0" cellspacing="0">
                                        <thead>
                                            <tr>
                                                <th class="firstColumn" tabindex="16" title="UserID">ID<span></span></th>
                                                <th width="150" title="User Nick Nmae">Nick Name<span></span></th>
                                                <th width="80" title="User Is Banned">Is Banned<span></span></th>
                                                <th width="80" title="User Is Active">Is Active<span></span></th>
                                                <th width="80" title="User Is LDAP User">Is Ldap<span></span></th>
                                                <th width="80" title="User Is Super User">Is Super<span></span></th>
                                                <th width="80" title="User Schedule" class="icons"  align="center">Schedule</th>
                                                <th width="65" title="Edit" class="icons"  align="center">Edit</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                        <% for(int i=0;i<allUserInfo.size();i++){ %>
                                            <tr>
                                                <td class="row"><%= allUserInfo.get(i).get("bu_id") %></td>
                                                <td><%= allUserInfo.get(i).get("bu_nick") %></td>
                                                <td><%= allUserInfo.get(i).get("bu_isbanned") %></td>
                                                <td><%= allUserInfo.get(i).get("bu_isactive") %></td>
                                                <td><%= allUserInfo.get(i).get("bu_isldap") %></td>
                                                <td><%= allUserInfo.get(i).get("bu_issuper") %></td>
                                                <td class="icons" align="center">
                                                    <a  class="schedule"  href='view_schedule.jsp?id=<%= allUserInfo.get(i).get("bu_id") %>' >
                                                        <img alt="Search" src="${pageContext.servletContext.contextPath}/${initParam.ImagesDirectory}/iconPlaceholder.svg" width="17" height="17" title="User Schedule" />
                                                    </a>
                                                </td>
                                                <td class="icons" align="center">
                                                    <a class="modify" href= <%= "edit_user.jsp?id=" +  allUserInfo.get(i).get("bu_id")  +"&action=edit" %>>
                                                        <img alt="Edit" src="${pageContext.servletContext.contextPath}/${initParam.ImagesDirectory}/iconPlaceholder.svg" width="17" height="17" title="Edit User" />
                                                    </a>
                                                </td>
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
