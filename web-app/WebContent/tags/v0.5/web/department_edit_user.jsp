<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String fname = request.getParameter("fname");
    if (fname == null || fname == "null") {
        fname = "";
    }
    String lname = request.getParameter("lname");
    if (lname == null || lname == "null") {
        lname = "";
    }
    String email = request.getParameter("email");
    if (email == null || email == "null") {
        email = "";
    }
    String sid = request.getParameter("usertype");
    if (sid == null || sid == "null") {
        sid = "";
    }
    String create = request.getParameter("create");
    if (create == null || create == "null") {
        create = "";
    }
    String type = (String) session.getAttribute("iUserType");
%>
<!DOCTYPE html>
<html>
    <head>
        <link rel='stylesheet' type='text/css' href='css/calendar_layout.css' />
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script>
            function check()
            {
                drop = document.getElementById("role");
                value = drop.options[drop.selectedIndex].value;
                if (value === "professor") {
                    addDepartment("sub1")
                }
            }
            function addDepartment(section, button) {
                area = document.getElementById(section);

                el = document.createElement("input");
                el = area.appendChild(el);
                el.type = "text";
                el.id = "tempBox";
                el.focus();
                el.name = section;
                document.getElementById(button).value = "Save";
                document.getElementById(button).onclick = (function() {
                    saveSection(button);
                });
            }
            function saveSection(button) {
                tempBox = document.getElementById("tempBox");
                name = tempBox.value;
                area = document.getElementById(tempBox.name);
                area.removeChild(tempBox);
                area.innerHTML += name + "<br/>";
                document.getElementById(button).value = "Add Section";
                document.getElementById(button).onclick = (function() {
                    addSection(tempBox.name, button);
                });
            }
        </script>
        <title>Edit <%=fname%> <%=lname%></title>
    </head>
    <body>
        <div id="header">
            <h1>Edit <%=fname%> <%=lname%></h1>
            <p id="layoutdims">

            </p>
        </div>
        <div class="colmask leftmenu">
            <div class="colleft">
                <div class="col1">
                    <div id="content">
                        <form>
                            <table style="text-align:left">
                                <tr>
                                    <td>First Name:</td>
                                    <td><input type="text" name="firstname" value="<%=fname%>"></td>
                                </tr>
                                <tr>
                                    <td>Last Name:</td>
                                    <td><input type="text" name="lastname" value="<%=lname%>"></td>
                                </tr>
                                <tr>
                                    <td>Email:</td>
                                    <td><input type="text" name="email" value="<%=email%>"></td>
                                </tr>
                                <tr>
                                    <td>User Type:</td>
                                    <td>
                                        <select id="role" onchange="check()">
                                            <option value ="professor"<%if (sid.equals("professor")) {
                                                    out.write("selected=selected");
                                                }%>>Professor</option>
                                            <option value ="student"<%if (sid.equals("student")) {
                                                    out.write("selected=selected");
                                                }%>>Student</option>
                                            <option value ="professor"<%if (sid.equals("employee")) {
                                                    out.write("selected=selected");
                                                }%>>Employee</option>
                                            <option value ="admin"<%if (sid.equals("admin")) {
                                                    out.write("selected=selected");
                                                }%>>Admin</option>
                                        </select>
                                        <div id="sub1"></div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Banned:</td>
                                    <td><input type="checkbox"></td>
                                </tr>
                                <tr><td><h3>Permissions</h3></td></tr>
                                <tr>
                                    <td>Create event:</td>
                                    <td><input type="checkbox" checked></td>
                                </tr>
                                <tr>
                                    <td>Manage class settings:</td>
                                    <td><input type="checkbox" checked></td>
                                </tr>
                                <tr>
                                    <td>Manage professors:</td>
                                    <td><input type="checkbox"></td>
                                </tr>
                                <tr>
                                    <td>Manage users</td>
                                    <td><input type="checkbox"></td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td><input type="button" value="Reset to default"></td>
                                </tr>
                            </table>
                            <%
                                if (create.equals("false")) {
                                    out.write("<a href=\'manage_users.jsp\'><button type=\'button\' >Save</button></a>");
                                } else if (create.equals("true")) {
                                    out.println("<a href=\'manage_users.jsp\'><button type=\'button\' >Create</button></a>");
                                }
                            %>
                        </form>
                    </div>
                </div>
                <div class="col2">
                    <a href="manage_users.jsp"><strong>Back</strong></a>
                </div>
            </div>
        </div>
        <div id="footer">
            This is the footer
        </div>
    </body>
</html>