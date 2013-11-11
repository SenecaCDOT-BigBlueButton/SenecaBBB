<%@page import="db.DBConnection"%>
<%@page import="sql.*"%>
<%@page import="test.*"%>
<%@page import="java.util.*"%>
<%@page import="helper.MyBoolean"%>
<%@page import="helper.Settings"%>
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<!doctype html>
<html lang="en">
<head>
<meta charset="UTF-8">
<head>
    <title>Seneca | System Settings</title>
    <link rel="icon" href="http://www.cssreset.com/favicon.png">
    <link rel="stylesheet" type="text/css" media="all" href="css/fonts.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/style.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.core.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.theme.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.datepicker.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.selectmenu.css">
    <link rel='stylesheet' type="text/css" href='fullcalendar-1.6.3/fullcalendar/fullcalendar.css'>
    <script type="text/javascript" src="http://code.jquery.com/jquery-1.9.1.js"></script>
    <script type="text/javascript" src='fullcalendar-1.6.3/fullcalendar/fullcalendar.js'></script>
    <script type="text/javascript" src="js/modernizr.custom.79639.js"></script>
    <script type="text/javascript" src="js/ui/jquery.ui.core.js"></script>
    <script type="text/javascript" src="js/ui/jquery.ui.widget.js"></script>
    <script type="text/javascript" src="js/ui/jquery.ui.position.js"></script>
    <script type="text/javascript" src="js/ui/jquery.ui.selectmenu.js"></script>
    <script type="text/javascript" src="js/ui/jquery.ui.stepper.js"></script>
    <script type="text/javascript" src="js/ui/jquery.ui.dataTable.js"></script>
    <script type="text/javascript" src="js/componentController.js"></script>
    <script type="text/javascript">
        //Table
        $(screen).ready(function() {
            /* Admin Key Name List */
            $('#bbb_adminTable').dataTable({"sPaginationType": "full_numbers"});
            $('#bbb_adminTable').dataTable({"aoColumnDefs": [{ "bSortable": false, "aTargets":[5]}], "bRetrieve": true, "bDestroy": true});
            $.fn.dataTableExt.sErrMode = 'throw';
            $('.dataTables_filter input').attr("placeholder", "Filter entries");
            
        });
        /* SELECT BOX */
        $(function(){
            $('select').selectmenu();
        });
    </script>
    <%
    //Start page validation
    String userId = usersession.getUserId();
    if (userId.equals("")) {
        response.sendRedirect("index.jsp?error=Please log in");
        return;
    }
    if (!usersession.isSuper()) {
        response.sendRedirect("calendar.jsp");
        return;
    }
    if (dbaccess.getFlagStatus() == false) {
        response.sendRedirect("index.jsp?error=Database connection error");
        return;
    } //End page validation


    String message = request.getParameter("message");
    if (message == null || message == "null") {
        message="";
    }
    
    User user = new User(dbaccess);
    Admin admin = new Admin(dbaccess);
    ArrayList<ArrayList<String>> timeout = new ArrayList<ArrayList<String>>();
    ArrayList<ArrayList<String>> systemInfo = new ArrayList<ArrayList<String>>();
    ArrayList<ArrayList<String>> predefinedRole = new ArrayList<ArrayList<String>>();
    MyBoolean prof = new MyBoolean();
    HashMap<String, Integer> userSettings = new HashMap<String, Integer>();
    HashMap<String, Integer> prRoleSettings = new HashMap<String, Integer>();
    HashMap<String, Integer> roleMask = new HashMap<String, Integer>();
    userSettings = usersession.getUserSettingsMask();
    roleMask = usersession.getRoleMask();
    int nickName = roleMask.get("nickname");

    admin.getPreDefinedRole(predefinedRole);
    admin.getSystemInfo(systemInfo);
    int guestAccount = 0;
    int recordableMeeting = 0;
        
    %>
