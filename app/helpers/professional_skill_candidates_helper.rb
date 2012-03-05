module ProfessionalSkillCandidatesHelper
  
  def level_options_hash
    { t('skills.beginner')     => :beginner, 
      t('skills.intermediate') => :intermediate, 
      t('skills.advanced')     => :advanced, 
      t('skills.expert')       => :expert }
  end
  
  def level_options_array
    [ [ t('skills.beginner'),     'beginner' ],
      [ t('skills.intermediate'), 'intermediate' ], 
      [ t('skills.advanced'),     'advanced' ],
      [ t('skills.expert'),       'expert' ] ]
  end
end
