$(document).ready(function(){
	/* CHECKBOXES */
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
		
		if (($(this).attr("aria-checked") === "true")) {
			$(this).attr("aria-checked", "false");
			($(this).siblings().last())[0].checked = false;
		} else {
			$(this).attr("aria-checked", "true");
			($(this).siblings().last())[0].checked = true;
		}
	});
	
	$('.checkbox .checkmark').click(function() {
		$(this).toggle();
		
		if (($(this).siblings().first().attr("aria-checked") === "true")) {
			$(this).siblings().first().attr("aria-checked", "false");
			($(this).siblings().last())[0].checked = false;
		} else {
			$(this).siblings().first().attr("aria-checked", "true");
			($(this).siblings().last())[0].checked = true;
		}
	});
});