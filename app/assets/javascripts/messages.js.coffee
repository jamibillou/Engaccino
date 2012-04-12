$ ->
  $('#new_message').bind('ajax:success', (evt, data, status, xhr) -> show_conversation($.parseJSON(xhr.responseText)))

@show_conversation = (contact_id) ->
  $.ajax 'messages/show',
  dataType: 'html'
  type: 'GET'
  data: {contact_id: contact_id}
  beforeSend: -> 
    show("conversation_loader")
  complete: -> 
    hide("conversation_loader")
  success: (data) ->
    $('#conversation').html(data)
    hide('unread_'+contact_id)
    refresh_menu_top()
    $('#new_message').bind('ajax:success', (evt, data, status, xhr) -> show_conversation($.parseJSON(xhr.responseText)))
    
@refresh_menu_top = ->
  $.ajax 'messages/menu_top',
  dataType: 'html'
  type: 'POST'
  success: (data) ->
    $('#messages_menu').html(data)

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
                     
@show_all_messages = ->
  $('#conversation .message').each ->
    if $(this).hasClass("hidden") then $(this).show() and $('#all').hide()