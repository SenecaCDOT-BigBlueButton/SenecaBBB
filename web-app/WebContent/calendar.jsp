<%@page import="sql.User"%>
<%@page import="sql.Meeting"%>
<%@page import="sql.Lecture"%>
<%@page import="java.util.ArrayList" %>
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<!doctype html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>Seneca | Change Settings</title>
	<link rel="icon" href="http://www.cssreset.com/favicon.png">
	<link rel="stylesheet" type="text/css" media="all" href="css/fonts.css">
	<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/style.css">
	<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.core.css">
	<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.theme.css">
	<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.datepicker.css">
	<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.selectmenu.css">
	<link rel='stylesheet' type="text/css" href='fullcalendar-1.6.3/fullcalendar/fullcalendar.css'>
	<script type="text/javascript" src="http://code.jquery.com/jquery-1.9.1.js"></script>
	<script type="text/javascript" src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>
	<script type="text/javascript" src='fullcalendar-1.6.3/fullcalendar/fullcalendar.js'></script>
	<script type="text/javascript" src="js/modernizr.custom.79639.js"></script>
	<script type="text/javascript" src="js/ui/jquery.ui.core.js"></script>
	<script type="text/javascript" src="js/ui/jquery.ui.widget.js"></script>
	<script type="text/javascript" src="js/ui/jquery.ui.position.js"></script>
	<script type="text/javascript" src="js/ui/jquery.ui.selectmenu.js"></script>
	<script type="text/javascript" src="js/ui/jquery.ui.stepper.js"></script>
	<script type="text/javascript" src="js/ui/jquery.ui.dataTable.js"></script>
	<script type="text/javascript" src="js/componentController.js"></script>
	<%
	String message = request.getParameter("message");
	if (message == null || message == "null") {
		message="";
	}
	
	boolean check1 = request.getParameter("filterOption1box") != null && request.getParameter("filterOption1box").equals("on");
	boolean check2 = request.getParameter("filterOption2box") != null && request.getParameter("filterOption2box").equals("on");
	boolean check3 = request.getParameter("filterOption3box") != null && request.getParameter("filterOption3box").equals("on");
	boolean check4 = request.getParameter("filterOption4box") != null && request.getParameter("filterOption4box").equals("on");
	
	ArrayList<ArrayList<String>> result = new ArrayList<ArrayList<String>>();
	Meeting meet = new Meeting(dbaccess);
	dbaccess.resetFlag();
	System.out.println(meet.getMeetingsForUser(result, usersession.getUserId(), true, true));
	System.out.println(dbaccess.getErrLog());
	System.out.println(result.size());
	String meetingJSON = meetingDBToJSON(result);
	
	Lecture lect = new Lecture(dbaccess);
	dbaccess.resetFlag();
	System.out.println(lect.getLecturesForUser(result, usersession.getUserId(), true, true));
	System.out.println(dbaccess.getErrLog());
	System.out.println(result.size());
	String lectureJSON = lectureDBToJSON(result);
	%>
	<script type='text/javascript'>
		$(document).ready(function() {
			$('#fullcalendar').fullCalendar({
				header: {
					left: 'prev,next today',
					center: 'title',
					right: 'month,agendaWeek,agendaDay'
				},
				editable: false,
				allDayDefault: false,
				events: [
					<%= meetingJSON %>, <%= lectureJSON%>
				]
			});
		});
	</script>
