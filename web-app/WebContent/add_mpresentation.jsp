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
<title>Add Meeting Presentation</title>
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
    	elog.writeLog("[add_mpresenation:] " + "unauthenticated user tried to access this page /n");
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

    String m_id = request.getParameter("m_id");
    String ms_id = request.getParameter("ms_id");
    if (m_id==null || ms_id==null) {
    	elog.writeLog("[add_mpresenation:] " + "null m_id or ms_id /n");
        response.sendRedirect("calendar.jsp?message=Please do not mess with the URL");
        return;
    }
    m_id = Validation.prepare(m_id);
    ms_id = Validation.prepare(ms_id);
    if (!(Validation.checkMId(m_id) && Validation.checkMsId(ms_id))) {
    	elog.writeLog("[add_mpresenation:] " +Validation.getErrMsg()+ "/n");
        response.sendRedirect("calendar.jsp?message=" + Validation.getErrMsg());
        return;
    }
    User user = new User(dbaccess);
    Meeting meeting = new Meeting(dbaccess);
    MyBoolean myBool = new MyBoolean();    
    if (!meeting.isMeeting(myBool, ms_id, m_id)) {
        message = "Could not verify meeting status (ms_id: " + ms_id + ", m_id: " + m_id + ")" + meeting.getErrMsg("AMP01");
        elog.writeLog("[add_mpresenation:] " + message + "/n");
        response.sendRedirect("logout.jsp?message=" + message);
        return;   
    }
    if (!myBool.get_value()) {
    	elog.writeLog("[add_mpresenation:] " + "permission denied" + "/n");
        response.sendRedirect("calendar.jsp?message=You do not permission to access that page");
        return;
    }
    if (!user.isMeetingCreator(myBool, ms_id, userId)) {
        message = "Could not verify meeting status (ms_id: " + ms_id + ", m_id: " + m_id + ")" + user.getErrMsg("AMP02");
        elog.writeLog("[add_mpresenation:] " + message + "/n");
        response.sendRedirect("logout.jsp?message=" + message);
        return;   
    }
    if (!myBool.get_value()) {
    	elog.writeLog("[add_mpresenation:] " + "permission denied" + "/n");
        response.sendRedirect("calendar.jsp?message=You do not permission to access that page");
        return;
    }
    // End page validation
    
    int i = 0;
   String mp_title = request.getParameter("searchBox");
   String mp_filename = request.getParameter("presentationFile");
    if (mp_title!=null) {
        mp_title = Validation.prepare(mp_title);
        if (!(Validation.checkPresentationTitle(mp_title))) {
            message = Validation.getErrMsg();
        } else {
            if (!meeting.isMPresentation(myBool, mp_title, ms_id, m_id)) {
                message = meeting.getErrMsg("AMP03");
                elog.writeLog("[add_mpresenation:] " + message + "/n");
                response.sendRedirect("logout.jsp?message=" + message);
                return;   
            }
            // presentation already added
            if (myBool.get_value()) {
                message = "Presentation with that name already exists";
            } else {
                if (!meeting.createMeetingPresentation(mp_title, ms_id, m_id)) {
                    message = meeting.getErrMsg("AMP04");
                    elog.writeLog("[add_mpresenation:] " + message + "/n");
                    response.sendRedirect("logout.jsp?message=" + message);
                    return;   
                } else {
                	successMessage = mp_title + " added to presentation list";
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
            if (!meeting.removeMeetingPresentation(remove, ms_id, m_id)) {
                message = meeting.getErrMsg("AMP05");
                elog.writeLog("[add_mpresenation:] " + message + "/n");
                response.sendRedirect("logout.jsp?message=" + message);
                return;   
            } else {
            	successMessage = remove + " was removed from presentation list";
            }
        }
    }
    
    ArrayList<ArrayList<String>> eventPresentation = new ArrayList<ArrayList<String>>();
    if (!meeting.getMeetingPresentation(eventPresentation, ms_id, m_id)) {
        message = meeting.getErrMsg("AMP05");
        elog.writeLog("[add_mpresenation:] " + message + "/n");
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
/*
//specify file formats accepted on client side
extArray = new Array(".gif", ".jpg", ".png", ".pdf",".doc",".docx",".xls",".xlsx",".ppt",".pptx",".txt",".rtf",".odt",".ods",".odp",".odg",".odc",".odi");
function LimitAttach(form, file) {
	allowSubmit = false;
	if (!file) {
		alert("Please select a file to upload");
		return false;
	}
	while (file.indexOf("\\") != -1)
	file = file.slice(file.indexOf("\\") + 1);
	ext = file.slice(file.indexOf(".")).toLowerCase();
	for (var i = 0; i < extArray.length; i++) {
	if (extArray[i] == ext) { allowSubmit = true; break; }
	}
	if (allowSubmit) form.submit();
	else
	alert("Please only upload files that end in types:  " 
	+ (extArray.join("  ")) + "\nPlease select a new "
	+ "file to upload and submit again.");
}
*/
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
                <a href="view_event.jsp?ms_id=<%= ms_id %>&m_id=<%= m_id %>" tabindex="14">view_event</a> » 
                <a href="add_mpresentation.jsp?ms_id=<%= ms_id %>&m_id=<%= m_id %>" tabindex="15">add_mpresentation</a></p>
            <!-- PAGE NAME -->
            <h1>Add Meeting Presentation</h1>
            <br />
	        <!-- MESSAGES -->
	        <div class="warningMessage"><%=message %></div>
	        <div class="successMessage"><%=successMessage %></div> </header>
        </header>
        <form name="addMPresentation" method="get" action="add_mpresentation.jsp" enctype="multipart/form-data">
            <article>
                <header>
                  <h2>Add Presentation</h2>
                  <img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content" alt="Arrow"/>
                </header>
                <div class="content">
                    <fieldset>
                        <div class="component">
                            <input type="hidden" name="ms_id" id="ms_id" value="<%= ms_id %>">
                            <input type="hidden" name="m_id" id="m_id" value="<%= m_id %>">  
                            <label for="searchBox" class="label"> Add Presentation:</label>
                            <input type="text" name="searchBox" id="searchBox" class="input" tabindex="37" title="Search user">                                                      
                        </div>                      
                        <div class="component">
                            <div class="buttons">
                               <button type="submit" name="savePresentation" id="savePresentation" class="button" title="Click here to save">Save</button>
                               <button type="reset" name="resetPresentation" id="resetPresentation" class="button" title="Click here to reset">Reset</button>
                            </div>
                        </div>
                    </fieldset>
                    <!--  
                    <fieldset>
	                    <div class="component">
	                            <label for="loadFile" class="label">Load Presentation File:</label>
	                            <input type="file" name="presentationFile" id="presentationFile" >                       
	                            <button type="submit" name="submitFile" id="submitFile" class="button" title="Click here to add file"  onclick="LimitAttach(this.form, this.form.presentationFile.value)">Load File</button>
	                    </div>
                    </fieldset>
                    -->
                </div>
            </article>
            <article>
                <header id="expandGuest">
                    <h2>Meeting Presentation List</h2>
                    <img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content"/>
                </header>
                <div class="content">
                    <fieldset>
                        <div id="currentEventDiv" class="tableComponent">
                            <table id="tbPresentation" border="0" cellpadding="0" cellspacing="0">
                                <thead>
                                    <tr>
                                        <th class="firstColumn" tabindex="16">Presentation Title<span></span></th>
                                        <!--  <th  tabindex="17">Presentation File<span></span></th>-->
                                        <th width="65" title="Remove" class="icons" align="center">Remove</th>
                                    </tr>
                                </thead>
                                <tbody>
                                <% for (i=0; i<eventPresentation.size(); i++) { %>
                                    <tr>
                                        <td class="row"><%= eventPresentation.get(i).get(0) %></td>
                                        <!--<td ></td>-->
                                        <td class="icons" align="center">
                                            <a href="add_mpresentation.jsp?ms_id=<%= ms_id %>&m_id=<%= m_id %>&remove=<%= eventPresentation.get(i).get(0) %>" class="remove">
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
                            onclick="window.location.href='view_event.jsp?ms_id=<%= ms_id %>&m_id=<%= m_id %>'">Return to Event Page</button>                                                              
                      
                      </div>
                   </div>
            </article>
        </form>
    </section>
    <jsp:include page="footer.jsp"/>
</div>
</body>
</html>