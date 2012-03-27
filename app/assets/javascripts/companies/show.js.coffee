$ ->    
  initBIP(I18n.t('click_to_edit'))
  manageProfilePicture()
  
@manageProfilePicture = ->
  $('#image_edit').click    -> $('#image_button').click()
  $('#image_button').change -> $('#image_form').submit()
  $('#image_form').bind('ajax:complete', (evt, xhr) -> 
    $.ajax 'up_picture',
    dataType: 'html',
    data: {id: getCompanyId()}
    type: 'POST',
    success: (data) ->
      $('#profile_picture').html(data))
      
@getCompanyId = ->
  arrayParam = window.location.href.split('/')
  arrayParam[4]
