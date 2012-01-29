module CandidatesHelper  
  
  def status_options
    { t('candidates.available_status') => :available, 
      t('candidates.looking_status')   => :looking, 
      t('candidates.open_status')      => :open, 
      t('candidates.listening_status') => :listening, 
      t('candidates.happy_status')     => :happy }
  end
  
  def status_again
    [ ['available', t('candidates.available_status')],
      ['looking', t('candidates.looking_status')], 
      ['open', t('candidates.open_status')],
      ['listening', t('candidates.listening_status')], 
      ['happy', t('candidates.happy_status')] ]
  end
  
end