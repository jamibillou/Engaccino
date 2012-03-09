$ ->    
  initBIP(I18n.t('click_to_edit'))
  
  $('#recruiter_image_form').bind('ajax:success', (evt, data, status, xhr) -> 
                    alert("success")
                    hide("recruiter_picture_upload_error"))
                  .bind('ajax:error', (evt, xhr, status) -> 
                    $("#recruiter_picture_upload_error").html(xhr.responseText+"<br/><br/>")
                    show("recruiter_picture_upload_error"))
                    
  $('#company_image_form').bind('ajax:success', (evt, data, status, xhr) -> 
                    alert("success")
                    hide("company_picture_upload_error"))
                  .bind('ajax:error', (evt, xhr, status) -> 
                    $("#company_picture_upload_error").html(xhr.responseText+"<br/><br/>")
                    show("company_picture_upload_error"))
  
  ## GROS CACA
  $('#image_edit_r').click    -> $('#image_button_r').click()
  $('#image_button_r').change -> $('#recruiter_image_form').submit()
  $('#image_edit_c').click    -> $('#image_button_c').click()
  $('#image_button_c').change -> $('#company_image_form').submit()