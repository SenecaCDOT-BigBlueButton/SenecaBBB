// JavaScript Document		
$(document).ready(function() {
				
		/* SELECT */
		function DropDown(el) {
			this.dd = el;
			this.placeholder = this.dd.children('span');
			this.opts = this.dd.find('ul.dropdown > li');
			this.val = '';
			this.index = -1;
			this.initEvents();
		}
		DropDown.prototype = {
			initEvents : function() {
				var obj = this;

				obj.dd.on('click', function(event){
					$(this).toggleClass('active');
					return false;
				});
				
				obj.opts.on('click',function(){
					var opt = $(this);
					obj.val = opt.text();
					obj.index = opt.index();
					obj.placeholder.text('' + obj.val);
					
					
					switch ($(this).text()){
						case "Daily":
							$("#ddEnds.select").css({"pointer-events" : "auto"});
							$("#ddEnds.select").fadeTo('slow',1);
							$("#selectRepeatsEvery").css("display", "block");
							$("#week").css("display", "none");
							$("#repeatsEvery").attr("placeholder", "# of days");
							$("#selectOccursBy").css("display", "none");
							$("#selectDayoftheMonth").css("display", "none");
							$("#selectDayoftheWeek").css("display", "none");
							break;
						case "Weekly":
							$("#ddEnds.select").css({"pointer-events" : "auto"});
							$("#ddEnds.select").fadeTo('slow',1);
							// Showing components for a weekly event
							$("#selectRepeatsEvery").css("display", "block");
							$("#repeatsEvery").attr("placeholder", "# of weeks");
							
							// Hiding all unnecessary components
							$("#week").css("display", "block");
							$("#selectOccursBy").css("display", "none");
							$("#selectDayoftheMonth").css("display", "none");
							$("#selectDayoftheWeek").css("display", "none");
							
							// Starting date
							var data = new Date(2013,6,19);
							// Day of the week of the starting date							
							var weekday=new Array();
							weekday[0]="Sunday";
							weekday[1]="Monday";
							weekday[2]="Tuesday";
							weekday[3]="Wednesday";
							weekday[4]="Thursday";
							weekday[5]="Friday";
							weekday[6]="Saturday";
							var dayOfTheWeek = weekday[data.getUTCDay()];
							// Unchecking all days of the week
							$('section form article div.content div.component#week .weekday').each(function() {
								$(this).attr("aria-checked", "false");
								$(this).toggleClass("selectedWeekday", false);
							});
							// Checking only the day of the week of the starting date
							$("section form article div.content div.component#week .weekday#"+dayOfTheWeek).attr("aria-checked", "true");
							$("section form article div.content div.component#week .weekday#"+dayOfTheWeek).toggleClass("selectedWeekday", true);
							
							break;
						case "Monthly":
							$("#ddEnds.select").css({"pointer-events" : "auto"});
							$("#ddEnds.select").fadeTo('slow',1);
							$("#selectRepeatsEvery").css("display", "block");
							$("#week").css("display", "none");
							$("#repeatsEvery").attr("placeholder", "# of months");
							$("#selectOccursBy").css("display", "block");
							$("#selectDayoftheMonth").css("display", "block");
							$("#selectDayoftheWeek").css("display", "none");
							break;
						case "No recurrence":
							$("#ddEnds.select").css({"pointer-events" : "none"});
							$("#ddEnds.select").fadeTo('slow',.5);
							$("#occurrencesNumber").css("display", "none");
							$("#occurrenceEnds").css("display", "none");
							$("#week").css("display", "none");
							$("#selectOccursBy").css("display", "none");
							$("#selectRepeatsEvery").css("display", "none");
							$("#selectDayoftheMonth").css("display", "none");
							$("#selectDayoftheWeek").css("display", "none");
							$("#ddEnds span").text($("#startsOn").val());
							break;
					}				
					
					switch ($(this).text()){
						case "Day of the month":
							$("#selectDayoftheWeek").css("display", "none");
							$("#selectDayoftheMonth").css("display", "block");
							break;
						case "Day of the month":
						case "Day of the first week":
						case "Day of the second week":
						case "Day of the third week":
						case "Day of the fourth week":
						case "Day of the last week":
							$("#selectDayoftheWeek").css("display", "block");
							$("#selectDayoftheMonth").css("display", "none");
							break;
					}
										
					switch ($(this).text()){
						case "Only once":
							$("#ddEnds span").text($("#startsOn").val());
							$("#occurrencesNumber").css("display", "none");
							$("#occurrenceEnds").css("display", "none");
							break;
						case "After # of occurrence(s)":
							$("#occurrencesNumber").css("display", "block");
							$("#occurrenceEnds").css("display", "none");
							break;
						case "On specified date":
							$("#occurrencesNumber").css("display", "none");
							$("#occurrenceEnds").css("display", "block");
							$("#endsOn").val($("#startsOn").val());
							break;
					}
				});
			},
			getValue : function() {
				return this.val;
			},
			getIndex : function() {
				return this.index;
			}
		}

		$(function() {

			var dd = new DropDown($('#dd'));
			var dd = new DropDown($('#dd1'));
			var dd = new DropDown($('#dd2'));
			var dd = new DropDown($('#ddEnds'));
			var dd = new DropDown($('#ddOccursBy'));
			
			$("#selectRepeatsEvery").css("display", "none");
			$("#selectDayoftheMonth").css("display", "none");
			$("#selectDayoftheWeek").css("display", "none");
			$("#occurrencesNumber").css("display", "none");
			$("#occurrenceEnds").css("display", "none");
			$("#week").css("display", "none");
			$("#selectOccursBy").css("display", "none");
			$("#ddEnds.select").css({"pointer-events" : "none"});
			$("#ddEnds.select").fadeTo('slow',.5);
			
			$(document).click(function() {
				// all dropdowns
				$('.select').removeClass('active');
			});

			$(dd).focusout(function() {
				// all dropdowns
				$(this).removeClass('active');
			});
		});
		
		/* ONLY NUMBERS */
		$('input[name="repeatsEvery"]').keydown(function(event) {
			// Allow only backspace (8), tab(9), end (35), home (36), arrows (37 and 39), and delete (46)
			if (event.keyCode == 8 || event.keyCode == 9 || event.keyCode == 35 || event.keyCode == 36 || event.keyCode == 37 || event.keyCode == 39 || event.keyCode == 46) {
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
        	$(this).next(".content").slideToggle(500);
			$(this).find("img").toggleClass("expandContent");	 
	    });
		
		/* Checkbox */
		$('.checkbox .box').keydown(function() {
			if (event.which == 13){
				event.preventDefault(event);
        		$(this).next(".checkmark").toggle();
				$(this).attr("aria-checked", ($(this).attr("aria-checked") === "true" ? "false" : "true"));
			}
	    });
		$('.checkbox .box').click(function() {
        	$(this).next(".checkmark").toggle();
			$(this).attr("aria-checked", ($(this).attr("aria-checked") === "true" ? "false" : "true"));
	    });
		$('.checkbox .checkmark').click(function() {
        	$(this).toggle();
	    });
		$.fn.pressEnterSpace = function(fn) {
			return this.each(function() {  
				$(this).bind('enterPress', fn);
				$(this).keyup(function (e) { 
					if(e.keyCode == 32) {
					  $(this).trigger("enterPress");
					  $(this).next(".checkmark").toggle();
					  $(this).attr("aria-checked", ($(this).attr("aria-checked") === "true" ? "false" : "true"));
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
		$("section form article div.content div.component#week .weekday").click(function() {
			$(this).attr("aria-checked", ($(this).attr("aria-checked") === "true" ? "false" : "true"));
			if ($(this).attr("aria-checked") == "true"){
				$(this).toggleClass("selectedWeekday");
			} else {
				$(this).toggleClass("selectedWeekday");
			}
        });
		
		
		/* Day of the Week checked for monthly events*/
		$("section form article div.content div.component#selectDayoftheWeek .weekday").click(function() {
			
			
			
			$("section form article div.content div.component#selectDayoftheWeek .weekday").removeClass("selectedWeekday");
			$("section form article div.content div.component#selectDayoftheWeek .weekday").attr("aria-checked", false);
			
			
			$(this).attr("aria-checked", ($(this).attr("aria-checked") === "true" ? "false" : "true"));
			
			
			if ($(this).attr("aria-checked") == "true"){
				$(this).toggleClass("selectedWeekday");
			} else {
				$(this).toggleClass("selectedWeekday");
			}
        });
		
		
		$("section form article div.content div.component#selectDayoftheMonth #dayoftheMonth").jStepper({minValue:1, maxValue:31, minLength:1});
		
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
			$(location).attr('href', "index.html");
		});
		
		$("aside nav #createEvent").click(function () {
			$(location).attr('href', "createEvent.html");
		});
		
		$("aside nav #manageUsers").click(function () {
			$(location).attr('href', "manageUsers.html");
		});
		
		$("aside nav #departments").click(function () {
			$(location).attr('href', "departments.html");
		});
		
		$("aside nav #departmentUsers").click(function () {
			$(location).attr('href', "departmentUsers.html");
		});	
		
		$("aside nav #subjects").click(function () {
			$(location).attr('href', "subjects.html");
		});	
		
		$("aside nav #classSettings").click(function () {
			$(location).attr('href', "classSettings.html");
		});	
		
		$("aside nav #systemSettings").click(function () {
			$(location).attr('href', "systemSettings.html");
		});
		
		/* MENU - CURRENT PAGE */
		var currentPage = $("section header h1").text().substr(0,1).toLowerCase() + $("section header h1").text().substr(1).replace(/ /g, '');
		
		$("aside nav #"+currentPage).css({"border-left":"0px solid #EEE"});
		$("aside nav #"+currentPage).css({"background-color":"#9F100B"});
		$("aside nav #"+currentPage).parent(this).css({"border-right":"10px solid #454545"});
		$("aside nav #"+currentPage).unbind('mouseout');
		$("aside nav #"+currentPage).unbind('mouseover');
		
		
		
		/*
     * Replace all SVG images with inline SVG
     */
      /*  $('img.svg').each(function(){
            var $img = $(this);
            var imgID = $img.attr('id');
            var imgClass = $img.attr('class');
            var imgURL = $img.attr('src');

            $.get(imgURL, function(data) {
                // Get the SVG tag, ignore the rest
                var $svg = $(data).find('svg');

                // Add replaced image's ID to the new SVG
                if(typeof imgID !== 'undefined') {
                    $svg = $svg.attr('id', imgID);
                }
                // Add replaced image's classes to the new SVG
                if(typeof imgClass !== 'undefined') {
                    $svg = $svg.attr('class', imgClass+' replaced-svg');
                }

                // Remove any invalid XML tags as per http://validator.w3.org
                $svg = $svg.removeAttr('xmlns:a');

                // Replace image with new SVG
                $img.replaceWith($svg);
				$svg.css({"position" : "absolute"},{"top" : "13px"}, {"right" : "10px"},{"z-index" : "5px"}) 
            });

        });*/
});