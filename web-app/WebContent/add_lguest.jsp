<%@page import="db.DBConnection"%>
<%@page import="sql.*"%>
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
    <title>SenecaBBB | Add Lecture Guest</title>
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
    <%@ include file="search.jsp" %>
    <%@ include file="send_Notification.jsp" %>
    <%
    //Start page validation
    String userId = usersession.getUserId();
    GetExceptionLog elog = new GetExceptionLog();
    if (userId.equals("")) {
        session.setAttribute("redirecturl",request.getRequestURI() + (request.getQueryString() != null ? "?" + request.getQueryString() : ""));
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
    String l_id = request.getParameter("l_id");
    String ls_id = request.getParameter("ls_id");
    if (l_id == null || ls_id == null) {
        elog.writeLog("[add_lguest:] " + "null l_id or ls_id /n");
        response.sendRedirect("calendar.jsp?message=Please do not mess with the URL");
        return;
    }
    l_id = Validation.prepare(l_id);
    ls_id = Validation.prepare(ls_id);
    if (!(Validation.checkLId(l_id) && Validation.checkLsId(ls_id))) {
        elog.writeLog("[add_lguest:] " + Validation.getErrMsg() + "/n");
        response.sendRedirect("calendar.jsp?message=" + Validation.getErrMsg());
        return;
    }
    User user = new User(dbaccess);
    Lecture lecture = new Lecture(dbaccess);
    MyBoolean myBool = new MyBoolean();
    if (!lecture.isLecture(myBool, ls_id, l_id)) {
        message = lecture.getErrMsg("ALG01");
        elog.writeLog("[add_lguest:] " + message + "/n");
        response.sendRedirect("logout.jsp?message=" + message);
        return;
    }
    if (!myBool.get_value()) {
        elog.writeLog("[add_lguest:] " + "Permission denied" + "/n");
        response.sendRedirect("calendar.jsp?message=You do not permission to access that page");
        return;
    }
    if (!user.isTeaching(myBool, ls_id, userId)) {
        message = user.getErrMsg("ALG02");
        elog.writeLog("[add_lguest:] " + message + "/n");
        response.sendRedirect("logout.jsp?message=" + message);
        return;
    }
    if (!myBool.get_value()) {
        elog.writeLog("[add_lguest:] " + "Permission denied" + "/n");
        response.sendRedirect("calendar.jsp?message=You do not permission to access that page");
        return;
    }
    // End page validation

    // Start User Search
    int i = 0;
    boolean searchSucess = false;
    String bu_id = request.getParameter("addBox");
    String nonldap = request.getParameter("searchBox");
    if (bu_id != null && bu_id != "") {
        bu_id = Validation.prepare(bu_id);
        if (!(Validation.checkBuId(bu_id))) {
            message = Validation.getErrMsg();
        } else {
            if (!user.isGuestTeaching(myBool, ls_id, l_id, bu_id)) {
                message = user.getErrMsg("ALG03");
                elog.writeLog("[add_lguest:] " + message + "/n");
                response.sendRedirect("logout.jsp?message=" + message);
                return;
            }
            // User already added
            if (myBool.get_value()) {
                message = "User already added";
            } else {
                if (!user.isUser(myBool, bu_id)) {
                    message = user.getErrMsg("ALG04");
                    elog.writeLog("[add_lguest:] " + message + "/n");
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

    ArrayList<HashMap<String, String>> searchResult = new ArrayList<HashMap<String, String>>();

    if (searchSucess) {
        if (!lecture.createLectureGuest(bu_id, ls_id, l_id, false)) {
            message = lecture.getErrMsg("ALG05");
            elog.writeLog("[add_lguest:] " + message + "/n");
            response.sendRedirect("logout.jsp?message=" + message);
            return;
        } else {
            successMessage = bu_id + " added to lecture guest list";
            sendNotification(dbaccess, ldap, bu_id, "lecture", ls_id,l_id, usersession.getGivenName());
        }
    } else if (nonldap != null && nonldap != "") {
        nonldap = Validation.prepare(nonldap);
        if (!(Validation.checkBuId(nonldap))) {
            message = Validation.getErrMsg();
        } else {
            String[] searchTerms = nonldap.split("[ .]");
            String term1 = "";
            String term2 = "";
            if (searchTerms.length == 1) {
                term1 = searchTerms[0];
                term2 = searchTerms[0];
            } else if (searchTerms.length >= 2) {
                term1 = searchTerms[0];
                term2 = searchTerms[1];
            }
            if (!user.getNonLdapSearch(searchResult, term1, term2)) {
                message = user.getErrMsg("ALG10");
                elog.writeLog("[add_lguest:] " + message + "/n");
                response.sendRedirect("logout.jsp?message=" + message);
                return;
            }
            successMessage = searchResult.size() + " Result(s) Found";
        }
    } else {
        String mod = request.getParameter("mod");
        String remove = request.getParameter("remove");
        if (mod != null) {
            mod = Validation.prepare(mod);
            if (!(Validation.checkBuId(mod))) {
                message = Validation.getErrMsg();
            } else {
                if (!lecture.setLectureGuestIsMod(mod, ls_id, l_id)) {
                    message = lecture.getErrMsg("ALG06");
                    elog.writeLog("[add_lguest:] " + message + "/n");
                    response.sendRedirect("logout.jsp?message=" + message);
                    return;
                }
            }
        } else if (remove != null) {
            remove = Validation.prepare(remove);
            if (!(Validation.checkBuId(remove))) {
                message = Validation.getErrMsg();
            } else {
                if (!lecture.removeLectureGuest(remove, ls_id, l_id)) {
                    message = lecture.getErrMsg("ALG07");
                    elog.writeLog("[add_lguest:] " + message + "/n");
                    response.sendRedirect("logout.jsp?message=" + message);
                    return;
                } else {
                    successMessage = remove + " was removed from guest list";
                }
            }
        }
    }

    ArrayList<HashMap<String, String>> eventGuest = new ArrayList<HashMap<String, String>>();
    if (!lecture.getLectureGuest(eventGuest, ls_id, l_id)) {
        message = lecture.getErrMsg("ALG08");
        elog.writeLog("[add_lguest:] " + message + "/n");
        response.sendRedirect("logout.jsp?message=" + message);
        return;
    }
    %>

    <script type="text/javascript">
        /* TABLE */
        $(screen).ready(function() {
            $("#help").attr({href:"help_addAttendee.jsp",target:"_blank"});
            /* CURRENT EVENT */
            $('#tbGuest').dataTable({
                "sPaginationType": "full_numbers",
                "aoColumnDefs": [{ "bSortable": false, "aTargets":[3,4]}], 
                "bRetrieve": true, 
                "bDestroy": true
                });
            $('#tbSearch').dataTable({
                "sPaginationType": "full_numbers",
                "aoColumnDefs": [{ "bSortable": false, "aTargets":[3]}], 
                "bRetrieve": true, 
                "bDestroy": true
                });
            $.fn.dataTableExt.sErrMode = 'throw';
            $('.dataTables_filter input').attr("placeholder", "Filter entries");
            $(".remove").click(function(){
                return window.confirm("Remove this person from list?");
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
                    <a href="view_event.jsp?ls_id=<%= ls_id %>&l_id=<%= l_id %>" tabindex="14">view_event</a> » 
                    <a href="add_lguest.jsp?ls_id=<%= ls_id %>&l_id=<%= l_id %>" tabindex="15">add_lguest</a>
                </p>
                <!-- PAGE NAME -->
                <h1>Add Lecture Guest</h1>
                <br />
                <!-- MESSAGES -->
                <div class="warningMessage"><%=message %></div>
                <div class="successMessage"><%=successMessage %></div>
            </header>
            <form name="addMGuest" method="get" action="add_lguest.jsp">
                <article>
                    <header>
                        <h2>Add User To Guest List</h2>
                        <img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content" alt="Arrow"/>
                    </header>
                    <div class="content">
                        <fieldset>
                            <div class="component">
                                <input type="hidden" name="ls_id" id="ls_id" value="<%= ls_id %>">
                                <input type="hidden" name="l_id" id="l_id" value="<%= l_id %>">  
                                <label for="addBox" class="label">Add User:</label>
                                <input type="text" name="addBox" id="addBox" class="searchBox" tabindex="37" title="Search user">
                                <button type="submit" name="search" class="search" tabindex="38" title="Search user"></button>
                                <div id="responseDiv"></div>
                            </div>
                        </fieldset>
                    </div>
                </article>
                <article>
                    <header id="expanSearch">
                        <h2>Search For Guest User</h2>
                        <img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content"/>
                    </header>
                    <div class="content">
                        <fieldset>
                            <div class="component">
                                <label for="searchBox" class="label">Search User:</label>
                                <input type="text" name="searchBox" id="searchBox" class="searchBox" tabindex="37" title="Add user">
                                <button type="submit" name="addAttendee" id="addAttendee" class="search" tabindex="38" title="Search user"></button>
                                <div id="responseDiv"></div>
                            </div>
                        </fieldset>
                    </div>
                </article>
                <%  if (searchResult.size() > 0) { %>
                <article>
                    <header id="expanSearch">
                        <h2>Search Results</h2>
                        <img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content"/>
                    </header>
                    <div class="content">
                        <fieldset>
                            <div id="currentEventDiv" class="tableComponent">
                                <table id="tbSearch" border="0" cellpadding="0" cellspacing="0">
                                    <thead>
                                        <tr>
                                            <th class="firstColumn" tabindex="16">Id<span></span></th>
                                            <th>First Name<span></span></th>
                                            <th>Last Name<span></span></th>
                                            <th width="65" title="Add" class="icons" align="center">Add</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    <% for (i=0; i<searchResult.size(); i++) { %>
                                        <tr>
                                            <td class="row"><%= searchResult.get(i).get("bu_id") %></td>
                                            <td><%= searchResult.get(i).get("nu_name") %></td>
                                            <td><%= searchResult.get(i).get("nu_lastname") %></td>
                                            <td class="icons" align="center">
                                                <a href="add_lguest.jsp?ls_id=<%= ls_id %>&l_id=<%= l_id %>&addBox=<%= searchResult.get(i).get("bu_id") %>" class="add">
                                                    <img src="images/iconPlaceholder.svg" width="17" height="17" title="Add user" alt="Add"/>
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
                <% } %>
                <article>
                    <header id="expandGuest">
                        <h2>Lecture Guest List</h2>
                        <img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content"/>
                    </header>
                    <div class="content">
                        <fieldset>
                            <div id="currentEventDiv" class="tableComponent">
                                <table id="tbGuest" border="0" cellpadding="0" cellspacing="0">
                                    <thead>
                                        <tr>
                                            <th class="firstColumn" tabindex="16">Id<span></span></th>
                                            <th>Nick Name<span></span></th>
                                            <th>Moderator<span></span></th>
                                            <th title="Action" class="icons" align="center">Modify</th>
                                            <th width="65" title="Remove" class="icons" align="center">Remove</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    <% for (i=0; i<eventGuest.size(); i++) { %>
                                        <tr>
                                            <td class="row"><%= eventGuest.get(i).get("bu_id") %></td>
                                            <td><%= eventGuest.get(i).get("bu_nick") %></td>
                                            <td><%= eventGuest.get(i).get("gl_ismod").equals("1") ? "Yes" : "" %></td>
                                            <td class="icons" align="center">
                                                <a href="add_lguest.jsp?ls_id=<%= ls_id %>&l_id=<%= l_id %>&mod=<%= eventGuest.get(i).get("bu_id") %>" class="modify">
                                                    <img src="images/iconPlaceholder.svg" width="17" height="17" title="Modify Mod Status" alt="Modify"/>
                                                </a>
                                            </td>
                                            <td class="icons" align="center">
                                                <a href="add_lguest.jsp?ls_id=<%= ls_id %>&l_id=<%= l_id %>&remove=<%= eventGuest.get(i).get("bu_id") %>" class="remove">
                                                    <img src="images/iconPlaceholder.svg" width="17" height="17" title="Remove user" alt="Remove"/>
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
                            <button type="button" name="button" id="returnButton"  class="button" title="Click here to return to event page" 
                                onclick="window.location.href='view_event.jsp?ls_id=<%= ls_id %>&l_id=<%= l_id %>'">
                                Return to Event Page
                            </button>
                        </div>
                    </div>
                </article>
            </form>
        </section>
        <jsp:include page="footer.jsp"/>
    </div>
</body>
</html>