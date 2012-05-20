@show_results = (type) ->
  hide('candidates'); hide('recruiters'); hide('companies')
  show(type)
  $('#candidates_link').removeClass('selected');$('#recruiters_link').removeClass('selected');$('#companies_link').removeClass('selected')
  $('#'+type+'_link').addClass('selected')
