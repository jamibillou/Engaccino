@index = (partial, method) -> ajax_call('candidates/'+partial, method, {}, '', (data) -> $('#candidates').html(data))
