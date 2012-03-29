class Message < ActiveRecord::Base
  
  attr_accessible :content
    
  belongs_to :author,    :class_name => 'User'
  belongs_to :recipient, :class_name => 'User'
    
  validates :content, :length => { :maximum => 140 }, :presence => true
  validates :author_id,                               :presence => true
  validates :recipient_id,                            :presence => true
end

# == Schema Information
#
# Table name: messages
#
#  id         :integer(4)      not null, primary key
#  content    :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

