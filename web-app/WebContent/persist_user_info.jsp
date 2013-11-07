<%@page import="db.DBConnection"%>
<%@page import="hash.PasswordHash"%>
<%@page import="sql.User"%>
<%@page import="java.util.*"%>
<%@page import="helper.MyBoolean"%>
<%@page import= "sql.User" %>
<%@page import= "helper.Settings" %>
<jsp:useBean id="ldap" class="ldap.LDAPAuthenticate" scope="session" />
<jsp:useBean id="hash" class="hash.PasswordHash" scope="session" />
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<%@ page language="java" import="java.sql.*" errorPage=""%>
<%
    Boolean IsBanned = false;
    Boolean IsActive = false;
    Boolean IsSuperAdmin = false;
    if(request.getParameter("bbbUserIsBanned").charAt(0)=='1'){
        IsBanned = true;        
    }
    if(request.getParameter("bbbUserIsActive").charAt(0)=='1'){
        IsActive = true;       
    }   
    request.getParameter("removeUser");
    request.getParameter("updateUser");
    HashMap<String, Integer> map = new HashMap<String, Integer>();
    User user = new User(dbaccess);
    String currentUserId = usersession.getUserId();
    ArrayList<ArrayList<String>> result = new ArrayList<ArrayList<String>> ();
    user.getIsSuperAdmin(result, currentUserId);
    System.out.println(currentUserId);
    System.out.println(result.get(0).get(0));
    if (result.get(0).get(0).charAt(0)=='1'){
    	IsSuperAdmin = true;
    }
    System.out.println(IsSuperAdmin);
    String option="";
    if(request.getParameter("updateUser")!=null){
    	option = request.getParameter("updateUser");
    }
    if(request.getParameter("removeUser")!=null){
        option = request.getParameter("removeUser");
    }
    if (IsSuperAdmin){   
    	if( option.compareTo("update") == 0) {
		    user.setName(request.getParameter("bbbUserId"), request.getParameter("bbbUserName"));
		    user.setLastName(request.getParameter("bbbUserId"), request.getParameter("bbbUserLastName"));
		    user.setNickName(request.getParameter("bbbUserId"), request.getParameter("bbbUserNick"));
		    user.setEmail(request.getParameter("bbbUserId"), request.getParameter("bbbUserEmail"));
		    user.setActive(request.getParameter("bbbUserId"), IsActive);
		    user.setBannedFromSystem(request.getParameter("bbbUserId"), IsBanned);		    
		    System.out.println("Updated Successfully!!");
       }
       if (option.compareTo("Ban")==0){
    	user.setBannedFromSystem(request.getParameter("bbbUserId"),true);   	
    	System.out.println("Deleted Successfully!!");
       }
    }
    else{   	
    	System.out.println("No authentication to edit or delete user information!!!");
    	
    }
    if( option.compareTo("update") == 0)
        response.sendRedirect("manage_users.jsp?message=Updated Successfully!!!");
    else if( option.compareTo("Ban") == 0)
    	response.sendRedirect("manage_users.jsp?message=Ban User from System Successfully!!!");
    else
    	response.sendRedirect("manage_users.jsp?message=No authentication to edit or delete user information!!!");
%>