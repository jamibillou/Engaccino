module UsersHelper
  
  def status_options
    [ t('users.available_status'), t('users.looking_status'), t('users.open_status'), t('users.listening_status'), t('users.happy_status') ]
  end
  
  def display_country(country)
    country.split(',')[0].split('(')[0]
  end
end