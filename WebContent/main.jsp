<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.ArrayList"%>
<%@page import="javax.script.*"%>
<%@page import="java.util.Random"%>
<%@page import="java.lang.Math"%>
<%@page import="java.text.*"%>


<%@page import="java.awt.Color"%>
<%@page import="java.util.Enumeration"%>
<%@page import="org.apache.cxf.jaxrs.impl.MetadataMap"%>
<%@page import="javax.ws.rs.core.MultivaluedMap"%>
<%@page import="sun.misc.Cache"%>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@  taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!doctype html>
<html>
<head>
<title>Orbits - Project Page</title>
<link rel="stylesheet" href="styles/jsPlumbDemo.css">
<link rel="stylesheet" href="styles/stateMachineDemo.css">
<link rel="stylesheet" href="styles/style.css">
<link href='http://fonts.googleapis.com/css?family=Open+Sans:400,700' rel='stylesheet' type='text/css'>

<style type="text/css">
input#chat {
	width: 410px
}

#console-container {
	width: 400px;
}

#console {
	border: 1px solid #CCCCCC;
	border-right-color: #999999;
	border-bottom-color: #999999;
	height: 170px;
	overflow-y: scroll;
	padding: 5px;
	width: 100%;
}

#console p {
	padding: 0;
	margin: 0;
}
</style>
<!-- Libs -->
<script type="text/javascript" src="js/lib/jquery-1.8.1-min.js"></script>
<script type="text/javascript" src="js/lib/jquery-ui-1.8.23-min.js"></script>
<script type="text/javascript" src="js/lib/jquery.ui.touch-punch.min.js"></script>
<script type="text/javascript" src="js/tinymce/tinymce.min.js"></script>
<script type="text/javascript" src="js/tinymce/jquery.tinymce.min.js"></script>
<!-- <script type="text/javascript" src="//tinymce.cachefly.net/4.0/tinymce.min.js"></script> -->
<script type="text/javascript" src="js/jquery.knob.js"></script>

<!-- Plug ins -->
<script type="text/javascript" src="scripts/jquery-mousewheel.js"></script>
<script type="text/javascript" src="scripts/jquery-viewport.js"></script>
<script type="text/javascript" src="scripts/jquery-transit-min.js"></script>

<!-- Files -->
<script type="text/javascript" src="scripts/updateHandler.js"></script>
<script type="text/javascript" src="scripts/cookieManagement.js"></script>
<script type="text/javascript" src="scripts/editNode.js"></script>
<script type="text/javascript" src="scripts/new_node.js"></script>

<script type="text/javascript">

	tinymce.init({
    	selector: "textarea.node_description",
    	toolbar: "insertfile undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image | forecolor backcolor emoticons"
	});
	
	$(function() {
	    $(".vote_dial").knob({
	    });
	});

	$(document).ready(function(){
	var Chat = {};
	var dURL = document.URL;
	var pid = dURL.indexOf("projectId=");
	var ampIndex = dURL.indexOf("&");
	if(ampIndex>0){
		pid = dURL.slice(pid+10,ampIndex);
	}
	else{
		pid = dURL.slice(pid+10,dURL.length);
	}
	//alert("pid"+pid);
    Chat.socket = null;

    Chat.connect = (function(host) {
    if ('WebSocket' in window) {
    	Chat.socket = new WebSocket(host);
        } else if ('MozWebSocket' in window) {
        	Chat.socket = new MozWebSocket(host);
        } else {
        	Console.log('Error: WebSocket is not supported by this browser.');
            return;
        }

        Chat.socket.onopen = function () {
			Console.log('Info: WebSocket connection opened.');
			var dURL = document.URL;
			var nodeFrom = dURL.indexOf("&selectedNodeId=");
			if(ampIndex>0){
				var nodeIam = dURL.slice(nodeFrom+16,dURL.length);
	       		Chat.socket.send(nodeIam);
	//          document.getElementById('chat').onkeydown = function(event) {
	//          	if (event.keyCode == 13) {
	//              	Chat.sendMessage();
	//              }
	//          };
	        }
		};
            
		Chat.socket.onclose = function () {
        document.getElementById('chat').onkeydown = null;
        Console.log('Info: WebSocket closed.');
                
            //$('.notification_flag').click(function(){});

		};
            
        Chat.socket.onmessage = function (message) {
        	var displayMessage=message.data;
            if(displayMessage.indexOf(pid)>0){
            	Console.log(message.data);
                updateHandler(displayMessage);
            }
        };
	});
       
	Chat.initialize = function() {
		if (window.location.protocol == 'http:') {
			// Chat.connect('ws://' + window.location.host + '/Orbits_v1/websocket/chat');
			Chat.connect('ws://' + window.location.host + '/Orbits_v1/updatedata?pid='+pid);
        } 
		else {
        	Chat.connect('wss://' + window.location.host + '/Orbits_v1/updatedata?pid='+pid);
        }
	};

    Chat.sendMessage = (function() {
		var message = document.getElementById('chat').value;
		if (message != '') {
			Chat.socket.send(message);
			document.getElementById('chat').value = '';
		}
	});

	var Console = {};

	Console.log = (function(message) {
		var console = document.getElementById('console');
		var p = document.createElement('p');
		p.style.wordWrap = 'break-word';
		p.innerHTML = message;
		console.appendChild(p);
		while (console.childNodes.length > 25) {
			console.removeChild(console.firstChild);
		}
		console.scrollTop = console.scrollHeight;
	});
        
	Chat.initialize();
});

