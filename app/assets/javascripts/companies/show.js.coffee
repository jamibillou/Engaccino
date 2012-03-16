$ ->    
  initBIP(I18n.t('click_to_edit'))
  
  $('#image_form').bind('ajax:success', (evt, data, status, xhr) -> 
                    alert("success")
                    hide("picture_upload_error"))
                  .bind('ajax:error', (evt, xhr, status) -> 
                    $("#picture_upload_error").html(xhr.responseText+"<br/><br/>")
                    show("picture_upload_error"))
  
  ## GROS CACA
  $('#image_edit').click    -> $('#image_button').click()
  $('#image_button').change -> $('#image_form').submit()