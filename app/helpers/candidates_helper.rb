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
  
  def main_experience_options(candidate, attribute)
    if attribute == :role
      candidate.experiences.map { |experience| role = experience.role ; [ experience.id, "#{role.slice(0..29)}#{'...' if role.length > 30}" ] }
    else 
      candidate.experiences.map { |experience| company = experience.company.name ; [ experience.id, "#{company.slice(0..29)}#{'...' if company.length > 30}" ] }
    end
  end
  
  def main_education_options(candidate, attribute)
    if attribute == :degree_type
      candidate.educations.map { |education| label = education.degree.degree_type.label ; [ education.id, "#{label.slice(0..14)}#{'...' if label.length > 15}" ] }
    else
      candidate.educations.map { |education| label = education.degree.label ; [ education.id, "#{label.slice(0..13)}#{'...' if label.length > 14}" ] }
    end
  end
  
  
end