//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require jquery.purr
//= require best_in_place
//= require i18n
//= require i18n/translations
//= require rails.validations

months = { 1:I18n.t('months.january'), 2:I18n.t('months.february'), 3:I18n.t('months.march'), 4:I18n.t('months.april'), 5:I18n.t('months.may'), 6:I18n.t('months.june'), 7:I18n.t('months.july'), 8:I18n.t('months.august'), 9:I18n.t('months.september'), 10:I18n.t('months.october'), 11:I18n.t('months.november'), 12:I18n.t('months.december') }

$ ->
  ## AUTOCOMPLETE
  $('input.country').each -> $(this).autocomplete({ source:"/ajax/countries", minLength: 2, autoFocus: true })
  $('input.month').each   -> 
    $(this).autocomplete({ source:"/ajax/months", minLength: 1, select: (event,ui) -> fillMonthInput($(this).attr("name"),ui.item.index) })
    $(this).change -> fillMonthInput($(this).attr("name"),getKey($(this).val()))
    $(this).val(months[$(this).val()])
  
  customForm('search_bar_form', '')
  $('#close_flash').click -> hide('flash')
    
## CUSTOMS ALL FIELDS OF THE GIVEN FORM
@customForm = (formId,translationPath) ->
  $("#"+formId+" input").each ->
    customInputField($(this).attr("id"), I18n.t(translationPath+$(this).attr("id")), formId, $(this).attr("type")) unless $(this).hasClass("hidden") or $(this).attr("type") is "hidden"
  $("#"+formId).submit ->
    emptyDefaultValuesForm(formId, translationPath)
    
## CUSTOMS THE GIVEN FIELD
@customInputField = (inputFieldId, inputFieldDefaultValue, formId, inputFieldType) ->
  if inputFieldType is "password" then styleInputPasswordField(inputFieldId, inputFieldDefaultValue) else styleInputField(inputFieldId, inputFieldDefaultValue)

## STYLES THE GIVEN INPUT FIELD
@styleInputField = (inputFieldId, inputFieldDefaultValue) ->
  $("#"+inputFieldId).ready ->
    if $("#"+inputFieldId).val() is inputFieldDefaultValue
      $("#"+inputFieldId).css("color", "#7c7777")
      $("#"+inputFieldId).css("font-style", "italic")
    else
      $("#"+inputFieldId).css("color", "#444")
      $("#"+inputFieldId).css("font-style", "normal")
  
  $("#"+inputFieldId).focus -> $("#"+inputFieldId).css("color", "#acacb3") if $("#"+inputFieldId).val() is inputFieldDefaultValue

  $("#"+inputFieldId).keydown ->
    if $("#"+inputFieldId).val() is inputFieldDefaultValue
      $("#"+inputFieldId).val("") 
      $("#"+inputFieldId).css("font-style", "normal") 
      $("#"+inputFieldId).css("color", "#444")

  $("#"+inputFieldId).blur ->
    if $("#"+inputFieldId).val() is "" or $("#"+inputFieldId).val() is inputFieldDefaultValue
      $("#"+inputFieldId).css("font-style", "italic")
      $("#"+inputFieldId).css("color", "#7c7777")
      if $("#"+inputFieldId).val() is ""
        $("#"+inputFieldId).val(inputFieldDefaultValue)
        
## STYLES THE GIVEN PASSWORD FIELD
@styleInputPasswordField = (inputFieldId, inputFieldDefaultValue) ->
  $("#"+inputFieldId).after("<input class='field' id='"+inputFieldId+"_placeholder' type='text' value='"+inputFieldDefaultValue+"' />")
  $("#"+inputFieldId+"_placeholder").css("color", "#7c7777")
  $("#"+inputFieldId+"_placeholder").css("font-style", "italic")
  show(inputFieldId+"_placeholder")
  hide(inputFieldId)
  
  $("#"+inputFieldId+"_placeholder").focus -> $("#"+inputFieldId+"_placeholder").css("color", "#acacb3")
  
  $("#"+inputFieldId+"_placeholder").keydown ->
    hide(inputFieldId+"_placeholder")
    $("#"+inputFieldId).val("")
    show(inputFieldId) 
    $("#"+inputFieldId).focus()
  
  $("#"+inputFieldId+"_placeholder").blur ->
    $("#"+inputFieldId+"_placeholder").css("color", "#7c7777") if $("#"+inputFieldId+"_placeholder").val() is "" or $("#"+inputFieldId+"_placeholder").val() is inputFieldDefaultValue     
  
  $("#"+inputFieldId).blur ->
    if $("#"+inputFieldId).val() is "" or $("#"+inputFieldId).val() is inputFieldDefaultValue    
      show(inputFieldId+"_placeholder") 
      hide(inputFieldId)
      $("#"+inputFieldId+"_placeholder").css("color", "#7c7777")

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
  
@fillMonthInput = (name,index) ->
  $("input[name^=candidate]").each ->
    $(this).val(index) if $(this).attr("name") is name and $(this).hasClass("hidden")

@getKey = (elem) ->
  (return key if elem is months[key]) for key of months
  if elem != "" then return -1 else return ""
    
@show = (id) -> $('#'+id).show()
@hide = (id) -> $('#'+id).hide()
