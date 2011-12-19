module ApplicationHelper

  def logo
    image_tag "logo.png", :alt => "Engaccino", :id => "logo"
  end
  
  def title 
    base_title = "Engaccino"
    @title.nil? ? base_title : "#{base_title} | #{@title}"
  end
  
  def settings
    image_tag "settings.png", :alt => t('settings'), :class => "settings"
  end
  
  def trash
    image_tag "trash.png", :alt => t('delete'), :class => "trash"
  end
  
  def link_to_remove_fields(name, f, css_class)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)", :class => css_class)
  end
  
  def link_to_add_fields(name, f, association, css_class)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function name, "add_fields(this, '#{association}', '#{escape_javascript(fields)}')", :class => css_class
  end
end