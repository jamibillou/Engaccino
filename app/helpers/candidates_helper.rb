module CandidatesHelper  
  
  def status_options
    { t('candidates.available_status') => :available, 
      t('candidates.looking_status')   => :looking, 
      t('candidates.open_status')      => :open, 
      t('candidates.listening_status') => :listening, 
      t('candidates.happy_status')     => :happy }
  end
  
  def display_period(object)
    unless object.start_year == object.end_year
      "#{object.start_year} - #{object.end_year}"
    else
      "#{object.start_month}/#{object.start_year} - #{object.end_month}/#{object.end_year}"
    end
  end
  
  def experience_total(experiences)
    experiences.first.end_year - experiences.last.start_year
  end  
  
end