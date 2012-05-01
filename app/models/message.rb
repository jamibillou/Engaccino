class Message < ActiveRecord::Base
  
  attr_accessible :content, :read, :archived_author, :archived_recipient, :author_id, :recipient_id
    
  belongs_to :author,    :class_name => 'User', :foreign_key => :author_id
  belongs_to :recipient, :class_name => 'User', :foreign_key => :recipient_id
    
  validates :author_id,                                           :presence => true
  validates :recipient_id,                                        :presence => true
  validates :content,            :length => { :maximum => 140 },  :presence => true
  validates :read,               :inclusion => { :in => [ true, false ] }
  validates :archived_author,    :inclusion => { :in => [ true, false ] }
  validates :archived_recipient, :inclusion => { :in => [ true, false ] }
  
  validate  :different_users
  validate  :different_classes_of_user
  
  private
  
    def different_users
      errors.add :users, I18n.t('message.validations.different_users') if author == recipient
    end
    
    def different_classes_of_user
      errors.add :users, I18n.t('message.validations.different_classes_of_user') if author.class == recipient.class
    end
end

# == Schema Information
#
# Table name: messages
#
#  id                 :integer(4)      not null, primary key
#  content            :string(255)
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  author_id          :integer(4)
#  recipient_id       :integer(4)
#  read               :boolean(1)      default(FALSE)
#  archived_author    :boolean(1)      default(FALSE)
#  archived_recipient :boolean(1)      default(FALSE)
#