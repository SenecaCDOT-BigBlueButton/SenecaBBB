<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String sname = request.getParameter("sname");
    if (sname == null || sname == "null") {
        sname = "";
    }
    String scode = request.getParameter("scode");
    if (scode == null || scode == "null") {
        scode = "";
    }
    String create = request.getParameter("create");
    if (create == null || create == "null") {
        create = "";
    }
    String professor = request.getParameter("professor");
    if (professor == null || professor == "null") {
        professor = "";
    }
    String created = request.getParameter("created");
    if (created == null || created == "null") {
        created = "";
    }
    String status = request.getParameter("status");
    if (status == null || status == "null") {
        status = "3";
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <link rel='stylesheet' type='text/css' href='css/calendar_layout.css' />
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script>
            function create() {
                var scode = document.getElementById("scode").value;
                var sname = document.getElementById("sname").value;
                window.location.href = "manage_subjects.jsp?professor=<%=professor%>&scode=" + scode + "&sname=" + sname + "&created=true" + "&status=" + <%=status%>;
            }
            function save() {
                var created = "<%=created%>";
                if (created !== "") {
                    var scode = document.getElementById("scode").value;
                    var sname = document.getElementById("sname").value;
                    window.location.href = "manage_subjects.jsp?professor=<%=professor%>&scode=" + scode + "&sname=" + sname + "&created=true" + "&status=" + <%=status%>;
                }
                else {
                    var scode = document.getElementById("scode").value;
                    var sname = document.getElementById("sname").value;
                    window.location.href = "manage_subjects.jsp?professor=" + "<%=professor%>" + "&scode=" + scode + "&sname=" + sname + "&status=" + <%=status%>;
                }
            }
        </script>
        <title>Edit <%=scode%></title>
    </head>
    <body>
        <div id="header">
            <h1>Edit <%=scode%></h1>
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
                                    <td>Course Code:</td>
                                    <td><input type="text" id="scode" value="<%=scode%>"></td>
                                </tr>
                                <tr>
                                    <td>Course Name:</td>
                                    <td><input type="text" id="sname" value="<%=sname%>"></td>
                                </tr>
                            </table>
                            <%
                                if (create.equals("false")) {
                                    out.write("<button onclick=\'save()\' type=\'button\' >Save</button></a>");
                                } else if (create.equals("true")) {
                                    out.write("<button onclick=\'create()\' type=\'button\' >Create</button>");
                                }
                            %>
                        </form>
                    </div>
                </div>
                <div class="col2">
                    <a href="manage_subjects.jsp?professor=<%=professor%>&scode=<%=scode%>&sname=<%=sname%>"><strong>Back to <%=professor%>'s Subjects</strong></a>
                </div>
            </div>
        </div>
        <div id="footer">
            This is the footer
        </div>
    </body>
</html>