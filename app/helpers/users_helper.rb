module UsersHelper
  
  def display_country(country)
    country.split(',')[0].split('(')[0]
  end
end