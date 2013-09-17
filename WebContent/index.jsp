<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html style="background-color:#333333;">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
<script src="scripts/script.js"></script>
<link href="styles/style.css" rel="stylesheet" type="text/css" />
<title>Orbits - Sign In</title>

<!-- BLAH -->

<!-- Le styles -->
    <link rel="stylesheet" href="styles/bootstrap/css/bootstrap.css"></link><style type="text/css">
      
      body {
        padding-top: 40px;
        padding-bottom: 40px;
        //background-color: black;
      }

      .form-signin {
        max-width: 300px;
        padding: 19px 29px 29px;
        margin: 0 auto 20px;
        background-color: #fff;
        border: 1px solid #e5e5e5;
        -webkit-border-radius: 5px;
           -moz-border-radius: 5px;
                border-radius: 5px;
        -webkit-box-shadow: 0 1px 2px rgba(0,0,0,.05);
           -moz-box-shadow: 0 1px 2px rgba(0,0,0,.05);
                box-shadow: 0 1px 2px rgba(0,0,0,.05);
      }
      .form-signin .form-signin-heading,
      .form-signin .checkbox {
        margin-bottom: 10px;
      }
      .form-signin input[type="text"],
      .form-signin input[type="password"] {
        font-size: 16px;
        height: auto;
        margin-bottom: 15px;
        padding: 7px 9px;
      }

    
    </style><link rel="stylesheet" href="styles/bootstrap/css/bootstrap-responsive.css"></link>



</head>
<body style="background-color:#333333;">
	<%@include file="header.jsp"%>

	<div class="container" style="background-color:#555555;">

		<%
			if (request.getAttribute("results") != null
					&& request.getAttribute("results").toString() == "none") {
		%><div class="errorWrapper">Please login again. Authentication
			Error</div>
		<%
			}else if(request.getAttribute("timedOut") != null
					&& request.getAttribute("timedOut").toString() == "true"){%>
					<div class="errorWrapper">Session Timed out. Please login again</div>
				
		<%}
		%>

		<form class="form-signin" action="AuthAndDisplayProjects" method="POST">
			<h2 class="form-signin-heading">Please sign in</h2>
			
			<input class="input-block-level" type="text" name="username" placeholder="Username"> </input> 
			<input class="input-block-level" type="password" name="password" placeholder="Password"> </input> 
			<label class="checkbox"> <input type="checkbox" value="remember-me"> </input> Remember me </label>
			<button class="btn btn-large btn-primary" type="submit" value="Login">Sign in</button>
		</form>
	</div>


<!-- 	<form action="AuthLogin" method="POST"> -->
<!-- 		Username : <input type="text" name="username" /> <br /> Password : <input -->
<!-- 			type="password" name="password" /> <input type="submit" -->
<!-- 			value="Login" /> -->
<!-- 	</form> -->
	
	
	<!-- Le javascript
    ================================================== -->
      <!-- Placed at the end of the document so the pages load faster -->
    <script src="styles/bootstrap/js/bootstrap.js"></script>
	<script src="styles/bootstrap/js/bootstrap.min.js"></script>
	
</body>
</html>