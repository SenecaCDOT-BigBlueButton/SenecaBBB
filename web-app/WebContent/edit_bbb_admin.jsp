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
    if(!(usersession.isSuper())) {
        elog.writeLog("[edit_bbb_admin:] " + " username: "+ userId + " tried to access this page, permission denied" +" /n");
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
    String key_name = request.getParameter("key_name");
    String key_value = request.getParameter("key_value");
    String key_title = request.getParameter("key_title");
    %>
    <title>SenecaBBB | Edit System Admin</title>
    <link rel="shortcut icon" href="http://www.senecacollege.ca/favicon.ico">
    <link rel="stylesheet" type="text/css" media="all" href="css/fonts.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/style.css">
    <script type="text/javascript" src="js/jquery-1.9.1.js"></script>
    <script type="text/javascript" src="js/modernizr.custom.79639.js"></script>
    <script type="text/javascript" src="js/jquery.validate.min.js"></script>
    <script type="text/javascript" src="js/additional-methods.min.js"></script>
</head>

<body>
    <div id="page">
        <jsp:include page="header.jsp"/>
        <jsp:include page="menu.jsp"/>
        <section>
            <header> 
                <!-- BREADCRUMB -->
                <p><a href="calendar.jsp" tabindex="13">home</a> » <a href="system_settings.jsp" tabindex="14">system settings</a> »<a href="edit_bbb_admin.jsp" tabindex="15">edit system admin</a></p>
                <!-- PAGE NAME -->
                <h1>Edit System Admin</h1>            
                <!-- MESSAGES -->
                <div class="warningMessage"><%=message %></div>
                <div class="successMessage"><%=successMessage %></div>       
                </header>
            <form name="editAdmin" id="editAdmin" method="post" action="persist_bbbadmin_setting.jsp">
                <article>
                    <header>
                        <h2>Admin Information</h2>
                        <img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content"/>
                    </header>
                    <div class="content">
                        <fieldset>
                            <div class="component">
                                <label for="keyname" class="label">Key Name:</label>
                                <input type="text" readonly name="key_name" id="key_name" class="input" tabindex="2"  
                                       value="<%= key_name %>" title="key_name" >                      
                            </div>
                            <div class="component">
                                <label for="keytitle" class="label">Key title:</label>
                                <input type="text" readonly name="key_title" id="key_title" class="input" tabindex="3"  
                                       value="<%= key_title %>" title="key_title" >
                            </div>
                            <div class="component">
                                <label for="keyvalue" class="label">key value:</label>
                                <input type="text" <% if(key_name.equals("timeout")) out.print("name='number_value'"); else
                                       out.print("name='key_value'");%>  class="input" tabindex="4"  value="<%= key_value %>" 
                                       title="Please Enter key value" >
                            </div>
                            <div class="component">
                                <div class="buttons">                          
                                    <button type="submit" name="updatesystem" id="updatesystem" class="button" title="Click here to update">Update</button>                                                                                                                                
                                    <button type="reset" name="reset" id="reset" class="button" title="Click here to reset">Reset</button>
                                    <button type="button" name="button" id="Course"  class="button" title="Click here to cancel" 
                                            onclick="window.location.href='system_settings.jsp'">Cancel</button>
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
                 $('#editAdmin').validate({
                     validateOnBlur : true,
                     rules: {
                         key_value: {
                             required: true,
                             pattern: /^\s*[a-zA-z]+\s*$/
                        },
                        number_value:{
                             required: true,
                             pattern: /^\s*[0-9]+\s*$/
                        },
                        key_value:{
                             required: false,
                             pattern: /^\s*[#@!,\.a-zA-z0-9 ]+\s*$/
                        }
                     },
                     messages: {
                         key_value: { 
                             pattern:"Please enter a valid value",
                             required:"key_value is required"
                         },
                         number_value:{
                             required: "timeout value is required",
                             pattern: "number only"
                         },
                         key_value:{
                             pattern:"Invalid characters"
                         }
                     }
                 });
             });
        </script>
        <jsp:include page="footer.jsp"/>
    </div>
</body>
</html>