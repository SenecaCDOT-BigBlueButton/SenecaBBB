<%@page import="sql.User"%>
<%@page import="sql.Meeting"%>
<%@page import="sql.Lecture"%>
<%@page import="java.util.ArrayList" %>
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SenecaBBB | Contact Us</title>
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
                <p>
                    <a href="calendar.jsp" tabindex="13">home</a> »<a href="contactUs.jsp" tabindex="13">contact us</a>
                </p>
                <h1>Contact Us</h1>
            </header>
            <div class="contactus">
                <h2>Seneca College of Applied Arts and Technology</h2>
                <p>Seneca@York Campus </p>
                <p>70 The Pond Road  </p>
                <p>Toronto, Ontario, M3J 3M6  </p>
                <p>Phone: (416) 491-5050 ext 33220  </p>
            </div>
            <div class="contactus">
                <h2>Contact Persons</h2>
                <p>Fardad Soleimanloo</p>
                <p><a href="mailto:fardad.soleimanloo@senecacollege.ca?subject=senecaBBB">fardad.soleimanloo@senecacollege.ca</a></p>
                <p>Chad Pilkey</P>
                <p><a href="mailto:chad.pilkey@senecacollege.ca?subject=senecaBBB">chad.pilkey@senecacollege.ca</a></p>                             
            </div>
        </section>
        <jsp:include page="footer.jsp"/>
    </div>
</body>
</html>

