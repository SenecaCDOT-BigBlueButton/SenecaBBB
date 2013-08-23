<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%  String isLDAP = (String) session.getAttribute("isLDAP");%>
<html>
    <head>
        <link rel='stylesheet' type='text/css' href='css/calendar_layout.css' />
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
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
                        <h2>User Settings</h2>
                        <form>
                            Nickname: <input type="text" name="nick" /><br><br>
                            <%
                                if (isLDAP.equals("false")) {
                                    out.write("Alternate email: <input type=\"text\" name=\"email\" /><br><br>");
                                }
                                else
                                    out.write("Alternate email: <input type=\"text\" name=\"email\" disabled/><br><br>");
                            %>
                        </form>
                        <h2>Meeting settings</h2>
                        <input type="checkbox"  name="silent"/> Silent mode <a style="font-size:7pt; vertical-align: top;" href="">What is this?</a>
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
