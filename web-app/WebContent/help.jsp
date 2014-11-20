<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SenecaBBB | Help</title>
    <link rel="shortcut icon" href="http://www.senecacollege.ca/favicon.ico">
    <link rel="stylesheet" type="text/css" media="all" href="css/fonts.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/style.css">
    <script type="text/javascript" src="js/jquery-1.9.1.js"></script>
</head>
<body>
    <div id="page">
        <jsp:include page="header.jsp"/>
        <jsp:include page="menu.jsp"/>
        <section>
            <header>
                <p><a href="calendar.jsp" tabindex="13">home</a> »<a href="help.jsp" tabindex="13">support</a> </p>
                <h1>Support</h1>               
            </header>
            <div class="help">
                <h2>Common Issues</h2>
                <ol>
                    <li><strong>Account Login</strong>
                        <p>--For Seneca College students and employees, use your student/employee account username and password to log in.</p>
                        <p>--For Guest user, please contact your event initiators to create account for you.</p>                   
                    </li>
                    <li><strong>Forgot Password</strong>
                        <p>--For Seneca College students and employees, please visit <a href="https://inside.senecacollege.ca/its/index.html">HELP DESK </a>to reset your password.</p>
                        <p>--For Guest user, please contact your event initiators.</p>  
                    </li>
                    <li><strong>Create Meetings/Lectures</strong>
                        <p>--Login with your username and password</p>
                        <p>--Click on Create Event</p> 
                        <p>--Complete the information and specify any future time for your events</p>
                        <p>--Click on the Save button</p> 
                    </li>
                    <li><strong>BigBlueButton FAQ</strong>
                        <P>--Please visit <a href="http://code.google.com/p/bigbluebutton/wiki/FAQ">BigBlueButton Frequently Asked Questions</a> to find your answers</p>                         
                    </li>
                </ol>
            </div>
            <div class="help">
                <h2>BigBlueButton Community Support</h2>
                <ol>
                    <li><a title="BigBlueButton Setup" href="http://groups.google.com/group/bigbluebutton-setup/topics?gvc=2">
                        <strong>BigBlueButton Setup</strong></a> --Get help with installation, setup, and configuration of a BigBlueButton server.
                    </li>
                    <li><a title="BigBlueButton Users" href="http://groups.google.com/group/bigbluebutton-users/topics?gvc=2">
                        <strong>BigBlueButton Users</strong></a>--Get help and give feedback about using BigBlueButton. 
                    </li>
                    <li><a title="BigBlueButton Developers" href="http://groups.google.com/group/bigbluebutton-dev/topics?gvc=2">
                        <strong>BigBlueButton Developers</strong></a>--Ask questions and share experiences with other BigBlueButton developers. 
                    </li>                                       
                </ol>
            </div>
        </section>
        <jsp:include page="footer.jsp"/>
    </div>
</body>
</html>

