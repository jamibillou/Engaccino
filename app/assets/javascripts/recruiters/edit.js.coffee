$ ->

  $('#company_profile_yes').change ->
    hide('company_information')
    hide('colleagues')
                                     
  $('#company_profile_no').change ->
    show('company_information')
    show('colleagues')
