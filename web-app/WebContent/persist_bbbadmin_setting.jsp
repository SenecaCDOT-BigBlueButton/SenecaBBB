<%@page import="db.DBConnection"%>
<%@page import="sql.*"%>
<%@page import="java.util.*"%>
<%@page import="helper.MyBoolean"%>
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />

<% 
    //Start page validation
    String userId = usersession.getUserId();
    if (userId.equals("")) {
        response.sendRedirect("index.jsp?error=Please log in");
        return;
    }
    if (!(usersession.isSuper())) {
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
    int nickName = roleMask.get("nickname");
  
    String key_name = request.getParameter("key_name");
    String key_value = request.getParameter("key_value");
    String key_title = request.getParameter("key_title");
    if(key_value==null){
    	key_value = request.getParameter("number_value");
    }

    Admin admin = new Admin(dbaccess);
    //TODO: If you want to modify default meeting,user,and class setting, create your method in Admin.java 
/*
    if(key_name.equals("default_meeting")){
        admin.setDefaultMeeting(key_value);
        response.sendRedirect("system_settings.jsp?message=System Default Meeting Setting Saved Successfully!");
    }
    if(key_name.equals("default_user")){
          admin.setDefaultUser(key_value);
          response.sendRedirect("system_settings.jsp?message=System Default User Setting Saved Successfully!");
      }
    if(key_name.equals("default_class")){
          admin.setDefaultClass(key_value);
          response.sendRedirect("system_settings.jsp?message=System Default Class Setting Saved Successfully!");
      }
*/
    if(key_name.equals("timeout")){
        admin.setTimeout(key_value);
        response.sendRedirect("system_settings.jsp?message=System Timeout Setting Saved Successfully!");
    }
    
    if(key_name.equals("welcome_msg")){
        admin.setWelcomeMsg(key_value);
        response.sendRedirect("system_settings.jsp?message=System Welcome message Setting Saved Successfully!");
    }
    
    if(key_name.equals("recording_msg")){
        admin.setRecordingMsg(key_value);
        response.sendRedirect("system_settings.jsp?message=System Recording Message Setting Saved Successfully!");
    }

%>


