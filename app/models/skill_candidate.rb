class SkillCandidate < ActiveRecord::Base
  
  attr_accessible :level, :experience, :description, :skill_attributes
    
  belongs_to :skill
  belongs_to :candidate
  
  validates :candidate, :skill,                                     :presence => true
  validates :description,        :length => { :within => 20..160 }, :presence => true
  validates :level, :experience,                                    :presence => true, :if => :skill_pro?
  validates :level, :experience, :length => { :is => 0 }, :if => :skill_perso?
  
  def skill_pro?
    skill.type == 'SkillPro'
  end
  
  def skill_perso?
    skill.type == 'SkillPerso'
  end
  
end

# == Schema Information
#
# Table name: skill_candidates
#
#  id           :integer(4)      not null, primary key
#  level        :string(255)
#  experience   :integer(4)
#  description  :string(255)
#  candidate_id :integer(4)
#  skill_id     :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#

