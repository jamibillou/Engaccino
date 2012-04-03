class Message < ActiveRecord::Base
  
  attr_accessible :content
    
  belongs_to :author,    :class_name => 'User', :foreign_key => :author_id
  belongs_to :recipient, :class_name => 'User', :foreign_key => :recipient_id
    
  validates :content,    :length => { :maximum => 140 }, :presence => true
  validates :author_id,                                  :presence => true
  validates :recipient_id,                               :presence => true
  validates :read, :inclusion => { :in => [true, false] }
  
  validate  :author_recipient
  validate  :author_recipient_class
  
  private
  
    def author_recipient
      errors.add :author_recipient, I18n.t('message.validations.author_recipient') if author == recipient
    end
    
    def author_recipient_class
      errors.add :author_recipient, I18n.t('message.validations.author_recipient_class') if author.class == recipient.class
    end
end

# == Schema Information
#
# Table name: messages
#
#  id           :integer(4)      not null, primary key
#  content      :string(255)
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#  author_id    :integer(4)
#  recipient_id :integer(4)
#  read         :boolean(1)      default(FALSE)
#

