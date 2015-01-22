<%@page import="db.DBConnection"%>
<%@page import="sql.User"%>
<%@page import="sql.Section"%>
<%@page import="sql.Department"%>
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
    <title>SenecaBBB | Create Section</title>
    <link rel="shortcut icon" href="http://www.senecacollege.ca/favicon.ico">
    <link rel="stylesheet" type="text/css" media="all" href="css/fonts.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/style.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.core.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.theme.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.selectmenu.css">
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/jquery-1.9.1.js"></script>   
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/modernizr.custom.79639.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/ui/jquery.ui.core.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/ui/jquery.ui.widget.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/ui/jquery.ui.position.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/ui/jquery.ui.selectmenu.js"></script>
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
    if(!(usersession.isSuper()||usersession.isDepartmentAdmin())) {
        elog.writeLog("[create_section:] " + "username: " + userId + "tried to access this page,permission denied"+" /n");
        response.sendRedirect("calendar.jsp?message=You do not have permission to access that page");
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
    Section section = new Section(dbaccess);
    Department department = new Department(dbaccess);
    
    ArrayList<HashMap<String,String>> courseCodeList = new ArrayList<HashMap<String,String>>();
    ArrayList<HashMap<String,String>> deptCodeList = new ArrayList<HashMap<String,String>>();
    section.getCourse(courseCodeList);
    department.getDepartment(deptCodeList);
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
                    <a href="subjects.jsp" tabindex="14">subjects</a> »
                    <a href="edit_subject.jsp" tabindex="15">create section</a>
                </p>
                <!-- PAGE NAME -->
                <h1>Create Section</h1>
                <!-- MESSAGES -->
                <div class="warningMessage"><%=message %></div>
                <div class="successMessage"><%=successMessage %></div> 
            </header>
            <form name="createSection" id="createSection" method="post" action="persist_section.jsp">
                <article>
                    <header>
                        <h2>Section Form</h2>
                        <img class="expandContent" width="9" height="6" src="${pageContext.servletContext.contextPath}/${initParam.ImagesDirectory}/arrowDown.svg" title="Click here to collapse/expand content"/>
                    </header>
                    <div class="content">
                        <fieldset>
                            <div class="component">
                                <label for="courseCode" class="label">Course ID:</label>
                                <select  name="courseCode" id="courseCode"  style="width: 402px;" tabindex="2" title="Please Select course code" >
                                    <% for(int i=0;i<courseCodeList.size();i++){ %>
                                    <option><%= courseCodeList.get(i).get("c_id") %></option><%} %>
                                </select>
                            </div>
                            <div class="component">
                                <label for="courseSection" class="label">Section ID:</label>
                                <input type="text" name="courseSection" id="courseSection" class="input" tabindex="4" title="Please Enter Course Section"  >
                            </div>
                            <div class="component">
                                <label for="semesterID" class="label">Semester ID:</label>
                                <select  name="semesterID" id="semesterID"  style="width: 402px;" tabindex="2" title="Please Select course code" >
                                    <% int curYear = Calendar.getInstance().get(Calendar.YEAR); %>
                                    <option><%= curYear + "1" %></option>
                                    <option><%= curYear + "2" %></option>
                                    <option><%= curYear + "3" %></option>
                                    <option><%= curYear + 1 + "1" %></option>
                                    <option><%= curYear + 1 + "2" %></option>
                                    <option><%= curYear + 1 + "3" %></option>
                                </select>
                            </div> 
                            <div class="component">
                                <label for="deptCode" class="label">Department ID:</label>
                                <select  name="deptCode" id="deptCode"  style="width: 402px;" tabindex="2" title="Please Select dept code" >
                                <% for(int j=0;j<deptCodeList.size();j++){ %>
                                    <option><%= deptCodeList.get(j).get("d_code") %></option><%} %>
                                </select>
                            </div>
                            <div class="component">
                                <div class="buttons">
                                    <button type="submit" name="saveSection" id="saveSection" class="button" title="Click here to save">Create</button>
                                    <button type="reset" name="resetSection" id="resetSection" class="button" title="Click here to reset">Reset</button>
                                    <button type="button" name="button" id="cancelDept"  class="button" title="Click here to cancel" 
                                            onclick="window.location.href='subjects.jsp'">Cancel</button>
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
                $('#createSection').validate({
                    validateOnBlur : true,
                    rules: {
                        courseSection:{
                            required: true,
                            pattern: /^\s*[A-Z][A-Z]?\s*$/
                       }
                    },
                    messages: {
                        courseSection:{
                            required:"Section ID is requried",
                            pattern:"Please enter a valid section, upper case only, max 2 letters"
                        }
                    }
                });
                //Select boxes
                $(function(){
                    $('select').selectmenu();
                });
            });
        </script>
        <jsp:include page="footer.jsp"/>
    </div>
</body>
</html>
