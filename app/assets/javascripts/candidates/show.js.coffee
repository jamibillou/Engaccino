$ ->    
  initBIP(I18n.t('click_to_edit'))
  
  $('.edit_experience').each                    -> handleAjaxEdition($(this).attr('id'), 'experience', ['show_completion','show_timeline', 'candidate']) 
  $('.edit_education').each                     -> handleAjaxEdition($(this).attr('id'), 'education', ['show_completion','show_timeline', 'candidate_degree_experience'])
  $('.edit_professional_skill_candidate').each  -> handleAjaxEdition($(this).attr('id'), 'professional_skill_candidate', ['show_completion','candidate_professional_skills'])
  $('.edit_interpersonal_skill_candidate').each -> handleAjaxEdition($(this).attr('id'), 'interpersonal_skill_candidate', ['show_completion'])
  $('.edit_language_candidate').each            -> handleAjaxEdition($(this).attr('id'), 'language_candidate', ['show_completion'])
  $('.edit_certificate_candidate').each         -> handleAjaxEdition($(this).attr('id'), 'certificate_candidate', ['show_completion'])
 
  refreshPartialThroughBIPcombo('candidate_company', 'role_BIPcombo')
  refreshPartialThroughBIPcombo('candidate_degree', 'degreetype_BIPcombo')
  manageProfilePicture()
  
  $('#new_message').submit -> show('message_status')
  $('#new_message').bind('ajax:success', (evt, data, status, xhr) -> 
                      $('#message_content').val('')
                      ajax_call('../messages/card_messages','POST',{id:$.parseJSON(xhr.responseText)}, '', (data) -> $('#card_messages').html(data)))
                   .bind('ajax:error',   (evt, xhr, status)       -> $('#message_status').html(buildErrorMessages(xhr)))

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
  ajax_call('refresh','POST',{model: model},model+'_loader', (data) -> 
    $('#'+model+'s').html(data)
    $('.edit_'+model).each -> handleAjaxEdition($(this).attr('id'), model, partials)
    refreshPartials(partials))      
      
@callNew = (model, partials) ->
  ajax_call('../'+model+'s/new','GET',{},model+'_loader', (data) ->
    $('#new_'+model).html(data)
    show('new_'+model)
  	hide('link_add_'+model)
  	handleAjaxCreation(model, partials))

## REFRESH PARTIALS
@refreshPartials = (partials) ->
  if typeof(partials) != 'undefined'
    refreshPartial(partial) for partial in partials

@refreshPartial = (partial) ->
  ajax_call('refresh','POST',{partial: partial},partial+'_loader', (data) ->
    $('#'+partial).html(data)
    initBIP(I18n.t('click_to_edit'))
    manageProfilePicture() if partial is 'candidate')

@refreshPartialThroughBIPcombo = (partial, BIPcombo) ->
  $('#'+BIPcombo+' span').each ->
    $(this).change ->
      ajax_call('refresh','POST',{partial: partial},'', (data) ->
        $('#'+partial).html(data)
        initBIP(I18n.t('click_to_edit'))
        refreshPartialThroughBIPcombo(partial, BIPcombo))

@manageProfilePicture = ->
  $('#image_edit').click    -> $('#image_button').click()
  $('#image_button').change -> $('#image_form').submit()
  $('#image_form').bind('ajax:complete', (evt, xhr) -> 
    hide("picture_upload_error")
    refreshPartial('candidate'))    