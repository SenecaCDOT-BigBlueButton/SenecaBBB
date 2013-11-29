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
        response.sendRedirect("index.jsp?message=Please log in");
        return;
    }
    if (!(usersession.isDepartmentAdmin() || usersession.isSuper())) {
        response.sendRedirect("calendar.jsp?message=You don't have permission to access that page!");
        return;
    }
    if (dbaccess.getFlagStatus() == false) {
        response.sendRedirect("index.jsp?message=Database connection error");
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
    
    String c_id = request.getParameter("CourseCode").trim();
    String c_name = request.getParameter("CourseName").trim();
    String del = request.getParameter("deleteCourse");
    ArrayList<ArrayList<String>> courseList = new ArrayList<ArrayList<String>>();
    ArrayList<ArrayList<String>> courseInSection = new ArrayList<ArrayList<String>>();
    Section section = new Section(dbaccess);
    section.setCourseName(c_id,c_name);
    section.getCourse(courseList,c_id);
    section.getSectionInfoByCourse(courseInSection, c_id);
    if(del == null ){
	    if(courseList.size()==0){
	        section.createCourse(c_id, c_name);      
	        response.sendRedirect("manage_course.jsp?successMessage=Subject created");
	        return;
	    }else{
	    	section.setCourseName(c_id,c_name);
	    	response.sendRedirect("manage_course.jsp?successMessage=Subject Modified");
	    	return;
	    }   
    }else{
    	if(courseInSection.size()>0){
    		response.sendRedirect("manage_course.jsp?message=Subject In Use, Could not be deleted");
    		return;
    	}else{
    		section.removeCourse(c_id);
    		response.sendRedirect("manage_course.jsp?successMessage=Subject deleted Successfully");
    	}
    }
%>
