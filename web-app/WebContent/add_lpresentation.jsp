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
	<title>Add Lecture Presentation</title>
	<link rel="icon" href="http://www.cssreset.com/favicon.png">
	<link rel="stylesheet" type="text/css" media="all" href="css/fonts.css">
	<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/style.css">
	<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.core.css">
	<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.theme.css">
	<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.selectmenu.css">
	<script type="text/javascript" src="http://code.jquery.com/jquery-1.9.1.js"></script>
	<script type="text/javascript" src="js/modernizr.custom.79639.js"></script>
	<script type="text/javascript" src="js/ui/jquery.ui.core.js"></script>
	<script type="text/javascript" src="js/ui/jquery.ui.widget.js"></script>
	<script type="text/javascript" src="js/ui/jquery.ui.position.js"></script>
	<script type="text/javascript" src="js/ui/jquery.ui.selectmenu.js"></script>
	<script type="text/javascript" src="js/ui/jquery.ui.stepper.js"></script>
	<script type="text/javascript" src="js/ui/jquery.ui.dataTable.js"></script>
<%@ include file="search.jsp" %>
<%
    //Start page validation
    String userId = usersession.getUserId();
    GetExceptionLog elog = new GetExceptionLog();
    if (userId.equals("")) {
    	elog.writeLog("[add_lpresentation:] " + "unauthenticated user tried to access this page /n");
    	response.sendRedirect("index.jsp?message=Please log in");
        return;
    }
    String message = request.getParameter("message");
    String successMessage = request.getParameter("successMessage");
    if (message == null || message == "null") {
        message="";
    }
    if (successMessage == null) {
        successMessage="";
    }
    String l_id = request.getParameter("l_id");
    String ls_id = request.getParameter("ls_id");
    if (l_id==null || ls_id==null) {
    	elog.writeLog("[add_lpresentation:] " + "null l_id or ls_id /n");
    	response.sendRedirect("calendar.jsp?message=Please do not mess with the URL");
        return;
    }
    l_id = Validation.prepare(l_id);
    ls_id = Validation.prepare(ls_id);
    if (!(Validation.checkLId(l_id) && Validation.checkLsId(ls_id))) {
    	elog.writeLog("[add_lpresentation:] " + Validation.getErrMsg() +" /n");
        response.sendRedirect("calendar.jsp?message=" + Validation.getErrMsg());
        return;
    }
    User user = new User(dbaccess);
    Lecture lecture = new Lecture(dbaccess);
    MyBoolean myBool = new MyBoolean();    
    if (!lecture.isLecture(myBool, ls_id, l_id)) {
        message = "Could not verify lecture status (ls_id: " + ls_id + ", l_id: " + l_id + ")" + lecture.getErrMsg("ALP01");
        elog.writeLog("[add_lpresentation:] " + message +" /n");
        response.sendRedirect("logout.jsp?message=" + message);
        return;   
    }
    if (!myBool.get_value()) {
    	elog.writeLog("[add_lpresentation:] " + "permission denied" +" /n");
    	response.sendRedirect("calendar.jsp?message=You do not permission to access that page");
        return;
    }
    if (!user.isTeaching(myBool, ls_id, userId)) {
        message = "Could not verify lecture status (ls_id: " + ls_id + ", l_id: " + l_id + ")" + user.getErrMsg("ALP02");
        elog.writeLog("[add_lpresentation:] " + message +" /n");
        response.sendRedirect("logout.jsp?message=" + message);
        return;   
    }
    if (!myBool.get_value()) {
    	elog.writeLog("[add_lpresentation:] " + "permission denied" +" /n");
    	response.sendRedirect("calendar.jsp?message=You do not permission to access that page");
        return;
    }
    // End page validation
    
    int i = 0;
    String lp_title = request.getParameter("searchBox");
    if (lp_title!=null) {
        lp_title = Validation.prepare(lp_title);
        if (!(Validation.checkPresentationTitle(lp_title))) {
            message = Validation.getErrMsg();
        } else {
            if (!lecture.isLPresentation(myBool, lp_title, ls_id, l_id)) {
                message = lecture.getErrMsg("ALP03");
                elog.writeLog("[add_lpresentation:] " + message +" /n");
                response.sendRedirect("logout.jsp?message=" + message);
                return;   
            }
            // presentation already added
            if (myBool.get_value()) {
                message = "Presentation with that name already exists";
            } else {
                if (!lecture.createLecturePresentation(lp_title, ls_id, l_id)) {
                    message = lecture.getErrMsg("ALP04");
                    elog.writeLog("[add_lpresentation:] " + message +" /n");
                    response.sendRedirect("logout.jsp?message=" + message);
                    return;   
                } else {
                	successMessage = lp_title + " added to presentation list";
                }
            }
        }
    }

    String remove = request.getParameter("remove");
    if (remove!= null) {
        remove = Validation.prepare(remove);
        if (!(Validation.checkPresentationTitle(remove))) {
            message = Validation.getErrMsg();
        } else {
            if (!lecture.removeLecturePresentation(remove, ls_id, l_id)) {
                message = lecture.getErrMsg("ALP05");
                elog.writeLog("[add_lpresentation:] " + message +" /n");
                response.sendRedirect("logout.jsp?message=" + message);
                return;   
            } else {
            	successMessage = remove + " was removed from presentation list";
            }
        }
    }
    
    ArrayList<ArrayList<String>> eventPresentation = new ArrayList<ArrayList<String>>();
    if (!lecture.getLecturePresentation(eventPresentation, ls_id, l_id)) {
        message = lecture.getErrMsg("ALP05");
        elog.writeLog("[add_lpresentation:] " + message +" /n");
        response.sendRedirect("logout.jsp?message=" + message);
        return;   
    }         
                           
