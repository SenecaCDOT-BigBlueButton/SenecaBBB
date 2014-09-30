<%@page import="db.DBConnection"%>
<%@page import="db.DBAccess" %>
<%@page import="sql.Admin" %>
<%@page import="java.util.ArrayList" %>
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<jsp:useBean id="ldap" scope="session" class="ldap.LDAPAuthenticate" />
<%
String message = request.getParameter("message");
String successMessage = request.getParameter("successMessage");
if (message == null || message == "null") {
    message="";
}
if (successMessage == null) {
    successMessage="";
}
String guestMessage = "";
String bu_id = "";
String guestCreated = request.getParameter("guestCreated");
if (guestCreated == null)
    guestCreated = "false";
if (guestCreated.equals("true")){
    bu_id = request.getParameter("bu_id");
    if (bu_id == null) {
        bu_id = "";
    } 
    else{ 
        successMessage = "Log in with username " + bu_id + "and the password you just set";
    }
}
if (usersession.getUserId() != ""){
    response.sendRedirect("calendar.jsp");
    return;
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SenecaBBB | Conference Management System</title>
    <link rel="shortcut icon" href="http://www.senecacollege.ca/favicon.ico" />
    <link href="css/themes/base/style.css" rel="stylesheet" type="text/css" media="all">
    <link href="css/fonts.css" rel="stylesheet" type="text/css" media="all">
    <script type="text/javascript" src="js/jquery-1.9.1.js"></script>
    <script type="text/javascript" src="js/jquery.noty.packaged.js"></script>
    <script type="text/javascript">
    /*
        if (window.location.protocol == "http:") {
            var restOfUrl = window.location.href.substr(5);
            window.location = "https:" + restOfUrl;
        }
    */    
        function trim(s) {
            return s.replace(/^\s*/, "").replace(/\s*$/, "");
        }
        function validate() {
            if (trim(document.getElementById("SenecaLDAPBBBLogin").value) == "") {
                alert("Login empty");
                document.getElementById("SenecaLDAPBBBLogin").focus();
                return false;
            } else if (trim(document.getElementById("SenecaLDAPBBBLoginPass").value) == "") {
                alert("Password empty");
                document.getElementById("SenecaLDAPBBBLoginPass").focus();
                return false;
            }
        }
    /*
        function showNotification()
        {
            var xmlhttp;   
            if (window.XMLHttpRequest){// code for IE7+, Firefox, Chrome, Opera, Safari
                xmlhttp=new XMLHttpRequest();
            }else{// code for IE6, IE5
                xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
            }
            xmlhttp.onreadystatechange=function(){
              if (xmlhttp.readyState==4 && xmlhttp.status==200){
                   document.getElementById("notification").innerHTML=xmlhttp.responseText;
              }
            }
            xmlhttp.open("POST","getNotification.jsp",true);
            xmlhttp.send();
        }
    */
        $(document).ready(function(){
            if(localStorage.Y > 0 || localStorage.X > 0){ 
                window.scrollBy(localStorage.X,localStorage.Y);  
            }
            if($(".warningMessage").text() !=""){
                var message = $(".warningMessage").text();
                var notierrMessage = noty({text: '<div>'+ message+' <img  class="notyCloseButton" src="css/themes/base/images/x.png" alt="close" /></div>',
                              layout:'top',
                              type:'error'});
                }
        
            if($(".successMessage").text() !=""){
                var successMessage = $(".successMessage").text();
                var notiMessage = noty({text: '<div>'+ successMessage+'<img  class="notyCloseButton" src="css/themes/base/images/x.png" alt="close" /></div>',
                              layout:'top',
                              type:'success'
                             });
            }
            
        
        });
    </script>
</head>

<body>
    <!-- Login form. -->
    <div id="page">
        <jsp:include page="header_plain.jsp"/>
        <% 
        DBAccess dbaccess = new DBAccess(); 
        Admin admin = new Admin(dbaccess);
        String notification="";
        notification = getNotification(dbaccess,admin);
        if (!notification.equals("")) {
        %>
        <section>
        	<div id="notification">     
        	    <p><%= notification %></p>
        	</div>
        </section>
        <% } %>
        <section id="login">
            <header>
                  <!-- MESSAGES -->
                <div class="warningMessage"><%=message %></div>
                <div class="successMessage"><%=successMessage %></div>
                <br /><br />
            </header>
            <form id="login" name="formLogin" action="auth.jsp" onSubmit="return validate();" method="post">
                <article >
                    <fieldset>
                        <div class="component">
                            <label for="SenecaLDAPBBBLogin" class="label">Username:</label>
                            <input type="text" name="SenecaLDAPBBBLogin" id="SenecaLDAPBBBLogin" class="input" tabindex="2" title="Please insert your username" required autofocus value="<%=bu_id%>">
                        </div>
                        <div class="component">
                            <label for="SenecaLDAPBBBLoginPass" class="label">Password:</label>
                            <input type="password" name="SenecaLDAPBBBLoginPass" id="SenecaLDAPBBBLoginPass" class="input" tabindex="3" title="Please insert your password" required>
                        </div>
                    </fieldset>
                </article>
                <article>
                    <fieldset>
                        <div class="buttons">
                            <button type="submit" name="submit" id="save" class="button" title="Click here to login">Login</button>
                        </div>
                    </fieldset>
                </article>
          </form>
        </section>
        <jsp:include page="footer.jsp"/>
    </div>
</body>
</html>

<%!
public String getNotification(DBAccess dbaccess,Admin admin) {
    ArrayList<ArrayList<String>> result = new ArrayList<ArrayList<String>>();
    String msg="";
    if(admin.getNotification(result)){
        if(result.size()>0){
            msg = result.get(0).get(0);
        }
    }
    return msg;
}
%>