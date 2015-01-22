<%@page import="db.DBConnection"%>
<%@page import="hash.PasswordHash"%>
<%@page import="sql.User"%>
<%@page import="java.util.*"%>
<%@page import="helper.MyBoolean"%>
<%@page import= "helper.*" %>
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SenecaBBB | Change Password</title>
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
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/ui/jquery.ui.stepper.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/componentController.js"></script>
    <%
    String message = request.getParameter("message");
    GetExceptionLog elog = new GetExceptionLog();
    String successMessage = request.getParameter("successMessage");
    if (message == null || message == "null") {
        message = "";
    }
    if (successMessage == null) {
        successMessage = "";
    }

    String key = request.getParameter("key");
    String bu_id = request.getParameter("user");
    if (key == null || bu_id == null) {
        elog.writeLog("[guest_setup:] " + " invalid username or key " + " /n");
        response.sendRedirect("index.jsp?message=Invalid username or key");
        return;
    }

    String success = request.getParameter("success");
    if (success == null) {
        success = "";
    } else {
        successMessage = "Log in with username " + bu_id;
    }
    boolean badParams = false;
    User user = new User(dbaccess);
    ArrayList<HashMap<String, String>> keyArray = new ArrayList<HashMap<String, String>>();
    ArrayList<String> retrievedKey = new ArrayList<String>();
    user.getSalt(keyArray, bu_id);
    if (keyArray.size() == 0) {
        message = "Invalid username or key";
        badParams = true;
    } else {
        if (!keyArray.get(0).get("nu_salt").equals(key)) {
            message = "Invalid username or key";
            badParams = true;
        }
    }
    %>

    <script type="text/javascript">
    
        function trim(s) {
        	return s.replace(/^\s*/, "").replace(/\s*$/, "");
        }
        function validate() {
            if (trim(document.getElementById("newPassword").value) == "") {
                $(".warningMessage").text("Please enter a password!");
                var notyMsg = noty({text: '<div>'+ $(".warningMessage").text()+' <img  class="notyCloseButton" src="${pageContext.servletContext.contextPath}/${initParam.CSSDirectory}/themes/base/images/x.png" alt="close" /></div>',
                                    layout:'top',
                                    type:'error'});
                document.getElementById("newPassword").focus();
                return false;
            }
            if (trim(document.getElementById("confirmPassword").value) == "") {
                $(".warningMessage").text("Please confirm your new password!");
                var notyMsg = noty({text: '<div>'+ $(".warningMessage").text()+' <img  class="notyCloseButton" src="${pageContext.servletContext.contextPath}/${initParam.CSSDirectory}/themes/base/images/x.png" alt="close" /></div>',
                                    layout:'top',
                                    type:'error'});
                document.getElementById("confirmPassword").focus();
                return false;
            }
            if (document.getElementById("newPassword").value != document.getElementById("confirmPassword").value) {
                $(".warningMessage").text("Passwords don't match!");
                var notyMsg = noty({text: '<div>'+ $(".warningMessage").text()+' <img  class="notyCloseButton" src="${pageContext.servletContext.contextPath}/${initParam.CSSDirectory}/themes/base/images/x.png" alt="close" /></div>',
                                    layout:'top',
                                    type:'error'});
                document.getElementById("newPassword").focus();
                return false;
            }
            return true;
        }
    </script>

</head>
<body>
    <div id="page">
        <jsp:include page="header_plain.jsp"/>
        <section>
            <header>
              <h1>Guest Setup</h1>
                  <!-- WARNING MESSAGES -->
                  <div class="warningMessage"><%=message %></div>
                  <div class="successMessage"><%=successMessage %></div>
            </header>
            <form action="persist_password.jsp" method="get" onSubmit="return validate()" <%if (badParams) out.write("hidden=\"hidden\""); %>>
                <article>
                    <header>
                        <h2>Edit Password</h2>
                        <img class="expandContent" width="9" height="6" src="${pageContext.servletContext.contextPath}/${initParam.ImagesDirectory}/arrowDown.svg" title="Click here to collapse/expand content"/>
                    </header>
                    <fieldset>
                        <div class="component">
                            <label for="newPassword" class="label">New password:</label>
                            <input type="hidden" name="frompage" id="frompage" value="guest">
                            <input type="password" name="newPassword" id="newPassword" class="input" tabindex="20" title="New password">
                        </div>
                        <div class="component">
                            <label for="confirmPassword" class="label">Confirm password:</label>
                            <input type="password" name="confirmPassword" id="confirmPassword" class="input" tabindex="21" title="Confirm password">
                        </div>
                        <input type=hidden class="input" name="page" id="page" value="guest">
                        <input type=hidden class="input" name="key" id="key" value="<%=key%>">
                        <input type=hidden class="input" name="bu_id" id="bu_id" value="<%=bu_id%>">
                    </fieldset>
                </article>
                <article>
                    <fieldset>
                        <div class="buttons">
                            <button type="submit" name="submit" id="save" class="button" title="Click here to save inserted data">Save</button>
                            <button type="button" name="button" id="cancel"  class="button" title="Click here to cancel" onclick="window.location.href='calendar.jsp'">Cancel</button>
                        </div>
                    </fieldset>
                </article>
            </form>
        </section>
        <jsp:include page="footer.jsp"/>
    </div>
</body>
</html>