<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String className = request.getParameter("class");
    if (className == null || className == "null") {
        className = "";
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <link rel='stylesheet' type='text/css' href='css/calendar_layout.css' />
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><%=className%> Settings</title>
    </head>
    <body>
        <div id="header">
            <h1><%=className%></h1>
            <p id="layoutdims">
                <select name="classes" onchange="settings(this);">
                    <option value="">Choose a section</option>
                    <option value="A">Section A</option>
                    <option value="B">Section B</option>
                </select>
            </p>
        </div>
        <div class="colmask leftmenu">
            <div class="colleft">
                <div class="col1">
                    <div id="content">
                       Upload student list <input type="file" id="input">
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
