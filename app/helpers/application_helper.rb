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
  
  def small_trash
    image_tag "small_trash.png", :alt => t('delete'), :class => "small_trash"
  end
  
  def pencil
    image_tag "pencil.png", :alt => t('edit'), :class => "pencil"
  end
  
  def link_to_delete(name, f, title = t('delete'))
    f.hidden_field(:_destroy) + link_to_function(name, "delete_fields(this)", :class => 'button blue round', :title => title)
  end
  
  def link_to_add(name, f, association, title = t('add'))
    new_associated_object = build_association(association, f.object)
    fields = f.fields_for(association, new_associated_object, :child_index => "new_#{association}") { |builder| render("fields_#{association.to_s.singularize}", :f => builder) }
    link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")", :class => 'button blue round', :title => title)
  end
  
  def hide_contact_information?
    params[:action] == 'index'
  end
  
  def build_associations(associations, object)
    associations.each { |association| build_association(association, object) }
  end
  
  def build_association(association, object)
    case association
      when :experiences
        experience = object.experiences.build
        experience.build_company
        experience
      when :educations
        education = object.educations.build
        education.build_school
        degree = education.build_degree
        degree.build_degree_type
        education
      when :languages
        language = object.language_candidates.build.build_language
        language
    end
  end
  
  def link_schools_degrees
    @candidate.educations.each do |education|
      school = education.school
      school.degrees.push(education.degree) unless school.degrees.include? education.degree
      school.save!
    end
  end
end