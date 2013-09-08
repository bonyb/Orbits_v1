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
<script src="scripts/script.js"></script>
<link href="styles/style.css" rel="stylesheet" type="text/css"/>
<title>Orbit's Dashboard</title>
</head>
<body>
<%@include file="header.jsp" %>
<%String username= session.getAttribute("username").toString(); %>
Hello <%=username%>
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
						<div class="comment_box">
									<%=value.get(0)%>
									<%=value.get(1)%>
							
							<a href="DisplayNodesServlet?projectId=<%=key%>" ><img src="images/circle.png"/></a>
						</div>
					<%
						
					}
					
					}
	


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
HashMap<String,List<String>> hashmapContri = (HashMap<String, List<String>>) request.getAttribute("contributions");

if (null != hashmapContri && !hashmapContri.isEmpty()) {
	
	Iterator contributionsIt=hashmapContri.entrySet().iterator();
	while (contributionsIt.hasNext()) {
		
		Map.Entry entry = (Map.Entry) contributionsIt.next();
		String key = (String) entry.getKey();
		List<String> value = (List<String>) entry.getValue();
		//showing the comment/author/date
		%>
		<div class="comment_box">
					<%=value.get(0)%>
					<%=value.get(1)%>
			
			<a href="DisplayNodesServlet?projectId=<%=key%>" ><img src="images/circle.png"/></a>
			
		</div>
	<%
		
	}
	
	}
%>
</body>
</html>