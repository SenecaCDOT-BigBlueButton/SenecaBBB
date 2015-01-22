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
    <%
    //Start page validation
    String userId = usersession.getUserId();
    GetExceptionLog elog = new GetExceptionLog();
    if (userId.equals("")) {
        session.setAttribute("redirecturl", request.getRequestURI()+(request.getQueryString()!=null?"?"+request.getQueryString():""));
        response.sendRedirect("index.jsp?message=Please log in");
        return;
    }
    if(!(usersession.isSuper()||usersession.isDepartmentAdmin())) {
        elog.writeLog("[create_course:] " + "username: " + userId + "tried to access this page,permission denied"+" /n");
        response.sendRedirect("subjects.jsp?message=You do not have permission to access that page");
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
    String c_id = request.getParameter("c_id");
    String c_name = request.getParameter("c_name");
    String toDel = request.getParameter("toDel");
    String toEdit = request.getParameter("toEdit");
    if(c_id==null)
        c_id ="";
    if(c_name==null)
        c_name ="";
    if(toDel==null)
        toDel ="";
    if(toEdit==null)
        toEdit ="";   
    if(c_id.equals("")) {%>
    <title>SenecaBBB | Create Subject</title>
    <% } else if (toDel=="1"){%>
    <title>SenecaBBB | Delete Subject</title><%}
    else { %>
    <title>SenecaBBB | Edit Subject</title>
    <% } %>
    <link rel="shortcut icon" href="http://www.senecacollege.ca/favicon.ico">
    <link rel="stylesheet" type="text/css" media="all" href="${pageContext.servletContext.contextPath}/${initParam.CSSDirectory}/fonts.css">
    <link rel="stylesheet" type="text/css" media="all" href="${pageContext.servletContext.contextPath}/${initParam.CSSDirectory}/themes/base/style.css">
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/jquery-1.9.1.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/modernizr.custom.79639.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/jquery.validate.min.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/additional-methods.min.js"></script>
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
                    <a href="subjects.jsp" tabindex="14">subjects</a> »
                    <a href="create_course.jsp" tabindex="15">create subject</a>
                </p>
                <!-- PAGE NAME -->
                <% if(c_id.equals("")) {%>
                <h1>Create Subject</h1><% }
                else if (toEdit.equals("1")){%>
                <h1>Edit Subject</h1><%}
                else { %><h1>Delete Subject</h1><%} %>
                
                <!-- MESSAGES -->
                <div class="warningMessage"><%=message %></div>
                <div class="successMessage"><%=successMessage %></div>
            </header>
            <form name="createCourse" id="createCourse" method="post" action="persist_course.jsp">
                <article>
                    <header>
                        <h2>Subject Form</h2>
                        <img class="expandContent" width="9" height="6" src="${pageContext.servletContext.contextPath}/${initParam.ImagesDirectory}/arrowDown.svg" title="Click here to collapse/expand content"/>
                    </header>
                    <div class="content">
                        <fieldset>
                            <div class="component">
                                <label for="CourseCode" class="label">Subject Code:</label>
                                <input type="text" name="CourseCode" id="CourseCode" class="input" tabindex="16"  value="<%= c_id %>" 
                                <% if (toEdit.equals("1") ||(toDel.equals("1"))){%> readonly="<%= true %>" <%} %>title="Please Enter Course code" >                 
                            </div>
                            <div class="component">
                                <label for="CourseName" class="label">Subject Name:</label>
                                <input type="text" name="CourseName" id="CourseName" class="input" tabindex="17"  value="<%= c_name %>" 
                                <% if (toDel.equals("1")){%> readonly="<%= true %>" <%} %> title="Please Enter Course Name" >
                            </div>
                            <div class="component">
                                <div class="buttons">
                                <% if(c_id.equals("")) {%>
                                     <button type="submit" name="createCourse" id="createCourse" class="button" tabindex="18" title="Click here to create">Create</button><%}
                                 else if(toEdit.equals("1")){ %>
                                     <button type="submit" name="updateCourse" id="updateCourse" class="button"  tabindex="19" title="Click here to update">Update</button><%}
                                 else { %>
                                     <button type="submit" name="deleteCourse" id="deleteCourse" class="button" value="del"  tabindex="20" title="Click here to delete">Delete</button><%} %>                          
                                     <button type="reset" name="resetCourse" id="resetCourse" class="button"  tabindex="21" title="Click here to reset">Reset</button>
                                     <button type="button" name="button" id="cancelCourse"  class="button" tabindex="22" title="Click here to cancel" 
                                             onclick="window.location.href='manage_course.jsp'">Cancel</button>
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
                $('#createCourse').validate({
                    validateOnBlur : true,
                    rules: {
                        CourseCode: {
                            required: true,
                            pattern: /^\s*[a-zA-z]{3}[0-9]{3}\s*$/
                        },
                        CourseName:{
                            required: true,
                            pattern: /^\s*[a-zA-Z]+[- a-zA-Z0-9]*\s*$/
                        }
                    },
                    messages: {
                        CourseCode: { 
                            pattern:"Please enter a valid course code: AAA999.",
                            required:"Cousre code is required"
                        },
                        CourseName:{
                            required:"Course name is required",
                            pattern:"Please enter a valid course name"
                        }
                    }
                });
            });
        </script>
        <jsp:include page="footer.jsp"/>
    </div>
</body>
</html>