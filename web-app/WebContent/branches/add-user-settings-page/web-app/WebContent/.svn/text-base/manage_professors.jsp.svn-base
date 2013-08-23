<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <link rel='stylesheet' type='text/css' href='css/calendar_layout.css' />
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script>
            function search()
            {
                var term = document.getElementById("search").value;
                var drop = document.getElementById("list");
                var div = document.getElementById("searchResults");
                div.innerHTML = "";
                var counter = 0;
                var firstTime = 0;
                for (var x = 1; x < drop.length; x++) {
                    var str = drop.options[x].value;
                    if (str.search(term) !== -1) {
                        firstTime = 1;
                        counter++;
                        div.innerHTML += drop.options[x].value + "<a style=\"margin-left: 40px;\" href=\"manage_subjects.jsp?professor=" + str + "\">Manage</a>" + "<br/>";
                    }
                }
                if (counter == 0 && firstTime == 0)
                    div.innerHTML = "\"" + term + "\"" + " did not return any results";
            }
            function go()
            {
                var drop = document.getElementById("list");
                var str = drop.options[drop.selectedIndex].value;
                window.location.replace("manage_subjects.jsp?professor=" + str);
            }
        </script>
        <title>Manage Professors</title>
    </head>
    <body>
        <div id="header">
            <h1>Manage Professors</h1>
        </div>
        <div class="colmask leftmenu">
            <div class="colleft">
                <div class="col1">
                    <div id="content">
                        Search for professor <input type="search" name="search" id="search"/><input type="button" name="doSearch" onclick="search()" value="Search"/><br/><br/>
                        <div id="searchResults"></div>
                        <h4>or</h4><br>Choose one
                        <select id="list">
                            <option>Select a Professor...</option>
                            <option value="Fardad Soleimanloo">Fardad Soleimanloo</option>
                            <option value="Peter McIntyre">Peter McIntyre</option>
                            <option value="Peter Liu">Peter Liu</option>
                            <option value="Bill Letterio">Bill Letterio</option>
                        </select>
                        <input type="button" value="Go" onclick='go()'/>
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
