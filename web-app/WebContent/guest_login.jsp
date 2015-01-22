<%
String message = request.getParameter("message");
String successMessage = request.getParameter("successMessage");
String meetingId = request.getParameter("meetingId");
if (message == null || message == "null") {
    message = "";
}
if (successMessage == null) {
    successMessage = "";
}
session.setAttribute("guestmeetingId", meetingId);
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
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/jquery-1.9.1.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/jquery.noty.packaged.js"></script>
    <script type="text/javascript" src="${pageContext.servletContext.contextPath}/${initParam.JavaScriptDirectory}/moment.js"></script>
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
            <article>
                <fieldset>
                    <div class="component">
                        <h2>Welcome to Seneca BigBlueButton Web Conference System!</h2>
                        <p>BigBlueButton is an open source web conferencing system for on-line learning. BigBlueButton enables you to share documents
                        (PDF and any office document), webcams, chat, audio and your desktop. It can also record sessions for later playback.</p>
                        <p>You can join the conference at scheduled date time. 
                           If you have any difficulties to join the conference, please contact your conference moderator!</p>
                        <p>If you are student or faculty of Seneca College, you can login our BigBlueButton Conference System 
                          using your Seneca Id and Password at <a href="https://bbbman.senecacollege.ca">https://bbbman.senecacollege.ca </a></p>
                        </div>
                </fieldset>
            </article>          
            <form id="login" name="formLogin" action="guest_join_event.jsp" onSubmit="return validate();" method="get">
                <article >
                    <fieldset>
                        <div class="component">
                            <input type="text" name="SenecaGuestLogin" id="SenecaGuestLogin" class="input guestlogin" tabindex="2" title="Please enter your name"  placeholder="Enter Your Name" required autofocus >
                            <button type="submit" name="submit" id="save" class="guestloginbutton" title="Click here to login">Join</button>                          
                        </div>
                    </fieldset>
                </article>
          </form>
        </section>
        <jsp:include page="footer_plain.jsp"/>
    </div>
</body>
</html>
