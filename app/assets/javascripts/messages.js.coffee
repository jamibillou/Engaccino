@show_conversation = (contact_id) ->
  $.ajax 'messages/conversation',
  dataType: 'html'
  type: 'GET'
  data: {contact_id: contact_id}
  beforeSend: -> 
    show("messages_loader")
  complete: -> 
    hide("messages_loader")
  success: (data) ->
    $('#conversation').html(data)