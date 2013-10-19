$(document).ready(function() {
	var nodeArray = new Array();
	var newNodeButtonArray = new Array();
	var nodeDesArray = new Array();
	var nodeTagArray = new Array();
	var newTagArray = new Array();

	nodeArray = document.getElementsByClassName("w");
	nodePopupArray = document.getElementsByClassName("node_pop_up");
	nodeInfoArray = document.getElementsByClassName("node_info");
	newNodeBtnArray = document.getElementsByClassName("new_btn");
	newNodeMapBtnArray = document.getElementsByClassName("addnodemap_btn");
	newNodeForm = document.getElementsByClassName("new_node_form");
	editNodeBtnArray = document.getElementsByClassName("edit_node_btn");
	editNodeMenuArray = document.getElementsByClassName("edit_node_menu");
	nodeTagArray = document.getElementsByClassName("node_tag_input");
	newTagArray = document.getElementsByClassName("new_tag");

	// Hide Elements on Load //
	$(".projectID").hide();
	for(var i=0;i<newNodeForm.length;i++)
	{
		$(newNodeForm[i]).draggable();

		$(newNodeForm[i]).hide();
	}

	for(var i=0;i<newNodeMapBtnArray.length;i++)
	{
		$(newNodeMapBtnArray[i]).hide();
	}

	for(var i=0;i<nodePopupArray.length;i++)
	{
		$(nodePopupArray[i]).hide();
	}

	for(var i=0;i<nodeInfoArray.length;i++)
	{
		$(nodeInfoArray[i]).hide();
	}

	for(var i=0;i<editNodeMenuArray.length;i++)
	{
		//$(editNodeMenuArray[i]).hide();
	}	
	// ---- //

	for(var i=0;i<nodeTagArray.length;i++)
	{
		$(nodeTagArray[i]).hide();
	}

	for(var i=0;i<nodeArray.length;i++)
	{	
		// display the user s vote
		var voteId="#vote_"+nodeArray[i].id;
		var vote=$.trim($(voteId).html());
		if(vote !="0"){
		var voteId="#up_btn_"+vote+"_"+nodeArray[i].id;
		$(voteId).attr('style','border: 3px solid #000000');
		}
		$(nodeArray[i]).find('.notification_flag').click(function() {
			window.location.reload(true);
		});

		$(nodeArray[i]).find('.notification_flag').hide();
		
		var commentThread="#node_comments_"+nodeArray[i].id;
		//if(!$.trim($(commentThread).html())){
			var discussionTh="#discussion_thread_"+nodeArray[i].id;
			$(discussionTh).hide();
		//}

		$(nodeArray[i]).click(function(){ 
    		var contentPanelId = jQuery(this).attr("id");
    		var idCheck = "#des_"+contentPanelId;
    		var titleid="#title_" + contentPanelId;
    		$(titleid).css('background-color',$(this).css('background-color'));
    		//to check if the node has been set or not. 
    		    		
    		for(var x=0;x<nodeArray.length;x++)
    		{
	    		var shownDiv="#des_"+nodeArray[x].id;

	    		//var sBtn=$(nodeArray[x]).find('.addnodemap_btn').attr("id");
	    		//var shownBtn="#"+sBtn;

	    		//$(shownBtn).hide();

	    		if($(shownDiv).is(":visible")){
	    			$(shownDiv).hide(); 
	    			$(idCheck).show();
	    			break;
	    		}
    		}
    	
    	var color=$(this).css('background-color');
    	var c = color.substring(4,color.length-1);      // strip #
    	//var rgb = parseInt(c, 16);   // convert rrggbb to decimal
    		var temp = new Array();
    		temp = c.split(',');
    		

    		var luma = 0.2126 * temp[0] + 0.7152 * temp[1] + 0.0722 * temp[2]; // per ITU-R BT.709
    		//alert("luma"+luma);
    		if (luma > 180) {
    		    // pick a different colour
    			var author= "#title_bar_"+contentPanelId+" .author_name";
    			var time= "#title_bar_"+contentPanelId+" .creation_date";
    			$(titleid).css('color','#333333');
    			$(author).css('color','#333333');
    			$(time).css('color','#333333');
    		}
    		
    		$('#content_field').find('.editTitle').hide();
    	});



		//var sBtn=$(nodeArray[x]).find('.addnodemap_btn').attr("id");
		//var shownBtn="#"+sBtn;
//    	var nNbID = jQuery(this).find('.addnodemap_btn').attr("id");
//    	var newNodeBtnId = "#"+nNbID;

		// Hover on Node \\ 
		var shownBtn;
		$(nodeArray[i]).hover(function(e){
			$(shownBtn).hide(); 
			var sBtn=jQuery(this).find('.addnodemap_btn').attr("id");
			shownBtn="#"+sBtn;
//			var nodeID = jQuery(this).attr("id"); 
//			var idCheck = "#node_pop_up_"+nodeID; 
//			node_pop = "#node_pop_up_"+nodeID; 
			$(shownBtn).show(); 
			//}, function(){ $(shownBtn).hide(); 
		}); 
		
		// for delete
		var deleteNode="#delete_"+nodeArray[i].id;
		$(deleteNode).click(function(e){ 
			// check if has children then do not let them delete
			
		var answer = confirm ('You will also delete the child nodes. Are you sure?');
		if (answer){
			// do nothing	
			return true;	
		}
		else{
			alert('you chose well');
			e.preventDefault();
			return false;
		} });

    }	
//	var node_pop; 
//	var moveLeft = -60; 
//	var moveDown = -260; 
//	var nodePositionArray = new Array();
//	for(var i=0;i<nodeArray.length;i++) {	 
//		var nodeID = jQuery(this).attr("id");  
//		
//		$(nodeArray[i]).position(nodePositionArray[nodeID]); 
//		// Hover on Node \\ 
////		$(nodeArray[i]).hover(function(e){ 
////			var nodeID = jQuery(this).attr("id"); 
////			var idCheck = "#node_pop_up_"+nodeID; 
////			node_pop = "#node_pop_up_"+nodeID; 
////			$(node_pop).show(); }, 
////			function(){ $(node_pop).hide(); }); 
//		$(nodeArray[i]).mousemove(function(e) { 
//			$(node_pop).css('top', e.pageY + moveDown).css('left', e.pageX + moveLeft); 
//			}); 
//	}

	for(var i=0;i<newNodeBtnArray.length;i++)
	{		
    	// Click on Node \\
    	$(newNodeBtnArray[i]).click(function(){
    		$(this).slideUp();
    		//$(this).parent().css("display","none");
    		$(this).parent().hide();
    		$(this).parent().next().show();
    		$(this).parent().next().find(".input_title" ).focus();
    	});
	}

	for(var i=0;i<editNodeBtnArray.length;i++)
	{		
    	// Click on Node \\
    	$(editNodeBtnArray[i]).click(function(){
    		//$(this).parent().parent().parent().children(".edit_node_menu").show();
    	});
	}

	for(var i=0;i<nodeTagArray.length;i++)
	{
		$(nodeTagArray[i]).click(function(){


		});
	}

	for(var i=0;i<newTagArray.length;i++)
	{
		var n=0;
		$(newTagArray[i]).click(function(){
			n++;
			var previousTag1 = $(this).prevAll(".node_tag1");
			var previousTag2 = $(this).prevAll(".node_tag2");
			var previousTag3 = $(this).prevAll(".node_tag3");

			if(n==1)
				previousTag1.show();
			if(n==2)
				previousTag2.show();
			if(n==3)
				previousTag3.show();	
		});
	}
	
	//to delete nodes
	function confirmation(message){
		var answer = confirm (message);
		if (answer){
			// do nothing	
			return true;	
		}
		else{
			alert('you chose well');
			return false;
		}

	}

	$("#demo").offset({left:$("#node_field").width/2-($("#demo").width/2),top:$("#node_field").height/2-($("#demo").height/2)});
	$("#node_field").offset({left:$(window).width/2-($("#node_field").width/2),top:$(window).height/2-($("#node_field").height/2)});

//	var gesturesX = 0;
//	var gesturesY = 0;
//	var startPositionX = 0;
//	var startPositionY = 0;
//	
//	var xVelocity = 0;
//	var yVelocity = 0;
//	
//	var isMouseDown = false;
//
//	$("#scroll_controller").mousemove( function (e) {
//		gesturesX = parseInt(e.pageX, 10);
//	    gesturesY = parseInt(e.pageY, 10);
//	    
//	    if (isMouseDown) {
//	    	$("#demo").offset({left:$("#demo").offset().left - ((startPositionX - gesturesX)/30),top:$("#demo").offset().top - ((startPositionY - gesturesY)/30)});//0, startPosition - gesturesY);
//	    }
//	    
//	    //if($("demo:in-viewport")){
//	    	
//	    //}
//	});
//	
//	$("#scroll_controller").mousestop( function (e) {
//		if(isMouseDown){
//			startPositionX = gesturesX;
//			startPositionY = gesturesY;
//		}
//	});
//
//	$("#scroll_controller").mousedown( function() {
//		startPositionX = gesturesX;
//	    startPositionY = gesturesY;
//	    isMouseDown = true;
//	});
//
//	$("#scroll_controller").mouseup( function() {
//	    isMouseDown = false;
//	    return false;
//	});

});

function addNode(key){

	// Click on Node \\
	var newNodeForm = "#new_node_form_"+key;
	$(newNodeForm).show();
	$(newNodeForm).find(".input_title" ).focus();	
}