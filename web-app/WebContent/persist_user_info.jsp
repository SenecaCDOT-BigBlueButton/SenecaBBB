<%@page import="db.DBConnection"%>
<%@page import="hash.PasswordHash"%>
<%@page import="sql.User"%>
<%@page import="java.util.*"%>
<%@page import="helper.*"%>
<%@page import= "sql.User" %>
<%@page import= "helper.Settings" %>
<jsp:useBean id="ldap" class="ldap.LDAPAuthenticate" scope="session" />
<jsp:useBean id="hash" class="hash.PasswordHash" scope="session" />
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<%@ page language="java" import="java.sql.*" errorPage=""%>
<%
	//Start page validation
	String userId = usersession.getUserId();
    GetExceptionLog elog = new GetExceptionLog();
    String message="";
	if (userId.equals("")) {
		elog.writeLog("[persist_user_info:] " + "unauthenticated user tried to access this page /n");
	    response.sendRedirect("index.jsp?message=Please log in");
	    return;
	}
	if (!usersession.isSuper()) {
		elog.writeLog("[persist_user_info:] " + " username: "+ userId + " tried to access this page, permission denied" +" /n");	       
	    response.sendRedirect("calendar.jsp?message=You don't have permission to access that page!");
	    return;
	}
	if (dbaccess.getFlagStatus() == false) {
		elog.writeLog("[persist_user_info:] " + "database connection error /n");
	    response.sendRedirect("index.jsp?message=Database connection error");
	    return;
	} //End page validation

    Boolean IsBanned = false;
    Boolean IsActive = false;
    Boolean IsSuper = false;
    String bbbUserNickname = request.getParameter("bbbUserNickname");
    String bbbUserName = request.getParameter("bbbUserName");
    String bbbUserLastName = request.getParameter("bbbUserLastName");
    String bbbUserEmail = request.getParameter("bbbUserEmail");
    int userRole = Integer.parseInt(request.getParameter("bbbUserList").substring(0 , 1));
    if(request.getParameter("bbbUserIsBanned") !=null && request.getParameter("bbbUserIsBanned").equals("on")){
        IsBanned = true;        
    }  
    if(request.getParameter("bbbUserIsSuper")!=null && request.getParameter("bbbUserIsSuper").equals("on")){
    	IsSuper = true;
    }
    if(request.getParameter("bbbUserIsActive")!=null && request.getParameter("bbbUserIsActive").equals("on")){
    	IsActive = true;
    }
    String bu_id = request.getParameter("bbbUserId");
    boolean searchSucess = false;
    MyBoolean myBoolean = new MyBoolean();
    User user = new User(dbaccess);
    if (bu_id!=null) {
        bu_id = Validation.prepare(bu_id);
        if (!(Validation.checkBuId(bu_id))) {
            message = Validation.getErrMsg();
            elog.writeLog("[persist_user_info:] " + message +" /n");
            response.sendRedirect("calendar.jsp?message=" + message);
            return; 
        } 
        else {
            if (!user.isUser(myBoolean, bu_id)) {
                message = user.getErrMsg("AS04");
                elog.writeLog("[persist_user_info:] " + message +" /n");
                response.sendRedirect("calendar.jsp?message=" + message);
                return;   
            }
            // User already in Database
            if (myBoolean.get_value()) {   
                searchSucess = true;
            } 
            else {
                message = "Invalid User Id";
                response.sendRedirect("calendar.jsp?message=" + message);
                return;
            }
        }
    }
    // End User Validatation
    HashMap<String, Integer> map = new HashMap<String, Integer>();
    ArrayList<ArrayList<String>> result = new ArrayList<ArrayList<String>>();

    Boolean mybool = false;
    if(searchSucess){
	    mybool=user.setActive(bu_id, IsActive);
	    user.setUserRole(bu_id, userRole);
	    if(mybool){
	        mybool=user.setBannedFromSystem(bu_id, IsBanned);   
	    }
	    if(mybool){
	        mybool=user.setSuperAdmin(bu_id, IsSuper);   
	    }
	    if(mybool && bbbUserNickname!=null){
	        mybool = user.setNickName(bu_id, bbbUserNickname);
	    }
	    if(mybool && bbbUserName!=null){
		    mybool = user.setName(bu_id, bbbUserName);
	    }
		if(mybool && bbbUserLastName!=null){
			mybool=user.setLastName(bu_id, bbbUserLastName);
		}
		if(mybool && bbbUserEmail!=null){
		    mybool=user.setEmail(bu_id, bbbUserEmail);
		}
		if(mybool){
		     response.sendRedirect("manage_users.jsp?successMessage=Updated User "+ bu_id + " Successfully!!!");
		     return;
		}else{
			 response.sendRedirect("manage_users.jsp?message=Fail to Update User "+ bu_id + " !!!");
			 return;	
		}
	}
    else{
		response.sendRedirect("manage_users.jsp?message=Invalid user information!");
	}
   			

%>