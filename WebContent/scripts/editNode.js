/**
 * functions related to all the editing/commenting of nodes
 */
// Edit Title and Description section
	
	function editNode(key){
	
	// title
	var titleLabel="#title_"+key;
	$(titleLabel).hide();
	$('.editTitle').show();

	//var titleVal=$(titleLabel).text();
	//var formId="editForm_"+key;
	//$(titleLabel).replaceWith('<input class="editTitle" type="text" name="title">');
	//$('.editTitle').val(titleVal);
	//$('.editTitle').attr("form",formId);
	
	// Description
	var descLabel="#node_description_"+key;
	$(descLabel).hide();
	$('.editDesc').show();
	
	//var descVal=$(descLabel).text();
	//$(descLabel).replaceWith('<textarea class="editDesc" rows="4" cols="50" maxlength="250" name="description"></textarea>');
	//$('.editDesc').val(descVal);
	//$('.editDesc').attr("form",formId);
	
	//show submit button
	var editFormSubmit="#editNodeDiv_"+key;
	$(editFormSubmit).show();
	}

// cancel for Edit functionality
function cancelEdit(key){
	
	// title
	var titleLabel="#title_"+key;
	$(titleLabel).show();
	$('.editTitle').hide();

	
	// Description
	var descLabel="#node_description_"+key;
	$(descLabel).show();
	$('.editDesc').hide();

	//hide submit button
	var editFormSubmit="#editNodeDiv_"+key;
	$(editFormSubmit).hide();
	}

//Cancel funntionality for Add node

function cancelAdd(key){
	var newnode="#new_node_form_"+key;
	var addButton="#new_btn_"+key;
	$(newnode).hide();
	$(addButton).show();
	$('.add_icon').show();

	
}

// open comment form section
function submitComment(key){
	var discussionTh="#discussion_thread_"+key;
	var commentLabel="#commentDiv_"+key;
	var commentArea="#comment_"+key;
	//$(titleLabel).hide();
	$(discussionTh).show();
	$(commentLabel).show();
	// focus on the comment text area
	$(commentArea).focus();

}

// cancel the comment area
function cancelComment(key){
	var commentThread="#node_comments_"+key;
	if(!$.trim($(commentThread).html())){
		var discussionTh="#discussion_thread_"+key;
		$(discussionTh).hide();
	}
	var commentLabel="#commentDiv_"+key;
	$(commentLabel).hide();
		
}

//});