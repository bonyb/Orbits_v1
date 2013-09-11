/**
 * 
 */

/**
 * Set and get the cookies for the page/tree
 */

function setProjectCookie()
	{ 
		var windowy= $(window).scrollTop();
		var windowx= $(window).scrollLeft();
		var nodeArrayCache = document.getElementsByClassName("new_project");
		var projectPositionArray= new Array();
		for(var i=0;i<nodeArrayCache.length;i++){
			var offset =$(nodeArrayCache[i]).offset();
			var otop=offset.top+windowy;
			var oleft=offset.left+windowx;
			projectPositionArray[i]="left:" + oleft + "top:" + otop;
		    }
		var c_name="projectPos";
		document.cookie=c_name + "=" + projectPositionArray;
		
	}	
	
function getProjectCookie()
	{
	//create focus on load
	var nodeArrayCache = document.getElementsByClassName("new_project");
	var c_value = document.cookie;
	var c_start = c_value.indexOf(" "+"projectPos=");
	if (c_start == -1)
	{
	c_start = c_value.indexOf("projectPos" + "=");
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
	if(c_value!=null)
	{	var pos=c_value.split(",");
		for(var i=0;i<pos.length;i++){
			//var l=pos[i].indexOf("left:");
			var t=pos[i].indexOf("top:");
			var leftval=pos[i].slice(5,t);
			var topval=pos[i].slice(t+4,pos[i].length);
			$(nodeArrayCache[i]).offset({top:topval,left:leftval});
			
		}
	}
	
}