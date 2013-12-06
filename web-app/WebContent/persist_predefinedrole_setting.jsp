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
    ArrayList<ArrayList<String>> allUserRole = new ArrayList<ArrayList<String>>();
    ArrayList<ArrayList<String>> predefinedRoleResult = new ArrayList<ArrayList<String>>();
    HashMap<String, Integer> roleMask = new HashMap<String, Integer>();
    HashMap<String, Integer> studentPrdefinedroleMask = new HashMap<String, Integer>();
    HashMap<String, Integer> guestPrdefinedroleMask = new HashMap<String, Integer>();
    Admin admin = new Admin(dbaccess);
    admin.getAllUserRoleInfo(allUserRole);
    System.out.println(allUserRole.size());
    try{
	    for(int i=1;i<=allUserRole.size();i++){
	    	roleMask.clear();
	    	roleMask.put("guestAccountCreation",request.getParameter("guestAccountCreate-".concat(String.valueOf(i)))==null? 0:1);
	        roleMask.put("recordableMeetings",request.getParameter("recordMeeting-".concat(String.valueOf(i)))==null? 0:1); 
	        if(!user.setUserRoleSetting(roleMask, i)){
	            response.sendRedirect("system_settings.jsp?message=User Role Setting Error!");
	            return;
	        }
	    }
    }catch(Exception e){
    	elog.writeLog("[persist_predefinedrole_setting:] " + e.getMessage() +" /n" + e.getStackTrace()); 
    	response.sendRedirect("system_settings.jsp?message=User Role Setting Error!");
    	return;
    }
    response.sendRedirect("system_settings.jsp?successMessage=User Role Setting Updated!");

%>


