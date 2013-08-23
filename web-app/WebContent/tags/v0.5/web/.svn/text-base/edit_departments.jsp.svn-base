<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String fname = request.getParameter("fname");
    if (fname == null || fname == "null") {
        fname = "";
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
        <title>Edit <%=fname%></title>
    </head>
    <body>
        <div id="header">
            <h1>Edit <%=fname%></h1>
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
                                    <td>Department Name:</td>
                                    <td><input type="text" name="firstname" value="<%=fname%>"></td>
                                </tr>
                               
                            </table>
                            <%
                                if (create.equals("false")) {
                                    out.write("<a href=\'manage_departments.jsp\'><button type=\'button\' >Save</button></a>");
                                } else if (create.equals("true")) {
                                    out.println("<a href=\'manage_departments.jsp\'><button type=\'button\' >Create</button></a>");
                                }
                            %>
                            <input type="button" value="Delete" onclick="confirm('Are you sure?');">
                        </form>
                    </div>
                </div>
                <div class="col2">
                    <a href="manage_departments.jsp"><strong>Back</strong></a>
                </div>
            </div>
        </div>
        <div id="footer">
            This is the footer
        </div>
    </body>
</html>