</script>
</head>

<body data-library="jquery" onload="getCookie(<%=request.getParameter("selectedNodeId")%>)" onunload="setCookie()">
	<%@include file="header.jsp"%>

	<%
	HashMap<String, Color> colorMap = new HashMap<String, Color>();
	%>


	<div class="mainContainer">
	
		<div id="node_field" style="position: absolute;" class="check">
			<div id="demo">
				<%
				String username = session.getAttribute("username").toString();
				String projectId = request.getParameter("projectId");
				String selectedNodeId = request.getParameter("selectedNodeId");
				String conList=request.getAttribute("conList").toString();
				int contributors = 7-Integer.parseInt(request.getAttribute("c").toString());
				String userID = session.getAttribute("userID").toString();
				pageContext.setAttribute("userID",userID);%>
				<div style="display:none" class="projectID"><%=projectId%></div>
				<%int i = 0;
				int position;

				int x_position = 0;
				int y_position = 0;

				int x_padding = 6;
				int y_padding = 6;

				Color prevColor = Color.darkGray;

				String att = "node" + i;
				Enumeration attr = request.getAttributeNames();
				//HashMap<String,Color> colorMap= new HashMap<String,Color>();
				float colorValue = 0;
				/*do{System.out.println("Bloody fuck1-"+attr.nextElement());}while(attr.hasMoreElements());*/
				while (attr.hasMoreElements()) { //System.out.println("Bloody fuck1-"+attr.nextElement());

					int node_height = 1;

					if (attr.nextElement().toString().startsWith("node")) {
						Map<String, List> hashmap = new HashMap<String, List>();
						hashmap = (HashMap<String, List>) request.getAttribute(att);

						if (null != hashmap && !hashmap.isEmpty()) {

							// 							int[] parray;
							// 							parray = new int[25];
							// 							int pcounter = 0;

							Iterator entries = hashmap.entrySet().iterator();
							while (entries.hasNext()) {

								Map.Entry entry = (Map.Entry) entries.next();
								String key = (String) entry.getKey();

								List value = (List) entry.getValue();
								//put it in an array
								// 								pcounter++;
								// 	     						parray[pcounter]= Integer.parseInt(value.get(2).toString());

								position = Integer.parseInt(key);
								pageContext.setAttribute("nodelistSize", value.size());

								//color test
								Color parentColor = Color.darkGray;
								colorMap.put(key, parentColor);
								if (Integer.parseInt(value.get(3).toString()) == 2) {
									colorValue += 0.2f;
									parentColor = new Color(Color.HSBtoRGB(colorValue, 1, 0.5f));
									colorMap.put(key, parentColor);
									//out.println("color-"+parentColor.getRed());
									//out.println("color br-"+parentColor.getRGB());
								} else if (Integer.parseInt(value.get(3).toString()) > 2) {
									Color c = colorMap.get(value.get(2).toString());
									parentColor = c.brighter();
									colorMap.put(key, parentColor);
									//out.println("node"+value.get(0));

								}%>
				<!-- Old Node -->
				<%
				double radius = 2;
				DecimalFormat twoDigit = new DecimalFormat("#,##0");//formats to 2 decimal places
				double uv = Integer.parseInt(value.get(7).toString()) + 1;
				double dv = Integer.parseInt(value.get(8).toString()) + 1;
				double inc = ((uv - dv) / dv) * 0.6;

				radius = 2 + inc;
				// to check if same author
				if (userID.equalsIgnoreCase(value.get(6).toString())) {%>

				<div class="current_user" style="display: none"><%=username%></div>
				<div class="w circle" id="<%=key%>" onclick="cancelEdit(<%=key%>)"
					style="left:<%=((i * x_padding)) + x_position%>em; top:<%=(node_height * y_padding)
										+ y_position%>em;width: <%=radius%>em;height: <%=radius%>em;  background-color: rgb(<%=parentColor.getRed()%>, <%=parentColor.getGreen()%>, <%=parentColor.getBlue()%>);">

					<div class="node_map_title"><%=value.get(0)%></div>
					<div style="display:none ! important;" class="notification_flag">!</div>

					<div class="ep"></div>

					<div class="node_color" style="display: none">
						#<%=parentColor.getRed()%><%=parentColor.getGreen()%><%=parentColor.getBlue()%>
					</div>
					
					<%radius*=15;%>
<%-- 				<div style="position:absolute;left:100px"><%=twoDigit.format(radius)%></div> --%>
<%-- 					<div style="position:absolute;left:-2px;top:-2px"><input style="display:none;" type="text" value="75" data-thickness=".2" data-fgColor="#AAAAAA" data-bgColor="#E1E1E1" class="vote_dial" data-readOnly="true" data-displayInput="false" data-height="<%=twoDigit.format(radius)%>" data-width="<%=twoDigit.format(radius)%>"></div> --%>
					
					<a style="display:none;" href="#" class="addnodemap_btn" id="addnodemap_<%=key%>" onclick="addNode(<%=key%>)"><img src="images/icons/addbutton-onmap-v2.png" alt="Add Node" /> </a>

				</div>
				<%} else {%>
				<div class="w circle" id="<%=key%>" onclick="cancelEdit(<%=key%>)"
					style="left:<%=((i * x_padding)) + x_position%>em; top:<%=(node_height * y_padding) + y_position%>em;width: <%=radius%>em;height: <%=radius%>em; background-color: rgb(<%=parentColor.getRed()%>, <%=parentColor.getGreen()%>, <%=parentColor.getBlue()%>);">
					<div class="node_map_title"><%=value.get(0)%></div>
					<div style="display:none ! important;" class="notification_flag">!</div>
					<div class="ep"></div>
 
					<div class="node_color" style="display: none;">#<%=parentColor.getRed()%><%=parentColor.getGreen()%><%=parentColor.getBlue()%></div>

<%-- 					<div style="position:absolute;left:-2px;top:-2px"><input style="display:none; type="text" value="75" data-thickness=".2" data-fgColor="#AAAAAA" data-bgColor="#E1E1E1" class="vote_dial" data-readOnly="true" data-displayInput="false" data-height="<%=twoDigit.format(radius)%>" data-width="<%=twoDigit.format(radius)%>"></div> --%>

					<a style="display:none;" href="#" class="addnodemap_btn" id="addnodemap_<%=key%>"onclick="addNode(<%=key%>)"><img src="images/icons/addbutton-onmap-v2.png" alt="Add Node" /> </a>

				</div>
				<%}%>

				<div class="parent" id="<%=value.get(2)%>"><%=value.get(2)%></div>

				<%-- 				<div class="node_pop_up" id="node_pop_up_<%=key%>"> --%>

				<%-- 					<div class="node_title_pu"><%=value.get(0)%></div> --%>
				<%-- 					<div class="author_name_pu"><%=value.get(5).toString()%></div> --%>
				<!-- 					<div class="expertise_pu"> -->
				<!-- 						To display Expertise -->
				<%-- 						<c:if test="${nodelistSize > 9}"> --%>
				<%-- 							<% --%>
				<!-- 							for (int tagno = 11; tagno <= value.size(); tagno++) { -->
				<!-- 													out.println(value.get(tagno - 1)); -->
				<!-- 												} -->
				<!-- 						%> -->
				<%-- 						</c:if> --%>
				<!-- 					</div> -->
				<!-- 					<div class="vote_count_pu"> -->
				<%-- 						<img src="images/icons/like-test1.png" /><%=key%> --%>
				<!-- 						<div class="rating"></div> -->
				<!-- 					</div> -->
				<!-- 				</div> -->

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
			<!-- Add people to project -->
			Contributors: <%=conList %>
			<div style="margin-bottom:20px;" class="addUsers_form">
			<% if(contributors > 0) {%>
			<%	if(null!=request.getAttribute("nonExistantPerson")){%>
				<div class="errorWrapper">  <%=request.getAttribute("nonExistantPerson").toString() %> does not exist</div><%}%>
				You can add <%=contributors %> more contributors to the project:
					<form action="AddContributorsServlet" method="post">
					<c:forEach var="con" begin="1" end="<%=contributors %>">
					
					<input class="contributorTitle" type="text" name="person${con}" placeholder="Username or Email" maxlength="25">					
					</c:forEach>
					<input type="hidden" value="<%=projectId%>" name="projectId" /> 
					<input type="hidden" value="<%=contributors%>" name="contributorNumber" /> 
					<input style="float:left;" type="image" src="images/icons/add-buttn-test1.png" alt="Submit"  align="right" width="48" height="20">
					</form>
					<%} %>
					</div>
		</div>
		<!-- 		<div id="scroll_controller"></div>	 -->
		
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
						// 						int[] parray;

						// 						parray = new int[25];
						int pcounter = 0;
						Iterator entries = hashmap.entrySet().iterator();
						while (entries.hasNext()) {

							Map.Entry entry = (Map.Entry) entries.next();
							String key = (String) entry.getKey();
							List value = (List) entry.getValue();
							//put it in an array
							pcounter++;
							// parray[pcounter] = Integer.parseInt(value.get(2).toString());
							position = Integer.parseInt(key);
							pageContext.setAttribute("nodelistSize", value.size());
							//to set the user's vote
							pageContext.setAttribute("vote",value.get(15));
							pageContext.setAttribute("author", value.get(6).toString());

		%>
			<!-- Old Node -->
			<div class="node_info" style="display:none;" id="des_<%=key%>">

				<% pageContext.setAttribute("nodeno", key);%>

				<c:set var="nodename" value="nodeno_${nodeno}"></c:set>
				<c:set var="imgnodename" value="imgno_${nodeno}"></c:set>
				<div class="node_titlebar" id="title_bar_<%=key%>">

					<!-- Display title -->
					<c:choose>
						<c:when test="${userID == author}">		
							<div class="node_title display_title" id="title_<%=key%>"><div class="title_content" onclick="editNode(<%=key%>);"><%=value.get(0)%></div></div>
							<!-- To edit title -->
							<input class="editTitle" type="text" name="title" style="display: none;" value="<%=value.get(0)%>" form="editForm_<%=key%>" maxlength="25">
						</c:when>
						<c:otherwise>
							<div class="node_title display_title" id="title_<%=key%>"><div class="title_content"><%=value.get(0)%></div></div>
						</c:otherwise>
					</c:choose>
						
					<!-- Comment submit section -->
					<img style="cursor: pointer;" class="comment_icon" id="comment_icon_<%=key%>" src="images/icons/comment-v2-3.png" onclick="submitComment(<%=key%>);" />
					
					<!-- Delete node section -->
					<c:if test="${userID == author}">
						<%if(Integer.parseInt(value.get(4).toString())==0){%>
							<div class="delete_form">
								<form action="DeleteNodeServlet" method="post">
									<input type="hidden" value='${nodeno}' name="nodeID" /> 
									<input type="hidden" value="<%=projectId%>" name="projectId" /> 
									<input type="image" src="images/icons/delete_icon.png" alt="Submit" id="delete_<%=key%>" align="right" width="48" height="20">
								</form>
							</div>
						<%}else{%>
							<div class="delete_form">
								<img src="images/icons/delete_icon.png" class="delete_icon" style="width:20px;height:20px">
							</div>
						<%}%>
					</c:if>
					
					<!-- Different Votes -->
					<div class="priority_btn">
						<form action="ImportanceVoteServlet" method="post">
							<input type="hidden" value='${nodeno}' name="nodeID" /> 
							<input type="hidden" value="<%=projectId %>" name="projectId" />
							<input type="hidden" name="vote" value="1"/>
							<%=value.get(10) %><input type="image" src="images/icons/dislike-test1.png" alt="Submit" id="up_btn_-1_<%=key%>" align="right"width="48" height="20" onClick="setVoteId('-1')">
							<%=value.get(11) %><input type="image" src="images/icons/normal_like.png" alt="Submit" id="up_btn_1_<%=key%>" align="right"width="48" height="20" onClick="setVoteId('1')">
							<%=value.get(12) %><input type="image" src="images/icons/like-test1.png" alt="Submit" id="up_btn_2_<%=key%>" align="right"width="48" height="20" onClick="setVoteId('2')">
							<%=value.get(13) %><input type="image" src="images/icons/star_half.png" alt="Submit" id="up_btn_3_<%=key%>" align="right"width="48" height="20" onClick="setVoteId('3')">
							<%=value.get(14) %><input type="image" src="images/icons/star.png" alt="Submit" id="up_btn_4_<%=key%>" align="right"width="48" height="20" onClick="setVoteId('4')">
							</form> 
						<div id="vote_<%=key%>" style="display:none"><%=value.get(15)%></div>
					</div>

					<div class="voting_form up_vote_btn">
						<form action="UpvoteServlet" method="post">
							<input type="hidden" value='${nodeno}' name="nodeID" /> 
							<input type="hidden" value="<%=projectId%>" name="projectId" /> 
							<input type="image" src="images/icons/like-test1.png" alt="Submit" id="up_btn_<%=key%>" align="right" width="48" height="20">
							<%=value.get(7)%>
						</form>
					</div>

					<div class="voting_form down_vote_btn">
						<form action="DownvoteServlet" method="post">
							<input type="hidden" value='${nodeno}' name="nodeID" /> 
							<input type="hidden" value="<%=projectId%>" name="projectId" /> 
							<input type="image" src="images/icons/dislike-test1.png" alt="Submit" id="down_btn_<%=key%>" align="right" width="48" height="20">
							<%=value.get(8)%>
						</form>
					</div>
					<div class="author_name"><%=value.get(5)%></div>
					<div class="creation_date"><%=value.get(9)%></div>
				</div>

				<!-- Node Content -->
				<div class="node_content">
				
					<c:choose>
						<c:when test="${userID == author}">		
							<form action="EditServlet" method="post" id="editForm_<%=key%>">				
							<!-- Rich Text Field -->
						<textarea class="node_description" name="description" rows="4" cols="50" maxlength="10000" form="editForm_<%=key%>">
							<%if (value.get(1) != null) {%>
								<%=value.get(1)%>
							<%}%>
						</textarea>
						<input type="hidden" value='${nodeno}' name="nodeID" /> 
						<input type="hidden" value="<%=projectId%>" name="projectId" /> 
						<input type="image" src="images/icons/submit-test1.png" alt="Submit" class="save_content" width="48" height="39">
					</form>
						</c:when>
						<c:otherwise>
							<!-- Display Content of Other Users -->
							<%if (value.get(1) != null) {%>
								<div class="node_description_otheruser"><%=value.get(1)%></div>
							<%}%>
						</c:otherwise>
						</c:choose>
				</div> <!-- Node Content End -->

				<div class="node_content_under_bar">
				<!-- Up Votes -->
				<% int length=value.get(16).toString().length()-1;
					if(length>6){
						String upVoteList = value.get(16).toString().substring(7,length);
						out.println("Upvotes-");
						if(upVoteList.indexOf('#')>0){
							//more than one person s vote
							String[] upList=upVoteList.split("#");
							for(int u=0;u<upList.length;u++){
							
								String uname=upList[u].substring(0,upList[u].indexOf('.'));
								String unumber=upList[u].substring(upList[u].indexOf('.')+1);
								out.println(uname);
								out.println(unumber);
							}
						}else{
							// just one peron s vote
							String uname=upVoteList.substring(0,upVoteList.indexOf('.'));
							String unumber=upVoteList.substring(upVoteList.indexOf('.')+1);
							out.println(uname);
							out.println(unumber);
						}
				}
				%>
				
				<!-- DownVotes -->
				<% int dlength=value.get(17).toString().length()-1;
					if(dlength>6){
						String upVoteList = value.get(17).toString().substring(7,dlength);
						out.println("Downvotes-");
						if(upVoteList.indexOf('#')>0){
							//more than one person s vote
							String[] upList=upVoteList.split("#");
							for(int u=0;u<upList.length;u++){
							
								String uname=upList[u].substring(0,upList[u].indexOf('.'));
								String unumber=upList[u].substring(upList[u].indexOf('.')+1);
								out.println(uname);
								out.println(unumber);
							}
						}else{
							// just one peron s vote
							String uname=upVoteList.substring(0,upVoteList.indexOf('.'));
							String unumber=upVoteList.substring(upVoteList.indexOf('.')+1);
							out.println(uname);
							out.println(unumber);
						}
				}
				%>

					<div class="expertise">

						<!-- To display Expertise -->
						<c:if test="${nodelistSize > 9}">

							<%
								for (int tagno = 19; tagno <= value.size(); tagno++) {%><div class="node_tag"><%
									
														out.println(value.get(tagno - 1));
								
								%></div>
							<%}%>
							
						</c:if>

					</div>
				</div> <!-- node_content_under_bar end -->

				<div class="new_node_form" id="new_node_form_<%=key%>">
					<form action="MyServlet" method="POST">
					<div class="new_node_form_title_bar">
						<div class="add_node_title">
							<input class="input_title" type="text" name="title" placeholder="Title" maxlength="35">
						</div>
						<div class="author_name"><%=username%></div>
						<div class="creation_date"><%=value.get(9)%></div>
					</div>
					<div class="new_node_form_content">
						<textarea class="node_description" rows="4" cols="50" maxlength="10000" name="description"></textarea>
						<input type="hidden" value='${nodeno}' name="parentId" /> 
						<input type="hidden" value="<%=projectId%>" name="projectId" /> <br>
					</div>
					<div class="new_node_under_bar">
						<div class="tagSection">
							<img class="tags_icon" id="tag_icon_<%=key%>" src="images/icons/tag_icon.png" /> 
							<input class="node_tag_input node_tag1" type="text" name="tag1">
							<input class="node_tag_input node_tag2" type="text" name="tag2">
							<input class="node_tag_input node_tag3" type="text" name="tag3">
							<a href="#" class="new_tag"><img class="new_tag_img" id="new_tag_<%=key%>" src="images/icons/add-buttn-test1.png" /></a>
						</div>
							<input class="new_node_submit_btn" type="image" src="images/icons/submit-test1.png" alt="Submit" width="48" height="39"> 
							<a href="#" class="new_node_cancel_btn" id="cancel_<%=key%>" onclick="cancelAdd(<%=key%>)">
							<img src="images/icons/cancel-test1.png" alt="Cancel Add" /> </a>
					</div>
					</form>
				</div> <!-- new_node_form end -->

				<div class="discussion_thread" id="discussion_thread_<%=key%>">
					<div class="node_comments" id="node_comments_<%=key%>">
						<%MultivaluedMap<String, List<String>> comments = new MetadataMap<String, List<String>>();
						comments = (MultivaluedMap<String, List<String>>) request.getAttribute("comments");
						if (null != comments && !comments.isEmpty()) {
							if (comments.containsKey(key)) {
							// if the particular node has comments, iterating over the list of comments
								Iterator listIt = comments.get(key).iterator();
								while (listIt.hasNext()) {
									List<String> commentSection = (List<String>) listIt.next();
									Iterator commentDetIt = commentSection.iterator();
													//showing the comment/author/date %>
						<div class="comment_box">
							<div class="comment_title">
								<div class="comment_author">
									<%=commentSection.get(2)%>
								</div>
								<div class="comment_date">
									<%=commentSection.get(1)%>
								</div>
							</div>
							<div class="comment_content">
								<%=commentSection.get(0)%>
							</div>
						</div>
								<%}
							} 
						}%>
					</div>
					<!-- To comment- the form! -->
					<div class="commentSection" id="commentDiv_<%=key%>"style="display: none">
						<form action="CommentServlet" method="post" id="commentForm_<%=key%>" class="comment_form">
							<textarea id="comment_<%=key%>" class="commentSection" rows="4" cols="50" maxlength="250" name="comment" form="commentForm_<%=key%>"></textarea>
							<input type="hidden" value='${nodeno}' name="nodeID" /> 
							<input type="hidden" value="<%=projectId%>" name="projectId" /> 
							<input type="image" class="comment_submit_btn" src="images/icons/submit-test1.png" alt="Submit" width="48" height="39" /> <a href="#" class="comment_cancel_btn" id="cancelEdit_<%=key%>" onclick="cancelComment(<%=key%>)"><img src="images/icons/cancel-test1.png" alt="Cancel Comment" /> </a>
						</form>
					</div>
				</div> <!-- Discussion Thread End -->
				
			</div> <!-- Node Info End -->
		
							<%}
						}
						i++;
						att = "node" + i;
					}%>
		
		<%}%>
		</div> <!-- Content Field End -->
		
	</div> <!-- Main Container End -->
		

	<div style="width: 50px; position: fixed; left: 0%; top: 0%;">
		<p>
			<input type="text" placeholder="type and press enter to chat" id="chat">
		</p>
		<div id="console-container">
			<div id="console"></div>
		</div>
	</div>
	<div id="notification_board"></div>

	<script>
  	$(function() {
//     	$( "#content_field" ).draggable({cancel : '.node_description, .creation_date, .project_author, .form, .comment_author, .comment_date, .comment_content'});
    	$("#node_field").draggable();
    	var content_field = $( "#content_field" ).draggable();
    	var new_node_form = $( ".new_node_form" ).draggable();
    	$( ".discussion_thread" ).resizable();

    	$('.creation_date', content_field).mousedown(function(ev) {content_field.draggable('disable');}).mouseup(function(ev) {content_field.draggable('enable');});
    	$('.project_author', content_field).mousedown(function(ev) {content_field.draggable('disable');}).mouseup(function(ev) {content_field.draggable('enable');});
    	$('.form', content_field).mousedown(function(ev) {content_field.draggable('disable');}).mouseup(function(ev) {content_field.draggable('enable');});
    	$('.comment_author', content_field).mousedown(function(ev) {content_field.draggable('disable');}).mouseup(function(ev) {content_field.draggable('enable');});
    	$('.comment_date', content_field).mousedown(function(ev) {content_field.draggable('disable');}).mouseup(function(ev) {content_field.draggable('enable');});
    	$('.comment_content', content_field).mousedown(function(ev) {content_field.draggable('disable');}).mouseup(function(ev) {content_field.draggable('enable');});
    	$('.node_content', content_field).mousedown(function(ev) {content_field.draggable('disable');}).mouseup(function(ev) {content_field.draggable('enable');});
    	$('.new_node_content', new_node_form).mousedown(function(ev) {new_node_form.draggable('disable');}).mouseup(function(ev) {new_node_form.draggable('enable');});
     	$('.mce-tinymce', content_field).mouseup(function(ev) {content_field.draggable('enable');});

  	});
  	</script>

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