class TwitterFormatValidator < ActiveModel::EachValidator
  
  def validate_each(object, attribute, value)
    unless value =~ /^@(_|([a-z]_)|[a-z])([a-z0-9]+_?)*$/i
      object.errors[attribute] << (options[:message] || "is not formatted properly") 
    end
  end
end