</head>
<body>
	<div id="page">
		<jsp:include page="header.jsp"/>
		<jsp:include page="menu.jsp"/>
		<section>
			<header>
				<p><a href="calendar.jsp" tabindex="13">home</a> » </p>
				<h1>Calendar</h1>
			</header>
				<form>
					<article>
						<header>
							<h2>Filter Options</h2>
							<img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content" alt="Arrow"/>
						</header>
						<div class="content">
							<fieldset>
								<div class="component">
									<div class="checkbox" title="Meetings you created."> <span class="box" role="checkbox" <%= (check1 ? "aria-checked='checked'" : "") %> tabindex="17" aria-labelledby="filterOption1"></span>
										<label class="checkmark"></label>
										<label class="text" id="filterOption1">Meetings you created.</label>
										<input type="checkbox" name="filterOption1box" <%= (check1 ? "checked='checked'" : "") %> aria-disabled="true">
									</div>
								</div>
								<div class="component">
									<div class="checkbox" title="Lectures you created."> <span class="box" role="checkbox" aria-checked="true" tabindex="18" aria-labelledby="filterOption2"></span>
										<label class="checkmark"></label>
										<label class="text" id="filterOption2">Lectures you created.</label>
										<input type="checkbox" name="filterOption2box" checked="checked" aria-disabled="true">
									</div>
								</div>
								<div class="component">
									<div class="checkbox" title="Meetings you were invited to attend."> <span class="box" role="checkbox" aria-checked="true" tabindex="19" aria-labelledby="filterOption3"></span>
										<label class="checkmark"></label>
										<label class="text" id="filterOption3">Meetings you were invited to attend.</label>
										<input type="checkbox" name="filterOption3box" checked="checked" aria-disabled="true">
									</div>
								</div>
								<div class="component" style="z-index: 2;">
									<div class="checkbox" title="Lectures you were invited to attend."> <span class="box" role="checkbox" aria-checked="true" tabindex="20" aria-labelledby="filterOption4"></span>
										<label class="checkmark"></label>
										<label class="text" id="filterOption4">Lectures you were invited to attend.</label>
										<input type="checkbox" name="filterOption4box" checked="checked" aria-disabled="true">
									</div>
								</div>
							</fieldset>
							<fieldset>
								<div class="buttons">
									<button type="submit" name="submit" id="save" class="button" title="Click here to submit filter options">Filter</button>
								</div>
							</fieldset>
						</div>
					</article>
				</form>
			<div class="content">
				<div class="component">
					<div id="fullcalendar"></div>
				</div>
			</div>
		</section>
		<jsp:include page="footer.jsp"/>
	</div>
</body>
</html>

<%! 
//title: 'Birthday Party',
//start: new Date(y, m, d+1, 19, 0),
//end: new Date(y, m, d+1, 22, 30),
//allDay: false
public String meetingDBToJSON(ArrayList<ArrayList<String>> results) {
	String converted = "";
	for (int i = 0; i < results.size(); ++i) {
		if (i > 0)
			converted += ",";
		//System.out.println("0: " + results.get(i).get(0) + " 1: " + results.get(i).get(1) + " 2: " + results.get(i).get(2) + " 3: " + results.get(i).get(3) 
		//		+ " 4: " + results.get(i).get(4) + " 5: " + results.get(i).get(5) + " 6: " + results.get(i).get(6) + " 7: " + results.get(i).get(7) 
		//		+ " 8: " + results.get(i).get(8) + " 9: " + results.get(i).get(9));
		String [] date = results.get(i).get(2).split(" ");
		
		converted += "{id: " + results.get(i).get(0) + ",title: '" + results.get(i).get(9) + "',start: new Date(" + date[0].split("-")[0] + ", "+ date[0].split("-")[1] +"-1, "+ date[0].split("-")[2] +", " + date[1].split(":")[0] + ", " + date[1].split(":")[1] + "),end: new Date(" + date[0].split("-")[0] + ", "+ date[0].split("-")[1] +"-1, "+ date[0].split("-")[2] +", " + date[1].split(":")[0] + ", " + date[1].split(":")[1] + "+" + results.get(i).get(3) + ")}";
		//System.out.println(converted);
	}
	return converted;
}

//     (0)ls_id (1)l_id (2)l_inidatetime (3)l_duration (4)l_iscancel (5)l_description (6)l_modpass (7)l_userpass (8)c_name (9)sc_id
public String lectureDBToJSON(ArrayList<ArrayList<String>> results) {
	String converted = "";
	for (int i = 0; i < results.size(); ++i) {
		if (i > 0)
			converted += ",";
		//System.out.println("0: " + results.get(i).get(0) + " 1: " + results.get(i).get(1) + " 2: " + results.get(i).get(2) + " 3: " + results.get(i).get(3) 
		//		+ " 4: " + results.get(i).get(4) + " 5: " + results.get(i).get(5) + " 6: " + results.get(i).get(6) + " 7: " + results.get(i).get(7) 
		//		+ " 8: " + results.get(i).get(8) + " 9: " + results.get(i).get(9));
		String [] date = results.get(i).get(2).split(" ");
		
		converted += "{id: " + results.get(i).get(0) + ",title: '" + results.get(i).get(8) + results.get(i).get(9) + "',start: new Date(" + date[0].split("-")[0] + ", "+ date[0].split("-")[1] +"-1, "+ date[0].split("-")[2] +", " + date[1].split(":")[0] + ", " + date[1].split(":")[1] + "),end: new Date(" + date[0].split("-")[0] + ", "+ date[0].split("-")[1] +"-1, "+ date[0].split("-")[2] +", " + date[1].split(":")[0] + ", " + date[1].split(":")[1] + "+" + results.get(i).get(3) + ")}";
		//System.out.println(converted);
	}
	return converted;
}
%>