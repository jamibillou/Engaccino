module ProfessionalSkillCandidatesHelper
  
  def level_options_hash
    { t('candidates.skill.beginner_level') => :beginner, 
      t('candidates.skill.intermediate_level')   => :intermediate, 
      t('candidates.skill.advanced_level')      => :advanced, 
      t('candidates.skill.expert_level') => :expert }
  end
  
  def level_options_array
    [ [ t('candidates.skill.beginner_level'), 'beginner' ],
      [ t('candidates.skill.intermediate_level'), 'intermediate' ], 
      [ t('candidates.skill.advanced_level'), 'advanced' ],
      [ t('candidates.skill.expert_level'), 'expert' ] ]
  end
  
end
