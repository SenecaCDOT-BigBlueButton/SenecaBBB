<%@page import="db.DBConnection"%>
<%@page import="db.DBAccess" %>
<%@page import="sql.Admin" %>
<%@page import="java.util.ArrayList" %>
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<jsp:useBean id="ldap" scope="session" class="ldap.LDAPAuthenticate" />
<%
String message = request.getParameter("message");
String successMessage = request.getParameter("successMessage");
String meetingId = request.getParameter("meetingId");
if (message == null || message == "null") {
    message="";
}
if (successMessage == null) {
    successMessage="";
}

session.setAttribute("guestmeetingId", meetingId);
System.out.println("guest login"+ meetingId);
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
    <script type="text/javascript" src="js/moment.js"></script>
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
                $(".warningMessage").text("Login empty!");
                var notyMsg = noty({text: '<div>'+ $(".warningMessage").text()+' <img  class="notyCloseButton" src="css/themes/base/images/x.png" alt="close" /></div>',
                                    layout:'top',
                                    type:'error'});
                document.getElementById("SenecaLDAPBBBLogin").focus();
                return false;
            } else if (trim(document.getElementById("SenecaLDAPBBBLoginPass").value) == "") {
                $(".warningMessage").text("Password empty!");
                var notyMsg = noty({text: '<div>'+ $(".warningMessage").text()+' <img  class="notyCloseButton" src="css/themes/base/images/x.png" alt="close" /></div>',
                                    layout:'top',
                                    type:'error'});
                document.getElementById("SenecaLDAPBBBLoginPass").focus();
                return false;
            }
        }

        $(document).ready(function(){
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
        <section id="login">
            <header>
                  <!-- MESSAGES -->
                <div class="warningMessage"><%= message %></div>
                <div class="successMessage"><%= successMessage %></div>
                <br /><br />
            </header>           
            <form id="login" name="formLogin" action="guest_join_event.jsp" onSubmit="return validate();" method="get">
                <article >
                    <fieldset>
                        <div>
                            <p style="text-align :center; font-size:20px; margin-bottom:30px">Welcome to Seneca College BigBlueButton Web Conference System!</p>
                        </div>
                        <div class="component">
                            <input type="text" name="SenecaGuestLogin" id="SenecaGuestLogin" class="input" tabindex="2" title="Please enter your name"  placeholder="Enter Your Name" required autofocus >
                        </div>
                    </fieldset>
                </article>
                <article>
                    <fieldset>
                        <div class="buttons">
                            <button type="submit" name="submit" id="save" class="button" title="Click here to login">Join</button>
                        </div>
                    </fieldset>
                </article>
          </form>
        </section>
        <jsp:include page="footer.jsp"/>
    </div>
</body>
</html>
