module CandidatesHelper  
  
  def status_options
    { t('candidates.available_status') => :available, 
      t('candidates.looking_status')   => :looking, 
      t('candidates.open_status')      => :open, 
      t('candidates.listening_status') => :listening, 
      t('candidates.happy_status')     => :happy }
  end
  
  def experience_period(experience)
    unless experience.start_year == experience.end_year
      "#{experience.start_year} - #{experience.end_year}"
    else
      "#{experience.start_month}/#{experience.start_year} - #{experience.end_month}/#{experience.end_year}"
    end
  end
  
  def experience_total(experiences)
    experiences.first.end_year - experiences.last.start_year
  end
  
end