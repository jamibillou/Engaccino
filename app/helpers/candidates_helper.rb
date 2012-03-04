module CandidatesHelper  
  
  def status_options_hash
    { t('candidates.available_status') => :available, 
      t('candidates.looking_status')   => :looking, 
      t('candidates.open_status')      => :open, 
      t('candidates.listening_status') => :listening, 
      t('candidates.happy_status')     => :happy }
  end
  
  def status_options_array
    [ [ 'available', t('candidates.available_status') ],
      [ 'looking', t('candidates.looking_status') ], 
      [ 'open', t('candidates.open_status') ],
      [ 'listening', t('candidates.listening_status') ], 
      [ 'happy', t('candidates.happy_status') ] ]
  end
  
  def month_hash
    { 1 => t('months.january'), 2 => t('months.february'), 3 => t('months.march'), 4 => t('months.april'),
      5 => t('months.may'), 6 => t('months.june'), 7 => t('months.july'), 8 => t('months.august'),
      9 => t('months.september'), 10 => t('months.october'), 11 => t('months.november'), 12 => t('months.december') } 
  end
  
  def main_experience_options(candidate)
    candidate.experiences.map { |experience| role = experience.role ; [ experience.id, "#{role.slice(0..29)}#{'...' if role.length > 30}" ] }
  end
  
  def main_education_options(candidate)
    candidate.educations.map { |education| label = education.degree.degree_type.label.split('(')[0] ; [ education.id, "#{label.slice(0..13)}#{'..' if label.length > 14}" ] }
  end
  
end