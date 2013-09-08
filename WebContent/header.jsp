<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

<!-- Le styles -->
<link rel="stylesheet" href="styles/bootstrap/css/bootstrap.css"></link>
<link rel="stylesheet" href="styles/bootstrap/css/bootstrap-responsive.css"></link>

<style type="text/css">
body {
	padding-top: 60px;
	padding-bottom: 40px;
}
</style>

</head>
<body>
	<div class="navbar navbar-inverse navbar-fixed-top">
		<div class="navbar-inner">
			<div class="container">
				<button class="btn btn-navbar" data-target=".nav-collapse"
					data-toggle="collapse" type="button">
					<span class="icon-bar"></span><span class="icon-bar"></span><span
						class="icon-bar"></span>
				</button>
				<a class="brand" href="AuthAndDisplayProjects"> Orbits </a>
				<div class="nav-collapse collapse">
					<ul class="nav">
						<li class="active"><a href="#"> New Project </a>
						</li>
						<li><a href="#about"> About </a>
						</li>
						<li class="dropdown"><a class="dropdown-toggle"
							data-toggle="dropdown" href="#"> Dropdown <b class="caret"></b>
						</a>
							<ul class="dropdown-menu">
								<li><a href="#"> Action </a>
								</li>
								<li><a href="#"> Another action </a>
								</li>
								<li><a href="#"> Something else here </a>
								</li>
								<li class="divider"></li>
								<li class="nav-header">Nav header</li>
								<li><a href="#"> Separated link </a>
								</li>
								<li><a href="#"> One more separated link </a>
								</li>
							</ul>
						</li>
					</ul>
					<form action="SessionInvalidate" method="POST">
							<input class="btn" type="submit" value="Logout">
					</form>
				</div>
				<!--/.nav-collapse -->
			</div>
		</div>
	</div>


	<%@include file="footer.jsp"%>

	<!-- Le javascript
    ================================================== -->

	<!-- Placed at the end of the document so the pages load faster -->
	<script src="styles/bootstrap/js/bootstrap.js"></script>
	<script src="styles/bootstrap/js/bootstrap.min.js"></script>

</body>
</html>