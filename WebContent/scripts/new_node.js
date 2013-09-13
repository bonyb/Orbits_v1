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
	newNodeForm = document.getElementsByClassName("new_node_form");
	editNodeBtnArray = document.getElementsByClassName("edit_node_btn");
	editNodeMenuArray = document.getElementsByClassName("edit_node_menu");
	nodeTagArray = document.getElementsByClassName("node_tag_input");
	newTagArray = document.getElementsByClassName("new_tag");
	
	// Hide Elements on Load //
	for(var i=0;i<newNodeForm.length;i++)
	{
		$(newNodeForm[i]).hide();
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
		var commentThread="#node_comments_"+nodeArray[i].id;
		if(!$.trim($(commentThread).html())){
			var discussionTh="#discussion_thread_"+nodeArray[i].id;
			$(discussionTh).hide();
		}
		
		$(nodeArray[i]).click(function(){  
    		var contentPanelId = jQuery(this).attr("id");
    		var idCheck = "#des_"+contentPanelId;
    		var titleid="#title_" + contentPanelId;
    		$(titleid).css('background-color',$(this).css('background-color'));
    		//to check if the node has been set or not. 
    		for(var x=0;x<nodeArray.length;x++)
    		{
    		var shownDiv="#des_"+nodeArray[x].id;	
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
    		if (luma > 200) {
    		    // pick a different colour
    			var author= "#title_bar_"+contentPanelId+" .author_name";
    			var time= "#title_bar_"+contentPanelId+" .creation_date";
    			$(titleid).css('color','#333333');
    			$(author).css('color','#333333');
    			$(time).css('color','#333333');
    		}
    		
    		$('#content_field').find('.editTitle').hide();
    		
    		
    	});
    }	
	var node_pop; 
	var moveLeft = -60; 
	var moveDown = -260; 
	var nodePositionArray = new Array();
	for(var i=0;i<nodeArray.length;i++) {	 
		var nodeID = jQuery(this).attr("id");  
		
		$(nodeArray[i]).position(nodePositionArray[nodeID]); 
		// Hover on Node \\ 
//		$(nodeArray[i]).hover(function(e){ 
//			var nodeID = jQuery(this).attr("id"); 
//			var idCheck = "#node_pop_up_"+nodeID; 
//			node_pop = "#node_pop_up_"+nodeID; 
//			$(node_pop).show(); }, 
//			function(){ $(node_pop).hide(); }); 
		$(nodeArray[i]).mousemove(function(e) { 
			$(node_pop).css('top', e.pageY + moveDown).css('left', e.pageX + moveLeft); 
			}); 
	}
	
	for(var i=0;i<newNodeBtnArray.length;i++)
	{		
    	// Click on Node \\
    	$(newNodeBtnArray[i]).click(function(){
    		$(this).slideUp();
    		//$(this).parent().css("display","none");
    		$(this).parent().hide();
    		$(this).parent().next().show();
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
	
	
	
});




                  