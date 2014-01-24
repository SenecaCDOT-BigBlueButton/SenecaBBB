<%@page import="db.DBConnection"%>
<%@page import="sql.*"%>
<%@page import="java.util.*"%>
<%@page import="helper.*"%>
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<jsp:useBean id="ldap" class="ldap.LDAPAuthenticate" scope="session" />
<%@ include file="search.jsp" %>
<%@ include file="send_Notification.jsp" %>
<% 
    //Start page validation
    String userId = usersession.getUserId();
    GetExceptionLog elog = new GetExceptionLog();
    if (userId.equals("")) {
    	session.setAttribute("redirecturl", request.getRequestURI()+(request.getQueryString()!=null?"?"+request.getQueryString():""));
        response.sendRedirect("index.jsp?message=Please log in");
        return;
    }
    if (!usersession.isSuper() && !usersession.isProfessor() ) {
        elog.writeLog("[persist_class_settings:] " + " username: "+ userId + " tried to access this page, permission denied" +" /n");        
        response.sendRedirect("calendar.jsp?message=You don't have permission to access this page");
        return;
    }
    if (dbaccess.getFlagStatus() == false) {
    	elog.writeLog("[persist_class_settings:] " + "database connection error /n");
        response.sendRedirect("index.jsp?message=Database connection error");
        return;
    } //End page validation
    
    String message = request.getParameter("message");
    String successMessage;
    String selectedclass = request.getParameter("classSectionInfo");
    String bu_id = request.getParameter("searchBox");
    if (message == null || message == "null") {
        message="";
    }
    Section section = new Section(dbaccess);
    User user = new User(dbaccess);
    Lecture lecture = new Lecture(dbaccess);
    MyBoolean myBool = new MyBoolean();  
    
    // Start User Search
    int i = 0;
    boolean searchSucess = false;
    if (bu_id!=null) {
        bu_id = Validation.prepare(bu_id);
        if (!(Validation.checkBuId(bu_id))) {
            message = Validation.getErrMsg();
        } else {
            if (!user.isLectureStudent(myBool, selectedclass.split("-")[0], selectedclass.split("-")[1],selectedclass.split("-")[2],bu_id)) {
                message = user.getErrMsg("AS03");
                elog.writeLog("[persist_class_settings:] " + message +" /n");
                response.sendRedirect("class_settings.jsp?message=" + message+ "&class=" + selectedclass);
                return;   
            }
            // User already added
            if (myBool.get_value()) {
                message = "User already added";
                response.sendRedirect("class_settings.jsp?message=" + message+ "&class=" + selectedclass);
                return;
            } else {
                if (!user.isUser(myBool, bu_id)) {
                    message = user.getErrMsg("AS04");
                    elog.writeLog("[persist_class_settings:] " + message +" /n");
                    response.sendRedirect("class_settings.jsp?message=" + message+ "&class=" + selectedclass);
                    return;   
                }
                // User already in Database
                if (myBool.get_value()) {   
                    searchSucess = true;
                } else {
                    // Found userId in LDAP
                    if (findUser(dbaccess, ldap, bu_id)) {
                        searchSucess = true;
                    } else {
                        message = "User Not Found";
                        response.sendRedirect("class_settings.jsp?message=" + message + "&class=" + selectedclass);
                        return;
                    }
                }
            }
        }
    }
    // End User Search
    
if (searchSucess) {
    ArrayList<ArrayList<String>> curCourse = new ArrayList<ArrayList<String>>();
    if (!section.createStudent(bu_id, selectedclass.split("-")[0], selectedclass.split("-")[1],selectedclass.split("-")[2], false)) {
        message = section.getErrMsg("AS06");
        elog.writeLog("[persist_class_settings:] " + message +" /n");
        response.sendRedirect("class_settings.jsp?message=" + message + "&class=" + selectedclass);
        return;   
    } else {
    	successMessage = bu_id + " added to student list";
    	ArrayList<ArrayList<String>> scheduleResult = new ArrayList<ArrayList<String>>();
    	section.getLectureSchedule(scheduleResult,selectedclass.split("-")[0], selectedclass.split("-")[1],selectedclass.split("-")[2]);
    	sendNotification(dbaccess,ldap,bu_id,"lecture",scheduleResult.get(0).get(0),"",usersession.getGivenName());
        response.sendRedirect("class_settings.jsp?successMessage=" + successMessage + "&class=" + selectedclass);
        return;
    }
} else {
    message = "User Not Found";
    response.sendRedirect("class_settings.jsp?message=" + message + "&class=" + selectedclass);
   }

%>
