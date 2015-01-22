<%@page import="db.DBConnection"%>
<%@page import="sql.*"%>
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
        session.setAttribute("redirecturl",request.getRequestURI() + (request.getQueryString() != null ? "?" + request.getQueryString() : ""));
        response.sendRedirect("index.jsp?message=Please log in");
        return;
    }
    if (!(usersession.isSuper() || usersession.isDepartmentAdmin())) {
        elog.writeLog("[create_professor:] " + "username: " + userId + "tried to access this page,permission denied" + " /n");
        response.sendRedirect("subjects.jsp?message=You do not have permission to access that page");
        return;
    }//End page validation

    String message = request.getParameter("message");
    String successMessage = request.getParameter("successMessage");
    if (message == null || message == "null") {
        message = "";
    }
    if (successMessage == null) {
        successMessage = "";
    }

    User user = new User(dbaccess);
    String c_id = request.getParameter("c_id");
    String sc_id = request.getParameter("sc_id");
    String toDel = request.getParameter("toDel");
    String bu_id = request.getParameter("bu_id");
    String sc_semesterid = request.getParameter("sc_semesterid");
    if (c_id == null)
        c_id = "";
    if (sc_id == null)
        sc_id = "";
    if (toDel == null)
        toDel = "";
    if (sc_semesterid == null)
        sc_semesterid = "";
    if (bu_id == null)
        bu_id = "";

    Section section = new Section(dbaccess);
    ArrayList<HashMap<String, String>> allSection = new ArrayList<HashMap<String, String>>();
    section.getSectionInfo(allSection);
    %>
    <title>SenecaBBB | Create Professor</title>
    <link rel="shortcut icon" href="http://www.senecacollege.ca/favicon.ico">
    <link rel="stylesheet" type="text/css" media="all" href="${pageContext.servletContext.contextPath}/${initParam.CSSDirectory}/fonts.css">
    <link rel="stylesheet" type="text/css" media="all" href="${pageContext.servletContext.contextPath}/${initParam.CSSDirectory}/themes/base/style.css">
    <link rel="stylesheet" type="text/css" media="all" href="${pageContext.servletContext.contextPath}/${initParam.CSSDirectory}/themes/base/jquery.ui.core.css">
    <link rel="stylesheet" type="text/css" media="all" href="${pageContext.servletContext.contextPath}/${initParam.CSSDirectory}/themes/base/jquery.ui.theme.css">
    <link rel="stylesheet" type="text/css" media="all" href="${pageContext.servletContext.contextPath}/${initParam.CSSDirectory}/themes/base/jquery.ui.selectmenu.css">
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/jquery-1.9.1.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/modernizr.custom.79639.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/ui/jquery.ui.core.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/ui/jquery.ui.widget.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/ui/jquery.ui.position.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/ui/jquery.ui.selectmenu.js"></script>
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
                    <a href="calendar.jsp" tabindex="13">home</a>» 
                    <a href="subjects.jsp" tabindex="14">subjects</a> » 
                    <a href="manage_professor.jsp" tabindex="14">manage professor</a> »<a href="create_professor.jsp" tabindex="15">create Professor</a>
                </p>
                <!-- PAGE NAME -->
                <h1>Create Professor</h1>
                <!-- MESSAGES -->
                <div class="warningMessage"><%=message %></div>
                <div class="successMessage"><%=successMessage %></div> 
            </header>
            <form name="createProfessor" id="createProfessor" method="post" action="persist_professor.jsp">
                <article>
                    <header>
                        <h2>Professor Form</h2>
                        <img class="expandContent" width="9" height="6" src="${pageContext.servletContext.contextPath}/${initParam.ImagesDirectory}/arrowDown.svg" title="Click here to collapse/expand content"/>
                    </header>
                    <div class="content">
                        <fieldset>
                            <div class="component">
                                <label for="professorid" class="label">Professor ID:</label>
                                <input type="text" name="professorid" id="professorid" class="input" tabindex="2" title="Please Enter Professor id" >
                            </div>
                            <div class="component">
                                <label for="sectionList" class="label">Section List:</label>
                                <select name="sectionList" id="sectionList" title="Please Select a section">
                                <% for(int i=0;i<allSection.size();i++){ %>
                                    <option><%= allSection.get(i).get("c_id").concat(" ").concat(allSection.get(i).get("sc_id")).concat(" ").concat(allSection.get(i).get("sc_semesterid")).concat(" ").concat(allSection.get(i).get("d_code")) %>  </option><%} %>
                                </select>
                            </div>
                            <div class="component">
                                <div class="buttons">
                                    <button type="submit" name="createProfessor" id="createProfessor" class="button" title="Click here to create">Create</button>                                                                                       
                                    <button type="reset" name="resetCourse" id="resetCourse" class="button" title="Click here to reset">Reset</button>
                                    <button type="button" name="button" id="cancelCourse"  class="button" title="Click here to cancel" 
                                        onclick="window.location.href='manage_professor.jsp'">Cancel</button>
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
                $('#createProfessor').validate({
                    validateOnBlur : true,
                    rules: {
                        professorid: {
                            required: true,
                            pattern: /^\s*[a-zA-z]+\.[a-zA-z]+\s*$/
                        } 
                    },
                    messages: {
                        professorid: { 
                            pattern:"Please enter a valid professor id (format: firstname.lastname)",
                            required:"Professor id is required"
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

