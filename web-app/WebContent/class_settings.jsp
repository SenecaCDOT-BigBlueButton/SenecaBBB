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
	<title>Class Settings</title>
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
        response.sendRedirect("index.jsp?error=Please log in");
        return;
    }
    if (dbaccess.getFlagStatus() == false) {
        response.sendRedirect("index.jsp?error=Database connection error");
        return;
    } 
    if (!usersession.isSuper()) {
        response.sendRedirect("calendar.jsp?message=You don't have permissions to view that page.");
        return;
    }
    
    //End page validation
    String c_id = "";
    String sc_id = "";
    String sc_semesterid = "";
    String professorid = "";
    String message = request.getParameter("message");
    String errMessage = request.getParameter("errMessage");
    String selectedclass;

    if (message == null || message == "null") {
        message="";
    }
    if (errMessage == null || errMessage == "null") {
    	errMessage="";
    }
    Section section = new Section(dbaccess);
    User user = new User(dbaccess);
    Lecture lecture = new Lecture(dbaccess);
    MyBoolean myBool = new MyBoolean();  
    selectedclass = request.getParameter("class");
    int profSettings = 0;
    HashMap<String, Integer> scSettingResult = new HashMap<String, Integer>(0);
    ArrayList<ArrayList<String>> profList = new ArrayList<ArrayList<String>>();
    ArrayList<ArrayList<String>> stuList = new ArrayList<ArrayList<String>>();
    if(selectedclass==null){ 	
    	message="Please choose a class to add students";
    }else if(selectedclass.split("-").length == 4){
	    c_id = selectedclass.split("-")[0];
	    sc_id = selectedclass.split("-")[1];
	    sc_semesterid = selectedclass.split("-")[2];
	    professorid = selectedclass.split("-")[3];
	    if(section.getSectionSetting(scSettingResult, c_id, sc_id, sc_semesterid, professorid)){
	        profSettings = scSettingResult.get("isRecorded");
	    }
	    if (section.getStudent(stuList,  c_id, sc_id, sc_semesterid)) {
	    	if(stuList.size()==0)
	    		message="No Student in this section!";	       
	    }else{
	    	 message="Can't get information from the given section!";
	    }
    }else{
    	message="Wrong section information";
    	response.sendRedirect("class_settings.jsp");
    }

%>

<%

