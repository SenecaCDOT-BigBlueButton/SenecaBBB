<%@ page contentType="text/html; charset=iso-8859-1" language="java"%>
<html>
    <head>
        <title>Successfully Login by JSP</title>
    </head>

    <body>
        Successfully login by JSP<br />
        Session Value<br />
        <%
            out.print("UserName: " + session.getAttribute("sUserID") + "<br>");
            out.print("First & Last Name: " + session.getAttribute("sUserName"));
        %>
    </body>
</html>
