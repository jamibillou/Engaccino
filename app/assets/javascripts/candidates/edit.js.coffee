months = { 1:I18n.t('months.january'), 2:I18n.t('months.february'), 3:I18n.t('months.march'), 4:I18n.t('months.april'), 5:I18n.t('months.may'), 6:I18n.t('months.june'), 7:I18n.t('months.july'), 8:I18n.t('months.august'), 9:I18n.t('months.september'), 10:I18n.t('months.october'), 11:I18n.t('months.november'), 12:I18n.t('months.december') }

$ ->
  $('#candidate_first_name').val("") if $('#candidate_first_name').val() is I18n.t('candidates.first_name')
  $('#candidate_last_name').val("") if $('#candidate_last_name').val() is I18n.t('candidates.last_name')
  $('#candidate_city').val("") if $('#candidate_city').val() is I18n.t('candidates.city')
  $('#candidate_country').val("") if $('#candidate_country').val() is 'Holy See (Vatican City State)'
  
  $('input.month').each -> 
    $(this).autocomplete({ source:"/ajax/months", minLength: 1, select: (event,ui) -> fillMonthInput($(this).attr("name"),ui.item.index) })
    $(this).change -> fillMonthInput($(this).attr("name"),getKey($(this).val()))
    $(this).val(months[$(this).val()])
  
@fillMonthInput = (name,index) ->
  $("input[name^=candidate]").each ->
    $(this).val(index) if $(this).attr("name") is name and $(this).hasClass("hidden")

@getKey = (elem) ->
  (return key if elem is months[key]) for key of months
  if elem != "" then return -1 else return ""