ArrayList<ArrayList<String>> listofclasses = new ArrayList<ArrayList<String>>();
ArrayList<ArrayList<String>> nickNameResult = new ArrayList<ArrayList<String>>();
section.getProfessor(listofclasses); // get every class
if (listofclasses.size() < 0){
    message = "There are no classes to show";
} 
%>
    <script type='text/javascript'>
        /* CLASS SELECT BOX */
        $(function(){
            $('select').selectmenu({
                change: function (e, object) {
                    window.location.href = "class_settings.jsp?class="+object.value;
                }
            });
        });
        
        var promptForStudent = function () {
            var userId = prompt("Enter a student id", "Search");
            if (userId && userId != "") {
                window.location.href = "class_settings.jsp?class=<%= selectedclass %>&userId="+userId;
            }
        }
        
        $(screen).ready(function() {
            /* Student List Table */
            $('#studentListTable').dataTable({"sPaginationType": "full_numbers"});
            $('#studentListTable').dataTable({"aoColumnDefs": [{ "bSortable": false, "aTargets":[5]}], "bRetrieve": true, "bDestroy": true});
            $.fn.dataTableExt.sErrMode = 'throw';
            $('.dataTables_filter input').attr("placeholder", "Filter entries");
        });
            /* Select Box */
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
			<p><a href="calendar.jsp" tabindex="13">home</a> » <a href="class_settings.jsp" tabindex="14">class settings</a></p>
			<!-- PAGE NAME -->
			<h1 style="margin-bottom:20px">Class Settings</h1>
			<!-- WARNING MESSAGES -->
			<div class="warningMessage"><%=message %></div>
			<div class="warningMessage"><%=errMessage %></div>
		</header>
		<% if (listofclasses.size() > 0) { %>
		<form action="uploadfile.jsp" method="post" enctype="multipart/form-data">
		<article>
			<div class="content">
				<fieldset>
					<div class="component">
						<label for="classSel" class="label">Class:</label>
						<select name="class" id="classSel" title="Class select box. Use the alt key in combination 
							with the arrow keys to select an option." tabindex="1" role="listbox" style="width: 402px">
							<option role='option' selected disabled>Choose a class</option>
							<% if (usersession.isSuper()){
									for (int j=0; j < listofclasses.size(); ++j) {								
										String fullclass = listofclasses.get(j).get(1) + "-" + listofclasses.get(j).get(2)+ "-" + listofclasses.get(j).get(3) + "-" + listofclasses.get(j).get(0);
										out.println("<option role='option' " + (fullclass.equals(selectedclass)?"selected":"") +">" + fullclass + "</option>");
									}
							   }
							%>
						</select>
					</div>
					<% } %>
					<div class="component">
						<div class="checkbox" title="Meetings you created."> <span class="box" role="checkbox" <%= (profSettings==1 ? "aria-checked='true'" : "aria-checked='false'") %> tabindex="17" aria-labelledby="recorded"></span>
							<label class="checkmark" <% if (profSettings==1) out.print(""); else out.print("style='display:none'"); %>></label>
							<label class="text" id="recorded">Recorded lectures</label>
							<input type="checkbox" name="recordedBox" <% if(profSettings==1) out.print("checked='checked'"); else out.print(""); %> aria-disabled="true" />
						</div>
					</div>
				</fieldset>
			    <fieldset>
	                <div class="component">
	                        <label for="loadFile" class="label">Add Students From File:</label>
	                        <input type="file" name="studentListFile" id="studentListFile" >                       
	                        <button type="submit" name="submitFile" id="submitFile" class="button" title="Click here to add Student"  >Load File</button>
	                </div>
	             </fieldset>
			</div>
			</article>
		</form>
        <form name="addStudent" method="get" action="persist_class_settings.jsp" >
            <article>
                <header>
                  <h2>Add Student</h2>
                  <img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content" alt="Arrow"/>
                </header>
                <div class="content">
                    <fieldset>
                        <div class="component">
                            <label for="searchBoxAddStudent" class="label">Search Student to Add:</label>
                              <input type="hidden" name="classSectionInfo" id="classSectionInfo" value="<%= selectedclass %>" >
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
                            <table id="studentListTable" border="0" cellpadding="0" cellspacing="0">
                                <thead>
                                    <tr>
                                        <th class="firstColumn" tabindex="16">Id<span></span></th>
                                        <th>Nick Name<span></span></th>
                                        <th>Banned<span></span></th>
                                        <th width="65" title="Remove" class="icons" align="center">Remove</th>
                                    </tr>
                                </thead>
                                <tbody>  
                                
                                <%  if(stuList.size()<1){ %> 
                                  <tr>
                                        <td class="row">No Students in this section</td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                <%}else 
                                  for(int k=0;k<stuList.size();k++){%>               
                                    <tr>
                                        <td class="row"><%= stuList.get(k).get(0)%></td>                                       
                                        <td><% if(user.getNickName(nickNameResult, stuList.get(k).get(0))) out.print(nickNameResult.get(0).get(0)); %></td>
                                        <td><%= stuList.get(k).get(4)%></td>
                                        <td class="icons" align="center">
                                            <a href="" class="remove">
                                            <img src="images/iconPlaceholder.svg" width="17" height="17" title="Remove user" alt="Remove"/>
                                        </a></td>
                                    </tr>
                             <%} %>
                                </tbody>
                            </table>
                        </div>
                    </fieldset>
                </div>
            </article>
            <br /><hr /><br />

        </form>
    </section>
	<jsp:include page="footer.jsp"/>
</div>
</body>
</html>