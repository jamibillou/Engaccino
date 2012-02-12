module SkillCandidatesHelper
  
  def level_options_hash
    { t('candidates.skill.beginner_level') => :beginner, 
      t('candidates.skill.intermediaire_level')   => :intermediate, 
      t('candidates.skill.advanced_level')      => :advanced, 
      t('candidates.skill.expert_level') => :expert }
  end
  
  def level_options_array
    [ [ 'beginner', t('candidates.skill.beginner_level') ],
      [ 'intermediate', t('candidates.skill.intermediaire_level') ], 
      [ 'advanced', t('candidates.skill.advanced_level') ],
      [ 'expert', t('candidates.skill.expert_level') ] ]
  end
  
end
