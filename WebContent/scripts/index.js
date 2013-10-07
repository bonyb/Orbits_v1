/**
 * for the registration
 */
	$(document).ready(function(){
	$('#registrationForm').submit(function (e) {
		var error=false;
		var fnvalue=$.trim($('#firstName').val());
		var lnvalue=$.trim($('#lastName').val());
		var emailvalue=$.trim($('#email').val());
		var usernamevalue=$.trim($('#username').val());
		var passvalue=$.trim($('#password').val());
		var confpassvalue=$.trim($('#confrimPassword').val());
		if(fnvalue.length==0){
			//check for empty
			$("input#firstName:text").css('border','5px solid red');
			error=true;
		}else{
			$("input#firstName:text").css('border','');
		}
		if(lnvalue.length==0){
			//check for empty
			$("input#lastName:text").css('border','5px solid red');
			error=true;
		}else{
			$("input#lastName:text").css('border','');
		}
		if(usernamevalue.length==0){
			//check for empty
			$("input#username:text").css('border','5px solid red');
			error=true;
		}else{
			$("input#username:text").css('border','');
		}
		if(emailvalue.length==0){
			//check for empty and pattern
			$("input#email:text").css('border','5px solid red');
			error=true;
		}else if(! emailvalue.test(/^\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/)){
			$("input#email:text").css('border','5px solid blue');
			console.log("inside email");
			error=true;
		}else{
			$("input#email:text").css('border','');
		}
		if(passvalue.length==0){
			//check for empty
			$("input#password:password").css('border','5px solid red');
			error=true;
		}else{
			$("input#password:password").css('border','');
		}
		if(confpassvalue.length==0){
			//check for empty n match
			$("input#confirmPassword:password").css('border','5px solid red');
			error=true;
		}else{
			$("input#confirmPassword:password").css('border','');
		}
		if(error){
			//e.preventDefault();
			e = window.event;
		    e.cancelBubble = true;
			console.log("noerror-"+noerror);
		}
	});
	});
	
	function greeting(){
		
	}
	
//	$(document).ready(function(){
//		$("input.reg:text").on('blur',
//				function(){
//			var val=$(this).val();
//			if(val.length==0){
//				setTimeout(function(){
//					alert("hh");
//					$(this).val('blah');
//					$(this).focus();},0);
//				//$(this).focus();
//			}
//		});
//	});
