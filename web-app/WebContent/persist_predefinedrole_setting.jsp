<%@page import="db.DBConnection"%>
<%@page import="sql.*"%>
<%@page import="java.util.*"%>
<%@page import="helper.*"%>
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />

<% 
    //Start page validation
    String userId = usersession.getUserId();
    GetExceptionLog elog = new GetExceptionLog();
    if (userId.equals("")) {
    	elog.writeLog("[persist_predefinedrole_setting:] " + "unauthenticated user tried to access this page /n");
        response.sendRedirect("index.jsp?message=Please log in");
        return;
    }
    if (!(usersession.isSuper())) {
    	elog.writeLog("[persist_predefinedrole_setting:] " + " username: "+ userId + " tried to access this page, permission denied" +" /n");          
        response.sendRedirect("calendar.jsp?message=You don't have permission to access that page!");
        return;
    }
    if (dbaccess.getFlagStatus() == false) {
    	elog.writeLog("[persist_predefinedrole_setting:] " + "database connection error /n");    	     
        response.sendRedirect("index.jsp?message=Database connection error");
        return;
    } //End page validation
    
    String message = request.getParameter("message");
    if (message == null || message == "null") {
        message="";
    }
    
    User user = new User(dbaccess);
    MyBoolean prof = new MyBoolean();
    ArrayList<ArrayList<String>> predefinedRoleResult = new ArrayList<ArrayList<String>>();
    HashMap<String, Integer> userSettings = new HashMap<String, Integer>();
    HashMap<String, Integer> meetingSettings = new HashMap<String, Integer>();
    HashMap<String, Integer> roleMask = new HashMap<String, Integer>();
    HashMap<String, Integer> employeePrdefinedroleMask = new HashMap<String, Integer>();
    HashMap<String, Integer> studentPrdefinedroleMask = new HashMap<String, Integer>();
    HashMap<String, Integer> guestPrdefinedroleMask = new HashMap<String, Integer>();
    userSettings = usersession.getUserSettingsMask();
    meetingSettings = usersession.getUserMeetingSettingsMask();
    roleMask = usersession.getRoleMask();
    
    Admin admin = new Admin(dbaccess);
    admin.getPreDefinedRole(predefinedRoleResult);
    
    employeePrdefinedroleMask.clear();
    employeePrdefinedroleMask.put("recordableMeetings",Integer.parseInt(request.getParameter("recordableMeeting-employee")));
    employeePrdefinedroleMask.put("guestAccountCreation",Integer.parseInt(request.getParameter("guestAccountCreate-employee")));   
	if(!admin.setPredefinedDefaultMask(employeePrdefinedroleMask,"employee")){
	    elog.writeLog("[persist_predefinedrole_setting:] " + "setting employee default mask fail /n");	      
	    response.sendRedirect("system_settings.jsp?message=Database error!");
	    return;
	}
    
    studentPrdefinedroleMask.clear();
    studentPrdefinedroleMask.put("recordableMeetings",Integer.parseInt(request.getParameter("recordableMeeting-student")));
    studentPrdefinedroleMask.put("guestAccountCreation",Integer.parseInt(request.getParameter("guestAccountCreate-student")));
    if(!admin.setPredefinedDefaultMask(studentPrdefinedroleMask,"student")){
    	elog.writeLog("[persist_predefinedrole_setting:] " + "setting student default mask fail /n"); 
        response.sendRedirect("system_settings.jsp?message=Database error!");
        return;
    }
    
    guestPrdefinedroleMask.clear();
    guestPrdefinedroleMask.put("recordableMeetings",Integer.parseInt(request.getParameter("recordableMeeting-guest")));
    guestPrdefinedroleMask.put("guestAccountCreation",Integer.parseInt(request.getParameter("guestAccountCreate-guest")));
    if(!admin.setPredefinedDefaultMask(guestPrdefinedroleMask,"guest")){
    	elog.writeLog("[persist_predefinedrole_setting:] " + "setting guest default mask fail /n"); 
        response.sendRedirect("system_settings.jsp?message=Database error!");
        return;
    }
    
    response.sendRedirect("system_settings.jsp?successMessage=Predefined RoleMask Setting Saved Successfully!");

%>


