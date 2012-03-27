$ ->    
  initBIP(I18n.t('click_to_edit'))
  manageProfilePicture('image_edit_r','image_button_r','recruiter_image_form')
  manageProfilePicture('image_edit_c','image_button_c','company_image_form')
  
@manageProfilePicture = (image_id,button_id,form_id) ->
  $('#'+image_id).click    -> $('#'+button_id).click()
  $('#'+button_id).change -> $('#'+form_id).submit()
  $('#'+form_id).bind('ajax:complete', (evt, xhr) -> 
    $.ajax 'refresh',
    dataType: 'html',
    type: 'POST',
    success: (data) ->
      $('#recruiter').html(data)
      initBIP(I18n.t('click_to_edit'))
      manageProfilePicture('image_edit_r','image_button_r','recruiter_image_form')
      manageProfilePicture('image_edit_c','image_button_c','company_image_form'))