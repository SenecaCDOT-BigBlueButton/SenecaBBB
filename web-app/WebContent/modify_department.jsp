<%@page import="db.DBConnection"%>
<%@page import="sql.User"%>
<%@page import="sql.Department"%>
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
<title>Modify Department</title>
<link rel="icon" href="http://www.cssreset.com/favicon.png">
<link rel="stylesheet" type="text/css" media="all" href="css/fonts.css">
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/style.css">
<script type="text/javascript" src="http://code.jquery.com/jquery-1.9.1.js"></script>
<script type="text/javascript" src="js/modernizr.custom.79639.js"></script>
<script type="text/javascript" src="js/componentController.js"></script>

<%
	boolean validFlag; 
	User user = new User(dbaccess);
	Department dept = new Department(dbaccess);
	MyBoolean myBool = new MyBoolean();
	String message;
	//Start page validation
	String userId = usersession.getUserId();
	if (userId.equals("")) {
		response.sendRedirect("index.jsp?message=Please log in");
		return;
	}
	String d_code = request.getParameter("mod_d_code");
	String d_name = request.getParameter("mod_d_name");
	if (d_code==null || d_name==null) {
	    response.sendRedirect("departments.jsp?message=Please do not mess with the URL");
	    return;
	}
	d_code = Validation.prepare(d_code);
	d_name = Validation.prepare(d_name);
	validFlag = Validation.checkDeptCode(d_code) && Validation.checkDeptName(d_name);
	if (!validFlag) {
	    response.sendRedirect("departments.jsp?message=" + Validation.getErrMsg());
	    return;
	}
	if (!dept.isDepartment(myBool, d_code)) {
	    message = "Could not verify department status: " + d_code + dept.getErrMsg("MD01");
        response.sendRedirect("logout.jsp?message=" + message);
	    return;   
	}
	if (!myBool.get_value()) {
	    response.sendRedirect("departments.jsp?message=Department with that code does not exist");
	    return;
	}
	if (!usersession.isSuper()) {
	    if (!user.isDepartmentAdmin(myBool, usersession.getUserId(), d_code)) {
	        message = "Could not verify department admin status for: " + usersession.getUserId() + dept.getErrMsg("MD02");
	        response.sendRedirect("logout.jsp?message=" + message);
		    return;   
		}
	    if (!myBool.get_value()) {
		    response.sendRedirect("departments.jsp?message=You do not have permission to access that page");
		    return;
		}	
	}	
	//End page validation
	
%>
</head>
<body>
<div id="page">
	<jsp:include page="header.jsp"/>
	<jsp:include page="menu.jsp"/>
	<section>
		<header> 
			<!-- BREADCRUMB -->
			<p><a href="calendar.jsp" tabindex="13">home</a> » <a href="departments.jsp" tabindex="14">departments</a> »<a href="create_departments.jsp" tabindex="15">create department</a></p>
			<!-- PAGE NAME -->
			<h1>Create Department</h1>
			<!-- WARNING MESSAGES -->
			<div class="warningMessage"></div>
		</header>
		<form name="modifyDept" method="post" action="departments.jsp">
			<article>
				<header>
					<h2>Modify Department Form</h2>
					<img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content"/>
				</header>
				<div class="content">
					<fieldset>
						<div class="component">
				            <label for="OldDeptCode" class="label">Department Code:</label>
				            <input type="text" name="OldDeptCode" id="OldDeptCode" class="input" tabindex="2" value="<%=d_code %>" title="Department code" readonly="readonly">
				        </div>
				        <div class="component">
				            <label for="NewDeptCode" class="label">New Department Code:</label>
				            <input type="text" name="NewDeptCode" id="NewDeptCode" class="input" tabindex="2" value="<%=d_code %>" title="Please Enter Department code">
				        </div>
				        <div class="component">
				            <label for="NewDeptName" class="label">New Department Name:</label>
				            <input type="text" name="NewDeptName" id="NewDeptName" class="input" tabindex="3" value="<%=d_name %>" title="Please Enter Department Name" >
				        </div>
				        <div class="component">
					        <div class="buttons">
	                           <button type="submit" name="saveDept" id="saveDept" class="button" title="Click here to save">Save</button>
	                           <button type="reset" name="resetDept" id="resetDept" class="button" title="Click here to reset">Reset</button>
	                           <button type="button" name="button" id="cancelDept"  class="button" title="Click here to cancel" 
	                           	onclick="window.location.href='departments.jsp'">Cancel</button>
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