<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String prevPage = request.getParameter("prevPage");
    if (prevPage == null || prevPage == "null") {
        prevPage = "";
    }

    String date = request.getParameter("date");
    if (date == null || date == "null") {
        date = "";
    }
    String day = request.getParameter("day");
    if (day == null || day == "null") {
        day = "";
    }
    String name = request.getParameter("name");
    if (name == null || name == "null") {
        name = "";
    }
    prevPage += "?date=" + date + "&day=" + day + "&name=" + name;
%>
<!DOCTYPE html>
<html>
    <head>
        <link rel='stylesheet' type='text/css' href='css/calendar_layout.css' />
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script>
            var rC = 0;
            var cC = 0;
            function search()
            {
                document.getElementById("searchResults").style.visibility = "visible";
            }
            function addToList(name)
            {
                source = document.getElementById("list2");
                numberOfItems = source.options.length;
                insertPt = source.options.length;
                if (source.options[0].text === "") {
                    insertPt = 0;
                }
                for (var i = 0; i < numberOfItems; i++) {
                    for (var j = 0; j < source.options.length; j++) {
                        if (name === source.options[j].text) {
                            j = 99;
                        }
                    }
                    if (j < 99) {
                        source.options[insertPt] = new Option(name);
                        insertPt = source.options.length;
                    }
                }
            }
            function add2list(sourceID, targetID) {
                source = document.getElementById(sourceID);
                target = document.getElementById(targetID);
                numberOfItems = source.options.length;
                insertPt = target.options.length; //insert at end
                if (target.options[0].text === "") {
                    insertPt = 0;
                } //null option fix
                for (var i = 0; i < numberOfItems; i++) {
                    if (source.options[i].selected === true) {
                        msg = source.options[i].text;
                        for (var j = 0; j < target.options.length; j++) {
                            if (msg === target.options[j].text) {
                                j = 99;
                            }
                        }
                        if (j < 99) {
                            target.options[insertPt] = new Option(msg);
                            insertPt = target.options.length;
                        }
                    }
                }
            }
            function takefromlist(targetID) {
                target = document.getElementById(targetID);
                if (target.options.length < 0) {
                    return;
                }
                for (var i = (target.options.length - 1); i >= 0; i--) {
                    if (target.options[i].selected) {
                        target.options[i] = null;
                        if (target.options.length === 0) {
                            target.options[0] = new Option("");
                        }
                    }
                }
            }
            function save()
            {
                document.getElementById("saveText").style.visibility = "visible";
            }
        </script>
        <title>Manage Whitelist</title>
    </head>
    <body>
        <div id="header">
            <h1>Whitelist</h1>
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
                        Search for user: <input type="search" name="search"/><input type="button" name="doSearch" onclick="search()" value="Search"/><br><br>
                        <div style="visibility:hidden;" id="searchResults">
                            <table id="table" border="1">
                                <tr>
                                    <td>First Name</td>
                                    <td>Last Name</td>
                                    <td>Email</td>
                                    <td>Student ID</td>
                                    <td>Add To List</td>
                                </tr>
                                <tr>
                                    <td>Robert</td>
                                    <td>Stanica</td>
                                    <td>robert.stanica@senecacollege.ca</td>
                                    <td>05955732</td>
                                    <td><button type="button" name="" onclick="addToList('Robert Stanica')">Add</button></td>
                                </tr>
                                <tr>
                                    <td>Chad</td>
                                    <td>Pilkey</td>
                                    <td>chad.pilkey@senecacollege.ca</td>
                                    <td>15933738</td>
                                    <td><button type="button" onclick="addToList('Chad Pilkey')">Add</button></td>
                                </tr>
                            </table><br/><br/>
                        </div>
                        <table class="n">
                            <tbody>
                                <tr>
                                    <th>Student List</th>
                                    <td></td>
                                    <th>Whitelist members</th>
                                </tr>
                                <tr>
                                    <th class="n">
                                        <label for="list1">&nbsp;</label> 
                                        <select id="list1" size="6" style="width:190px" multiple="multiple" ondblclick="add2list('list1', 'list2');">
                                            <option>George Herman </option>
                                            <option>Steve Park</option>
                                            <option>Kanye East</option>
                                            <option>Tara Reynolds</option>
                                            <option>Amanda Goldman</option>
                                            <option>Abhishek Pateli</option>
                                        </select>
                                    </th>
                                    <th class="n" style="vertical-align:middle">
                                        <button onclick="add2list('list1', 'list2');">--&gt;</button><br />
                                        <button onclick="takefromlist('list2');">&lt;--</button>
                                    </th>
                                    <th class="n">
                                        <label for="list2">&nbsp;</label> 
                                        <select id="list2" size="6" style="width:190px" multiple="multiple" ondblclick="takefromlist('list2');">
                                            <option></option>
                                        </select>
                                    </th>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td></td>
                                    <td><input type="button" id="saveBtn" value="Save" onclick="save()"/><div id="saveText" style="visibility:hidden; color:green">Whitelist saved.</div></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="col2">
                    <a href="<%=prevPage%>"><strong>Back to Event Details</strong></a>
                </div>
            </div>
        </div>
        <div id="footer">
            This is the footer
        </div>
    </body>
</html>
