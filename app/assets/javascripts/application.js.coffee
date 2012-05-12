//= require jquery
//= require jquery-ui
//= require jquery.purr
//= require jquery_ujs
//= require jquery.remotipart
//= require best_in_place
//= require i18n
//= require i18n/translations

$ ->
  $('input.country').each -> $(this).autocomplete({ source:"/ajax/countries", minLength: 2, autoFocus: true })
  $('#close_flash').click -> hide('flash')  

## CUSTOMS ALL FIELDS OF THE GIVEN FORM
@customForm = (formId,translationPath) ->
  $("#"+formId+" input").each ->
    customInputField($(this).attr("id"), I18n.t(translationPath+$(this).attr("id")), formId, $(this).attr("type")) unless $(this).hasClass("hidden") or $(this).attr("type") is "hidden"
  $("#"+formId).submit ->
    emptyDefaultValuesForm(formId, translationPath)

## GIVEN A FORM, EMPTIES FIELDS THAT HAVE DEFAULT VALUES
@emptyDefaultValuesForm = (formId, translationPath) ->
  $("#"+formId+" input").each ->
    emptyDefaultValueField($(this).attr("id"), I18n.t(translationPath+$(this).attr("id"))) unless $(this).hasClass("hidden") or $(this).attr("type") is "hidden"

## EMPTIES THE GIVEN FIELD IF IT HAS THE DEFAULT VALUE
@emptyDefaultValueField = (inputFieldId, inputFieldDefaultValue) ->
  $("#"+inputFieldId).val("") if $("#"+inputFieldId).val() is inputFieldDefaultValue

## REVEALS THE GIVEN ITEM WHEN THE MOUSE IS OVER THE GIVEN BLOCK
@revealItem = (itemToRevealId, blockToHoverId) ->
  $("#"+blockToHoverId).mouseenter -> show(itemToRevealId)
  $("#"+blockToHoverId).mouseleave -> hide(itemToRevealId)

@delete_fields = (link) ->
  $(link).prev("input[type=hidden]").val("1")
  $(link).parent().hide()

@add_fields = (link, association, content) ->
  new_id = new Date().getTime()
  regexp = new RegExp("new_" + association, "g")
  $(link).before(content.replace(regexp, new_id))

@initBIP = (title) ->
  $('.best_in_place').best_in_place()
  $('span.best_in_place').each -> $(this).attr('title', title)

@buildErrorMessages = (xhr) ->
  try 
    errors = $.parseJSON(xhr.responseText)
  catch err
    errors = message: 'JSON Error'
  errorMessages = 'Error(s): '
  errorMessages += error+' '+errors[error]+' ' for error of errors
  errorMessages

@ajax_call = (url,type,data,loader,success_function) ->
  $.ajax url,
  dataType: 'html'
  data: data
  type: type
  success: (data) ->
    success_function(data) if success_function?
  beforeSend: ->
    show(loader) unless loader is ''
  complete: ->
    hide(loader) unless loader is ''
      
@show = (id) -> $('#'+id).show()
@hide = (id) -> $('#'+id).hide()