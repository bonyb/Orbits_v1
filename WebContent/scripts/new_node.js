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
	
	var node_des;
	for(var i=0;i<nodeArray.length;i++)
	{		
    	// Click on Node \\
		/*	if($(nodeArray[i]).hasClass('circle')){
		alert("nodeArray[i]-"+nodeArray[i]);
		}*/
		
		var nodeid="#"+jQuery(this).attr("id");
		var node=nodeArray[i];
		$(nodeArray[i]).click(function(){  
    		var contentPanelId = jQuery(this).attr("id");
    		var idCheck = "#des_"+contentPanelId;
    		
    		// make the title same color
    		
    		//alert("colorcheck2+"+$(this).css('background-color'));
    		var titleid="#title_" + contentPanelId;
    		$(titleid).css('color',$(this).css('background-color'));
    		
    		if(idCheck != node_des)
    		{
	    		$(node_des).slideUp(); 
	    		node_des = "#des_"+contentPanelId;
	    		$(node_des).slideDown();    	
    		}
    	});
    	//alert("colorArray+"+colorArray[i]);
	}	
	var node_pop; 
	var moveLeft = -60; 
	var moveDown = -260; 
	var nodePositionArray = new Array();
	for(var i=0;i<nodeArray.length;i++) {	 
		var nodeID = jQuery(this).attr("id"); // Set the position of the node from the cache 
		 // Retreive nodePositionArray from cache 
		$(nodeArray[i]).position(nodePositionArray[nodeID]); 
		// Hover on Node \\ 
		$(nodeArray[i]).hover(function(e){ 
			var nodeID = jQuery(this).attr("id"); 
			var idCheck = "#node_pop_up_"+nodeID; 
			node_pop = "#node_pop_up_"+nodeID; 
			$(node_pop).show(); }, 
			function(){ $(node_pop).hide(); }); 
		$(nodeArray[i]).mousemove(function(e) { 
			$(node_pop).css('top', e.pageY + moveDown).css('left', e.pageX + moveLeft); 
			}); 
	}
	
	for(var i=0;i<newNodeBtnArray.length;i++)
	{		
    	// Click on Node \\
    	$(newNodeBtnArray[i]).click(function(){
    		$(this).slideUp();
    		$(this).parent().css("display","none");
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




                  