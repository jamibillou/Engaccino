class ProfessionalSkillCandidate < ActiveRecord::Base
  
  attr_accessible :level, :experience, :description, :professional_skill_attributes, :professional_skill
    
  belongs_to :professional_skill
  belongs_to :candidate
  
  accepts_nested_attributes_for :professional_skill, :allow_destroy => true
  
  validates :candidate, :professional_skill,                                                                    :presence => true
  validates :description,        :length    => { :within => 20..160 },                                          :presence => true
  validates :level,              :inclusion => { :in => [ 'beginner', 'intermediate', 'advanced', 'expert' ] }, :presence => true
  validates :experience,         :inclusion => { :in => (1..60).to_a },                                         :presence => true
  
  #after_create   :update_completion_new
  #after_destroy  :update_completion_del
  
  private  
  
    def update_completion_new
      candidate.update_attributes :profile_completion => candidate.profile_completion+5 if candidate.professional_skill_candidates.count < 4
    end
    
    def update_completion_del
      candidate.update_attributes :profile_completion => candidate.profile_completion-5 if candidate.professional_skill_candidates.count < 3
    end

end
# == Schema Information
#
# Table name: professional_skill_candidates
#
#  id                    :integer(4)      not null, primary key
#  level                 :string(255)
#  experience            :integer(4)
#  description           :string(255)
#  candidate_id          :integer(4)
#  professional_skill_id :integer(4)
#  created_at            :datetime
#  updated_at            :datetime
#

