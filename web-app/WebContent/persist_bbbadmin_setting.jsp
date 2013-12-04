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
    	elog.writeLog("[persist_bbbadmin_setting:] " + "unauthenticated user tried to access this page /n");
        response.sendRedirect("index.jsp?message=Please log in");
        return;
    }
    if (!(usersession.isSuper())) {
        elog.writeLog("[persist_bbbadmin_setting:] " + " username: "+ userId + " tried to access this page, permission denied" +" /n");      
        response.sendRedirect("calendar.jsp?message=You don't have permission to access that page!");
        return;
    }
    if (dbaccess.getFlagStatus() == false) {
        elog.writeLog("[persist_bbbadmin_setting:] " + "database connection error /n");
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
  
    String key_name = request.getParameter("key_name");
    String key_value = request.getParameter("key_value");
    String key_title = request.getParameter("key_title");
    if(key_value==null){
    	key_value = request.getParameter("number_value");
    }

    Admin admin = new Admin(dbaccess);
    //TODO: If you want to modify default meeting,user,and class setting, create your method in Admin.java 
    try{
	    if(key_name.equals("timeout")){
	        admin.setTimeout(key_value);
	        response.sendRedirect("system_settings.jsp?successMessage=System Timeout Setting Saved Successfully!");
	        return;
	    }
	    
	    if(key_name.equals("welcome_msg")){
	        admin.setWelcomeMsg(key_value);
	        response.sendRedirect("system_settings.jsp?successMessage=System Welcome message Setting Saved Successfully!");
	        return;
	    }
	    
	    if(key_name.equals("recording_msg")){
	        admin.setRecordingMsg(key_value);
	        response.sendRedirect("system_settings.jsp?successMessage=System Recording Message Setting Saved Successfully!");	       
	    }
    }catch(Exception e){
        elog.writeLog("[persist_bbbadmin_setting:] " + e.getMessage()+ " /n" + e.getStackTrace()+"/n");       
    }

%>


