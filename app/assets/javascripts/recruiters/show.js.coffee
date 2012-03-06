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
  $('#edit_recruiter_image').click    -> $('#recruiter_image_button').click()
  $('#recruiter_image_button').change -> $('#recruiter_image_form').submit()
  $('#edit_company_image').click      -> $('#company_image_button').click()
  $('#company_image_button').change   -> $('#company_image_form').submit()