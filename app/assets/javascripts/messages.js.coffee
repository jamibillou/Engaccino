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
    refresh_menu()
    $('#new_message').bind('ajax:success', (evt, data, status, xhr) -> show_conversation($.parseJSON(xhr.responseText)))
    
@refresh_menu = ->
  $.ajax 'messages/refresh_menu',
  dataType: 'html'
  type: 'POST'
  success: (data) ->
    $('#messages_menu').html(data)

@add_message = ->
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
        alert($('#message_recipient_id').val())})
    $('#new_message').bind('ajax:success', (evt, data, status, xhr) -> show_conversation($.parseJSON(xhr.responseText)))
                     .bind('ajax:error', (evt, xhr, status)         -> $('#message_errors').html(buildErrorMessages(xhr)))
  
