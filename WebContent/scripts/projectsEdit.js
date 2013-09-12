/**
 * 
 */
$(document).ready(function(){
	$(".new_project_users").hide();
	$(".add_members").click(function(){
		if ($(".new_project_users").is(":hidden")) {
			$(".new_project_users").slideDown("slow");
			} else {
			$(".new_project_users").slideUp();
			}
	});
});