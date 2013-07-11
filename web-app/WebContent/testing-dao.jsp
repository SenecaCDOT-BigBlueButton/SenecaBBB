<%//Tests for DAO%>
<jsp:useBean id="db" scope="session" class="db.DBQuery" />
<%@page import="test.*"%>

<%
    DAO_User_Test userTest = new DAO_User_Test(db);
	DAO_Meeting_Test meetingTest = new DAO_Meeting_Test(db);
	DAO_Lecture_Test lectureTest = new DAO_Lecture_Test(db);
	DAO_Section_Test sectionTest = new DAO_Section_Test(db);
%>