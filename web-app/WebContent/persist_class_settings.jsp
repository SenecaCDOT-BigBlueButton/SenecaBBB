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
    if (userId.equals("")) {
        response.sendRedirect("index.jsp?error=Please log in");
        return;
    }
    if (!usersession.isSuper() && !usersession.isProfessor() ) {
        response.sendRedirect("calendar.jsp?message=You don't have permission to access this page");
        return;
    }
    if (dbaccess.getFlagStatus() == false) {
        response.sendRedirect("index.jsp?error=Database connection error");
        return;
    } //End page validation
    
    String message = request.getParameter("message");
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
                response.sendRedirect("class_settings.jsp?message=" + message+ "&class=" + selectedclass);
                return;   
            }
            // User already added
            if (myBool.get_value()) {
                message = "User already added";
                response.sendRedirect("class_settings.jsp?message=" + message+ "&class=" + selectedclass);
            } else {
                if (!user.isUser(myBool, bu_id)) {
                    message = user.getErrMsg("AS04");
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
        response.sendRedirect("class_settings.jsp?message=" + message + "&class=" + selectedclass);
        return;   
    } else {
        message = bu_id + " added to student list";
        response.sendRedirect("class_settings.jsp?message=" + message + "&class=" + selectedclass);
    }
} else {
    message = "User Not Found";
    response.sendRedirect("class_settings.jsp?message=" + message + "&class=" + selectedclass);
   }

%>
