module LanguageCandidatesHelper
  
  def language_level_options_hash
    { t('languages.beginner')     => :beginner, 
      t('languages.intermediate') => :intermediate, 
      t('languages.fluent')       => :fluent, 
      t('languages.native')       => :native }
  end
  
  def language_level_options_array
    [ [ t('languages.beginner'),     'beginner' ],
      [ t('languages.intermediate'), 'intermediate' ], 
      [ t('languages.fluent'),       'fluent' ],
      [ t('languages.native'),       'native' ] ]
  end
end
