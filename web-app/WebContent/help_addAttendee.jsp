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
    <title>SenecaBBB | Help: Add User to Event</title>
    <link rel="shortcut icon" href="http://www.senecacollege.ca/favicon.ico">
    <link rel="stylesheet" type="text/css" media="all" href="css/fonts.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/style.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.core.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.theme.css">
    <script type="text/javascript" src="js/jquery-1.9.1.js"></script>
    <script type="text/javascript" src="js/ui/jquery.ui.core.js"></script>

    <%
    //Start page validation
    String userId = usersession.getUserId();
    if (userId.equals("")) {
        response.sendRedirect("index.jsp?message=Please log in");
        return;
    }
    String message = request.getParameter("message");
    String successMessage = request.getParameter("successMessage");
    if (message == null || message == "null") {
        message="";
    }
    if (successMessage == null) {
        successMessage="";
    }
    //End page validation
%>

</head>
<body>
    <div id="page">
        <jsp:include page="header.jsp"/>
        <jsp:include page="menu.jsp"/>
        <section>
            <header> 
                <!-- BREADCRUMB -->
                <h1>Help Page: Add User to Event</h1>
                <br />
                <!-- WARNING MESSAGES -->
                <div class="warningMessage"><%=message %></div>
                <div class="successMessage"><%=successMessage %></div> 
            </header>
            <article>
                <div class="content">
                    <fieldset>
                    <hr />
                        <h2>Why is there two search fields?</h2>
                        <ol>
                            <li>the ADD USER field takes in the EXACT user id and adds it to the appropriate list.</li>
                            <li>the SEARCH USER field takes the search term and search for a guest user.</li>
                        </ol>
                    </fieldset>
                </div>
            </article>
            <article>
                <div class="content">
                    <fieldset>
                    <hr />
                        <h2>What formats are accepted in the SEARCH USER field?</h2>
                        <ol>
                            <li>You can enter a single (1) term, this can be first name or last name.</li>
                            <li>You can enter two (2) terms separated by a space or comma.</li>
                            <li>Examples: ""firstname lastname" "firstname.lastname"</li>
                        </ol>
                    </fieldset>
                </div>
            </article>
            <article>
                <div class="content">
                    <fieldset>
                    <hr />
                        <h2>I entered a search term but nothing came up, why?</h2>
                        <ol>
                            <li>Please note that the SEARCH USER function only searches the guest users in the local database, it does not search for Seneca IDs.</li>
                        </ol>
                    </fieldset>
                </div>
            </article>
        </section>
        <jsp:include page="footer.jsp"/>
    </div>
</body>
</html>
