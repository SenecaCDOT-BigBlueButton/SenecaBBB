<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
        <script type='text/javascript'>
            var settingsArray = new Array();
            settingsArray[0]=0;
            settingsArray[1]=0;
            settingsArray[2]=0;
            function settings(dropdown){
                var el = document.getElementById('frame');
                var index = dropdown.selectedIndex;
                var selectedValue = dropdown.options[index].value;
                var p = document.getElementById("link");
                var check = document.getElementById("recorded");
                if (index !=0)
                    {
                        check.checked=settingsArray[index-1];
                        el.src = "manage_students.jsp?class=" + selectedValue;
                    }
                else
                    p.innerHTML ="";
            }
            function check(checkbox) {
                var drop = document.getElementById("drop");
                var index = drop.selectedIndex;
                if (checkbox.checked)
                    settingsArray[index-1]=1;
                else
                    settingsArray[index-1]=0;
            
            }
        </script>
        <title>Class Settings</title>
    </head>
    <body>
        <div id="header">
            <h1>Class Settings</h1>
            <p id="layoutdims">Filter by class
                <select name="classes" onchange="settings(this);" id="drop">
                    <option value="">Choose a class</option>
                    <option value="BTP100">BTP100</option>
                    <option value="BTP200">BTP200</option>
                    <option value="BTP300">BTP300</option>
                </select>
            </p>
        </div>
        <div class="colmask leftmenu">
            <div class="colleft">
                <div class="col1">
                    <div id="content">
                        <input type="checkbox" name="recorded" value="ON" id="recorded" onchange="check(this)"/>Allow recording <br><br>
                          <a id="link" href="classes.jsp"></a>
                          <iframe id="frame" src="" scrolling="auto" frameborder="0" align="center" height = "422px" width = "932px"></iframe>
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