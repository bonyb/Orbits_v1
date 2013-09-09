/**
 * Set and get the cookies for the page/tree
 */
$(document).ready(function(){
	//posx=$(window).scrollTop();
	//posxn=$(document).scrollTop();
	//$("#node_field").scrollIntoView();
	 note = document.getElementsByClassName('check')[0];
	 screenPosition = note.getBoundingClientRect();
	 scrOfY = window.pageYOffset;
	 bodY=document.body.scrollTop;
	 scrOfX = window.pageXOffset;
	 //testy= $(window).scrollTop();
	 testy= $('#node_field').scrollTop();

	 $('#node_field').scroll(function(e){
		 	testy= $('#node_field').scrollTop();
			y=$(document).scrollTop();
			//$('.hello').text(testy);
		});
});

function setCookie()
	{ 	var unloady= $('#node_field').scrollTop();
		var windowy= $(window).scrollTop();
		var unloadx= $('#node_field').scrollLeft();
		var nodeArrayCache = document.getElementsByClassName("w");
		var nodePositionArray= new Array();
		for(var i=0;i<nodeArrayCache.length;i++){
			var offset =$(nodeArrayCache[i]).offset();
			var otop=offset.top+unloady+windowy-10;
			var oleft=offset.left+unloadx;
			nodePositionArray[i]="left:" + oleft + "top:" + otop;
		    }
		var c_name="nodePos";
		document.cookie=c_name + "=" + nodePositionArray;
		
	}	
	
	function getCookie(selectedNodeid)
	{
	//create focus on load
	var nodeArray = document.getElementsByClassName("w");
	for(var i=0;i<nodeArray.length;i++)
	{	
		if(selectedNodeid == nodeArray[i].id){
			var descId = "#des_"+nodeArray[i].id;
			var titleid="#title_" + nodeArray[i].id;
			var node="#"+nodeArray[i].id;
			$(titleid).css('background-color',$(node).css('background-color'));
			$(descId).show(); 
		}
	}	
	var nodeArrayCache = document.getElementsByClassName("w");
	var c_value = document.cookie;
	var c_start = c_value.indexOf(" "+"nodePos=");
	if (c_start == -1)
	{
	c_start = c_value.indexOf("nodePos" + "=");
	}
	if (c_start == -1)
	{
	c_value = null;
	}else{
	c_start = c_value.indexOf("=", c_start) + 1;
	var c_end = c_value.indexOf(";", c_start);
	if (c_end == -1)
	{c_end = c_value.length;}
	c_value = unescape(c_value.substring(c_start,c_end));
	}
	//$('.hello').text("c_value"+$(window).scrollTop());
	//setCookie(nodeArrayCache);
	//var nodePosition=getCookie(nodeArrayCache);
	if(c_value!=null)
	{	var pos=c_value.split(",");
		for(var i=0;i<pos.length;i++){
			//var l=pos[i].indexOf("left:");
			var t=pos[i].indexOf("top:");
			var leftval=pos[i].slice(5,t);
			var topval=pos[i].slice(t+4,pos[i].length);
			$(nodeArrayCache[i]).offset({top:topval,left:leftval});
			
		}
		for(var i=0;i<nodeArrayCache.length;i++)
		{
			var currentNode = nodeArrayCache[i].id;
			var parentNode = $(nodeArrayCache[i]).next().html();
			var cC="#"+currentNode;
			var nodeColor = $(cC).children(".node_color").html();
			
			var pC="#"+parentNode;
			var parentColor = $(pC).children(".node_color").html();
			
			
			if(i!=0)
			{
				jsPlumb.connect({source:parentNode, target:currentNode, anchor:"Center", 
					paintStyle:{
						gradient:{ stops:[ [ 0, nodeColor ], [ 1, parentColor ] ] },
						lineWidth:3,
						strokeStyle:'rgba(255, 255, 255, 1.0)'
					}});
			}				
		} 
	}else{
		var nodeArray = new Array();
		nodeArray = document.getElementsByClassName("w");
		for(var i=0;i<nodeArray.length;i++)
		{
			var currentNode = nodeArrayCache[i].id;
			var parentNode = $(nodeArrayCache[i]).next().html();
			var cC="#"+currentNode;
			var nodeColor = $(cC).children(".node_color").html();
			
			var pC="#"+parentNode;
			var parentColor = $(pC).children(".node_color").html();
						
			if(i!=0)
			{
				jsPlumb.connect({source:parentNode, target:currentNode, anchor:"Center", 
					paintStyle:{
						gradient:{ stops:[ [ 0, nodeColor ], [ 1, parentColor ] ] },
						lineWidth:3,
						strokeStyle:'rgba(255, 255, 255, 1.0)'
					}});	
			}				
		}
	}
	//$('#node_field').append("pos+"+pos.length+"nodec+"+nodeArrayCache.length);
}