</head>
<body>
<div id="page">
    <jsp:include page="header.jsp"/>
    <jsp:include page="menu.jsp"/>
    <section>
        <header> 
            <!-- BREADCRUMB -->
            <p><a href="calendar.jsp" tabindex="13">home</a> >> <a href="system_settings.jsp" tabindex="14">system settings</a></p>
            <!-- PAGE NAME -->
            <h1>System Settings</h1>
            <!-- WARNING MESSAGES -->
            <div class="warningMessage"><%=message %></div>
        </header>
        <form method="get" action="persist_predefinedrole_setting.jsp" name="predefinedRoleForm" id="predefinedRoleForm">
            <article>
                <header>
                    <h2>Predefined Role Setting</h2>
                    <img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content"/>
                </header>
                <div class="content">                
                    <div class="tableComponent" >
                      <table id="predefinedRoleList" border="0" cellpadding="0" cellspacing="0">
                        <thead>
                          <tr>
                            <th width="200" class="firstColumn" tabindex="16" title="Username">Role name<span></span></th>                          
                            <th  title="Name">guest account creation<span></span></th>
                            <th  title="Name">recordable meeting<span></span></th>                          
                          </tr>
                        </thead>
                        <tbody>
                        <%for(int i=0;i<predefinedRole.size();i++) {
                           prRoleSettings.clear();
                           user.getPredefinedUserRoleSetting(prRoleSettings,predefinedRole.get(i).get(0));
                           recordableMeeting= prRoleSettings.get(Settings.ur_rolemask[0]);
                           guestAccount= prRoleSettings.get(Settings.ur_rolemask[1]);
                        %>
                          <tr>
                            <td><input style="border:none" readonly type="text" name="<%= predefinedRole.get(i).get(0) %>" value="<%= predefinedRole.get(i).get(0) %>"></td>                           
                            <td><input type="checkbox"  <% if(guestAccount==1) out.print("checked=checked"); else out.print(""); %>>
                                <input type="text"  hidden=hidden name="<%= "guestAccountCreate".concat("-").concat(predefinedRole.get(i).get(0)) %>" <% if(guestAccount==1) out.print("value = 1"); else out.print("value=0"); %>></td>
                            <td><input type="checkbox"  <% if (recordableMeeting==1) out.print("value = 1 checked=checked"); else out.print("value=0"); %> >
                                <input type="text"  hidden=hidden name="<%= "recordableMeeting".concat("-").concat(predefinedRole.get(i).get(0)) %>" <% if(recordableMeeting==1) out.print("value = 1"); else out.print("value=0"); %>></td>
                           
                          </tr><% } %>
                        </tbody>
                      </table>
                    </div>
                   <div class="buttons">
                       <button type="submit" name="saveSetting" id="saveSetting" class="button"  title="Click here to save">Save</button>                         
                   </div>
                </div>
            </article>
        </form>
        <form name="bbbadminSettingForm" id="bbbadminSettingForm">
             <article>
                <header>
                    <h2>BBB Admin Settings</h2>
                    <img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content"/>
                </header>
                <div class="content">
                     <fieldset>
                        <div class="tableComponent">
                          <table id="bbb_adminTable" border="0" cellpadding="0" cellspacing="0">
                            <thead>
                              <tr>
                                <th width="100" class="firstColumn" tabindex="16" title="keyName">key name<span></span></th>
                                <th  title="keytitle">key title<span></span></th>
                                <th  width="100" title="value">key value<span></span></th> 
                                <th  width="50" title="edit">edit<span></span></th>                               
                              </tr>
                            </thead>
                            <tbody>
                              <%for(int j=0;j<systemInfo.size();j++) {%>
                              <tr>
                                <td><%= systemInfo.get(j).get(0) %></td>
                                <td><%= systemInfo.get(j).get(1)%></td>
                                <td><input type="text" name="key_value"  style="border:none" value="<%= systemInfo.get(j).get(2)%>" <% if(systemInfo.get(j).get(0).indexOf("next")>=0 || systemInfo.get(j).get(0).indexOf("default")>=0) out.print("readonly=readonly"); %>></td>
                                <td class="icons" align="center" >
                                    <a <% if(systemInfo.get(j).get(0).indexOf("next")>=0 || systemInfo.get(j).get(0).indexOf("default")>=0) out.print("style='display:none'"); %> href="edit_bbb_admin.jsp?key_name=<%= systemInfo.get(j).get(0) %>&key_title=<%= systemInfo.get(j).get(1) %>&key_value=<%= systemInfo.get(j).get(2) %>" class="modify"><img src="images/iconPlaceholder.svg" width="17" height="17" title="modify bbb_admin" alt="Edit"/></a>
                                </td>
                              </tr><% } %>
                            </tbody>
                          </table>
                        </div>
                    </fieldset>
                </div>          
            </article> 
        </form>
    </section>
    <script>
        $(document).ready(function(){
        	$( "form :checkbox" ).click(function(e){
        		target = e.target;
        		console.log(target);
        		if($(target).siblings().attr('value')==1){
        			$(target).siblings().attr('value',0);
        		}else
        			$(target).siblings().attr('value',1);
        	});
        	$("a").click(function(e){
        		target = e.target;
        		value = $(target).text();
        		$(target).attr('value',value);
        		console.log(value);
        	});
        	$("tr td:first-child").addClass("row");
        	$("#predefinedRoleList thead tr th").click(function(e){
        		var target = e.target;
        		$(target).css({"background-color":"#454545","color":"#FFFFFF"}).siblings().css({"background-color":"#E0E0E0","color":"#454545"});
        		
        	});
        });
    </script>
    <jsp:include page="footer.jsp"/>
</div>
</body>
</html>