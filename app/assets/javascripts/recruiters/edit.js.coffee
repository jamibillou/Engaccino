$ ->
  $('#recruiter_first_name').val("") if $('#recruiter_first_name').val() is I18n.t('recruiters.first_name')
  $('#recruiter_last_name').val("") if $('#recruiter_last_name').val() is I18n.t('recruiters.last_name')
  $('#recruiter_city').val("") if $('#recruiter_city').val() is I18n.t('recruiters.city')
  $('#recruiter_country').val("") if $('#recruiter_country').val() is 'Holy See (Vatican City State)'
  $('#recruiter_company_attributes_name').autocomplete({ 
    source: '/ajax/companies',
    minLength: 2, 
    autoFocus: true,
    formatItem: (item) ->
      item.name+' ('+item.city+', '+item.country+')'
    select: (event,ui) ->
      $.ajax '../company_details',
      dataType: 'html',
      type: 'POST',
      data: { id: ui.item.id},
      success: (data) -> 
        $('#recruiter_company_attributes_id').val(ui.item.id)
        $('#company_details').html(data)
        show('company_details')})
  
  $('#company_profile_no').change ->
    hide('company_information')
    hide('colleagues')                                
  $('#company_profile_yes').change ->
    show('company_information')
    show('colleagues')
  $('#recruiter_company_attributes_name').change ->
    hide('company_details') if $('#recruiter_company_attributes_name').val() is ''
  
