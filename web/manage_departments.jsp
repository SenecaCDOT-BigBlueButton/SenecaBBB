<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%  String isLDAP = (String) session.getAttribute("isLDAP");%>
<html>
    <head>
        <link rel='stylesheet' type='text/css' href='css/calendar_layout.css' />
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script>
            function goPage() {
                window.location.href = "edit_departments.jsp?create=true"
            }
        </script>
        <title>Manage Departments</title>
    </head>
    <body>
        <div id="header">
            <h1>Manage Departments</h1>
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
                        <h2>All Departments</h2>
                        <table border='1'>
                            <tr>
                                <td>Select</td>
                                <td>Name</td>
                                <td>Modify</td>
                            </tr>
                            <tr>
                                <td><input type="checkbox"></td>
                                <td>ICT</td>
                                <td><a href='edit_departments.jsp?fname=ICT&create=false'>Edit</a></td>
                            </tr>
                            <tr>
                                <td><input type="checkbox"></td>
                                <td>Artsy Fartsy</td>
                                <td><a href='edit_departments.jsp?fname=Artsy Fartsy&create=false'>Edit</a></td>
                            </tr>
                        </table>
                        <input type="button" value="Add Department" onclick="goPage()">
                        <input type="button" value="Delete Selected" onclick="confirm('Are you sure?');">
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