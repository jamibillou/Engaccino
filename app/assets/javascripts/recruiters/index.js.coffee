@index = (partial, method) -> ajax_call('recruiters/'+partial, method, {}, '', (data) -> $('#recruiters').html(data))
