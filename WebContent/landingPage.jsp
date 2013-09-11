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
<title>Orbit's Dashboard</title>
<script type="text/javascript" src="scripts/projectsCache.js"></script>
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
<form action="CreateNewTree" method="POST">
	<input class="input-block-level input_title" type="text" name="title" placeholder="Title">
	Add people <!-- expand the div on click -->
	<input type="text" name="person1" class="input_title"/>
	<input type="text" name="person2" class="input_title"/>
	<input type="text" name="person3" class="input_title"/>
	<input type="text" name="person4" class="input_title"/>
	<input type="text" name="person5" class="input_title"/>
	<input type="text" name="person6" class="input_title"/>
	<input type="text" name="person7" class="input_title"/>
	<input type="text" name="person8" class="input_title"/>
	<input type="image" src="images/sub_btn.png" alt="Submit" align="left" width="48" height="39">
</form>


<%
HashMap<String,List<String>> hashmap = (HashMap<String, List<String>>) request.getAttribute("projects");
				
if (null != hashmap && !hashmap.isEmpty()) {
					
	Iterator listIt=hashmap.entrySet().iterator();
	while (listIt.hasNext()) {
						
		Map.Entry entry = (Map.Entry) listIt.next();
		String key = (String) entry.getKey();
		List<String> value = (List<String>) entry.getValue();
		//showing the comment/author/date
		%>
		
		<div class="new_project" id="project_<%=key%>">
			<div class="project_title"><%=value.get(0)%></div>
			<div class="project_date"><%=value.get(1)%></div>
			
			<a class="project_link octagon" href="DisplayNodesServlet?projectId=<%=key%>">
				<img src="images/shadow-node.png" style="width:100%;height:243%;position:absolute;top:-71%;left:0%;"/>
			</a>	
		</div>
		
		<%				
	}					
}
%>

<%
HashMap<String,List<String>> hashmapContri = (HashMap<String, List<String>>) request.getAttribute("contributions");

if (null != hashmapContri && !hashmapContri.isEmpty()) {
	
	Iterator contributionsIt=hashmapContri.entrySet().iterator();
	while (contributionsIt.hasNext()) {
		
		Map.Entry entry = (Map.Entry) contributionsIt.next();
		String key = (String) entry.getKey();
		List<String> value = (List<String>) entry.getValue();
		//showing the comment/author/date
%>
		<div class="new_project" id="project_<%=key%>">
			<div class="project_title"><%=value.get(0)%></div>
			<div class="project_date"><%=value.get(1)%></div>
			
			<a class="project_link octagon" href="DisplayNodesServlet?projectId=<%=key%>">
				<img src="images/shadow-node.png" style="width:100%;height:243%;position:absolute;top:-71%;left:0%;"/>
			</a>	
		</div>
	<%
		
	}
	
}
%>
	<script>
  	$(function() {
    	$( ".new_project" ).draggable();
  	});
  	</script>
  	
</body>
</html>