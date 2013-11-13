<%@page import="db.DBConnection"%>
<%@page import="sql.*"%>
<%@page import="java.util.*"%>
<%@page import="helper.*"%>
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<jsp:useBean id="ldap" class="ldap.LDAPAuthenticate" scope="session" />
<!doctype html>
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Add Lecture Student</title>
<link rel="icon" href="http://www.cssreset.com/favicon.png">
<link rel="stylesheet" type="text/css" media="all" href="css/fonts.css">
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/style.css">
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.core.css">
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.theme.css">
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.datepicker.css">
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.selectmenu.css">
<link rel='stylesheet' type="text/css" href='fullcalendar-1.6.3/fullcalendar/fullcalendar.css'>
<script type="text/javascript" src="http://code.jquery.com/jquery-1.9.1.js"></script>
<script type="text/javascript" src='fullcalendar-1.6.3/fullcalendar/fullcalendar.js'></script>
<script type="text/javascript" src="js/modernizr.custom.79639.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.position.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.selectmenu.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.stepper.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.dataTable.js"></script>
<script type="text/javascript" src="js/componentController.js"></script>
<%@ include file="search.jsp" %>
<%
    //Start page validation
    String userId = usersession.getUserId();
    if (userId.equals("")) {
        response.sendRedirect("index.jsp?message=Please log in");
        return;
    }
    String message = request.getParameter("message");
    if (message == null || message == "null") {
        message="";
    }
    String l_id = request.getParameter("l_id");
    String ls_id = request.getParameter("ls_id");
    if (l_id==null || ls_id==null) {
        response.sendRedirect("calendar.jsp?message=Please do not mess with the URL");
        return;
    }
    l_id = Validation.prepare(l_id);
    ls_id = Validation.prepare(ls_id);
    if (!(Validation.checkLId(l_id) && Validation.checkLsId(ls_id))) {
        response.sendRedirect("calendar.jsp?message=" + Validation.getErrMsg());
        return;
    }
    User user = new User(dbaccess);
    Lecture lecture = new Lecture(dbaccess);
    Section section = new Section(dbaccess);
    MyBoolean myBool = new MyBoolean();    
    if (!lecture.isLecture(myBool, ls_id, l_id)) {
        message = lecture.getErrMsg("AS01");
        response.sendRedirect("logout.jsp?message=" + message);
        return;   
    }
    if (!myBool.get_value()) {
        response.sendRedirect("calendar.jsp?message=You do not permission to access that page");
        return;
    }
    if (!user.isTeaching(myBool, ls_id, userId)) {
        message = user.getErrMsg("AS02");
        response.sendRedirect("logout.jsp?message=" + message);
        return;   
    }
    if (!myBool.get_value()) {
        response.sendRedirect("calendar.jsp?message=You do not permission to access that page");
        return;
    }
    // End page validation
    
    // Start User Search
    int i = 0;
    boolean searchSucess = false;
    String bu_id = request.getParameter("searchBox");
    if (bu_id!=null) {
        bu_id = Validation.prepare(bu_id);
        if (!(Validation.checkBuId(bu_id))) {
            message = Validation.getErrMsg();
        } else {
            if (!user.isLectureStudent(myBool, ls_id, bu_id)) {
                message = user.getErrMsg("AS03");
                response.sendRedirect("logout.jsp?message=" + message);
                return;   
            }
            // User already added
            if (myBool.get_value()) {
                message = "User already added";
            } else {
                if (!user.isUser(myBool, bu_id)) {
                    message = user.getErrMsg("AS04");
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
        ArrayList<ArrayList<String>> curCourse = new ArrayList<ArrayList<String>>();
        if (!lecture.getLectureScheduleInfo(curCourse, ls_id)) {
            message = lecture.getErrMsg("AS05");
            response.sendRedirect("logout.jsp?message=" + message);
            return;   
        }
        if (!section.createStudent(bu_id, curCourse.get(0).get(1), curCourse.get(0).get(2), curCourse.get(0).get(3), false)) {
            message = section.getErrMsg("AS06");
            response.sendRedirect("logout.jsp?message=" + message);
            return;   
        } else {
            message = bu_id + " added to student list";
        }
    } else {
        String mod = request.getParameter("mod");
        String remove = request.getParameter("remove");
        if (mod != null) {
            mod = Validation.prepare(mod);
            if (!(Validation.checkBuId(mod))) {
                message = Validation.getErrMsg();
            } else {
                if (!user.setBannedFromLecture(mod, ls_id)) {
                    message = lecture.getErrMsg("AS07");
                    response.sendRedirect("logout.jsp?message=" + message);
                    return;   
                }
            }  
        } else if (remove != null) {
            remove = Validation.prepare(remove);
            if (!(Validation.checkBuId(remove))) {
                message = Validation.getErrMsg();
            } else {
                if (!user.isLectureStudent(myBool, ls_id, remove)) {
                    message = user.getErrMsg("AS09");
                    response.sendRedirect("logout.jsp?message=" + message);
                    return;   
                }
                // User Not in Student List
                if (!myBool.get_value()) {
                    response.sendRedirect("calendar.jsp?message=Please do not mess with the URL");
                    return;
                }
                ArrayList<ArrayList<String>> tempInfo = new ArrayList<ArrayList<String>>();
                if (!lecture.getLectureScheduleInfo(tempInfo, ls_id)) {
                    message = lecture.getErrMsg("AS10");
                    response.sendRedirect("logout.jsp?message=" + message);
                    return;   
                }
                if (!section.removeStudent(remove, tempInfo.get(0).get(1), tempInfo.get(0).get(2), tempInfo.get(0).get(3))) {
                    message = lecture.getErrMsg("AS11");
                    response.sendRedirect("logout.jsp?message=" + message);
                    return;   
                } else {
                    message = remove + " was removed from student list";
                }      
            }  
        }
    }
    
    ArrayList<ArrayList<String>> stuList = new ArrayList<ArrayList<String>>();
    if (!section.getStudent(stuList, ls_id)) {
        message = lecture.getErrMsg("ALG12");
        response.sendRedirect("logout.jsp?message=" + message);
        return;   
    }                                
%>

<script type="text/javascript">
/* TABLE */
$(screen).ready(function() {
    /* CURRENT EVENT */
    $('#addMGuest').dataTable({
            "bPaginate": false,
            "bLengthChange": false,
            "bFilter": false,
            "bSort": false,
            "bInfo": false,
            "bAutoWidth": false});
    $('#addMGuest').dataTable({"aoColumnDefs": [{ "bSortable": false, "aTargets":[5]}], "bRetrieve": true, "bDestroy": true});
    $('#tbGuest').dataTable({"sPaginationType": "full_numbers"});
    $('#tbGuest').dataTable({"aoColumnDefs": [{ "bSortable": false, "aTargets":[5]}], "bRetrieve": true, "bDestroy": true});
    $.fn.dataTableExt.sErrMode = 'throw';
    $('.dataTables_filter input').attr("placeholder", "Filter entries");
    $(".remove").click(function(){
        return window.confirm("Remove this student from list?");
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
            <p><a href="calendar.jsp" tabindex="13">home</a> » 
                <a href="view_event.jsp?ls_id=<%= ls_id %>&l_id=<%= l_id %>" tabindex="14">view_event</a> » 
                <a href="add_student.jsp?ls_id=<%= ls_id %>&l_id=<%= l_id %>" tabindex="15">add_student</a></p>
            <!-- PAGE NAME -->
            <h1>Add Student</h1>
            <br />
            <!-- WARNING MESSAGES -->
            <div class="warningMessage"><%=message %></div>
        </header>
        <form name="addMGuest" method="get" action="add_student.jsp">
            <article>
                <header>
                  <h2>Add Student</h2>
                  <img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content" alt="Arrow"/>
                </header>
                <div class="content">
                    <fieldset>
                        <div class="component">
                            <input type="hidden" name="ls_id" id="ls_id" value="<%= ls_id %>">
                            <input type="hidden" name="l_id" id="l_id" value="<%= l_id %>">  
                            <label for="searchBoxAddAttendee" class="label">Search User:</label>
                              <input type="text" name="searchBox" id="searchBox" class="searchBox" tabindex="37" title="Search user">
                              <button type="submit" name="search" class="search" tabindex="38" title="Search user"></button><div id="responseDiv"></div>
                        </div>
                    </fieldset>
                </div>
            </article>
            <article>
                <header id="expandGuest">
                    <h2>Student List</h2>
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
                                        <th>Banned<span></span></th>
                                        <th title="Action" class="icons" align="center">Modify</th>
                                        <th width="65" title="Remove" class="icons" align="center">Remove</th>
                                    </tr>
                                </thead>
                                <tbody>
                                <% for (i=0; i<stuList.size(); i++) { %>
                                    <tr>
                                        <td class="row"><%= stuList.get(i).get(0) %></td>
                                        <td><%= stuList.get(i).get(5) %></td>
                                        <td><%= stuList.get(i).get(4).equals("1") ? "Yes" : "" %></td>
                                        <td class="icons" align="center">
                                            <a href="add_student.jsp?ls_id=<%= ls_id %>&l_id=<%= l_id %>&mod=<%= stuList.get(i).get(0) %>" class="modify">
                                            <img src="images/iconPlaceholder.svg" width="17" height="17" title="Modify Mod Status" alt="Modify"/>
                                        </a></td>
                                        <td class="icons" align="center">
                                            <a href="add_student.jsp?ls_id=<%= ls_id %>&l_id=<%= l_id %>&remove=<%= stuList.get(i).get(0) %>" class="remove">
                                            <img src="images/iconPlaceholder.svg" width="17" height="17" title="Remove user" alt="Remove"/>
                                        </a></td>
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
                            onclick="window.location.href='view_event.jsp?ls_id=<%= ls_id %>&l_id=<%= l_id %>'">Return to Event Page</button>
                      </div>
                   </div>
            </article>
        </form>
    </section>
    <jsp:include page="footer.jsp"/>
</div>
</body>
</html>