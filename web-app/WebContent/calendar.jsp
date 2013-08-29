<!doctype html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Seneca | Conferece Management System</title>
<link rel="icon" href="http://www.cssreset.com/favicon.png">
<link rel="stylesheet" type="text/css" media="all" href="css/fonts.css">
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/style.css">
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.core.css">
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.theme.css">
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.datepicker.css">
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.selectmenu.css">
<link rel='stylesheet' type="text/css" href='fullcalendar-1.6.3/fullcalendar/fullcalendar.css'>
<script type="text/javascript" src="http://code.jquery.com/jquery-1.9.1.js"></script>
<script type="text/javascript" src='fullcalendar-1.6.3/fullcalendar/fullcalendar.js'></script>
<script type="text/javascript" src="js/modernizr.custom.79639.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.position.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.selectmenu.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.datepicker.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.stepper.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.dataTable.js"></script>
<script type="text/javascript" src="js/componentController.js"></script>

<script type="text/javascript">
$(function(){
	$('select').selectmenu();

	var date = new Date();
	var d = date.getDate();
	var m = date.getMonth();
	var y = date.getFullYear();
	
	$('#calendar').fullCalendar({
			header: {
				left: 'prev,next today',
				center: 'title',
				right: 'month,agendaWeek,agendaDay'
			},
			editable: true,
			events: [
				{
					title: 'All Day Event',
					start: new Date(y, m, 1)
				},
				{
					title: 'Long Event',
					start: new Date(y, m, d-5),
					end: new Date(y, m, d-2)
				},
				{
					id: 999,
					title: 'Repeating Event',
					start: new Date(y, m, d-3, 16, 0),
					allDay: false
				},
				{
					id: 999,
					title: 'Repeating Event',
					start: new Date(y, m, d+4, 16, 0),
					allDay: false
				},
				{
					title: 'Meeting',
					start: new Date(y, m, d, 10, 30),
					allDay: false
				},
				{
					title: 'Lunch',
					start: new Date(y, m, d, 12, 0),
					end: new Date(y, m, d, 14, 0),
					allDay: false
				},
				{
					title: 'Birthday Party',
					start: new Date(y, m, d+1, 19, 0),
					end: new Date(y, m, d+1, 22, 30),
					allDay: false
				},
				{
					title: 'Click for Google',
					start: new Date(y, m, 28),
					end: new Date(y, m, 29),
					url: 'http://google.com/'
				}
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
			<p><a href="calendar.jsp" tabindex="13">home</a> » <a href="createEvent" tabindex="14">create event</a></p>
			<h1>Create Event</h1>
		</header>
		<form>
			<article>
				<header>
					<h2>Filter Options</h2>
					<img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content" alt="Arrow"/></header>
				<div class="content">
					<fieldset>
						<div class="component">
							<div class="checkbox" title="Meetings you created."> <span class="box" role="checkbox" aria-checked="true" tabindex="17" aria-labelledby="filterOption1"></span>
								<label class="checkmark"></label>
								<label class="text" id="filterOption1">Meetings you created.</label>
								<input type="checkbox" name="filterOption1box" checked="checked" aria-disabled="true">
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
		<h4></h4>
		<div id='calendar'></div>
	</section>
	<jsp:include page="footer.jsp"/>
</div>
</body>
</html>