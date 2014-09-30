<%@page import="db.DBConnection"%>
<%@page import="sql.*"%>
<%@page import="java.util.*"%>
<%@page import="helper.*"%>
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<jsp:useBean id="ldap" class="ldap.LDAPAuthenticate" scope="session" />
<%@ include file="search.jsp" %>

<% 
//Start page validation
String userId = usersession.getUserId();
GetExceptionLog elog = new GetExceptionLog();
if (userId.equals("")) {
    session.setAttribute("redirecturl", request.getRequestURI()+(request.getQueryString()!=null?"?"+request.getQueryString():""));
    response.sendRedirect("index.jsp?message=Please log in");
    return;
}
if (!(usersession.isDepartmentAdmin() || usersession.isSuper())) {
    elog.writeLog("[persist_professor:] " + " username: "+ userId + " tried to access this page, permission denied" +" /n");       
    response.sendRedirect("calendar.jsp?message=You don't have permission to access that page!");
    return;
}
if (dbaccess.getFlagStatus() == false) {
    elog.writeLog("[persist_professor:] " + "database connection error /n");
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
boolean searchSuccess = false;
MyBoolean myBool = new MyBoolean();
if (!user.isUser(myBool, bu_id)) {
    message = user.getErrMsg("PP01");
    elog.writeLog("[persist_professor:] " + message +" /n");
    response.sendRedirect("logout.jsp?message=" + message);
    return;
}
// User already in Database
if (myBool.get_value()) {
    searchSuccess = true;
} else {
    // Found userId in LDAP
    if (findUser(dbaccess, ldap, bu_id)) {
        searchSuccess = true;
    } else {
        message = "User Not Found";
    }
}

if(del == null ){  
    if(!searchSuccess){// make sure the bu_id is registered in database
        response.sendRedirect("create_professor.jsp?message=Professor ID Not in Database");
        return;
    }
    else{
        section.createProfessor(bu_id, c_id, sc_id,sc_semesterid);
        response.sendRedirect("manage_professor.jsp?successMessage=Professor created");
        return;
    }
}else{
    section.removeProfessor(bu_id, c_id, sc_id,sc_semesterid);
    response.sendRedirect("manage_professor.jsp?successMessage=Professor Removed");
}

%>
