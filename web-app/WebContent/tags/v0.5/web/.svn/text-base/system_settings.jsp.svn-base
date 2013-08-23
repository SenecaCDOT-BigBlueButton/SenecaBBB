<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%  String isLDAP = (String) session.getAttribute("isLDAP");%>
<html>
    <head>
        <link rel='stylesheet' type='text/css' href='css/calendar_layout.css' />
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>System Settings</title>
    </head>
    <body>
        <div id="header">
            <h1>System Settings</h1>
            <p id="layoutdims">
                <%
                    String type = (String) session.getAttribute("iUserLevel");
                    out.write("You are a <strong>" + type + "</strong>");
                %>
            </p>
        </div>
        <div class="colmask leftmenu">
            <div class="colleft">
                <div class="col1">
                    <div id="content">
                        <h2>System Settings</h2>
                        <form>
                            Global Timeout: <input type="text" name="nick" /><br><br>
                        </form>
                    </div>
                </div>
                <div class="col2">
                    <a href="calendar.jsp"><strong>Back</strong></a>
                </div>
            </div>
        </div>
        <div id="footer">
            This is the footer
        </div>
    </body>
</html>