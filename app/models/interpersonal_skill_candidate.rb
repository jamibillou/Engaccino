class InterpersonalSkillCandidate < ActiveRecord::Base
  
  attr_accessible :description, :interpersonal_skill_attributes, :interpersonal_skill
    
  belongs_to :interpersonal_skill
  belongs_to :candidate
  
  accepts_nested_attributes_for :interpersonal_skill, :allow_destroy => true
  
  validates :candidate, :interpersonal_skill,                                       :presence => true
  validates :description,                     :length    => { :within => 20..160 }, :presence => true

  after_create   :update_completion_new
  after_destroy  :update_completion_del
  
  private
  
    def update_completion_new
      candidate.update_attributes :profile_completion => candidate.profile_completion+5 if candidate.interpersonal_skill_candidates.count < 4
    end
    
    def update_completion_del
      candidate.update_attributes :profile_completion => candidate.profile_completion-5 if candidate.interpersonal_skill_candidates.count < 3
    end
  
end

# == Schema Information
#
# Table name: interpersonal_skill_candidates
#
#  id                     :integer(4)      not null, primary key
#  description            :string(255)
#  candidate_id           :integer(4)
#  interpersonal_skill_id :integer(4)
#  created_at             :datetime
#  updated_at             :datetime
#

