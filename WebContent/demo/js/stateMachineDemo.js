;(function() {

	var curColourIndex = 1, maxColourIndex = 24, nextColour = function() {
		var R,G,B;
		R = parseInt(128+Math.sin((curColourIndex*3+0)*1.3)*128);
		G = parseInt(128+Math.sin((curColourIndex*3+1)*1.3)*128);
		B = parseInt(128+Math.sin((curColourIndex*3+2)*1.3)*128);
		curColourIndex = curColourIndex + 1;
		if (curColourIndex > maxColourIndex) curColourIndex = 1;
		return "rgb(" + R + "," + G + "," + B + ")";
	};
		
	window.jsPlumbDemo = { 
	
		init :function() {
			
			
			jsPlumb.importDefaults({
				Endpoint : ["Dot", {radius:5}],
				HoverPaintStyle : {strokeStyle:"#42a62c", lineWidth:2 }//,
				
//				ConnectionOverlays : [
//					[ "Arrow", { 
//						location:0.5,
//						id:"arrow",
//	                    length:20,
//	                    foldback:0.8
//					} ],
	                //[ "Label", { location:0.1, label:"FOO", id:"label" }]
				//]
			});
			
			   jsPlumbDemo.initEndpoints = function(nextColour) {
			        $(".ep").each(function(i,e) {
						var p = $(e).parent();
						jsPlumb.makeSource($(e), {
							parent:p,
							//anchor:"BottomCenter",
							//anchor:"Continuous",
							anchor:"Center",
							
							connector:[ "Straight"/*, { curviness:0, proximityLimit:80 }*/ ],
							connectorStyle:{ strokeStyle:nextColour(), lineWidth:5 },
							maxConnections:1000,
							onMaxConnections:function(info, e) {
			                    alert("Maximum connections (" + info.maxConnections + ") reached");
			                }

						});
					});		
			    };
			    
            // initialise draggable elements.  note: jsPlumb does not do this by default from version 1.3.4 onwards.
			jsPlumb.draggable(jsPlumb.getSelector(".w"));

            // bind a click listener to each connection; the connection is deleted.
			jsPlumb.bind("click", function(c) { 
				//jsPlumb.detach(c); 
			});
				
			jsPlumbDemo.initEndpoints(nextColour);

            jsPlumb.bind("jsPlumbConnection", function(conn) {
                conn.connection.setPaintStyle({strokeStyle:nextColour()});
                //conn.connection.getOverlay("label").setLabel(conn.connection.id);
            });

            jsPlumb.makeTarget(jsPlumb.getSelector(".w"), {
				dropOptions:{ hoverClass:"dragHover" },
				connectorStyle:{ strokeStyle:nextColour(), lineWidth:5 },

				anchor:"Center"	
				//anchor:"TopCenter"			
			});
            
			/*var nodeArray = new Array();
			nodeArray = document.getElementsByClassName("w");
			for(var i=0;i<nodeArray.length;i++)
			{
				var src = $(nodeArray[i]).next().html();
				var target1 = nodeArray[i].id;

				if(i!=0)
				{
					jsPlumb.connect({source:src, target:target1, anchors:["Perimeter", {shape:"Circle"}]});
				}				
			} */
		}
	};
})();