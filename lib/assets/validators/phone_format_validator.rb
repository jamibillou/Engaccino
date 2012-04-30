class PhoneFormatValidator < ActiveModel::EachValidator
  
  def validate_each(object, attribute, value)
    unless value =~ /^\+(?:[0-9] ?){6,14}[0-9]$/
      object.errors[attribute] << (options[:message] || I18n.t('activerecord.errors.messages.phone_format')) 
    end
  end
end