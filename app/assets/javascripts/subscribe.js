$(document).ready(function() {

	$('#subscribe form').submit(function(e) {
		e.preventDefault();
		$.ajax({
			type: "POST",
			data: "email=" + $('#subscribe input[type="email"]').val(),
			dataType: "json",
			url: "http://mailman.yale.edu/mailman/subscribe/casa-list",
			complete: function() {
				alert("Thank you for signing up! Please check your email to confirm your subscription.");
			}
		});
	});

});