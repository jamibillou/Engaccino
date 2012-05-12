$ ->
  init_links(window.location.pathname.substr(1,window.location.pathname.length))

@init_links = (model) ->
  $('.will_paginate a').attr('data-remote', 'true')
  $('.will_paginate a').bind('ajax:complete', (et, e) -> $('#'+model).html(e.responseText); init_links(model))
  $('#all').bind('ajax:complete', (et, e) -> manage_response(e.responseText,I18n.t(model+'.index.title'),model))
  $('#following').bind('ajax:complete', (et, e) -> manage_response(e.responseText,I18n.t('users.index.list_following'),model))
  $('#followers').bind('ajax:complete', (et, e) -> manage_response(e.responseText,I18n.t('users.index.list_followers'),model))

@manage_response = (responseText,title,model) ->
  $('#'+model).html(responseText)
  $('#container_title').html(title)
  init_links(model)

@index = (model, partial) -> 
  $('#container_title').html(I18n.t('users.index.list_'+partial))
  ajax_call('../'+model+'/'+partial, 'POST', {}, '', (data) -> $('#'+model).html(data))