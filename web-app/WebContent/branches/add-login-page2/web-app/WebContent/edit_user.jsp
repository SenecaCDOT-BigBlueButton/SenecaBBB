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
        <style type='text/css'>
            #content {
                margin: auto;
                float: left;
            }

        </style>
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
                                        <select>
                                            <option value ="professor"<%if (sid.equals("professor")) {
                                                    out.write("selected=selected");
                                                }%>>Professor</option>
                                                    <option value ="student"<%if (sid.equals("student")) {
                                                    out.write("selected=selected");
                                                }%>>Student</option>
                                                    <option value ="professor"<%if (sid.equals("employee")) {
                                                    out.write("selected=selected");
                                                }%>>Employee</option>
                                                    <%
                                                        
                                                        if (type.equals("superadmin"))
                                                            out.write("<option value='admin'>Admin</option>");
                                                    %>
                                        </select>
                                    </td>
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