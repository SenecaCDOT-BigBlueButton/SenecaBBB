//side menu controller
$(document).ready(function(){   
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
	
	    /* CALENDAR - MOUSEOVER */
	    $("aside nav #calendar").mouseover(
	        function () {
	            $(this).css({"background-color":"#9F100B"});
	            $(this).css({"border-left":"95px solid #EEE"});
	            $(this).parent(this).css({"border-right":"10px solid #9F100B"});
	        }
	    );
	    
	    /* EVENTS - MOUSEOVER */
	    $("aside nav #events").mouseover(
	        function () {
	            $(this).css({"background-color":"#9F100B"});
	            $(this).css({"border-left":"120px solid #EEE"});
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
	    
	    /* SETTINGS - MOUSEOVER */
	    
	    $("aside nav #settings").mouseover(
	        function () {
	            $(this).css({"background-color":"#9F100B"});
	            $(this).css({"border-left":"108px solid #EEE"});
	            $(this).parent(this).css({"border-right":"10px solid #9F100B"});
	        }
	    );
	    
	    /* INVITE GUEST - MOUSEOVER */
	    $("aside nav #inviteGuest").mouseover(
	        function () {
	            $(this).css({"background-color":"#9F100B"});
	            $(this).css({"border-left":"47px solid #EEE"});
	            $(this).parent(this).css({"border-right":"10px solid #9F100B"});
	        }	    		
	    );
	    
	    /* Quick Meeting - MOUSEOVER */
	    $("aside nav #QuickMeeting").mouseover(
	        function () {
	            $(this).css({"background-color":"#9F100B"});
	            $(this).css({"border-left":"47px solid #EEE"});
	            $(this).parent(this).css({"border-right":"10px solid #9F100B"});
	        }
	    );
	}
	
	clear();
	
	/* MENU - CLICK EVENT */
	$("aside nav #calendar").click(function () {
	    $(location).attr('href', "calendar.jsp");
	});
	
	$("aside nav #events").click(function () {
	    $(location).attr('href', "view_events.jsp");
	});
	
	$("aside nav #createEvent").click(function () {
	    $(location).attr('href', "create_event.jsp");
	});
	
	$("aside nav #manageUsers").click(function () {
	    $(location).attr('href', "manage_users.jsp");
	});
	
	$("aside nav #departments").click(function () {
	    $(location).attr('href', "departments.jsp");
	});
	
	$("aside nav #departmentUsers").click(function () {
	    $(location).attr('href', "department_users.jsp");
	}); 
	
	$("aside nav #subjects").click(function () {
	    $(location).attr('href', "subjects.jsp");
	}); 
	
	$("aside nav #classSettings").click(function () {
	    $(location).attr('href', "class_settings.jsp");
	}); 
	
	$("aside nav #systemSettings").click(function () {
	    $(location).attr('href', "system_settings.jsp");
	});
	
	$("aside nav #settings").click(function () {
	    $(location).attr('href', "settings.jsp");
	});
	
	$("aside nav #inviteGuest").click(function () {
	    $(location).attr('href', "invite_guest.jsp");
	});
	
	$("aside nav #QuickMeeting").click(function () {
	    $(location).attr('href', "quickMeeting.jsp");
	});
	
	/* MENU - CURRENT PAGE */
	var currentPage = $("section header h1").text().substr(0,1).toLowerCase() + $("section header h1").text().substr(1).replace(/ /g, '');
	$("aside nav #"+currentPage).css({"border-left":"0px solid #EEE"});
	$("aside nav #"+currentPage).css({"background-color":"#9F100B"});
	$("aside nav #"+currentPage).parent(this).css({"border-right":"10px solid #454545"});
	$("aside nav #"+currentPage).unbind('mouseout');
	$("aside nav #"+currentPage).unbind('mouseover');
	

	/* Expand-Collapse content */
	$('article header').click(function() {
		$(this).next(".content").slideToggle(500);
		$(this).find("img").toggleClass("expandContent");
	});

});

