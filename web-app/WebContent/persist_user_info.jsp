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
    String message="";
	if (userId.equals("")) {
	    response.sendRedirect("index.jsp?error=Please log in");
	    return;
	}
	if (!usersession.isSuper()) {
	    response.sendRedirect("calendar.jsp?message=You don't have permission to access that page!");
	    return;
	}
	if (dbaccess.getFlagStatus() == false) {
	    response.sendRedirect("index.jsp?error=Database connection error");
	    return;
	} //End page validation

    Boolean IsBanned = false;
    Boolean IsActive = false;
    Boolean IsLdap = false;
    Boolean IsSuper = false;
    if(request.getParameter("bbbUserIsBanned") !=null && request.getParameter("bbbUserIsBanned").equals("1")){
        IsBanned = true;        
    }  
    if(request.getParameter("bbbUserIsLdap")!=null && request.getParameter("bbbUserIsLdap").equals("1")){
    	IsLdap = true;
    }
    if(request.getParameter("bbbUserIsSuper")!=null && request.getParameter("bbbUserIsSuper").equals("1")){
    	IsSuper = true;
    }
    if(request.getParameter("bbbUserIsActive")!=null && request.getParameter("bbbUserIsActive").equals("1")){
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
            response.sendRedirect("calendar.jsp?message=" + message);
            return; 
        } 
        else {
            if (!user.isUser(myBoolean, bu_id)) {
                message = user.getErrMsg("AS04");
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
    if(searchSucess && !IsLdap){
	    mybool=user.setActive(bu_id, IsActive);
	    if(mybool){
	        mybool=user.setBannedFromSystem(bu_id, IsBanned);   
	    }
	    if(mybool){
	        mybool=user.setSuperAdmin(bu_id, IsSuper);   
	    }
	    if(mybool){
		    mybool = user.setName(bu_id, request.getParameter("bbbUserName"));
	    }
		if(mybool){
			mybool=user.setLastName(bu_id, request.getParameter("bbbUserLastName"));
		}
		if(mybool){
		    mybool=user.setEmail(bu_id, request.getParameter("bbbUserEmail"));
		}
		if(mybool){
		     response.sendRedirect("manage_users.jsp?message=Updated A Non_Ldap_User Successfully!!!");
		     return;
		}else{
			 response.sendRedirect("manage_users.jsp?message=Fail to Updated A Non_Ldap_User !!!");
			 return;	
		}
	}else if(searchSucess && IsLdap){
	    mybool=user.setActive(bu_id, IsActive);
        if(mybool){
            mybool=user.setBannedFromSystem(bu_id, IsBanned);   
        }
        if(mybool){
            mybool=user.setSuperAdmin(bu_id, IsSuper);   
        }
        if(mybool){
            response.sendRedirect("manage_users.jsp?message=Updated A Ldap_User Successfully!!!");
            return;
       }else{
            response.sendRedirect("manage_users.jsp?message=Fail to Updated A Ldap_User !!!");
            return;    
       }
	}
    else{
		response.sendRedirect("manage_users.jsp?message=Invalid user information!");
		return;
	}
   			

%>