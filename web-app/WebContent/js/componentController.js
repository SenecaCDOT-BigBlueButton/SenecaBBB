// JavaScript Document
$(screen).ready(function() {

		/* SELECT */
		$("#selectRepeatsEvery").css("display", "none");
		$("#selectDayoftheMonth").css("display", "none");
		$("#selectDayoftheWeek").css("display", "none");
		$("#occurrencesNumber").css("display", "none");
		$("#occurrenceEnds").css("display", "none");
		$("#week").css("display", "none");
		$("#selectOccursBy").css("display", "none");
		$("#selectEnds").css("display", "none");
		//$("#tableAddAttendee").css("display", "none");

		//Setting default values for selects
		$("#dropdownEventType").val("Meeting");
		$("#dropdownRecurrence").val("Only once");
		$("#dropdownEnds").val("After # of occurrence(s)");

		function populateDate(){
			var data = new Date();
			var month = new Array(12);
			month[0]="January";
			month[1]="February";
			month[2]="March";
			month[3]="April";
			month[4]="May";
			month[5]="June";
			month[6]="July";
			month[7]="August";
			month[8]="September";
			month[9]="October";
			month[10]="November";
			month[11]="December";
			
			//Select month value
			$("#dropdownMonthStarts").val(month[data.getUTCMonth()]);
			$("#dropdownMonthEnds").val(month[data.getUTCMonth()]);
			
			//Add days according to month
			switch($("#dropdownMonthStarts").val()){
				case "January":
				case "March":
				case "May":
				case "July":
				case "August":
				case "October":
				case "December":
					for (var i = 1; i <= 31; i++) {
						$("#dropdownDayStarts").append("<option role='option'>" + (i) + "</option>");
						$("#dropdownDayEnds").append("<option role='option'>" + (i) + "</option>");
					}
					break;
				case "April":
				case "June":
				case "September":
				case "November":
					for (var i = 1; i <= 30; i++) {
						$("#dropdownDayStarts").append("<option role='option'>" + (i) + "</option>");
						$("#dropdownDayEnds").append("<option role='option'>" + (i) + "</option>");
					}
					break;
				case "February":
					for (var i = 1; i <= 28; i++) {
						$("#dropdownDayStarts").append("<option role='option'>" + (i) + "</option>");
						$("#dropdownDayEnds").append("<option role='option'>" + (i) + "</option>");
					}
					if ((data.getUTCFullYear() % 4) == 0){
						$("#dropdownDayStarts").append("<option role='option'>" + 29 + "</option>");
						$("#dropdownDayEnds").append("<option role='option'>" + 29 + "</option>");
					}
					break;
			}
			$("#dropdownDayStarts").val(data.getUTCDate());
			$("#dropdownDayEnds").val(data.getUTCDate());
			
			// Add the next 5 years as options
			for (var i = 0; i < 5; i++) {
				$("#dropdownYearStarts").append("<option role='option'>" + (data.getUTCFullYear() + i) + "</option>");
				$("#dropdownYearEnds").append("<option role='option'>" + (data.getUTCFullYear() + i) + "</option>");
			}
			$("#dropdownYearStarts").val(data.getUTCFullYear());
			$("#dropdownYearEnds").val(data.getUTCFullYear());
		}

		populateDate();

		//Change days field according to the current month
		function populateMonthStarts(month){
			switch (month){
				case "January":
				case "March":
				case "May":
				case "July":
				case "August":
				case "October":
				case "December":
				
					var previouslySelectedDay = $("#dropdownDayStarts").val();
					$("#dropdownDayStarts option").remove();
					for (var i = 1; i <= 31; i++) {
						$("#dropdownDayStarts").append("<option role='option'>" + (i) + "</option>");
					}
					$("#dropdownDayStarts").val(previouslySelectedDay);
					$("#dropdownDayStarts").selectmenu({'refresh': true});
					break;
				case "April":
				case "June":
				case "September":
				case "November":
					var previouslySelectedDay = $("#dropdownDayStarts").val();
					$("#dropdownDayStarts option").remove();
					for (var i = 1; i <= 30; i++) {
						$("#dropdownDayStarts").append("<option role='option'>" + (i) + "</option>");
					}
					if (previouslySelectedDay > 30){
						$("#dropdownDayStarts").val(30);
					} else{
						$("#dropdownDayStarts").val(previouslySelectedDay);
					}
					$("#dropdownDayStarts").selectmenu({'refresh': true});
					break;
				case "February":
					var previouslySelectedDay = $("#dropdownDayStarts").val();
					$("#dropdownDayStarts option").remove();
					
					var isLeapYear = ((($("#dropdownYearStarts").val()) % 4) == 0) ? true : false;
					
					for (var i = 1; i <= (isLeapYear ? 29 : 28); i++) {
						$("#dropdownDayStarts").append("<option role='option'>" + (i) + "</option>");
					}
					
					if ((previouslySelectedDay >= 29) && (isLeapYear)){
						$("#dropdownDayStarts").val(29);
					} else if (previouslySelectedDay >= 28){
						$("#dropdownDayStarts").val(28);
					} else {
						$("#dropdownDayStarts").val(previouslySelectedDay);
					}
					
					$("#dropdownDayStarts").selectmenu({'refresh': true});
					break;
			}
		}
		
		//Change days field according to the current month
		function populateMonthEnds(month){
			switch (month){
				case "January":
				case "March":
				case "May":
				case "July":
				case "August":
				case "October":
				case "December":
					var previouslySelectedDay = $("#dropdownDayEnds").val();
					$("#dropdownDayEnds option").remove();
					for (var i = 1; i <= 31; i++) {
						$("#dropdownDayEnds").append("<option role='option'>" + (i) + "</option>");
					}
					$("#dropdownDayEnds").val(previouslySelectedDay);
					$("#dropdownDayEnds").selectmenu({'refresh': true});
					break;
				case "April":
				case "June":
				case "September":
				case "November":
					var previouslySelectedDay = $("#dropdownDayEnds").val();
					$("#dropdownDayEnds option").remove();
					for (var i = 1; i <= 30; i++) {
						$("#dropdownDayEnds").append("<option role='option'>" + (i) + "</option>");
					}
					if (previouslySelectedDay > 30){
						$("#dropdownDayEnds").val(30);
					} else{
						$("#dropdownDayEnds").val(previouslySelectedDay);
					}
					$("#dropdownDayEnds").selectmenu({'refresh': true});
					break;
				case "February":
					var previouslySelectedDay = $("#dropdownDayEnds").val();
					$("#dropdownDayEnds option").remove();
					
					var isLeapYear = ((($("#dropdownYearEnds").val()) % 4) == 0) ? true : false;
					
					for (var i = 1; i <= (isLeapYear ? 29 : 28); i++) {
						$("#dropdownDayEnds").append("<option role='option'>" + (i) + "</option>");
					}
					
					if ((previouslySelectedDay >= 29) && (isLeapYear)){
						$("#dropdownDayEnds").val(29);
						
					} else if (previouslySelectedDay >= 28){
						$("#dropdownDayEnds").val(28);
					} else {
						$("#dropdownDayEnds").val(previouslySelectedDay);
					}
					
					$("#dropdownDayEnds").selectmenu({'refresh': true});
					break;
			}
		}

		//Change days field according to the current month
		$("#dropdownMonthStarts").change(function(){
			populateMonthStarts($("#dropdownMonthStarts").val());
		});

		//Change days field according to the current month
		$("#dropdownMonthEnds").change(function(){
			populateMonthEnds($("#dropdownMonthEnds").val());
		});

		//Change days field according to the current year
		$("#dropdownYearStarts").change(function(){
			populateMonthStarts($("#dropdownMonthStarts").val());
		});

		//Change days field according to the current year
		$("#dropdownYearEnds").change(function(){
			populateMonthEnds($("#dropdownMonthEnds").val());
		});

		// Dropdown: Recurrence
		$('select#dropdownRecurrence').change( function() {
			switch ($(this).val()){
				case "Daily":
					$("#selectRepeatsEvery").css("display", "block");
					$("#repeatsEvery").attr("placeholder", "# of days");
					$("#repeatsEvery").val("");
					$("#selectOccursBy").css("display", "none");
					$("#selectDayoftheMonth").css("display", "none");
					$("#week").css("display", "none");
					$("#selectDayoftheWeek").css("display", "none");
					$("#selectEnds").css("display", "block");
					$("#occurrencesNumber").css("display", "block");
					$("#occurrences").val("");
					$("#occurrenceEnds").css("display", "none");
					$("#dropdownEnds").val("After # of occurrence(s)");
					$("#dropdownEnds").selectmenu({'refresh': true});
					break;
				case "Weekly":
					$("#selectRepeatsEvery").css("display", "block");
					$("#repeatsEvery").attr("placeholder", "# of weeks");
					$("#repeatsEvery").val("");
					$("#selectOccursBy").css("display", "none");
					$("#selectDayoftheMonth").css("display", "none");
					$("#week").css("display", "block");
					$("#selectDayoftheWeek").css("display", "none");
					$("#selectEnds").css("display", "block");
					$("#occurrencesNumber").css("display", "block");
					$("#occurrences").val("");
					$("#occurrenceEnds").css("display", "none");
					$("#dropdownEnds").val("After # of occurrence(s)");
					$("#dropdownEnds").selectmenu({'refresh': true});
					// Starting date
					//var data = new Date(2013,6,19);
					var data = new Date();
					// Day of the week of the starting date
					var weekday = new Array();
					weekday[0]="Sunday";
					weekday[1]="Monday";
					weekday[2]="Tuesday";
					weekday[3]="Wednesday";
					weekday[4]="Thursday";
					weekday[5]="Friday";
					weekday[6]="Saturday";
					var dayOfTheWeek = weekday[data.getUTCDay()];
					
					// Unchecking all days of the week
					$('section form article fieldset div.component#week .weekday').each(function() {
						$(this).attr("aria-checked", "false");
						$(this).toggleClass("selectedWeekday", false);
					});
					
					// Checking only the day of the week of the starting date
					$("section form article fieldset div.component#week .weekday#"+dayOfTheWeek).attr("aria-checked", "true");
					$("section form article fieldset div.component#week .weekday#"+dayOfTheWeek).toggleClass("selectedWeekday", true);
					break;
				case "Monthly":
					$("#selectRepeatsEvery").css("display", "block");
					$("#repeatsEvery").attr("placeholder", "# of months");
					$("#repeatsEvery").val("");
					$("#selectOccursBy").css("display", "block");
					$("#dropdownOccursBy").val("Day of the month");
					$("#dropdownOccursBy").selectmenu({'refresh': true});
					$("#selectDayoftheMonth").css("display", "block");
					$("#dropdownDayoftheMonth").val("1st");
					$("#dropdownDayoftheMonth").selectmenu({'refresh': true});
					$("#week").css("display", "none");
					$("#selectDayoftheWeek").css("display", "none");
					$("#selectEnds").css("display", "block");
					$("#occurrencesNumber").css("display", "block");
					$("#occurrences").val("");
					$("#occurrenceEnds").css("display", "none");
					$("#dropdownEnds").val("After # of occurrence(s)");
					$("#dropdownEnds").selectmenu({'refresh': true});
					break;
				case "Only once":
					$("#selectRepeatsEvery").css("display", "none");
					$("#selectOccursBy").css("display", "none");
					$("#selectDayoftheMonth").css("display", "none");
					$("#week").css("display", "none");
					$("#selectDayoftheWeek").css("display", "none");
					$("#selectEnds").css("display", "none");
					$("#occurrencesNumber").css("display", "none");
					$("#occurrenceEnds").css("display", "none");
					$("#dropdownEnds").val("After # of occurrence(s)");
					$("#dropdownEnds").selectmenu({'refresh': true});
					break;
			}
		});

		// Dropdown: Occurs by
		$('select#dropdownOccursBy').change( function() {
			switch ($(this).val()){
				case "Day of the month":
					$("#selectDayoftheWeek").css("display", "none");
					$("#selectDayoftheMonth").css("display", "block");
					$("#dropdownDayoftheMonth").val("1st");
					$("#dropdownDayoftheMonth").selectmenu({'refresh': true});
					break;
				case "First occurrence of the day of the week":
				case "Second occurrence of the day of the week":
				case "Third occurrence of the day of the week":
				case "Fourth occurrence of the day of the week":
				case "Last occurrence of the day of the week":
					$("#selectDayoftheWeek").css("display", "block");
					$("#selectDayoftheMonth").css("display", "none");
					
					// Starting date
					//var data = new Date(2013,6,19);
					var data = new Date();
					// Day of the week of the starting date
					var weekday = new Array();
					weekday[0]="Sunday";
					weekday[1]="Monday";
					weekday[2]="Tuesday";
					weekday[3]="Wednesday";
					weekday[4]="Thursday";
					weekday[5]="Friday";
					weekday[6]="Saturday";
					var dayOfTheWeek = weekday[data.getUTCDay()];
					
					// Unchecking all days of the week
					$('section form article fieldset div.component#selectDayoftheWeek .weekday').each(function() {
						$(this).attr("aria-checked", "false");
						$(this).toggleClass("selectedWeekday", false);
					});
					
					// Checking only the day of the week of the starting date
					$("section form article fieldset div.component#selectDayoftheWeek .weekday#"+dayOfTheWeek).attr("aria-checked", "true");
					$("section form article fieldset div.component#selectDayoftheWeek .weekday#"+dayOfTheWeek).toggleClass("selectedWeekday", true);
					break;
			}
		});

		// Dropdown: Ends
		$('select#dropdownEnds').change( function() {
			switch ($(this).val()){
				
				case "After # of occurrence(s)"://After # of occurrence(s)
					$("#occurrencesNumber").css("display", "block");
					$("#occurrencesNumber").text();
					$("#occurrenceEnds").css("display", "none");
					$("#occurrences").val("");
					break;
				case "On specified date"://On specified date
					$("#occurrencesNumber").css("display", "none");
					$("#occurrenceEnds").css("display", "block");
					$("#dropdownMonthEnds").val($("#dropdownMonthStarts").val());
					$("#dropdownMonthEnds").selectmenu({'refresh': true});
					$("#dropdownDayEnds").val($("#dropdownDayStarts").val());
					$("#dropdownDayEnds").selectmenu({'refresh': true});
					$("#dropdownYearEnds").val($("#dropdownYearStarts").val());
					$("#dropdownYearEnds").selectmenu({'refresh': true});
					break;
			}
		});

		/* ONLY NUMBERS */
		$('input[type="number"]').keydown(function(event) {
			switch(event.keyCode){
				case 8: //backspace
				case 9: //tab
				case 35: //end
				case 36: //home
				case 37: //left arrow
				case 39: //right arrow
				case 46: //delete
					break;
				default:
					// Ensure that it is a number that user is inserting
					if ((event.keyCode < 48 || event.keyCode > 57) && (event.keyCode < 96 || event.keyCode > 105)) {
						event.preventDefault();	
					}
					break;
			}
		});

		/* Expand-Collapse content */
		$('article header').click(function() {
			$(this).next(".content").slideToggle(500);
			$(this).find("img").toggleClass("expandContent");
		});
		$("#startsOnDatePicker").hide();

		/* DATEPICKER */
		$("#datePicker").click(function () {
			$("#startsOnDatePicker").slideToggle(500);
		});

		/* Checkbox */
		$('.checkbox .box').keydown(function() {
			if (event.which == 13){
				event.preventDefault(event);
				$(this).next(".checkmark").toggle();
				$(this).attr("aria-checked", ($(this).attr("aria-checked") === "true" ? "false" : "true"));
				
				if (($(this).siblings().last().is(":checked"))){
					$(this).siblings().last().prop("checked", false);
				} else {
					$(this).siblings().last().prop("checked", true);
				}
			}
		});
		$('.checkbox .box').click(function(event) {
			$(this).next(".checkmark").toggle();
			$(this).attr("aria-checked", ($(this).attr("aria-checked") === "true" ? "false" : "true"));
			
			if (($(this).siblings().last().is(":checked"))){
				$(this).siblings().last().prop("checked", false);
			} else {
				$(this).siblings().last().prop("checked", true);
			}
		});
		$('.checkbox .checkmark').click(function() {
			$(this).toggle();
			if (($(this).siblings().last().is(":checked"))){
				$(this).siblings().last().prop("checked", false);
			} else {
				$(this).siblings().last().prop("checked", true);
			}
		});
/*		$('.checkbox .text').click(function(event) {
			$(this).prev(".checkmark").toggle();
			$('.checkbox .box').attr("aria-checked", ($(this).attr("aria-checked") === "true" ? "false" : "true"));
			
			if (($('.checkbox .box').siblings().last().is(":checked"))){
				$('.checkbox .box').siblings().last().prop("checked", false);
			} else {
				$('.checkbox .box').siblings().last().prop("checked", true);
			}
		);*/
		$.fn.pressEnterSpace = function(fn) {
			return this.each(function() {  
				$(this).bind('enterPress', fn);
				$(this).keyup(function (e) { 
					if(e.keyCode == 32) {
					  $(this).trigger("enterPress");
					  $(this).next(".checkmark").toggle();
					  $(this).attr("aria-checked", ($(this).attr("aria-checked") === "true" ? "false" : "true"));
					  if (($(this).siblings().last().is(":checked"))){
						$(this).siblings().last().prop("checked", false);
					  } else {
						$(this).siblings().last().prop("checked", true);
					  }
					}
				})
			});
		};
		$(".checkbox .box").pressEnterSpace();

		/* Radio */
		$('.radio .box').keydown(function() {
			if (event.which == 13){
				event.preventDefault(event);
				$(this).next(".checkradio").toggle();
				$(this).attr("aria-checked", ($(this).attr("aria-checked") === "true" ? "false" : "true"));
			}
		});
		$('.radio .box').click(function() {
			$(this).next(".checkradio").toggle();
			$(this).attr("aria-checked", ($(this).attr("aria-checked") === "true" ? "false" : "true"));
		});
		$('.radio .checkradio').click(function() {
			$(this).toggle();
		});

		/* Day of the Week checked for weekly events*/
		$("section form article fieldset div.component#week .weekday").click(function() {
			$(this).attr("aria-checked", ($(this).attr("aria-checked") === "true" ? "false" : "true"));
			if ($(this).attr("aria-checked") == "true"){
				$(this).toggleClass("selectedWeekday");
			} else {
				$(this).toggleClass("selectedWeekday");
			}
		});

		/* Day of the Week checked for monthly events*/
		$("section form article fieldset div.component#selectDayoftheWeek .weekday").click(function() {
			$("section form article fieldset div.component#selectDayoftheWeek .weekday").removeClass("selectedWeekday");
			$("section form article fieldset div.component#selectDayoftheWeek .weekday").attr("aria-checked", false);
			$(this).attr("aria-checked", ($(this).attr("aria-checked") === "true" ? "false" : "true"));
			if ($(this).attr("aria-checked") == "true"){
				$(this).toggleClass("selectedWeekday");
			} else {
				$(this).toggleClass("selectedWeekday");
			}
		});

		/* Day of the Month */
		$("section form article fieldset div.component#selectDayoftheMonth #dayoftheMonth").jStepper({minValue:1, maxValue:31, minLength:1});

		/* CLEAR MENU */		
		function clear (){
			$("aside nav li").each(function() {
				menu_id = $(this).attr('id');
				
				/* NORMAL STATE */		
				$("aside nav #"+menu_id).css({"background-color":"#CD352B"});
				$("aside nav #"+menu_id).css({"border-left":"0px solid #EEE"});
				$("aside nav #"+menu_id).parent(this).css({"border-right":"10px solid #EEEEEE"}); //CD352B
					
				/* MOUSEOUT */			
				$("aside nav #"+menu_id).mouseout(  
					function () {
						$(this).css({"background-color":"#CD352B"});
						$(this).css({"border-left":"0px solid #EEE"});
						$(this).parent(this).css({"border-right":"10px solid #EEEEEE"}); //CD352B
					}
				);
			});

			/* HOME - MOUSEOVER */
			$("aside nav #home").mouseover(
				function () {
					$(this).css({"background-color":"#9F100B"});
					$(this).css({"border-left":"123px solid #EEE"});
					$(this).parent(this).css({"border-right":"10px solid #9F100B"});
				}
			);

			/* CREATE EVENT - MOUSEOVER */
			$("aside nav #createEvent").mouseover(
				function () {
					$(this).css({"background-color":"#9F100B"});
					$(this).css({"border-left":"68px solid #EEE"});
					$(this).parent(this).css({"border-right":"10px solid #9F100B"});
				}
			);

			/* MANAGE USERS - MOUSEOVER */
			$("aside nav #manageUsers").mouseover(
				function () {
					$(this).css({"background-color":"#9F100B"});
					$(this).css({"border-left":"56px solid #EEE"});
					$(this).parent(this).css({"border-right":"10px solid #9F100B"});
				}
			);

			/* DEPARTMENTS - MOUSEOVER */
			$("aside nav #departments").mouseover(
				function () {
					$(this).css({"background-color":"#9F100B"});
					$(this).css({"border-left":"68px solid #EEE"});
					$(this).parent(this).css({"border-right":"10px solid #9F100B"});
				}
			);

			/* DEPARTMENT USERS - MOUSEOVER */
			$("aside nav #departmentUsers").mouseover(
				function () {
					$(this).css({"background-color":"#9F100B"});
					$(this).css({"border-left":"30px solid #EEE"});
					$(this).parent(this).css({"border-right":"10px solid #9F100B"});
				}
			);

			/* SUBJECTS - MOUSEOVER */
			$("aside nav #subjects").mouseover(
				function () {
					$(this).css({"background-color":"#9F100B"});
					$(this).css({"border-left":"102px solid #EEE"});
					$(this).parent(this).css({"border-right":"10px solid #9F100B"});
				}
			);

			/* CLASS SETTINGS - MOUSEOVER */
			$("aside nav #classSettings").mouseover(
				function () {
					$(this).css({"background-color":"#9F100B"});
					$(this).css({"border-left":"61px solid #EEE"});
					$(this).parent(this).css({"border-right":"10px solid #9F100B"});
				}
			);

			/* SYSTEM SETTINGS - MOUSEOVER */
			$("aside nav #systemSettings").mouseover(
				function () {
					$(this).css({"background-color":"#9F100B"});
					$(this).css({"border-left":"47px solid #EEE"});
					$(this).parent(this).css({"border-right":"10px solid #9F100B"});
				}
			);
		}

		clear();

	 	/* MENU - CLICK EVENT */
		$("aside nav #home").click(function () {
			$(location).attr('href', "calendar.jsp");
		});

		$("aside nav #createEvent").click(function () {
			$(location).attr('href', "createEvent.jsp");
		});

		$("aside nav #manageUsers").click(function () {
			$(location).attr('href', "manageUsers.jsp");
		});

		$("aside nav #departments").click(function () {
			$(location).attr('href', "departments.jsp");
		});

		$("aside nav #departmentUsers").click(function () {
			$(location).attr('href', "departmentUsers.jsp");
		});	

		$("aside nav #subjects").click(function () {
			$(location).attr('href', "subjects.jsp");
		});	

		$("aside nav #classSettings").click(function () {
			$(location).attr('href', "classSettings.jsp");
		});	

		$("aside nav #systemSettings").click(function () {
			$(location).attr('href', "systemSettings.jsp");
		});

		/* MENU - CURRENT PAGE */
		var currentPage = $("section header h1").text().substr(0,1).toLowerCase() + $("section header h1").text().substr(1).replace(/ /g, '');
		$("aside nav #"+currentPage).css({"border-left":"0px solid #EEE"});
		$("aside nav #"+currentPage).css({"background-color":"#9F100B"});
		$("aside nav #"+currentPage).parent(this).css({"border-right":"10px solid #454545"});
		$("aside nav #"+currentPage).unbind('mouseout');
		$("aside nav #"+currentPage).unbind('mouseover');
});