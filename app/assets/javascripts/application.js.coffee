//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require jquery.purr
//= require best_in_place
//= require i18n
//= require i18n/translations

$ ->
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
  
@show = (id) -> $('#'+id).show()
@hide = (id) -> $('#'+id).hide()
