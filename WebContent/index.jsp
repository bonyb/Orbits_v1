<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html style="background-color:#333333;">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
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
       // margin: 0 auto 20px;
       margin:-34px 22px 0px -300px;
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
      
      .form-register {
        max-width: 300px;
        padding: 19px 29px 29px;
        margin: 5px 0 5px 671px;
        background-color: #fff;
        border: 1px solid #e5e5e5;
        -webkit-border-radius: 5px;
           -moz-border-radius: 5px;
                border-radius: 5px;
        -webkit-box-shadow: 0 1px 2px rgba(0,0,0,.05);
           -moz-box-shadow: 0 1px 2px rgba(0,0,0,.05);
                box-shadow: 0 1px 2px rgba(0,0,0,.05);
                  top: 18%;
      }
      .form-register .form-register-heading,
      .form-register .checkbox {
        margin-bottom: 10px;
      }
      .form-register input[type="text"],
      .form-register input[type="password"] {
        font-size: 16px;
        height: auto;
        margin-bottom: 2px;
        padding: 7px 9px;
      }

    
    </style><link rel="stylesheet" href="styles/bootstrap/css/bootstrap-responsive.css"></link>


<script type="text/javascript" src="js/lib/jquery-1.8.1-min.js"></script>
<script type="text/javascript" src="js/lib/jquery-ui-1.8.23-min.js"></script>
<script type="text/javascript" src="js/lib/jquery.ui.touch-punch.min.js"></script>
<script src="scripts/index.js"></script>
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
		
		<%
			if (request.getAttribute("mandatory") != null
					&& request.getAttribute("mandatory").toString() == "none") {
		%><div class="errorWrapper" style="margin-left: 612px;margin-top: 10px;">Please enter all the mandatory fields</div>
		<%
			}else if (request.getAttribute("emailexists") != null
					&& request.getAttribute("emailexists").toString() == "none") {
		%><div class="errorWrapper" style="margin-left: 612px;margin-top: 10px;">The email address is already registered.Please select another email address</div>
		<%
			}else if(request.getAttribute("usernameexists") != null
					&& request.getAttribute("usernameexists").toString() == "none"){%>
					<div class="errorWrapper" style="margin-left: 612px;margin-top: 10px;">The Username already exists. Please select another username</div>
		<%
			}else if(request.getAttribute("regerror") != null
				&& request.getAttribute("regerror").toString() == "none"){
		%>
			<div class="errorWrapper" style="margin-left: 612px;margin-top: 10px;">Some error has occurred! Please register again</div>
				
		<%
			}	%>
				
		<form class="form-register" action="RegistrationServlet" id="registrationForm"  method="POST">
			<h2 class="form-register-heading">Please Register</h2>
			<input id="firstName" class="input-block-level" type="text" name="firstName" placeholder="First Name"> </input> 
			<input id="lastName" class="input-block-level" type="text" name="lastName" placeholder="Last Name"> </input> 
			<input id="email" class="input-block-level" type="text" name="email" placeholder="Email"> </input> 
			<input id="username" class="input-block-level" type="text" name="username" placeholder="Username"> </input> 
			<input id="password" class="input-block-level" type="password" name="password" placeholder="Password"> </input> 
			<input id="confirmPassword" class="input-block-level" type="password" name="confirmPassword" placeholder="confirmPassword"> </input> 
			<label class="checkbox"> <input type="checkbox" value="remember-me"> Remember me </label>
			<button class="btn btn-large btn-primary" type="submit" value="Login">Sign Up</button>
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