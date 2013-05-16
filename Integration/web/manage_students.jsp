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
        <script>
            function deleteRow(num)
            {
                var r = confirm("Are you sure?");
                if (r)
                    document.getElementById("table").deleteRow(num);
            }
        </script>
        <link rel='stylesheet' type='text/css' href='css/calendar_layout.css' />
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <style type='text/css'>
            #content {
                margin: auto;
                float: left;
            }
        </style>
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
                        <h2>Class list</h2>
                        <table id="table" border="1">
                            <tr>
                                <td>First Name</td>
                                <td>Last Name</td>
                                <td>Email</td>
                                <td>Student ID</td>
                                <td>Modify</td>
                            </tr>
                            <tr>
                                <td>Robert</td>
                                <td>Stanica</td>
                                <td>robert.stanica@senecacollege.ca</td>
                                <td>05955732</td>
                                <td><a href="edit_student.jsp?fname=Robert&lname=Stanica&email=robert.stanica@senecacollege.ca&id=05955732&create=false">Edit</a></br><button type="button" onclick="deleteRow(1)">Delete</button></td>
                            </tr>
                            <tr>
                                <td>Chad</td>
                                <td>Pilkey</td>
                                <td>chad.pilkey@senecacollege.ca</td>
                                <td>15933738</td>
                                <td><a href="edit_student.jsp?fname=Chad&lname=Pilkey&email=chad.pilkey@senecacollege.ca&id=15933738&create=false">Edit</a></br><button type="button" onclick="deleteRow(1)">Delete</button></td>
                            </tr>
                        </table>
                        <a href="edit_student.jsp?create=true"><button type="button" >Add Student</button></a></br></br>
                        Upload student list <input type="file" id="input">
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
