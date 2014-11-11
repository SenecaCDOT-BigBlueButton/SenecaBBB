<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SenecaBBB | Page Not Found</title>
    <link rel="shortcut icon" href="http://www.senecacollege.ca/favicon.ico">
    <link rel="stylesheet" type="text/css" media="all" href="css/fonts.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/style.css">
    <!--
    To customize 404 error page, please add the following lines to web.xml file in tomcat7 server
    <error-page>
        <error-code>404</error-code>
        <location>/page_not_found.jsp</location>
    </error-page>   
    -->
</head>
<body>
    <div id="page">
        <jsp:include page="header_plain.jsp"/>
        <section>
            <header>
                <h1>Page Not Found</h1>               
            </header>
            <div class="help" style="margin-top:50px">
                <p>Sorry, there is no bbbman.senecacollege.ca web page matching your request.
                 It is possible you typed the address incorrectly, or that the page no longer exists.</p>
            </div>
        </section>
        <jsp:include page="footer_plain.jsp"/>
    </div>
</body>
</html>