%>

<script type="text/javascript">
/* TABLE */
$(screen).ready(function() {
    $('#tbPresentation').dataTable({"sPaginationType": "full_numbers"});
    $('#tbPresentation').dataTable({"aoColumnDefs": [{ "bSortable": false, "aTargets":[5]}], "bRetrieve": true, "bDestroy": true});
    $.fn.dataTableExt.sErrMode = 'throw';
    $('.dataTables_filter input').attr("placeholder", "Filter entries");
    $(".remove").click(function(){
        return window.confirm("Remove this item from list?");
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
                <a href="add_lpresentation.jsp?ls_id=<%= ls_id %>&l_id=<%= l_id %>" tabindex="15">add_lpresentation</a></p>
            <!-- PAGE NAME -->
            <h1>Add Lecture Presentation</h1>
            <br />
            <!-- MESSAGES -->
            <div class="warningMessage"><%=message %></div>
            <div class="successMessage"><%=successMessage %></div> </header>
        <form name="addLPresentation" method="get" action="add_lpresentation.jsp">
            <article>
                <header>
                  <h2>Add Presentation</h2>
                  <img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content" alt="Arrow"/>
                </header>
                <div class="content">
                    <fieldset>
                        <div class="component">
                            <input type="hidden" name="ls_id" id="ls_id" value="<%= ls_id %>">
                            <input type="hidden" name="l_id" id="l_id" value="<%= l_id %>">  
                            <label for="searchBox" class="label">Add Presentation:</label>
                            <input type="text" name="searchBox" id="searchBox" class="input" tabindex="37" title="Search user">                                                      
                        </div>                      
                        <div class="component">
                            <div class="buttons">
                               <button type="submit" name="savePresentation" id="savePresentation" class="button" title="Click here to save">Save</button>
                               <button type="reset" name="resetPresentation" id="resetPresentation" class="button" title="Click here to reset">Reset</button>
                            </div>
                        </div>
                    </fieldset>
                </div>
            </article>
            <article>
                <header id="expandGuest">
                    <h2>Lecture Presentation List</h2>
                    <img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content"/>
                </header>
                <div class="content">
                    <fieldset>
                        <div id="currentEventDiv" class="tableComponent">
                            <table id="tbPresentation" border="0" cellpadding="0" cellspacing="0">
                                <thead>
                                    <tr>
                                        <th class="firstColumn" tabindex="16">Presentation Title<span></span></th>
                                        <th width="65" title="Remove" class="icons" align="center">Remove</th>
                                    </tr>
                                </thead>
                                <tbody>
                                <% for (i=0; i<eventPresentation.size(); i++) { %>
                                    <tr>
                                        <td class="row"><%= eventPresentation.get(i).get(0) %></td>
                                        <td class="icons" align="center">
                                            <a href="add_lpresentation.jsp?ls_id=<%= ls_id %>&l_id=<%= l_id %>&remove=<%= eventPresentation.get(i).get(0) %>" class="remove">
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