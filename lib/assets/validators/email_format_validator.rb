class EmailFormatValidator < ActiveModel::EachValidator
  
  def validate_each(object, attribute, value)
    unless value =~ /^[\w+\d\-.]+@[a-z\d\-.]+\.[a-z]{2,3}(\.[a-z]{2,3})?$/i
      object.errors[attribute] << (options[:message] || "is not formatted properly") 
    end
  end
end