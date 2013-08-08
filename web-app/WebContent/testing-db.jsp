<%//Tests for DAO%>
<jsp:useBean id="dbaccess" scope="session" class="db.DBAccess" />
<%@page import="test.*"%>

<%
    Test_User userTest = new Test_User(dbaccess);
	//Test_Meeting meetingTest = new Test_Meeting(dbaccess);
	//Test_Lecture lectureTest = new Test_Lecture(dbaccess);
	//Test_Section sectionTest = new Test_Section(dbaccess);
%>