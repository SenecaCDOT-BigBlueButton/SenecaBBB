// JavaScript Document
$(document).ready(function() {
				
		/* Expand-Collapse content */
		$('article header').click(function() {
        	$(this).next(".content").slideToggle(500);
			$("article header img").toggleClass("expandContent");	 
	    });
		
		/* Checkbox */
		$('.checkbox .box').keydown(function() {
			if (event.which == 32){
				event.preventDefault();
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
		
		/* Table */
		$('#example').dataTable({"sPaginationType": "full_numbers"});
		$('#example').dataTable({"aoColumnDefs": [{ "bSortable": false, "aTargets":[5]}], "bRetrieve": true, "bDestroy": true});
		$.fn.dataTableExt.sErrMode = 'throw';
		 $('.dataTables_filter input').attr("placeholder", "Search");
		 
		/* Center icons */
/*		$('#page section article #example tbody tr td').has('img').css('text-align', 'center');*/
		 
		/*$('#page section article #example thead tr th:eq(2).sorting:after').css("visibility", "hidden");*/
		
		/*working*/
/*		$('#page section article #example thead tr th:eq(5) span').css("visibility", "hidden");
		$('#page section article #example thead tr th:eq(5).sorting').css("visibility", "hidden");*/
	
	
				
		/*$('#page section article #example tbody tr td:nth-child(4)').css('background','red');*/
/*		$("table.pretty thead th").click(function(){
			$("#page section article #example tbody tr td:nth-child(" + ($(this).index()+2) +")").css('background','red');
		});*/
		
		/*$('table.pretty thead th').click(function () {
			var index = parseInt($(this).index(), 10)+2;
			$('#page section article #example tbody tr td').css('border-left-color','#EEEEEE');
			$('#page section article #example tbody tr td').css('border-right-color','#EEEEEE');
			$('#page section article #example tbody tr td:nth-child(' + index  + ')').css('border-left-color','#454545');
			$('#page section article #example tbody tr td:nth-child(' + index  + ')').css('border-right-color','#454545');
			$('#page section article #example tbody tr td:nth-child(1)').css('border-left-color','#9F100B');
		});
		
		$('table.pretty thead th#darkCol').click(function () {
			var index = parseInt($(this).index(), 10)+1;
			$('#page section article #example tbody tr td:nth-child(1)').css('border-left-color','#9F100B');
			$('#page section article #example tbody tr td:nth-child(1)').css('border-right-color','#454545');
			$('#page section article #example tbody tr td:nth-child(' + index  + ')').css('border-left-color','#EEEEEE');
			$('#page section article #example tbody tr td:nth-child(' + index  + ')').css('border-right-color','#EEEEEE');
		});*/
		
		
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
			clear();
			$(this).css({"border-left":"0px solid #EEE"});
			$(this).css({"background-color":"#9F100B"});
			$(this).parent(this).css({"border-right":"10px solid #454545"});
			
			$(this).unbind('mouseout');
			$(this).unbind('mouseover');
		});
		
		$("aside nav #createEvent").click(function () {
			clear();
			$(this).css({"border-left":"0px solid #EEE"});
			$(this).css({"background-color":"#9F100B"});
			$(this).parent(this).css({"border-right":"10px solid #454545"});
			
			$(this).unbind('mouseout');
			$(this).unbind('mouseover');
		});
		
		$("aside nav #manageUsers").click(function () {
			clear();
			$(this).css({"border-left":"0px solid #EEE"});
			$(this).css({"background-color":"#9F100B"});
			$(this).parent(this).css({"border-right":"10px solid #454545"});
			
			$(this).unbind('mouseout');
			$(this).unbind('mouseover');
		});
		
		$("aside nav #departments").click(function () {
			clear();
			$(this).css({"border-left":"0px solid #EEE"});
			$(this).css({"background-color":"#9F100B"});
			$(this).parent(this).css({"border-right":"10px solid #454545"});
			
			$(this).unbind('mouseout');
			$(this).unbind('mouseover');
		});
		
		$("aside nav #departmentUsers").click(function () {
			clear();
			$(this).css({"border-left":"0px solid #EEE"});
			$(this).css({"background-color":"#9F100B"});
			$(this).parent(this).css({"border-right":"10px solid #454545"});
			
			$(this).unbind('mouseout');
			$(this).unbind('mouseover');
		});	
		
		$("aside nav #subjects").click(function () {
			clear();
			$(this).css({"border-left":"0px solid #EEE"});
			$(this).css({"background-color":"#9F100B"});
			$(this).parent(this).css({"border-right":"10px solid #454545"});
			
			$(this).unbind('mouseout');
			$(this).unbind('mouseover');
		});	
		
		$("aside nav #classSettings").click(function () {
			clear();
			$(this).css({"border-left":"0px solid #EEE"});
			$(this).css({"background-color":"#9F100B"});
			$(this).parent(this).css({"border-right":"10px solid #454545"});
			
			$(this).unbind('mouseout');
			$(this).unbind('mouseover');
		});	
		
		$("aside nav #systemSettings").click(function () {
			clear();
			$(this).css({"border-left":"0px solid #EEE"});
			$(this).css({"background-color":"#9F100B"});
			$(this).parent(this).css({"border-right":"10px solid #454545"});
			
			$(this).unbind('mouseout');
			$(this).unbind('mouseover');
		});
		
		/* DROPDOWN */
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
				});
			},
				getValue : function() {
					return this.val;
				},
				getIndex : function() {
					return this.index;
				}
		}

			var dd = new DropDown($('#dd1'));
			/*var dd = new DropDown( $('#dd2') );*/
			/*var dd = new DropDown( $('#dd3') );*/
			
			$(document).click(function() {
				$('section form article div.content div.component div.select').removeClass('active');
			});
					
			$("#page section form article div.content div.component div.select").click(function() {
				
				$(this).removeClass('active');
				$(this).css({"padding":"50px"});
			});
});