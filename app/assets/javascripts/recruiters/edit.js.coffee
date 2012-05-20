$ ->
  $('#recruiter_first_name').val("") if $('#recruiter_first_name').val() is I18n.t('recruiters.first_name')
  $('#recruiter_last_name').val("") if $('#recruiter_last_name').val() is I18n.t('recruiters.last_name')
  $('#recruiter_city').val("") if $('#recruiter_city').val() is I18n.t('recruiters.city')
  $('#recruiter_country').val("") if $('#recruiter_country').val() is 'Holy See (Vatican City State)'
  $('#recruiter_company_attributes_name').autocomplete({ source: '/ajax/companies', minLength: 2, autoFocus: true, select: (event,ui) -> 
      ajax_call('../../recruiters/company_details','POST',{ id: ui.item.id },'',(data) ->
        $('#recruiter_company_attributes_id').val(ui.item.id)
        $('#recruiter_company_attributes_url').val(ui.item.url)
        $('#recruiter_company_attributes_city').val(ui.item.city)
        $('#recruiter_company_attributes_country').val(ui.item.country)
        $('#company_details').html(data)
        show('company_details'))})
  
  $('#company_profile_no').change ->
    hide('company_information')
    hide('colleagues')                                
  $('#company_profile_yes').change ->
    show('company_information')
    show('colleagues')
  $('#recruiter_company_attributes_name').change ->
    deleteCompanyDetails() if $('#recruiter_company_attributes_name').val() is ''
    
@deleteCompanyDetails = ->
  $('#recruiter_company_attributes_name').val('')
  $('#recruiter_company_attributes_id').val('')
  $('#recruiter_company_attributes_url').val('')
  $('#recruiter_company_attributes_city').val('')
  $('#recruiter_company_attributes_country').val('')
  hide('company_details')
  
