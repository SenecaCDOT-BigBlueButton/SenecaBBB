<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String professor = request.getParameter("professor");
    if (professor == null || professor == "null") {
        professor = "";
    }
    String created = request.getParameter("created");
    if (created == null || created == "null") {
        created = "";
    }
    String scode = request.getParameter("scode");
    if (scode == null || scode == "null") {
        scode = "";
    }
    String sname = request.getParameter("sname");
    if (sname == null || sname == "null") {
        sname = "";
    }
    String status = request.getParameter("status");
    if (status == null || status == "null") {
        status = "";
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <link rel='stylesheet' type='text/css' href='css/calendar_layout.css' />
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script>
            function deleteRow(num)
            {
                var r = confirm("Are you sure?");
                if (r)
                    document.getElementById("table").deleteRow(num);
            }
            function addSection(section, button) {
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
            function edit(code, name)
            {
                window.location.replace("edit_subject.jsp?scode=" + code + "&sname=" + name + "&professor=<%=professor%>&create=false");
                alert("");
            }
            function addProf(button, loc)
            {
                area = document.getElementById(loc);
                el = document.createElement("input");
                el2 = document.createElement("input");
                select = document.createElement("select");
                select.setAttribute("id", "dropDown");
                var option;
                option = document.createElement("option");
                option.setAttribute("value", "A");
                option.innerHTML = "A";
                select.appendChild(option);
                option = document.createElement("option");
                option.setAttribute("value", "B");
                option.innerHTML = "B";
                select.appendChild(option);
                el = area.appendChild(el);
                el2 = area.appendChild(el2);
                area.appendChild(select);
                el.type = "text";
                el.id = "tempBox";
                el.focus();
                el.name = loc;
                el2.type = "button";
                el2.id = "searchBtn";
                el2.value = "Search";
                el2.onclick = searchGuest;
                document.getElementById(button).value = "Save";
                document.getElementById(button).onclick = (function() {
                    saveProf(button);
                });
            }
            function saveProf(button) {
                tempBox = document.getElementById("tempBox");
                tempBtn = document.getElementById("searchBtn");
                tempDrop = document.getElementById("dropDown");
                name = tempBox.value;
                name2 = tempDrop[tempDrop.selectedIndex].value;
                area = document.getElementById(tempBox.name);
                area.removeChild(tempBox);
                area.removeChild(tempBtn);
                area.removeChild(tempDrop);
                area.innerHTML += name + " " + name2 + "<br/>";
                document.getElementById(button).value = "Add Prof";
                document.getElementById(button).onclick = (function() {
                    addProf(button, tempBox.name);
                });
            }
            function searchGuest()
            {
                value = document.getElementById("tempBox").value;
            }
        </script>
        <title>Manage Subjects</title>
    </head>
    <body>
        <div id="header">
            <h1>Manage All Subjects</h1>
            <p id="layoutdims">
            </p>
        </div>
        <div class="colmask leftmenu">
            <div class="colleft">
                <div class="col1">
                    <div id="content">
                        <h2>Current </h2>
                        <table id="table" border="1">
                            <tr>
                                <td>Subject Code</td>
                                <td>Subject Name</td>
                                <td>Sections</td>
                                <td>Professors</td>
                                <td>Modify</td>
                            </tr>
                            <tr>
                                <td><%=status.equals("1") ? scode : "BTP100"%></td>
                                <td><%=status.equals("1") ? sname : "Programming Fundamentals using C"%></td>
                                <td>
                                    <div id="sub1">
                                        A</a><br/>
                                        B<br/>
                                    </div>
                                    <input type="button" value="Add Section" id="button" onclick="addSection('sub1', 'button')">
                                </td>
                                <td>
                                    <div id="sub4"></div>
                                    <input type="button" id="button3" onclick="addProf('button3', 'sub4')" value="Add Prof">
                                </td>
                                <td><a href="alternate_edit_subject.jsp?scode=<%=status.equals("1") && !scode.equals("") ? scode : "BTP100"%>&sname=<%=status.equals("1") && !sname.equals("") ? sname : "Programming Fundamentals using C"%>&professor=<%=professor%>&status=1&create=false">Edit Subject</a></br><button type="button" onclick="deleteRow(1)">Delete</button></td>
                            </tr>
                            <tr>
                                <td><%=status.equals("2") ? scode : "BTC140"%></td>
                                <td><%=status.equals("2") ? sname : "Critical Thinking and Writing"%></td>
                                <td>
                                    <div id="sub2">
                                        A <br/>
                                    </div>
                                    <input type="button" value="Add Section" id="button2" onclick="addSection('sub2', 'button2')">
                                </td>
                                <td>
                                    <div id="sub5"></div>
                                    <input type="button" id="button4" onclick="addProf('button4', 'sub5')" value="Add Prof">
                                </td>
                                <td><a href="alternate_edit_subject.jsp?scode=<%=status.equals("2") && !scode.equals("") ? scode : "BTC140"%>&sname=<%=status.equals("2") && !sname.equals("") ? sname : "Critical Thinking and Writing"%>&professor=<%=professor%>&status=2&create=false">Edit Subject</a></br><button type="button" onclick="deleteRow(1)">Delete</button></td>
                            </tr>
                            <%
                                if (created.equals("true")) {
                                    out.write("<tr>");
                                    out.write("<td>" + scode + "</td>");
                                    out.write("<td>" + sname + "</td>");
                                    out.write("<td>" + "<div id='sub3'></div>" + "<input type=\"button\" value=\"Add Section\" id=\"button3\" onclick=\"addSection('sub3', 'button3')\">");
                                    out.write("<td>" + "<a href=\"alternate_edit_subject.jsp?scode=" + scode + "&sname=" + sname + "&professor=" + professor + "&create=false&created=true" + "\">Edit Subject</a></br><button type=\"button\" onclick=\"deleteRow(1)\">Delete</button></td>");
                                    out.write("</tr>");
                                }
                            %>
                        </table>
                        <a href="alternate_edit_subject.jsp?create=true&professor=<%=professor%>"><button type="button" >Add Subject</button></a></br></br>
                        Upload subject list <input type="file" id="input">
                    </div>
                </div>
                <div class="col2">
                    <a href="calendar.jsp"><strong>Back to Calendar</strong></a>
                </div>
            </div>
        </div>
        <div id="footer">
            This is the footer
        </div>
    </body>
</html>