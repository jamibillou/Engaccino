module CandidatesHelper  
  
  def status_options
    { t('candidates.available_status') => :available, 
      t('candidates.looking_status')   => :looking, 
      t('candidates.open_status')      => :open, 
      t('candidates.listening_status') => :listening, 
      t('candidates.happy_status')     => :happy }
  end
  
  def build_associations
    build_experience
    build_education
    build_language
  end
  
  def build_experience
    @candidate.experiences.build.build_company
  end
  
  def build_education
    @education = @candidate.educations.build
    @education.build_school
    @degree = @education.build_degree
    @degree.build_degree_type
  end
  
  def build_language
    @candidate.language_candidates.build.build_language
  end
  
  def link_schools_degrees
    @candidate.educations.each do |education|
      school = education.school
      school.degrees.push(education.degree) unless school.degrees.include? education.degree
      school.save!
    end
  end
end
