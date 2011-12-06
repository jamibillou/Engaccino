module UserHelper
  
  def status_options
    [ t('user.available_status'), t('user.looking_status'), t('user.open_status'), t('user.listening_status'), t('user.happy_status') ]
  end
end