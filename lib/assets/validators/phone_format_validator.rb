class PhoneFormatValidator < ActiveModel::EachValidator
  
  def validate_each(object, attribute, value)
    unless value =~ /^\+(?:[0-9] ?){6,14}[0-9]$/
      object.errors[attribute] << (options[:message] || "is not formatted properly") 
    end
  end
end