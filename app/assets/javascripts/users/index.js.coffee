@index = (model, partial) -> 
  $('#container_title').html(I18n.t('users.index.list_'+partial))
  ajax_call(model+'/'+partial, 'POST', {}, '', (data) -> $('#'+model).html(data))