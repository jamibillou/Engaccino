$ ->
  $('#recruiter_first_name').val("") if $('#recruiter_first_name').val() is I18n.t('recruiters.first_name')
  $('#recruiter_last_name').val("") if $('#recruiter_last_name').val() is I18n.t('recruiters.last_name')
  $('#recruiter_city').val("") if $('#recruiter_city').val() is I18n.t('recruiters.city')
  $('#recruiter_country').val("") if $('#recruiter_country').val() is 'Holy See (Vatican City State)'
  
  $('#company_profile_no').change ->
    hide('company_information')
    hide('colleagues')                                
  $('#company_profile_yes').change ->
    show('company_information')
    show('colleagues')
