module UserHelper

  def signup_blocks
    [ { :id => 'personal_information',
    
        :fields => [ { :id => 'first_name',
                       :type => 'text',
                       :new_line => true
                     },
                     { :id => 'last_name',
                       :type => 'text',
                       :new_line => true
                     },
                     { :id => 'year_of_birth',
                       :type => 'text',
                       :new_line => true
                     },
                     { :id => 'country',
                       :type => 'text',
                       :new_line => true
                     }
                   ] }
#      { :id => 'professional_experience',
#        :fields => [ { :id => 'role',
#                       :new_line => false
#                     },
#                     { :id => 'company',
#                       :new_line => false
#                     },
#                     { :id => 'timeframe',
#                       :new_line => false
#                     }
#                   ] },
#      { :id => 'education',
#        :fields => [ { :id => 'degree',
#                       :new_line => false
#                     },
#                     { :id => 'university',
#                       :new_line => false
#                     },
#                     { :id => 'timeframe_education',
#                       :new_line => false
#                     }
#                   ] },
#      { :id => 'status',
#        :fields => [ { :id => 'status',
# =>                    :type => 'select',
#                       :new_line => false
#                     }
#                   ] }
    ]
  end
end
