class Message < ActiveRecord::Base
  
  attr_accessible :content
    
  validates :content, :length => { :maximum => 140 }, :presence => true
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

