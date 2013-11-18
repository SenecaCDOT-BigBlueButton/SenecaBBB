<%@page import="sql.*"%>
<%@page import="java.util.*"%>
<%@page import="helper.*"%>
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<!doctype html>
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Seneca | Departments</title>
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

<%
	//Start page validation
	boolean validFlag; 
	String userId = usersession.getUserId();
	if (userId.equals("")) {
		response.sendRedirect("index.jsp?message=Please log in");
		return;
	}
	if (!(usersession.isDepartmentAdmin() || usersession.isSuper())) {
	    response.sendRedirect("calendar.jsp");
	    return;
	}
	//End page validation
	
	String message = request.getParameter("message");
	if (message == null || message == "null") {
		message="";
	}
	
	User user = new User(dbaccess);
	Department dept = new Department(dbaccess);
	MyBoolean myBool = new MyBoolean();
	
	String deptCode = request.getParameter("DeptCode");
	String deptName = request.getParameter("DeptName");
	String deptRemove = request.getParameter("deptRemove");
	String oldDeptCode = request.getParameter("OldDeptCode");
	String modDeptCode = request.getParameter("NewDeptCode");
	String modDeptName = request.getParameter("NewDeptName");
	
	if (deptCode!=null && deptName!=null) {
	    deptCode = Validation.prepare(deptCode).toUpperCase();
		deptName = Validation.prepare(deptName);
	    validFlag = Validation.checkDeptCode(deptCode) && Validation.checkDeptName(deptName);
	    if (validFlag) {
	        if (!dept.createDepartment(deptCode, deptName)) {
	            message = "Could not create new department " + deptCode + dept.getErrMsg("D01");
	        } else {
	            message = "Department " + deptCode + " created"; 
	        }
	    } else {
	        message = Validation.getErrMsg();
	    }
	}
	
	if (deptRemove!=null && usersession.isSuper()) {
	    deptRemove = Validation.prepare(deptRemove);
	    validFlag = Validation.checkDeptCode(deptRemove);
	    if (validFlag) {
	        if (!dept.isDepartment(myBool, deptRemove)) {
	            message = "Could not verify department status: " + deptRemove + dept.getErrMsg("D02");
	    	    response.sendRedirect("logout.jsp?message=" + message);
	    	    return;   
	    	}
	    	if (!myBool.get_value()) {
	    	    message = "Department with that code does not exist";
	    	} else {
	    		if (!dept.removeDepartment(deptRemove)) {
	    		    message = "Could not remove department " + deptRemove + dept.getErrMsg("D03");
            		dept.resetErrorFlag();
        		} else {
            		message = "Department " + deptRemove + " was removed";
        		}
	    	}
	    } else {
	        message = Validation.getErrMsg();
	    }
	}
	
	if (modDeptCode!=null && modDeptName!=null && oldDeptCode!=null) {
	    modDeptCode = Validation.prepare(modDeptCode);
		modDeptName = Validation.prepare(modDeptName);
		oldDeptCode = Validation.prepare(oldDeptCode);
	    validFlag = Validation.checkDeptCode(modDeptCode) && Validation.checkDeptName(modDeptName) && Validation.checkDeptCode(oldDeptCode);
	    if (validFlag) {
	        if (!dept.setMultiDepartment(oldDeptCode, modDeptCode, modDeptName)) {
	            message = "Could not modify department " + oldDeptCode + dept.getErrMsg("D04");
	        } else {
	            message = "Department " + oldDeptCode + " was modified"; 
	        }
	    } else {
	        message = Validation.getErrMsg();
	    }
	}
	
	ArrayList<ArrayList<String>> deptList = new ArrayList<ArrayList<String>>();
	if (usersession.isSuper()) {
	    if (!dept.getDepartment(deptList)) {
	        message = "Could not get department list" + dept.getErrMsg("D05");
            response.sendRedirect("logout.jsp?message=" + message);
            return;
        }
	}
	else {
	    if (!dept.getDepartment(deptList, userId)) {
	        message = "Could not get department list" + dept.getErrMsg("D06");
            response.sendRedirect("logout.jsp?message=" + message);
            return;
        }
	}
		
%>
<script type="text/javascript">
/* TABLE */
$(screen).ready(function() {
	/* DEPARTMENT LIST */
	$('#departmentList').dataTable({"sPaginationType": "full_numbers"});
	$('#departmentList').dataTable({"aoColumnDefs": [{ "bSortable": false, "aTargets":[5]}], "bRetrieve": true, "bDestroy": true});
	$.fn.dataTableExt.sErrMode = 'throw';
	$('.dataTables_filter input').attr("placeholder", "Filter entries");
    $(".remove").click(function(){
        return window.confirm("Are you sure to remove this item?");;
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
			<p><a href="calendar.jsp" tabindex="13">home</a> » <a href="departments.jsp" tabindex="14">departments</a></p>
			<h1>Departments</h1>
			<div class="warningMessage"><%=message %></div>
		</header>
		<form action="persist_user_settings.jsp" method="get">
			<article>
				<header>
					<h2>Department List</h2>
					<img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content"/></header>
				<div class="content">
					<fieldset>
						<div id="tableAddAttendee" class="tableComponent">
							<table id="departmentList" border="0" cellpadding="0" cellspacing="0">
								<thead>
									<tr>
										<th width="65" class="firstColumn" tabindex="16" title="Code">Code<span></span></th>
										<th title="Name">Name<span></span></th>
										<th width="65" title="View users" class="icons" align="center">Users</th>
										<th width="65" title="Modify" class="icons" align="center">Modify</th>
										<% if (usersession.isSuper()) { %>
										<th width="65" title="Remove" class="icons" align="center">Remove</th>
										<% } %>
									</tr>
								</thead>
								<tbody>
								<%
									for (int i=0; i<deptList.size(); i++) {
								%>
									<tr>
										<td class="row"><%= deptList.get(i).get(0) %></td>
										<td><%= deptList.get(i).get(1) %></td>
										<td class="icons" align="center"><a href="department_users.jsp?DeptCode=<%= deptList.get(i).get(0) %>" class="view"><img src="images/iconPlaceholder.svg" width="17" height="17" title="View all users associated with this department" alt="Users"/></a></td>
										<% //The ampersand symbol that are in some department names needs to be escaped to %26 before merged into GET URL %>
										<td class="icons" align="center"><a href="modify_department.jsp?mod_d_code=<%= deptList.get(i).get(0) %>&mod_d_name=<%= deptList.get(i).get(1).replace("&", "%26") %>" class="modify"><img src="images/iconPlaceholder.svg" width="17" height="17" title="Modify department name" alt="Modify"/></a></td>
										<% if (usersession.isSuper()) { %>
										<td class="icons" align="center"><a href="departments.jsp?deptRemove=<%= deptList.get(i).get(0) %>" class="remove"><img src="images/iconPlaceholder.svg" width="17" height="17" title="Remove department" alt="Remove"/></a></td>
										<% } %>
									</tr>
								<%
									}
								%>
								</tbody>
							</table>
						</div>
					</fieldset>
				</div>
			</article>
			<article>
				<h4></h4>
				<fieldset>
				<% if (usersession.isSuper()) { %>
					<div class="actionButtons">
						<button type="button" name="button" id="addDepartment" class="button" title="Click here to add a new department" onclick="window.location.href='create_departments.jsp'">Add department</button>
					</div>
				<% } %>
				</fieldset>
			</article>
		</form>
	</section>
	<jsp:include page="footer.jsp"/>
</div>
</body>
</html>