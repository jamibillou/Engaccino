$ ->    
  initBIP(I18n.t('click_to_edit'))
  
  $('.edit_experience').each                    -> handleAjaxEdition($(this).attr('id'), 'experience', ['show_top','show_timeline', 'candidate']) 
  $('.edit_education').each                     -> handleAjaxEdition($(this).attr('id'), 'education', ['show_top','show_timeline', 'candidate_degree_experience'])
  $('.edit_professional_skill_candidate').each  -> handleAjaxEdition($(this).attr('id'), 'professional_skill_candidate', ['show_top','candidate_professional_skills'])
  $('.edit_interpersonal_skill_candidate').each -> handleAjaxEdition($(this).attr('id'), 'interpersonal_skill_candidate', ['show_top'])
  $('.edit_language_candidate').each            -> handleAjaxEdition($(this).attr('id'), 'language_candidate', ['show_top'])
  $('.edit_certificate_candidate').each         -> handleAjaxEdition($(this).attr('id'), 'certificate_candidate', ['show_top'])
 
  refreshPartialThroughBIPcombo('candidate_company', 'role_BIPcombo')
  refreshPartialThroughBIPcombo('candidate_degree', 'degreetype_BIPcombo')
  
  ## GROS CACA
  $('#edit_image').click    -> $('#image_button').click()
  $('#image_button').change -> $('#image_form').submit()

## OBJECT CREATION 
@handleAjaxCreation = (model, partials) ->
  $('#new_'+model).bind('ajax:success', (evt, data, status, xhr) -> callRefresh(model, data, partials))
	                .bind('ajax:error',   (evt, xhr, status)       -> $('#errors_new_'+model).html(buildErrorMessages(xhr)))

## OBJECT EDITION
@handleAjaxEdition = (form_id, model, partials) ->
  id = form_id.substr(form_id.lastIndexOf('_')+1,form_id.length-form_id.lastIndexOf('_'))
  $('#'+'show_'+model+'_'+id).click -> showForm(model, partials, id)
  $('#'+form_id).bind('ajax:success', (evt, data, status, xhr) -> callRefresh(model, data, partials))
                .bind('ajax:error', (evt, xhr, status) -> $('#errors_'+model+id).html(buildErrorMessages(xhr)))

## SHOW/HIDE FORMS
@showForm = (model, partials, id) ->
  if (typeof(id) == 'undefined') then callNew(model, partials) else show('edit_'+model+'_'+id) and hide('show_'+model+'_'+id)
  
@hideForm = (model, id) ->
  if (typeof(id) == 'undefined') then hide('new_'+model) && show('link_add_'+model) else hide('edit_'+model+'_'+id) and show('show_'+model+'_'+id)

## AJAX CALLS TO CONTROLLERS ACTIONS
@callRefresh = (model, data, partials) ->
  $.ajax 'refresh',
    type: 'POST'
    data: {model: model}
    beforeSend: -> 
      show(model+"_loader")
    complete: -> 
      hide(model+"_loader")
    success: (data) -> 
      $('#'+model+'s').html(data)
      $('.edit_'+model).each -> handleAjaxEdition($(this).attr('id'), model, partials)
      refreshPartials(partials)
      
@callNew = (model, partials) ->
  $.ajax '../'+model+'s/new',
  	beforeSend: -> 
  	  show(model+"_loader")
    complete: -> 
      hide(model+"_loader")															  
  	success: (data) -> 
  	  $('#new_'+model).html(data)
  	  show('new_'+model)
  	  hide('link_add_'+model)
  	  handleAjaxCreation(model, partials)

## REFRESH PARTIALS
@refreshPartials = (partials) ->
  if typeof(partials) != 'undefined'
    refreshPartial(partial) for partial in partials
          
@refreshPartial = (partial) ->
  $.ajax 'refresh',
  type: 'POST'
  data: {partial: partial}
  beforeSend: -> 
    show(partial+"_loader")
  complete: -> 
    hide(partial+"_loader")
  success: (data) ->
    $('#'+partial).html(data)
    initBIP(I18n.t('click_to_edit')) 

@refreshPartialThroughBIPcombo = (partial, BIPcombo) ->
  $('#'+BIPcombo+' span').each ->
    $(this).change ->
      $.ajax 'refresh',
        type: 'POST'
        data: {partial: partial}
        success: (data) -> 
          $('#'+partial).html(data)
          initBIP(I18n.t('click_to_edit'))
          refreshPartialThroughBIPcombo(partial, BIPcombo)

@buildErrorMessages = (xhr) ->
  try 
    errors = $.parseJSON(xhr.responseText)
  catch err
    errors = message: 'JSON Error'
  errorMessages = 'Error(s): '
  errorMessages += error+' '+errors[error]+' ' for error of errors
  errorMessages
    