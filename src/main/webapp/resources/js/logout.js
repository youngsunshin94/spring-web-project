$(document).ready(function(){
	
	$("#logoutTag").on('click', function(e){
		e.preventDefault();
		
		$("#logoutForm").submit();
	});
	
});