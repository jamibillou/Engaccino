module UserHelper

  def signup_blocks
    [ { :id => 'personal_information',
    
        :fields => [ { :id => 'first_name',
                       :new_line => true
                     },
                     { :id => 'last_name',
                       :new_line => true
                     },
                     { :id => 'birthdate',
                       :new_line => true
                     },
                     { :id => 'country',
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
#                       :new_line => false
#                     }
#                   ] }
    ]
  end
end
