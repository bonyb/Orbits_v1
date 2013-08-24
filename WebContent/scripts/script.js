$(document).ready(function() {
                  // Handler for .ready() called.                  
                  
	//$("p").bind("fadeOut",slow,function(){alert("FADE");});
	//$("#type_rpg").hide();
	$('#addNode').hide();
	var nodeArray = new Array();
	var nodeNum = 0;
	var name;
	var description;
	
    function createNewForm()
    {
    	var new_form = '<form class="nodeForm" id="nodeForm" action="MyServlet" method="POST">\
    		<label for="regNr">Title</label> </div> <div><input type="text" id="inputTitle" class="uprCase">\
            <input type="submit" id="submitdata" value="Go">\
    		</form><script src="scripts/script.js"></script>';
    	
    	return new_form;
    }
    
    function createNewNode()
    {
    	var new_node = '<div class="newNode" id="node'+nodeNum+'">\
    	<h3>'+name+'</h3><br>\
    	</div>';
    	
    	$("#first_node").css("display","none").append(new_node).slideDown();
    	nodeNum++;
    	
    	return new_node;
    }
    
	// Click on New Node \\
	$("#new_node").click(function(){
		$("#new_node").slideUp();
		$('#addNode').show();
		//$("#first_node").css("display","none").append(createNewForm()).slideDown();
	});  
	
	// Submit New Node \\
	$("#submitdata").click(function()
	{
		//alert("Data Submitted");
		$("#nodeForm").slideUp();
		
		name = $("input#inputTitle").val(); 
		alert("inout");
		//description = $("input#inputDescription").val();  var dataString = 'name='+ name + '&description=' + description;
		var dataString = 'name='+ name;
		
		$.ajax({
			type: "POST",
			url: "/MyServlet",
			data: dataString,
			dataType: 'text',
			success: function(){
				var url = "/MyServlet";  
				$(location).attr('href', url);
				createNewNode();
			}
		});
	});
});