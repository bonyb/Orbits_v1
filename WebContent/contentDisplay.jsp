<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Arrays"%>
<%@page import="javax.script.*"%>
<%@page import="java.util.Enumeration;"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@  taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<div id="content_field">



		<%
 		int i = 0; 		
		int position;		
 		 String att="node"+i;
 		Enumeration attr=request.getAttributeNames();
		/*do{System.out.println("Bloody fuck1-"+attr.nextElement());}while(attr.hasMoreElements());*/
 		while(attr.hasMoreElements())
 		{	//System.out.println("Bloody fuck1-"+attr.nextElement());
 		
 			int node_height = 1;
			if(attr.nextElement().toString().startsWith("node"))
			{
	 			Map<String, List> hashmap = new HashMap<String, List>();
	 			hashmap=(HashMap<String, List>)request.getAttribute(att);
	 			if(null!=hashmap && !hashmap.isEmpty()){
	 				int[] parray;
	 				
	 					parray=new int[25];
	 					int pcounter=0;
	 					Iterator entries = hashmap.entrySet().iterator();
	 					while(entries.hasNext()){
	 					
	 					Map.Entry entry = (Map.Entry) entries.next();
	     				String key = (String)entry.getKey();
	     				List value = (List)entry.getValue(); 
	     				//put it in an array
	     				pcounter++;
	     				parray[pcounter]= Integer.parseInt(value.get(2).toString());
	     				position = Integer.parseInt(key);
	     				pageContext.setAttribute("nodelistSize",value.size());
	 				%>
		<!-- Old Node -->
		<div class="node_info" id="<%=key%>">

			<% if(parray[pcounter]!=parray[pcounter-1]) {System.out.println("a line is here");}
							pageContext.setAttribute("nodeno",key);%>

			<div>
				<c:set var="nodename" value="nodeno_${nodeno}"></c:set>
				<c:set var="imgnodename" value="imgno_${nodeno}"></c:set>
				<div class="node" id="container_<%=i %>">
					<div class="node_title"><%=value.get(0) %>
					</div>
					<div class="author_name"><%=request.getAttribute("author") %></div>
					<div class="expertise">
						<!-- To display Expertise -->
						<c:if test="${nodelistSize > 5}">
						<% for(int tagno=6;tagno<=value.size();tagno++){
							out.println(value.get(tagno-1));
						}
						%>
						</c:if></div>
					<div class="node_description"><%=value.get(1)%></div>
					<div class="vote_count">
						<img src="images/icons/like.png" /><%=key %>
						<div class="rating"></div>
					</div>

					<div class="edit_node_btn">
						<img class="edit_menu_btn" id="edit_btn"
							src="images/icons/plus_btn.png" />
					</div>
				</div>
			</div>

			<div>
				<img class="new_btn" id="newNodeButton" src="images/plus_btn.png" />
			</div>

			<div class="new_node_form">
					<form action="MyServlet" method="POST">
						<input type="text" value="Title" name="title"><input
							type="text" value="Description" name="description"> <input
							type="hidden" value='${nodeno}' name="parentId" /> 
								<div class="tagSection">Add Tags
	    						<input type="text" name="tag1">
	    						<input type="text" name="tag2">
	    						<input type="text" name="tag3">
	    						<a href="#" class="moreTags">Add more tags</a></div>
							<input class="submit_btn" type="submit" value="Submit"> <input
							class="cancel_btn" type="button" value="Cancel">
					</form>
			</div>

			<div class="edit_node_menu">
				<img class="delete_btn" id="delete_btn" src="images/plus_btn.png" /><br>
				<img class="edit_btn" id="delete_btn" src="images/plus_btn.png" /><br>
				<img class="hide_btn" id="hide_btn" src="images/plus_btn.png" />
			</div>




			<div class="ep"></div>
		</div>
		<div class="parent" id="<%=value.get(2)%>"><%=value.get(2)%></div>
		<%
     				node_height++;
	 				}
	 			}	
    			i++;
				att="node"+i;	
			}	
 		} 
		%>



	</div>
	<div id="checkpage">THE PAGE IS HERE</div>
	<!-- DEP -->
	<script type="text/javascript" src="js/lib/jquery-1.8.1-min.js"></script>
	<script type="text/javascript" src="js/lib/jquery-ui-1.8.23-min.js"></script>
	<script type="text/javascript"
		src="js/lib/jquery.ui.touch-punch.min.js"></script>
	<!-- /DEP -->

	<script type="text/javascript" src="scripts/new_node.js"></script>


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