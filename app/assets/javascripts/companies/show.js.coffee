$ ->    
  initBIP(I18n.t('click_to_edit'))
  manageProfilePicture()
  
  
@manageProfilePicture = ->
  $('#image_edit').click    -> $('#image_button').click()
  $('#image_button').change -> $('#image_form').submit()
  $('#image_form').bind('ajax:complete', (evt, xhr) -> 
    $.ajax 'show',
    dataType: 'html',
    type: 'GET',
    success: (data) ->
      $('#container').html(data))