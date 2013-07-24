// JavaScript Document
$(document).ready(function() {
	
		$("aside nav #home").mouseover(
			function () {
				$(this).css({"background-color":"#9F100B"});
				$(this).css({"border-left":"123px solid #EEE"});
				$(this).parent(this).css({"border-right":"10px solid #9F100B"});
		});
		
		$("aside nav #home").mouseout(  
			function () {
				$(this).css({"background-color":"#CD352B"});
				$(this).css({"border-left":"0px solid #EEE"});
				$(this).parent(this).css({"border-right":"10px solid #EEEEEE"}); //CD352B
			}
		);
	 
		/*$("aside nav li").click(function () {
			$(this).css({"border-left":"0px solid #EEE"});
			$(this).parent(this).css({"border-right":"10px solid #454545"});
			$(this).attr('disabled', 'disabled');
			$(this).unbind('click');
			$(this).unbind('mouseover');
		});*/
	 
		$("aside nav #home").click(function () {
			$(this).css({"border-left":"0px solid #EEE"});
			$(this).parent(this).css({"border-right":"10px solid #454545"});
			$(this).unbind('mouseout');
			$(this).unbind('mouseover');
			
			
			b_id = $(this).attr('id');
			
			
			$("aside nav .menu").each(function() {
				button_id = $(this).attr('id');
				if(button_id != b_id) {
					//$('aside nav #'+button_id).bind('mouseover', mouseOver());
					//$('aside nav #'+button_id).bind('mouseout', mouseOut());
					
					$("aside nav #"+button_id).mouseover(
					function () {
						$(this).css({"background-color":"#9F100B"});
						$(this).css({"border-left":"123px solid #EEE"});
						$(this).parent(this).css({"border-right":"10px solid #9F100B"});
					});
					
					$("aside nav #"+button_id).mouseout(  
					function () {
						$(this).css({"background-color":"#CD352B"});
						$(this).css({"border-left":"0px solid #EEE"});
						$(this).parent(this).css({"border-right":"10px solid #EEEEEE"}); //CD352B
					}
					);				
				}
			}); 
		});


		function mouseOver (){
           		$(this).css({"background-color":"#9F100B"});
		   		$(this).css({"border-left":"68px solid #EEE"});
  		   		$(this).parent(this).css({"border-right":"10px solid #9F100B"});
		}
		
		function mouseOut () {
           $(this).css({"background-color":"#CD352B"});
		   $(this).css({"border-left":"0px solid #EEE"});
   		   $(this).parent(this).css({"border-right":"10px solid #EEEEEE"}); //CD352B
        }
		
		$("aside nav #createEvent").mouseover(mouseOver);
		 
		$("aside nav #createEvent").mouseout(mouseOut);
		
		$("aside nav li").click(function () {
			$(this).css({"border-left":"0px solid #EEE"});
			$(this).parent(this).css({"border-right":"10px solid #454545"});
			$(this).unbind('mouseout');
			$(this).unbind('mouseover');
			
			
			b_id = $(this).attr('id');
			
			$("aside nav li").each(function() {
				button_id = $(this).attr('id');
				
				//$(this).text('#'+button_id+'/'+b_id);
				
				if(button_id != b_id) {
					//$('aside nav #'+button_id).bind('mouseover', mouseOver());
					//$('aside nav #'+button_id).bind('mouseout', mouseOut());
					
					$("aside nav #"+button_id).mouseover(
					function () {
						$(this).css({"background-color":"#9F100B"});
						$(this).css({"border-left":"123px solid #EEE"});
						$(this).parent(this).css({"border-right":"10px solid #9F100B"});
					});
					
					$("aside nav #"+button_id).mouseout(  
					function () {
						$(this).css({"background-color":"#CD352B"});
						$(this).css({"border-left":"0px solid #EEE"});
						$(this).parent(this).css({"border-right":"10px solid #EEEEEE"}); //CD352B
					}
					);				
				}
			}); 
		});



	 
	 
/*	 $("aside nav #createEvent").hover(
         function () {
           $(this).css({"background-color":"#9F100B"});
		   $(this).css({"border-left":"68px solid #EEE"});
  		   $(this).parent(this).css({"border-right":"10px solid #9F100B"});
         }, 
         function () {
           $(this).css({"background-color":"#CD352B"});
		   $(this).css({"border-left":"0px solid #EEE"});
   		   $(this).parent(this).css({"border-right":"10px solid #EEEEEE"}); //CD352B
         }
     );
	 
	  $("aside nav #manageUsers").hover(
         function () {
           $(this).css({"background-color":"#9F100B"});
		   $(this).css({"border-left":"56px solid #EEE"});
  		   $(this).parent(this).css({"border-right":"10px solid #9F100B"});
         }, 
         function () {
           $(this).css({"background-color":"#CD352B"});
		   $(this).css({"border-left":"0px solid #EEE"});
   		   $(this).parent(this).css({"border-right":"10px solid #EEEEEE"}); //CD352B
         }
     );
	 
	 $("aside nav #departments").hover(
         function () {
           $(this).css({"background-color":"#9F100B"});
		   $(this).css({"border-left":"68px solid #EEE"});
  		   $(this).parent(this).css({"border-right":"10px solid #9F100B"});
         }, 
         function () {
           $(this).css({"background-color":"#CD352B"});
		   $(this).css({"border-left":"0px solid #EEE"});
   		   $(this).parent(this).css({"border-right":"10px solid #EEEEEE"}); //CD352B
         }
     );

	 $("aside nav #departmentUsers").hover(
         function () {
           $(this).css({"background-color":"#9F100B"});
		   $(this).css({"border-left":"30px solid #EEE"});
  		   $(this).parent(this).css({"border-right":"10px solid #9F100B"});
         }, 
         function () {
           $(this).css({"background-color":"#CD352B"});
		   $(this).css({"border-left":"0px solid #EEE"});
   		   $(this).parent(this).css({"border-right":"10px solid #EEEEEE"}); //CD352B
         }
     );
	 
	 $("aside nav #subjects").hover(
         function () {
           $(this).css({"background-color":"#9F100B"});
		   $(this).css({"border-left":"102px solid #EEE"});
  		   $(this).parent(this).css({"border-right":"10px solid #9F100B"});
         }, 
         function () {
           $(this).css({"background-color":"#CD352B"});
		   $(this).css({"border-left":"0px solid #EEE"});
   		   $(this).parent(this).css({"border-right":"10px solid #EEEEEE"}); //CD352B
         }
     );
	 
	 $("aside nav #classSettings").hover(
         function () {
           $(this).css({"background-color":"#9F100B"});
		   $(this).css({"border-left":"61px solid #EEE"});
  		   $(this).parent(this).css({"border-right":"10px solid #9F100B"});
         }, 
         function () {
           $(this).css({"background-color":"#CD352B"});
		   $(this).css({"border-left":"0px solid #EEE"});
   		   $(this).parent(this).css({"border-right":"10px solid #EEEEEE"}); //CD352B
         }
     );
	 
	 $("aside nav #systemSettings").hover(
         function () {
           $(this).css({"background-color":"#9F100B"});
		   $(this).css({"border-left":"47px solid #EEE"});
  		   $(this).parent(this).css({"border-right":"10px solid #9F100B"});
         }, 
         function () {
           $(this).css({"background-color":"#CD352B"});
		   $(this).css({"border-left":"0px solid #EEE"});
   		   $(this).parent(this).css({"border-right":"10px solid #EEEEEE"}); //CD352B
         }
     );
*/	 
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

			$(function() {

				var dd = new DropDown( $('#dd') );

				$(document).click(function() {
					// all dropdowns
					$('.wrapper-dropdown-1').removeClass('active');
				});

			});
   });