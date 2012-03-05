class Recruiter < User
  
  attr_accessible :quote
  
  belongs_to :company
  
  validates :quote, :length => { :maximum => 200 }
end
