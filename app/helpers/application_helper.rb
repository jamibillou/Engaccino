module ApplicationHelper
  
  def title 
    base_title = 'Engaccino'
    @title.nil? ? base_title : "#{base_title} | #{@title}"
  end
  
  def image(name, alt = '')
    image_tag "#{name}.png", :alt => (alt.blank? ? t(name).humanize : alt), :class => name
  end
  
  def link_to_delete(name, f, title = t('delete'))
    f.hidden_field(:_destroy) + link_to_function(name, 'delete_fields(this)', :class => 'button blue round', :title => title)
  end
  
  def link_to_add(name, f, association, title = t('add'))
    new_associated_object = (association == 'education' ? build_education : build_experience)
    fields = f.fields_for(association, new_associated_object, :child_index => "new_#{association}") { |builder| render("fields_#{association.to_s.singularize}", :f => builder) }
    link_to_function(name, "add_fields(this, '#{association}', '#{escape_javascript(fields)}')", :class => 'button blue round', :title => title)
  end
  
  def hide_contact_information?
    params[:action] == 'index'
  end
  
  def build_education
    education = @candidate.educations.build ; education.build_school ; degree = education.build_degree ; degree.build_degree_type
    education
  end
  
  def build_experience
    experience = @candidate.experiences.build ; experience.build_company
    experience
  end
  
  def associate_schools_and_degrees
    @candidate.educations.each { |education| school = education.school ; school.degrees.push education.degree ; school.save! unless school.degrees.include? education.degree }
  end
end