// JavaScript Document
$(document).ready(function() {

		/* SELECT */
		$("#selectRepeatsEvery").css("display", "none");
		$("#selectDayoftheMonth").css("display", "none");
		$("#selectDayoftheWeek").css("display", "none");
		$("#occurrencesNumber").css("display", "none");
		$("#occurrenceEnds").css("display", "none");
		$("#week").css("display", "none");
		$("#selectOccursBy").css("display", "none");
		$("#selectEnds").css("display", "none");
		$("#tableAddAttendee").css("display", "none");			
		
		function populateYear(){
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

			$('.select[data-dropdown="#dropdownMonthStarts"]').text(month[data.getUTCMonth()]);
			$('.select[data-dropdown="#dropdownDayStarts"]').text(data.getUTCDate());			
			$('.select[data-dropdown="#dropdownYearStarts"]').text(data.getUTCFullYear());
			
			$('.select[data-dropdown="#dropdownMonthEnds"]').text(month[data.getUTCMonth()]);
			$('.select[data-dropdown="#dropdownDayEnds"]').text(data.getUTCDate());
			$('.select[data-dropdown="#dropdownYearEnds"]').text(data.getUTCFullYear());
			
			// Add the next 5 years as options
			for (var i = 0; i < 5; i++) {
				$("#dropdownYearStarts").append("<option role='option'><a>" + (data.getUTCFullYear() + i) + "</a></option>");
				$("#dropdownYearEnds").append("<option role='option'><a>" + (data.getUTCFullYear() + i) + "</a></option>");
			}
		}
		populateYear();
		
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
					$("#dropdownEnds_chosen").css("width", $("#dropdownEnds").css("width"));
					$("#occurrencesNumber").css("display", "block");
					$("#occurrences").val("");
					$("#occurrenceEnds").css("display", "none");
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
					$("#dropdownEnds_chosen").css("width", $("#dropdownEnds").css("width"));
					$("#occurrencesNumber").css("display", "block");
					$("#occurrences").val("");
					$("#occurrenceEnds").css("display", "none");
					
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
					$("#dropdownOccursBy_chosen").css("width", $("#dropdownOccursBy").css("width"));
					$("#selectDayoftheMonth").css("display", "block");
					$("#dropdownDayoftheMonth_chosen").css("width", $("#dropdownDayoftheMonth").css("width"));
					$("#week").css("display", "none");
					$("#selectDayoftheWeek").css("display", "none");
					$("#selectEnds").css("display", "block");
					$("#dropdownEnds_chosen").css("width", $("#dropdownEnds").css("width"));
					$("#occurrencesNumber").css("display", "block");
					$("#occurrences").val("");
					$("#occurrenceEnds").css("display", "none");
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
					break;
			}
		});
		
		// Dropdown: Occurs by
		$('select#dropdownOccursBy').change( function() {
			switch ($(this).val()){
				case "Day of the month":
					$("#selectDayoftheWeek").css("display", "none");
					$("#selectDayoftheMonth").css("display", "block");
					$("#dropdownDayoftheMonth_chosen").css("width", $("#dropdownDayoftheMonth").css("width"));
					$("#dropdownDayoftheMonth_chosen li:eq(5)").addClass("result-selected");
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
				case "1"://After # of occurrence(s)
					$("#occurrencesNumber").css("display", "block");
					$("#occurrencesNumber").text();
					$("#occurrenceEnds").css("display", "none");
					$("#occurrences").val("");
					break;
				case "2"://On specified date
					$("#occurrencesNumber").css("display", "none");
					$("#occurrenceEnds").css("display", "block");
					$("#dropdownMonthEnds_chosen").css("width", $("#dropdownMonthEnds").css("width"));
					$("#dropdownDayEnds_chosen").css("width", $("#dropdownDayEnds").css("width"));
					$("#dropdownYearEnds_chosen").css("width", $("#dropdownYearEnds").css("width"));
					$("#endsOn").val($("#startsOn").val());
					break;
			}
		});

		/* ONLY NUMBERS */
		$('input[type="number"]').keydown(function(event) {
			if (event.keyCode == 8 || event.keyCode == 9 || event.keyCode == 35 || event.keyCode == 36 || event.keyCode == 37 || event.keyCode == 39 || event.keyCode == 46) {
				// Allow only backspace (8), tab(9), end (35), home (36), arrows (37 and 39), and delete (46)
			}
			else {
				// Ensure that it is a number
				if ((event.keyCode < 48 || event.keyCode > 57) && (event.keyCode < 96 || event.keyCode > 105)) {
					event.preventDefault();	
				}	
			}
		});
			
		/* Expand-Collapse content */
		$('article header').click(function() {
        	$(this).next("fieldset").slideToggle(500);
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