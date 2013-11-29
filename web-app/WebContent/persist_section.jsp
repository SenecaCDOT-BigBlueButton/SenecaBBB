<%@page import="db.DBConnection"%>
<%@page import="sql.User"%>
<%@page import="sql.Section"%>
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
    
    ArrayList<ArrayList<String>> professorInSection = new ArrayList<ArrayList<String>>();
    ArrayList<ArrayList<String>> studentInSection = new ArrayList<ArrayList<String>>();
    ArrayList<ArrayList<String>> scheduleforSection = new ArrayList<ArrayList<String>>();
    ArrayList<ArrayList<String>> sectionInUse = new ArrayList<ArrayList<String>>();
    ArrayList<ArrayList<String>> sectionInSchedule = new ArrayList<ArrayList<String>>();
    String c_id = request.getParameter("courseCode");
    String sc_id = request.getParameter("courseSection");
    String sc_semesterid =request.getParameter("semesterID");
    String d_code = request.getParameter("deptCode");
    String toDel = request.getParameter("toDel");
    Section section = new Section(dbaccess);
    section.getSectionInfo(sectionInUse, c_id, sc_id, sc_semesterid);
    section.getStudent(studentInSection, c_id, sc_id, sc_semesterid);
    section.getProfessor(professorInSection, c_id, sc_id, sc_semesterid);
    section.getLectureSchedule(sectionInSchedule, c_id, sc_id, sc_semesterid);
    if(toDel==null){
    	if(sectionInUse.size()>0){
    		response.sendRedirect("subjects.jsp?message= duplicated section, please create a new one");
    		return;
    	}else{
		    section.createSection(c_id, sc_id, sc_semesterid, d_code);
		    response.sendRedirect("subjects.jsp?successMessage=section created");
		    return;
	    }
    }else{
    	if(studentInSection.size()>0 || professorInSection.size()>0 || sectionInSchedule.size()>0){
    		response.sendRedirect("subjects.jsp?message= section in use,could not be removed");
    		return;
    	}else{
	        section.removeSection(c_id, sc_id, sc_semesterid);
	        response.sendRedirect("subjects.jsp?successMessage=section removed successfully");    	
        }
    }
            
%>
