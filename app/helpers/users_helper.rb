module UsersHelper
  
  def status_options
    [ t('candidates.available_status'), t('candidates.looking_status'), t('candidates.open_status'), t('candidates.listening_status'), t('candidates.happy_status') ]
  end
  
  def display_country(country)
    country.split(',')[0].split('(')[0]
  end
end