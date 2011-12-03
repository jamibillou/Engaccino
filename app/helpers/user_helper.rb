module UserHelper
  
  def signup_blocks
    [ { :id => 'personal_information',
        :fields => [ { :id => 'first_name', :type => 'text', :new_line => true },
                     { :id => 'last_name', :type => 'text', :new_line => true },
                     { :id => 'year_of_birth', :type => 'text', :new_line => true },
                     { :id => 'country', :type => 'hidden' },
                     { :id => 'country_full_text', :type => 'text', :new_line => true }
                   ] },
      { :id => 'professional_experience',
        :fields => [ { :id => 'role', :type => 'text', :new_line => false },
                     { :id => 'company', :type => 'text', :new_line => false },
                     { :id => 'experience_timeframe', :type => 'text', :new_line => false }
                   ] },
      { :id => 'education',
        :fields => [ { :id => 'degree', :type => 'text', :new_line => false },
                     { :id => 'university', :type => 'text', :new_line => false },
                     { :id => 'education_timeframe', :type => 'text', :new_line => false }
                   ] },
      { :id => 'status',
        :fields => [ { :id => 'status', :type => 'select', :new_line => false,
                       :options => ["available","looking","open","listening","happy"] }
                   ] }
    ]
  end
  
end