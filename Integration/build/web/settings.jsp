<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <link rel='stylesheet' type='text/css' href='css/calendar_layout.css' />
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <style type='text/css'>
            #content {
                margin: auto;
                float: left;
            }

        </style>
        <title>User and Meeting Settings</title>
    </head>
    <body>
        <div id="header">
            <h1>User and Meeting Settings</h1>
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
                        <input type="checkbox" name="guests" value="ON" />Allow guests <br><br>
                        <form>
                            Default password: <input type="password" name="password" placeholder="Password"><br><br>
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
