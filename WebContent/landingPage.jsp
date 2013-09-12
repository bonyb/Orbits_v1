<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.ArrayList"%>
<%@page import="javax.script.*"%>
<%@page import="java.util.Random"%>
<%@page import="java.awt.Color"%>
<%@page import="java.util.Enumeration"%>



<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js" ></script>
<script type="text/javascript" src="js/lib/jquery-1.8.1-min.js"></script>
<script type="text/javascript" src="js/lib/jquery-ui-1.8.23-min.js"></script>
<script type="text/javascript" src="js/lib/jquery.ui.touch-punch.min.js"></script>
<script src="scripts/script.js"></script>
<link href="styles/style.css" rel="stylesheet" type="text/css"/>
<title>Orbits - Dashboard</title>
<script type="text/javascript" src="scripts/projectsCache.js"></script>
<script type="text/javascript" src="scripts/projectsEdit.js"></script>
</head>
<body onload="getProjectCookie()" onunload="setProjectCookie()">
<%@include file="header.jsp" %>
<%String username= session.getAttribute("username").toString(); %>
Hello <%=username%>

<%	
if(null!=request.getAttribute("nonExistantPerson")){%>
	<div class="errorWrapper">  <%=request.getAttribute("nonExistantPerson").toString() %> does not exist</div>
<%
}
%>
<img src="images/ui-orbits-background-v1.png" style="width:90%;height:auto;position:fixed;z-index:-2;"/>

<div class="new_project_node octagon">
<img src="images/shadow-node.png" style="width:100%;height:243%;position:absolute;top:-71%;left:0%;"/>
	<div class="new_project_form">
		<form action="CreateNewTree" method="POST">
			<div class="new_project_title">
				<input class="input-block-level input_title" type="text" name="title" placeholder="Title" maxlength="25">
			</div>
			
			<div class="add_users_form">				
				<div class="add_members" style="white-space: nowrap;">Add Team Members</div>
					<div class="new_project_users">
					<input type="text" name="person1" class="new_user_input"/>
					<input type="text" name="person2" class="new_user_input"/>
					<input type="text" name="person3" class="new_user_input"/>
					<input type="text" name="person4" class="new_user_input"/>
					<input type="text" name="person5" class="new_user_input"/>
					<input type="text" name="person6" class="new_user_input"/>
					<input type="text" name="person7" class="new_user_input"/>
					<input type="text" name="person8" class="new_user_input"/>
				</div>
				
					<input type="submit" alt="Submit" class="newProjectSubmit" value="Submit">
				
			</div>
		</form>
	</div>
</div>
<%
HashMap<String,List<String>> hashmap = (HashMap<String, List<String>>) request.getAttribute("projects");


int position;
int i = 1;
int x_position = 5;
int y_position = 0;

int x_padding = 10;
int y_padding = 6;

int node_height = 1;

if (null != hashmap && !hashmap.isEmpty()) {
	
	Iterator listIt=hashmap.entrySet().iterator();
	while (listIt.hasNext()) {
						
		Map.Entry entry = (Map.Entry) listIt.next();
		String key = (String) entry.getKey();
		List<String> value = (List<String>) entry.getValue();
		//showing the comment/author/date
		%>
		
		<div class="new_project" id="project_<%=key%>" 
		style="left:<%=((i*x_padding))+x_position%>em;top:27%;position:absolute;">
		
			<div class="project_title_box">
				<div class="project_title"><%=value.get(0)%></div>
				<div class="date_author_bar">
					<div class="project_date"><%=value.get(1)%></div>
					<div class="project_author"><%=username%></div>
				</div>
			</div>
			
			
			
			<a class="project_link octagon" href="DisplayNodesServlet?projectId=<%=key%>">
				<img src="images/shadow-node.png" style="width:100%;height:243%;position:absolute;top:-71%;left:0%;"/>
				<div class="contributors_num"><%=value.get(2)%></div>
			</a>	
			
			
		</div>
		
		<%	
		
		i++;
	}					
}
%>

<%
HashMap<String,List<String>> hashmapContri = (HashMap<String, List<String>>) request.getAttribute("contributions");

position =0;
i = 1;
x_position = 5;
y_position = 0;

x_padding = 10;
y_padding = 6;

node_height = 1;

if (null != hashmapContri && !hashmapContri.isEmpty()) {
	
	Iterator contributionsIt=hashmapContri.entrySet().iterator();
	while (contributionsIt.hasNext()) {
		
		Map.Entry entry = (Map.Entry) contributionsIt.next();
		String key = (String) entry.getKey();
		List<String> value = (List<String>) entry.getValue();
		//showing the comment/author/date
%>
		<div class="new_project" id="project_<%=key%>"
		style="left:<%=((i*x_padding))+x_position%>em;top:52%;position:absolute;">
			<div class="project_title_box">
				<div class="project_title"><%=value.get(0)%></div>
				<div class="date_author_bar">
					<div class="project_date"><%=value.get(1)%></div>
					<div class="project_author"><%=value.get(2)%></div>
				</div>
			</div>
			
			<a class="project_link square" href="DisplayNodesServlet?projectId=<%=key%>">
				<div class="contributors_num" style="top:30%"><%=value.get(3)%></div>
			</a>
				
		</div>
	<%
		i++;
	}
	
}
%>
<script>
	$(function() {
   		$( ".new_project" ).draggable();
   		$( ".new_project_node" ).draggable();
 	});
  </script>
  	
</body>
</html>