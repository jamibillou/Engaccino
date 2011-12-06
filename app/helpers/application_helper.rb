module ApplicationHelper

  def logo
    image_tag "logo.png", :alt => "Engaccino", :id => "logo"
  end
  
  def title 
    base_title = "Engaccino"
    @title.nil? ? base_title : "#{base_title} | #{@title}"
  end
  
  def menu_items
    unless signed_in?
      [{:title => t(:menu_overview),  :path => root_path,                     :selected => (t(:menu_overview) == @title)},
       {:title => t(:menu_tour),      :path => tour_path,                     :selected => (t(:menu_tour) == @title)},
       {:title => t(:menu_pricing),   :path => pricing_path,                  :selected => (t(:menu_pricing) == @title)},
       {:title => t(:menu_about),     :path => about_path,                    :selected => (t(:menu_about) == @title)},
       {:title => t(:menu_contact),   :path => contact_path,                  :selected => (t(:menu_contact) == @title)}]
    else
      [{:title => t(:menu_dashboard), :path => '#',                           :selected => (t(:menu_dashboard) == @title)},
       {:title => t(:menu_profile),   :path => user_path(@current_user),      :selected => ("#{@current_user.first_name} #{@current_user.last_name}" == @title)},
       {:title => t(:menu_edit),      :path => edit_user_path(@current_user), :selected => (t('user.edit.title') == @title)},
       {:title => t(:menu_users),     :path => users_path,                    :selected => (t('user.index.title') == @title)}]
    end
  end
  
  def settings
    image_tag "settings.png", :alt => t('settings'), :class => "settings"
  end
  
  def trash
    image_tag "trash.png", :alt => t('delete'), :class => "trash"
  end
end