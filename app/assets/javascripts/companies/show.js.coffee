$ ->    
  initBIP(I18n.t('click_to_edit'))
  manageProfilePicture()
  
@manageProfilePicture = ->
  $('#image_edit').click    -> $('#image_button').click()
  $('#image_button').change -> $('#image_form').submit()
  $('#image_form').bind('ajax:complete', (evt, xhr) -> ajax_call('up_picture','POST',{id: getCompanyId()},'',(data) -> $('#profile_picture').html(data)))
      
@getCompanyId = ->
  arrayParam = window.location.href.split('/')
  arrayParam[4]
