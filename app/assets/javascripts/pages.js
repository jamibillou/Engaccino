/* Functions calls when the page has just finished to load */
$(document).ready(function()
{
	$("#search_bar").click(function()
	{
		$("#search_bar_input").attr("value","");
		$("#search_bar_input").css("color","black");
	})		
})
