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
    if (!(usersession.isDepartmentAdmin() || usersession.isSuper())) {
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
    HashMap<String, Integer> userSettings = new HashMap<String, Integer>();
    HashMap<String, Integer> meetingSettings = new HashMap<String, Integer>();
    HashMap<String, Integer> roleMask = new HashMap<String, Integer>();
    userSettings = usersession.getUserSettingsMask();
    meetingSettings = usersession.getUserMeetingSettingsMask();
    roleMask = usersession.getRoleMask();
    int nickName = roleMask.get("nickname");
    
    String c_id = null;
    String sc_id = null;
    String bu_id = null;
    String sc_semesterid = null;
    String del =  request.getParameter("toDel");
    ArrayList<ArrayList<String>> result = new ArrayList<ArrayList<String>>();
    
    if(del == null){//get information from form to create professor
    	bu_id = request.getParameter("professorid").trim();
    	c_id = request.getParameter("sectionList").split(" ")[0];
    	sc_id = request.getParameter("sectionList").split(" ")[1];
    	sc_semesterid = request.getParameter("sectionList").split(" ")[2];
        user.getUserInfo(result,bu_id);
    }else{ // get information from manage_professor.jsp 
        c_id = request.getParameter("c_id");
        bu_id = request.getParameter("bu_id");
        sc_id = request.getParameter("sc_id");
        sc_semesterid = request.getParameter("sc_semesterid");        
    }

    Section section = new Section(dbaccess);
    if(del == null ){  
    	if(result.size()==0){// make sure the bu_id is registered in database
    		 response.sendRedirect("create_professor.jsp?message=Professor ID Not in Database"); 
    	}
    	else{
	        section.createProfessor(bu_id, c_id, sc_id,sc_semesterid);      
	        response.sendRedirect("manage_professor.jsp?message=Professor created");    
	    }    
    }else{
        section.removeProfessor(bu_id, c_id, sc_id,sc_semesterid);      
        response.sendRedirect("manage_professor.jsp?message=Professor Removed");  
    }
%>
