<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Arrays"%>
<%@page import="javax.script.*"%>
<%@page import="java.util.Random"%>
<%@page import="java.awt.Color"%>
<%@page import="java.util.Enumeration"%>
<%@page import="sun.misc.Cache"%>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@  taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!doctype html>
<html>
<head>
<title>jsPlumb 1.3.16 - State Machine Demonstration - jQuery</title>
<link rel="stylesheet" href="styles/jsPlumbDemo.css">
<link rel="stylesheet" href="styles/stateMachineDemo.css">
<link rel="stylesheet" href="styles/style.css">
	<!-- DEP -->
<script type="text/javascript" src="js/lib/jquery-1.8.1-min.js"></script>
<script type="text/javascript" src="js/lib/jquery-ui-1.8.23-min.js"></script>
<script type="text/javascript"
		src="js/lib/jquery.ui.touch-punch.min.js"></script>
	<!-- /DEP -->

	<script type="text/javascript" src="scripts/new_node.js"></script>
</head>
<script type="text/javascript">
	
	
		  
	
	function setCookie()
	{ 
		var nodeArrayCache = document.getElementsByClassName("w");
		var nodePositionArray= new Array();
		for(var i=0;i<nodeArrayCache.length;i++){
			var offset =$(nodeArrayCache[i]).offset();
			nodePositionArray[i]="left:" + offset.left + "top:" + offset.top;
		    }
		var c_name="nodePos";
		document.cookie=c_name + "=" + nodePositionArray;
		  }	
	
	function getCookie()
	{
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
	//$('.hello').text("c_value"+c_value);
	//setCookie(nodeArrayCache);
	//var nodePosition=getCookie(nodeArrayCache);
	if(c_value!=null)
	{
		
	
		var pos=c_value.split(",");
		
	
		for(var i=0;i<pos.length;i++){
			//var l=pos[i].indexOf("left:");
			var t=pos[i].indexOf("top:");
			var leftval=pos[i].slice(5,t);
			var topval=pos[i].slice(t+4,pos[i].length);
			$(nodeArrayCache[i]).offset({top:topval,left:leftval});
			
		}
		for(var i=0;i<nodeArrayCache.length;i++)
		{
			var src = $(nodeArrayCache[i]).next().html();
			var target1 = nodeArrayCache[i].id;

			if(i!=0)
			{
				jsPlumb.connect({source:src, target:target1, anchor:"Center"});
			}				
		} 
	}else{
		var nodeArray = new Array();
		nodeArray = document.getElementsByClassName("w");
		for(var i=0;i<nodeArray.length;i++)
		{
			var src = $(nodeArray[i]).next().html();
			var target1 = nodeArray[i].id;

			if(i!=0)
			{
				jsPlumb.connect({source:src, target:target1, anchor:"Center"});
			}				
		}
	}
	//$('#node_field').append("pos+"+pos.length+"nodec+"+nodeArrayCache.length);
}
	
	
// Edit Title and Description
	
	function editNode(key){
	
	// title
	var titleLabel="#title_"+key;
	var titleVal=$(titleLabel).text();
	var formId="editForm_"+key;
	$(titleLabel).replaceWith('<input class="editTitle" type="text" name="title">');
	$('.editTitle').val(titleVal);
	$('.editTitle').attr("form",formId);
	
	// Description
	var descLabel="#node_description_"+key;
	var descVal=$(descLabel).text();
	$(descLabel).replaceWith('<textarea class="editDesc" rows="4" cols="50" maxlength="250" name="description"></textarea>');
	$('.editDesc').val(descVal);
	$('.editDesc').attr("form",formId);
	
	//show submit button
	var editFormSubmit="#editNodeDiv_"+key;
	$(editFormSubmit).show();
	}


