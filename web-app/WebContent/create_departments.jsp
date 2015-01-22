<%@page import="db.DBConnection"%>
<%@page import="sql.User"%>
<%@page import="java.util.*"%>
<%@page import="helper.*"%>
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SenecaBBB | Create Department</title>
    <link rel="shortcut icon" href="http://www.senecacollege.ca/favicon.ico">
    <link rel="stylesheet" type="text/css" media="all" href="${pageContext.servletContext.contextPath}/${initParam.CSSDirectory}/fonts.css">
    <link rel="stylesheet" type="text/css" media="all" href="${pageContext.servletContext.contextPath}/${initParam.CSSDirectory}/themes/base/style.css">
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/jquery-1.9.1.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/modernizr.custom.79639.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/jquery.validate.min.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/additional-methods.min.js"></script>
    
    <%
    //Start page validation
    String userId = usersession.getUserId();
    GetExceptionLog elog = new GetExceptionLog();
    if (userId.equals("")) {
        session.setAttribute("redirecturl", request.getRequestURI()+(request.getQueryString()!=null?"?"+request.getQueryString():""));
        response.sendRedirect("index.jsp?message=Please log in");
        return;
    }
    if(!usersession.isSuper() && !usersession.isDepartmentAdmin()) {
        elog.writeLog("[create_department:] " + "username: " + userId + "tried to access this page,permission denied"+" /n");
        response.sendRedirect("departments.jsp?message=You do not have permission to access that page");
        return;
    }//End page validation
    
    String message = request.getParameter("message");
    String successMessage = request.getParameter("successMessage");
    if (message == null || message == "null") {
        message="";
    }
    if (successMessage == null) {
        successMessage="";
    }
    User user = new User(dbaccess);
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
                    <a href="departments.jsp" tabindex="14">departments</a> »
                    <a href="create_departments.jsp" tabindex="15">create department</a>
                </p>
                <!-- PAGE NAME -->
                <h1>Create Department</h1>
                <!-- MESSAGES -->
                <div class="warningMessage"><%=message %></div>
                <div class="successMessage"><%=successMessage %></div>
            </header>
            <form name="createDept" id="createDept" method="post" action="departments.jsp">
                <article>
                    <header>
                        <h2>Department Form</h2>
                        <img class="expandContent" width="9" height="6" src="${pageContext.servletContext.contextPath}/${initParam.ImagesDirectory}/arrowDown.svg" title="Click here to collapse/expand content"/>
                    </header>
                    <div class="content">
                        <fieldset>
                            <div class="component">
                                <label for="DeptCode" class="label">Department Code:</label>
                                <input type="text" name="DeptCode" id="DeptCode" class="input" tabindex="16" title="Please Enter Department code" autofocus >
                            </div>
                            <div class="component">
                                <label for="DeptName" class="label">Department Name:</label>
                                <input type="text" name="DeptName" id="DeptName" class="input" tabindex="17" title="Please Enter Department Name" autofocus >
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
        <script>
            // form validation, edit the regular expression pattern and error messages to meet your needs
            $(document).ready(function(){
                 $('#createDept').validate({
                     validateOnBlur : true,
                     rules: {
                         DeptCode: {
                             required: true,
                             pattern: /^\s*[a-zA-z]{3}\s*$/
                         },
                         DeptName:{
                             required: true,
                             pattern: /^\s*[a-zA-z&#\ \/-]+\s*$/
                         }
                     },
                     messages: {
                         DeptCode: { 
                             pattern:"Please enter a valid department code",
                             required:"department code is required"
                         },
                         DeptName:{
                             required: "department name is required",
                             pattern: "Please enter a valid department name"
                         }
                     }
                 });
            });
        </script>
        <jsp:include page="footer.jsp"/>
    </div>
</body>
</html>