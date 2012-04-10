$ ->
  $('#new_message').bind('ajax:success', (evt, data, status, xhr) -> show_conversation($.parseJSON(xhr.responseText)))

@show_conversation = (contact_id) ->
  $.ajax 'messages/conversation',
  dataType: 'html'
  type: 'GET'
  data: {contact_id: contact_id}
  beforeSend: -> 
    show("conversation_loader")
  complete: -> 
    hide("conversation_loader")
  success: (data) ->
    $('#conversation').html(data)
    $('#new_message').bind('ajax:success', (evt, data, status, xhr) -> show_conversation($.parseJSON(xhr.responseText)))