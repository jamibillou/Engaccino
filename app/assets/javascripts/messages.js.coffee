$ ->
  $('#new_message').bind('ajax:success', (evt, data, status, xhr) -> show_conversation($.parseJSON(xhr.responseText)))

@show_conversation = (current_contact) ->
  refresh_menu_left(current_contact)
  $.ajax 'messages/show',
  dataType: 'html'
  type: 'GET'
  data: {current_contact: current_contact}
  beforeSend: -> 
    show("conversation_loader")
  complete: -> 
    hide("conversation_loader")
  success: (data) ->
    $('#conversation').html(data)
    hide('unread_'+current_contact)
    refresh_menu_top()
    $('#new_message').bind('ajax:success', (evt, data, status, xhr) -> show_conversation($.parseJSON(xhr.responseText)))
    
@refresh_menu_top = ->
  ajax_call('messages/menu_top','POST',{}, (data) -> $('#messages_menu').html(data))
    
@refresh_menu_left = (current_contact) ->
  ajax_call('messages/menu_left','POST',{ current_contact: current_contact}, (data) -> $('#menu_left').html(data))

@new_conversation = ->
  $.ajax 'messages/new',
  dataType: 'html'
  type: 'GET'
  success: (data) ->
    $('#conversation').html(data)
    $('#recipient').autocomplete({ 
      source:"/ajax/recipients", 
      minLength: 2, 
      autoFocus: true,
      select: (event,ui) ->
        $('#message_recipient_id').val(ui.item.id)
    })
    $('#new_message').bind('ajax:success', (evt, data, status, xhr) -> show_conversation($.parseJSON(xhr.responseText)))
                     .bind('ajax:error', (evt, xhr, status)         -> $('#message_errors').html(buildErrorMessages(xhr)))

@archive_conversation = (current_contact) ->
  if(confirm(I18n.t('delete')+I18n.t('_?')))
    $.ajax 'messages/archive',
    dataType: 'html'
    type: 'POST'
    data: { current_contact : current_contact}
    success: (data) ->
      show_conversation()
                     
@show_all_messages = ->
  $('#conversation .message').each ->
    if $(this).hasClass("hidden") then $(this).show() and $('#all').hide()