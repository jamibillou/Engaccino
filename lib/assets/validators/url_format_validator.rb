class UrlFormatValidator < ActiveModel::EachValidator
  
  def validate_each(object, attribute, value)
    unless value =~ /^(http|https):\/\/((www(\d){0,3}?.)|([a-z0-9\-_]{1,63}.)+)?[a-z0-9\-_]+(.{1}[a-z]{2,4}){1,2}(\/[a-z0-9\-_]+)*$/
      object.errors[attribute] << (options[:message] || "is not formatted properly") 
    end
  end
end