</script>
<body data-library="jquery" onload="getCookie()" onunload="setCookie()">
	<%@include file="header.jsp"%>
	<% HashMap<String,Color> colorMap= new HashMap<String,Color>(); %>

	<div id="node_field" style="position: absolute">
		<div id="demo">

			<%
			
			String userID= session.getAttribute("userID").toString();
			//out.println("Hello - "+userID);
				int i = 0;
				int position;

				int x_position = 0;
				int y_position = 0;

				int x_padding = 6;
				int y_padding = 6;

				String att = "node" + i;
				Enumeration attr = request.getAttributeNames();
				//HashMap<String,Color> colorMap= new HashMap<String,Color>();
				float colorValue=0;
				/*do{System.out.println("Bloody fuck1-"+attr.nextElement());}while(attr.hasMoreElements());*/
 		while(attr.hasMoreElements())
 		{	//System.out.println("Bloody fuck1-"+attr.nextElement());

					int node_height = 1;
					
					
			if(attr.nextElement().toString().startsWith("node"))
			{
						Map<String, List> hashmap = new HashMap<String, List>();
						hashmap = (HashMap<String, List>) request.getAttribute(att);
						
						if (null != hashmap && !hashmap.isEmpty()) {
							int[] parray;

							parray = new int[25];
							int pcounter = 0;
							
							Iterator entries = hashmap.entrySet().iterator();
							while (entries.hasNext()) {

								Map.Entry entry = (Map.Entry) entries.next();
								String key = (String) entry.getKey();
								List value = (List) entry.getValue();
								//put it in an array
								pcounter++;
	     						parray[pcounter]= Integer.parseInt(value.get(2).toString());
								position = Integer.parseInt(key);
								pageContext.setAttribute("nodelistSize",
										value.size());
								
								Random randomGenerator = new Random();
								float value1 = (8 + 64 + 119)/3;
								float newValue = value1 + 2 * i;
								float valueRatio = newValue / value1;
								//Color newColor = new Color(8 * valueRatio,64 * valueRatio,119 * valueRatio);
								Color newColor = new Color(i*20,i*25,i*30);
								
								//color test
								Color parentColor=Color.darkGray;
								colorMap.put(key,parentColor);
								if(Integer.parseInt(value.get(3).toString()) == 2 ){
									colorValue+=0.2f;
									parentColor=new Color(Color.HSBtoRGB(colorValue,1,0.5f));
									colorMap.put(key,parentColor);
									//out.println("color-"+parentColor.getRed());
									//out.println("color br-"+parentColor.getRGB());
								}else if(Integer.parseInt(value.get(3).toString()) > 2 ){
									Color c=colorMap.get(value.get(2).toString());
									parentColor=c.brighter();
									colorMap.put(key,parentColor);
									//out.println("node"+value.get(0));
									
								}
								
								
			%>
			<!-- Old Node -->
			<% 
			double radius=2;
			double uv= Integer.parseInt(value.get(7).toString())+1;
			double dv= Integer.parseInt(value.get(8).toString())+1;
			double inc=((uv-dv)/dv)*0.6;
			
			radius=2+ inc;
			// to check if same author
					if(userID.equalsIgnoreCase(value.get(6).toString())){ %>
			<div class="w circle" id="<%=key%>"
				style="left:<%=((i*x_padding))+x_position%>em; top:<%=(node_height*y_padding)+y_position%>em;width: <%=radius%>em;height: <%=radius%>em;  background-color: rgb(<%=parentColor.getRed()%>, <%=parentColor.getGreen()%>, <%=parentColor.getBlue()%>);">
				
				<div class="node_map_title"><%=value.get(0)%></div>
				
				
				<div class="ep"></div>
			</div>
			<%	} else{
				%>
				<div class="w" id="<%=key%>"
				style="left:<%=((i*x_padding))+x_position%>em; top:<%=(node_height*y_padding)+y_position%>em;width: <%=radius%>em;height: <%=radius%>em; background-color: rgb(<%=parentColor.getRed()%>, <%=parentColor.getGreen()%>, <%=parentColor.getBlue()%>);">
				<div class="node_map_title"><%=value.get(0) %></div>
	
			

				<div class="ep"></div>
			</div>
			<%} %>
			
			<div class="parent" id="<%=value.get(2)%>"><%=value.get(2)%></div>


			<div class="node_pop_up" id="node_pop_up_<%=key%>">

				<div class="node_title_pu"><%=value.get(0)%></div>
				<div class="author_name_pu"><%=value.get(5).toString()%></div>
				<div class="expertise_pu">
					<!-- To display Expertise -->
					<c:if test="${nodelistSize > 9}">
						<%
								for (int tagno = 11; tagno <= value.size(); tagno++) {
														out.println(value.get(tagno - 1));
													}
							%>
					</c:if>
				</div>
				<div class="vote_count_pu">
					<img src="images/icons/like.png" /><%=key%>
					<div class="rating"></div>
				</div>
			</div>


			<%
				node_height++;
							}
						}
						i++;
						att = "node" + i;
					}
				}
			%>

		</div>
	</div>

		<div id="content_field">

		<%
			i = 0;

			att = "node" + i;
			attr = request.getAttributeNames();
			/*do{System.out.println("Bloody fuck1-"+attr.nextElement());}while(attr.hasMoreElements());*/
			while (attr.hasMoreElements()) { //System.out.println("Bloody fuck1-"+attr.nextElement());

				int node_height = 1;
				if (attr.nextElement().toString().startsWith("node")) {
					Map<String, List> hashmap = new HashMap<String, List>();
					hashmap = (HashMap<String, List>) request.getAttribute(att);
					if (null != hashmap && !hashmap.isEmpty()) {
						int[] parray;

						parray = new int[25];
						int pcounter = 0;
						Iterator entries = hashmap.entrySet().iterator();
						while (entries.hasNext()) {

							Map.Entry entry = (Map.Entry) entries.next();
							String key = (String) entry.getKey();
							List value = (List) entry.getValue();
							//put it in an array
							pcounter++;
							parray[pcounter] = Integer.parseInt(value.get(2)
									.toString());
							position = Integer.parseInt(key);
							pageContext.setAttribute("nodelistSize",
									value.size());
		%>
		<!-- Old Node -->
		<div class="node_info" id="des_<%=key%>">

			<%
				if (parray[pcounter] != parray[pcounter - 1]) {
									//System.out.println("a line is here");
								}
								pageContext.setAttribute("nodeno", key);
			%>

			<div>
				<c:set var="nodename" value="nodeno_${nodeno}"></c:set>
				<c:set var="imgnodename" value="imgno_${nodeno}"></c:set>
				<div class="node" id="container_<%=i%>">
				<!-- Display title -->
					<div class="node_title display_title" id="title_<%=key %>"><%=value.get(0)%></div>
					
					<img class="mark_icon" id="mark_icon_<%=key%>" src="images/icons/mark_icon.png" />
						
						<img class="comment_icon" id="comment_icon_<%=key%>" src="images/icons/comment_icon.png" />
						
						
						
						<div class="voting_form">
						<form  action="DownvoteServlet" method="post">
							<input type="hidden" value='${nodeno}' name="nodeID" /> 
							<!-- input class="downVote_btn" type="submit" id="down_btn_<%=key%>" value=""> -->
							<input type="image" src="images/icons/disagree_icon.png" alt="Submit" id="down_btn_<%=key%>" align="right"width="48" height="20">
							<!-- img class="edit_btn" id="down_btn_<%=key%>" src="images/icons/down_chosen.png" /-->
						<%=value.get(8) %></form>
						</div>
						
						<div class="voting_form">
						<form action="UpvoteServlet" method="post">
							<input type="hidden" value='${nodeno}' name="nodeID" /> 
							<!-- input class="upVote_btn" type="submit" id="up_btn_<%=key%>" value=""> -->
							<input type="image" src="images/icons/agree_icon.png" alt="Submit" id="up_btn_<%=key%>" align="right"width="48" height="20">
							<!-- img class="delete_btn" id="up_btn_<%=key%>" src="images/icons/up_chosen.png" /-->
						<%=value.get(7) %></form> 
						</div>
						
						
					
					<div class="author_name">by: <%=value.get(5)%> on <%=value.get(9) %></div>
					
				
					<div class="expertise">
						
						<!-- To display Expertise -->
						<c:if test="${nodelistSize > 9}">
						
							<%
								for (int tagno = 11; tagno <= value.size(); tagno++) {%><div class="node_tag"><%
									
														out.println(value.get(tagno - 1));
								
								%></div><%
													}
							%>
							
						</c:if>
					
					</div>
						<!-- Display Description -->
					<div class="node_description" id="node_description_<%=key%>"><%=value.get(1)%></div>
					
					<div class="content_icons">
					

					 <img style="cursor:pointer;" class="text_icon" id="text_icon_<%=key%>" src="images/icons/text_icon.png" onclick="editNode(<%=key%>);"/>  
						
						<!-- To edit! -->
						<div class="editNode" id="editNodeDiv_<%=key%>" style="display:none">
						<form action="EditServlet" method="post" id="editForm_<%=key%>">
							<input type="hidden" value='${nodeno}' name="nodeID" /> 
							<input type="image" src="images/sub_btn.png" alt="Submit" align="left" width="48" height="39">
						</form> 
						</div>
						<img class="camera_icon" id="camera_icon_<%=key%>" src="images/icons/camera_icon.png" />
						<img class="graphic_icon" id="graphic_icon_<%=key%>" src="images/icons/graphic_icon.png" />
						<img class="link_icon" id="link_icon_<%=key%>" src="images/icons/link_icon.png" />
						<img class="audio_icon" id="audio_icon_<%=key%>" src="images/icons/audio_icon.png" />
					</div>
				</div>
			</div>

						<div class="add_icon" style="cursor:pointer;">
							<img class="new_btn" id="new_btn_<%=key%>" src="images/plus_btn.png" />
						</div>

			<div class="new_node_form" id="new_node_form_<%=key%>"><div class="add_node_title">Add a Child Node</div>
				<form action="MyServlet" method="POST">
						<input class="input-block-level input_title" type="text" name="title" placeholder="Title"><br>
						
						<div class="tagSection">
						
							<img class="tags_icon" id="tag_icon_<%=key%>" src="images/icons/tag_icon.png" />
						
	    					<input class="node_tag_input node_tag1" type="text" name="tag1">
	    					<input class="node_tag_input node_tag2" type="text" name="tag2">
	    					<input class="node_tag_input node_tag3" type="text" name="tag3">
	    				<a href="#" class="new_tag"><img class="new_tag_img" id="new_tag_<%=key%>" src="images/icons/plusTag_icon.png" /></a></div><br>
						<textarea class="node_description_input" rows="4" cols="50" maxlength="250" name="description"></textarea> 
						<input type="hidden" value='${nodeno}' name="parentId" /> <br>
								
						<input type="image" src="images/sub_btn.png" alt="Submit" align="left" width="48" height="39">
						<a href="#" id="cancel_<%=key%>"><img src="images/cncl_btn.png" alt="Read book" /></a>
					<!-- <div>cancel button onclick='$(this).parent().parent().hide();'</div> -->
				</form>
			</div>			
			
		<div class="discussion_thread" id="discussion_thread_<%=key%>">
<%-- 			<img class="placeholder" id="placeholder_<%=key%>" src="images/placeholderdiscussion.png" /> --%>
		</div>
		

			
		
		</div>

		<%
			}
					}
					i++;
					att = "node" + i;
				}
			}
		%>



	</div>
	
	<img class="placeholder_thread" src="images/placeholderdiscussion.png" />




	<!-- JS -->
	<!-- support lib for bezier stuff -->
	<script type="text/javascript" src="js/lib/jsBezier-0.4-min.js"></script>
	<!-- jsplumb util -->
	<script type="text/javascript"
		src="js/1.3.16/jsPlumb-util-1.3.16-RC1.js"></script>
	<!-- base DOM adapter -->
	<script type="text/javascript"
		src="js/1.3.16/jsPlumb-dom-adapter-1.3.16-RC1.js"></script>
	<!-- main jsplumb engine -->
	<script type="text/javascript" src="js/1.3.16/jsPlumb-1.3.16-RC1.js"></script>
	<!-- connectors, endpoint and overlays  -->
	<script type="text/javascript"
		src="js/1.3.16/jsPlumb-defaults-1.3.16-RC1.js"></script>
	<!-- state machine connectors -->
	<script type="text/javascript"
		src="js/1.3.16/jsPlumb-connectors-statemachine-1.3.16-RC1.js"></script>
	<!-- SVG renderer -->
	<script type="text/javascript"
		src="js/1.3.16/jsPlumb-renderers-svg-1.3.16-RC1.js"></script>
	<!-- canvas renderer -->
	<script type="text/javascript"
		src="js/1.3.16/jsPlumb-renderers-canvas-1.3.16-RC1.js"></script>
	<!-- vml renderer -->
	<script type="text/javascript"
		src="js/1.3.16/jsPlumb-renderers-vml-1.3.16-RC1.js"></script>
	<!-- jquery jsPlumb adapter -->
	<script type="text/javascript"
		src="js/1.3.16/jquery.jsPlumb-1.3.16-RC1.js"></script>
	<!-- /JS -->

	<!--  demo code -->

	<script type="text/javascript" src="demo/js/demo-list.js"></script>
	<script type="text/javascript" src="demo/js/demo-helper-jquery.js"></script>

	<script type="text/javascript" src="demo/js/stateMachineDemo.js"></script>
	<script type="text/javascript" src="demo/js/stateMachineDemo-jquery.js"></script>


</body>
</html>
